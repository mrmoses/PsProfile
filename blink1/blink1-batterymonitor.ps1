$global:batteryMonitor = $null

function Enable-BatteryMonitor() {
    if ((Get-WmiObject win32_battery) -eq $null) {
        Write-Host "No battery found."
        return
    }

    if ($global:batteryMonitor -eq $null) {
        $global:batteryMonitor = New-Object Timers.Timer
        $global:batteryMonitor.Interval = 30000
        $global:batteryMonitor.Enabled = $true

        Register-ObjectEvent -InputObject $global:batteryMonitor -SourceIdentifier BatteryMonitor -EventName Elapsed -Action { 
            $battery = Get-WmiObject win32_battery
            if ($battery.EstimatedChargeRemaining -le 20) {
                blink1-tool.exe --red -q
            } elseif ($battery.EstimatedChargeRemaining -gt 20 -and $battery.EstimatedChargeRemaining -le 70) {
                blink1-tool.exe --rgb "255,204,0" -q #yellow
            } else {
                blink1-tool.exe --green -q
            }
        } | Out-Null

        $global:batteryMonitor.Start()
    } else {
        Write-Host "BatteryMonitor has already been enabled."
    }
}

function Disable-BatteryMonitor() {
    if ($global:batteryMonitor -ne $null) {
        blink1-tool.exe --off -q

        Unregister-Event -SourceIdentifier BatteryMonitor
        $global:batteryMonitor.Stop()
        $global:batteryMonitor.Dispose()
        $global:batteryMonitor = $null
    }
}
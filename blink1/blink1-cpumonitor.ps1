$global:cpuMonitor = $null

function Enable-CpuMonitor() {
    if ($global:cpuMonitor -eq $null) {
        $global:cpuMonitor = New-Object Timers.Timer
        $global:cpuMonitor.Interval = 5000
        $global:cpuMonitor.Enabled = $true

        Register-ObjectEvent -InputObject $global:cpuMonitor -SourceIdentifier CpuMonitor -EventName Elapsed -Action { 
            $processor = Get-WmiObject win32_processor
            if ($processor.LoadPercentage -le 50) {
                blink1-tool.exe --green -q
            } elseif ($processor.LoadPercentage -gt 50 -and $processor.LoadPercentage -le 90) {
                blink1-tool.exe --rgb "255,204,0" -q #yellow
            } else {
                blink1-tool.exe --red -q
            }
        } | Out-Null

        $global:cpuMonitor.Start()
    } else {
        Write-Host "CpuMonitor has already been enabled."
    }
}

function Disable-CpuMonitor() {
    if ($global:cpuMonitor -ne $null) {
        blink1-tool.exe --off -q

        Unregister-Event -SourceIdentifier CpuMonitor
        $global:cpuMonitor.Stop()
        $global:cpuMonitor.Dispose()
        $global:cpuMonitor = $null
    }
}
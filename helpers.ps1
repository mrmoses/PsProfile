function Get-IsSessionElevated {   
    [System.Security.Principal.WindowsPrincipal]$currentPrincipal = `
        New-Object System.Security.Principal.WindowsPrincipal(
        [System.Security.Principal.WindowsIdentity]::GetCurrent());

    [System.Security.Principal.WindowsBuiltInRole]$administratorsRole = `
        [System.Security.Principal.WindowsBuiltInRole]::Administrator;
    
    if($currentPrincipal.IsInRole($administratorsRole)) {
        return $true;
    } else {
        return $false;
    }
}

function Test-Module($name) {
    return (Get-Module -ListAvailable | ? Name -eq $name) -ne $null
}

function ImportOrPsGet-Module($name) {
    if (Test-Module $name) {
        Write-Host "Importing Module: $name" -ForegroundColor Green
        Import-Module $name
    } else {
        if ($name -eq "PsGet") {
            # Install PsGet if not already installed.
            Invoke-RestMethod "http://psget.net/GetPsGet.ps1" | iex
        } else {
            Install-Module $name
        }        
    }
}

function Initialize-TfsPowerTools() {
    $tfsPowerToolsPath = $Env:TFSPowerToolDir
    if ($tfsPowerToolsPath -eq $null) {
        $tfsPowerToolsPath = "C:\Program Files (x86)\Microsoft Team Foundation Server 2012 Power Tools"   
    }

    if (Test-Path $tfsPowerToolsPath) {
        Add-PSSnapin Microsoft.TeamFoundation.PowerShell
        . "$tfsPowerToolsPath\TFSSnapin.ps1"

        Write-Host "TFS 2012 Power Tools Initialized" -ForegroundColor Green
    }   
}

function Initialize-PoshGit() {
    # Set up a simple prompt, adding the git prompt parts inside git repos
    function global:prompt {
        $realLASTEXITCODE = $LASTEXITCODE

        # Reset color, which can be messed up by Enable-GitColors
        $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

        Write-Host($pwd.ProviderPath) -nonewline

        Write-VcsStatus

        $global:LASTEXITCODE = $realLASTEXITCODE
        return "> "
    }

    $global:GitPromptSettings.EnableFileStatus = $false

    Enable-GitColors
}

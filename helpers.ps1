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
    return Get-Module -ListAvailable -Name $name
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
        $tfsPowerToolsPath = "C:\Program Files (x86)\Microsoft Team Foundation Server 2013 Power Tools"
    }

    if (Test-Path $tfsPowerToolsPath) {
        Add-PSSnapin Microsoft.TeamFoundation.PowerShell
        Write-Host "TFS 2013 Power Tools Initialized" -ForegroundColor Green
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

function Reinitialize-Profile() {
    $profilePaths = $PROFILE.CurrentUserAllHosts, $PROFILE.CurrentUserCurrentHost
    foreach($profilePath in $profilePaths) {
        if (Test-Path $profilePath) {
            $fileName = Split-Path $profilePath -Leaf
            Write-Host "Reinitializing $fileName..." -ForegroundColor Yellow
            . $profilePath
        }
    }
}

function Test-Url() {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$url
    )

    Process {
        foreach($u in $url) {
            try {
                Invoke-WebRequest $u |
                    select StatusCode, StatusDescription |
                    Add-Member -MemberType NoteProperty -Name URL -Value $u -PassThru

            } catch {
                $ex = $_.Exception
                if ($ex.Status -eq [System.Net.WebExceptionStatus]::ProtocolError) {
                     $obj = New-Object -TypeName psobject |
                        Add-Member -MemberType NoteProperty -Name StatusCode -Value ($ex.Response.StatusCode -as [int]) -PassThru |
                        Add-Member -MemberType NoteProperty -Name StatusDescription -Value $ex.Response.StatusDescription -PassThru |
                        Add-Member -MemberType NoteProperty -Name URL -Value $u -PassThru

                        Write-Output $obj
                } else {
                    Write-Host $ex.Message -ForegroundColor Red
                }
            }
        }
    }
}

function Invoke-Tika() {
    java -jar c:\tools\tika-app-1.4.jar $args
}

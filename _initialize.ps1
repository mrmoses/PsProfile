Write-Host "Initializing Profile..." -ForegroundColor Green

cd $Env:USERPROFILE

Split-Path $MyInvocation.MyCommand.Definition | Push-Location

# Load helpers
. .\helpers.ps1
. .\serengeti.ps1
. .\gitignore.io.ps1
. .\blink1\blink1-cpumonitor.ps1
. .\blink1\blink1-batterymonitor.ps1
. .\aliases.ps1

Initialize-TfsPowerTools

# Import/Install Modules
ImportOrPsGet-Module PsGet
ImportOrPsGet-Module Psake

Pop-Location
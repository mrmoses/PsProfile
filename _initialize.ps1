cd $Env:USERPROFILE

Split-Path $MyInvocation.MyCommand.Definition | Push-Location

# Load helpers
. .\helpers.ps1
. .\serengeti.ps1
. .\gitignore.io.ps1
. .\blink1\blink1-cpumonitor.ps1
. .\blink1\blink1-batterymonitor.ps1
. .\aliases.ps1

# Import/Install Modules
ImportOrPsGet-Module PsGet
ImportOrPsGet-Module Posh-Git
ImportOrPsGet-Module Psake

Initialize-PoshGit
Initialize-TfsPowerTools

Pop-Location
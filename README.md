# PsProfile

## Overview

PsProfile is a set of scripts that initialize a global PowerShell profile on my machines. It uses [PsGet](http://psget.net/) to install missing modules. It will even install [PsGet](http://psget.net/) if it hasn't already been install on the machine.


## Installation

Open a PowerShell command prompt and clone this repository into the PowerShell profile folder for your system. 

```
Split-Path $PROFILE | Push-Location
git clone https://github.com/jrotello/PsProfile.git
```

Add the following line to the beginning of your PowerShell profile file (`$PROFILE`).

```
. (Split-Path $PROFILE | Join-Path -ChildPath "PsProfile\_initialize.ps1")
```

If you want a global profile that applies to all the PowerShell hosting environments on the system (PowerShell Command Prompt, Visual Studio, etc) then place the above line in `$PROFILE.CurrentUserAllHosts` instead.  
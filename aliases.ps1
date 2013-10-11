Set-Alias sublime "C:\Program Files\Sublime Text 2\sublime_text.exe"
Set-Alias keytool "C:\Program Files\Java\jre7\bin\keytool.exe"

if (Test-Path "c:\Chocolatey\bin\curl.bat") {
    Set-Alias curl "c:\Chocolatey\bin\curl.bat" -Force -Option AllScope
}

Set-Alias Out-Clipboard "$env:SystemRoot\system32\clip.exe"
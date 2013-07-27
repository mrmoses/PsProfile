# Description:
#   A couple of PowerShell helper functions to interact with 
#   http://gitignore.io. These functions will allow you to 
#   list the terms recognized by http://gitignore.io as well 
#   as generate .gitignore files.
#
# Install:
#   Save this file to your machine and dot source it in your PowerShell 
#   profile.

function Get-GitIgnore() {
    <#
    .SYNOPSIS
    Generate .gitignore files from http://gitignore.io.

    .DESCRIPTION
    Generate .gitignore files from http://gitignore.io.

    .PARAMETER terms
    A comma separated list of terms to generate your .gitignore file from.

    .EXAMPLE
    Get-GitIgnore visualstudio

    Preview a .gitignore file suitable for Visual Studio.

    .EXAMPLE
    Get-GitIgnore visualstudio > .gitignore

    Save a .gitignore file suitable for Visual Studio to disk.

    .EXAMPLE
    Get-GitIgnore linux,java
    #>
    param(
        [Parameter(Mandatory=$true)]
        [string[]]$terms
    )

    $url = "http://gitignore.io/api/" + [string]::Join(",",$terms)
    Invoke-RestMethod $url
}

function List-GitIgnore() {
    <#
    .SYNOPSIS
    List the available terms recognized by http://gitignore.io.

    .DESCRIPTION
    List the available terms recognized by http://gitignore.io.

    .EXAMPLE
    List-GitIgnore

    Display all of the terms recognized by http://gitignore.io.
    #>    
    Get-GitIgnore list | 
        % { $_.Split(",", [StringSplitOptions]::RemoveEmptyEntries) } | 
        Sort-Object | 
        Format-Wide -Property { $_.Trim() } -AutoSize -Force
}
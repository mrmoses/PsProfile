function Remove-TrackerIDCacheFiles() {
    # TODO: Incomplete

    $path = "~\AppData\Local\Temp\Tracker"
    if (Test-Path $path) {
        Write-Host "Removing: $path" -ForegroundColor Yellow
        Remove-Item $path -Recurse -Force
    }
}
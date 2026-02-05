# Check if watch-simple.ps1 is running
$running = $false

Get-Process -Name powershell -ErrorAction SilentlyContinue | ForEach-Object {
    $cmd = $_.CommandLine
    if ($cmd -and $cmd.Contains("watch-simple.ps1")) {
        $running = $true
        Write-Host "✅ Watch is RUNNING"
        Write-Host "PID: $($_.Id)"
        Write-Host ""
        Write-Host "To stop: Run watch-stop.ps1"
    }
}

if (-not $running) {
    Write-Host "❌ Watch is NOT running"
    Write-Host ""
    Write-Host "To start: powershell -ExecutionPolicy Bypass -File watch-simple.ps1"
}

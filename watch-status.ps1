# Check if watch-simple.ps1 is running
$pidFile = "$PSScriptRoot\watch.pid"

if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    $proc = Get-Process -Id $pid -ErrorAction SilentlyContinue
    
    if ($proc) {
        Write-Host "✅ Watch is RUNNING"
        Write-Host "PID: $pid"
        Write-Host ""
        Write-Host "To stop: Run watch-stop.ps1"
    } else {
        Remove-Item $pidFile -ErrorAction SilentlyContinue
        Write-Host "❌ Watch is NOT running (stale PID file)"
        Write-Host ""
        Write-Host "To start: powershell -ExecutionPolicy Bypass -File watch-simple.ps1"
    }
} else {
    Write-Host "❌ Watch is NOT running"
    Write-Host ""
    Write-Host "To start: powershell -ExecutionPolicy Bypass -File watch-simple.ps1"
}

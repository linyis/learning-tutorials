# Check if watch-simple.ps1 is running
$process = Get-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*watch-simple.ps1*"}

if ($process) {
    Write-Host "✅ Watch is RUNNING"
    Write-Host "PID: $($process.Id)"
    Write-Host "Started: $($process.StartTime)"
    Write-Host ""
    Write-Host "To stop: Run watch-stop.ps1 or press Ctrl+C in the running window"
} else {
    Write-Host "❌ Watch is NOT running"
    Write-Host ""
    Write-Host "To start: powershell -ExecutionPolicy Bypass -File watch-simple.ps1"
}

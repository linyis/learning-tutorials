# Stop watch-simple.ps1
$process = Get-Process -Name powershell -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like "*watch-simple.ps1*"}

if ($process) {
    Write-Host "Stopping watch... PID: $($process.Id)"
    $process | Stop-Process -Force
    Write-Host "✅ Stopped"
} else {
    Write-Host "❌ Watch is not running"
}

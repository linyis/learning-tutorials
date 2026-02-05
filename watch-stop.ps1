# Stop watch-simple.ps1
$pidFile = "$PSScriptRoot\watch.pid"

if (Test-Path $pidFile) {
    $pid = Get-Content $pidFile
    Remove-Item $pidFile -ErrorAction SilentlyContinue
    
    $proc = Get-Process -Id $pid -ErrorAction SilentlyContinue
    if ($proc) {
        $proc | Stop-Process -Force
        Write-Host "✅ Stopped (PID: $pid)"
    } else {
        Write-Host "✅ Stopped (process already gone)"
    }
} else {
    Write-Host "❌ Watch is not running"
}

# learning-tutorials Auto-Watch (Simple Version)
$repoPath = "C:\Users\linyi\.openclaw\workspace\learning-tutorials"
$pidFile = "$PSScriptRoot\watch.pid"

# Save PID
$PID | Out-File -FilePath $pidFile -Force

Write-Host "Watching: $repoPath"
Write-Host "PID: $PID"
Write-Host "Press Ctrl+C to stop`n"

$lastHash = ""

while ($true) {
    $files = Get-ChildItem -Path $repoPath -Recurse -File -Include *.md,*.txt,*.ps1,*.bat,*.vbs -ErrorAction SilentlyContinue
    $currentHash = ($files | Get-FileHash -Algorithm MD5).Hash -join ""

    if ($lastHash -ne "" -and $currentHash -ne $lastHash) {
        Write-Host "Change detected..."
        Set-Location $repoPath
        git add . 2>&1 | Out-Null
        git commit -m "Auto-update: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>&1 | Out-Null
        git push origin main 2>&1 | Out-Null
        Write-Host "Done"
    }

    $lastHash = $currentHash
    Start-Sleep -Seconds 5
}

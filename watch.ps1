# learning-tutorials Auto-Watch
$repoPath = "C:\Users\linyi\.openclaw\workspace\learning-tutorials"
$lastHash = ""

while ($true) {
    $files = Get-ChildItem -Path $repoPath -Recurse -File -Include *.md,*.txt -ErrorAction SilentlyContinue
    $currentHash = ($files | Get-FileHash -Algorithm MD5).Hash -join ""

    if ($lastHash -ne "" -and $currentHash -ne $lastHash) {
        Set-Location $repoPath
        git add . 2>&1 | Out-Null
        git commit -m "Auto-update: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" 2>&1 | Out-Null
        git push origin main 2>&1 | Out-Null
    }

    $lastHash = $currentHash
    Start-Sleep -Seconds 5
}

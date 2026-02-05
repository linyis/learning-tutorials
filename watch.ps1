# learning-tutorials Auto-Watch Script
# 使用方式: powershell -ExecutionPolicy Bypass -File watch.ps1

$repoPath = "C:\Users\linyi\.openclaw\workspace\learning-tutorials"
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $repoPath
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$lastAction = 0
$debounceSeconds = 5

Write-Host "👀 監控中... 偵測到變更會自動 commit+push"

$action = {
    $currentTime = [DateTime]::Now.Ticks
    global:$lastAction = $currentTime
    Start-Sleep -Seconds $debounceSeconds

    if ([DateTime]::Now.Ticks -ne $lastAction) { return }

    $changeType = $Event.SourceEventArgs.ChangeType
    $fullPath = $Event.SourceEventArgs.FullPath
    Write-Host "📝 偵測到變更: $changeType - $fullPath"

    try {
        Set-Location $repoPath
        git add .
        $status = git status --porcelain
        if ($status) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            git commit -m "Auto-update: $timestamp"
            git push origin main
            Write-Host "✅ 已推送到 GitHub"
        }
    } catch {
        Write-Host "❌ 錯誤: $_"
    }
}

$createdHandler = Register-ObjectEvent $watcher "Created" -Action $action
$changedHandler = Register-ObjectEvent $watcher "Changed" -Action $action
$deletedHandler = Register-ObjectEvent $watcher "Deleted" -Action $action
$renamedHandler = Register-ObjectEvent $watcher "Renamed" -Action $action

Write-Host "按 Ctrl+C 停止監控"
try {
    do {
        Wait-Event -Timeout 1
    } while ($true)
}
finally {
    Unregister-Event * 
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
}

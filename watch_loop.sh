#!/bin/bash
# learning-tutorials Watch Loop

REPO_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAST_HASH=""

while true; do
    # 取得所有 .md 和 .txt 檔案的 MD5 總和
    CURRENT_HASH=$(find "$REPO_PATH" -type f \( -name "*.md" -o -name "*.txt" \) -exec md5sum {} \; 2>/dev/null | md5sum | awk '{print $1}')
    
    if [ -n "$LAST_HASH" ] && [ "$CURRENT_HASH" != "$LAST_HASH" ]; then
        cd "$REPO_PATH"
        git add .
        git commit -m "Auto-update: $(date '+%Y-%m-%d %H:%M:%S')" 2>/dev/null
        git push origin main 2>/dev/null
    fi
    
    LAST_HASH="$CURRENT_HASH"
    sleep 5
done

#!/bin/bash
# learning-tutorials Stop Watch

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/watch.pid"

# 從 PID 檔案終止
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        kill "$OLD_PID"
        rm -f "$PID_FILE"
        echo "監控程序已停止 (PID: $OLD_PID)"
    else
        rm -f "$PID_FILE"
    fi
fi

# 強制終止所有 watch_loop.sh 行程
pkill -f "watch_loop.sh" 2>/dev/null
echo "監控程序已停止"

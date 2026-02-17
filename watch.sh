#!/bin/bash
# learning-tutorials Auto-Watch (Start)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/watch.log"
PID_FILE="$SCRIPT_DIR/watch.pid"

# 檢查是否已有運行的監控程序
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null 2>&1; then
        echo "監控程序已在運行中 (PID: $OLD_PID)"
        exit 0
    fi
fi

# 檢查是否有其他 watch 程序在運行
if pgrep -f "watch_loop.sh" > /dev/null 2>&1; then
    echo "監控程序已在運行中"
    exit 0
fi

# 啟動監控腳本
nohup "$SCRIPT_DIR/watch_loop.sh" > "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"
echo "監控程序已啟動 (PID: $(cat $PID_FILE))"

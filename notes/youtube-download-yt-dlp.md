# YouTube 影片下載 - yt-dlp 使用筆記

## 簡介

`yt-dlp` 是一個強大的命令行工具，用於從 YouTube 和其他影片平台下載影片和音頻。

## 基本安裝

```bash
# pip 安裝
pip install yt-dlp

# 或使用 winget (Windows)
winget install yt-dlp.yt-dlp
```

---

## 下載指令詳解

### 範例指令

```bash
yt-dlp -f "bestaudio[ext=m4a]" -o "audio.m4a" "https://www.youtube.com/watch?v=HwYVKc1zyPY"
```

### 指令拆解

| 參數 | 說明 |
|------|------|
| `-f` | 指定下載格式 (format) |
| `bestaudio` | 最佳音頻品質 |
| `[ext=m4a]` | 限制副檔名為 m4a |
| `-o` | 輸出檔名 (output) |
| `audio.m4a` | 儲存的檔案名稱 |
| URL | YouTube 影片連結 |

### 下載後產生什麼？

執行上述指令會：

1. **下載音頻檔案** (`audio.m4a`)
   - 格式：AAC 編碼
   - 取樣率：44100 Hz
   - 聲道：立體聲 (stereo)
   - 位元率：128 kbps
   - 時長：5 分鐘 6 秒

2. **終端機顯示資訊**：
   ```
   [youtube] Extracting URL: ...
   [info] Downloading 1 format(s): 140
   [download] 0.0% ... ETA Unknown
   [download] 100% ... in 00:00:01 at xx.xxMiB/s
   ```

---

## 影片解析度設定

### 下載最佳畫質影片（含音頻）

```bash
# 自動選擇最佳畫質和音頻合併
yt-dlp -f "bestvideo+bestaudio" -o "video.mp4" "URL"
```

### 指定解析度

| 指令 | 解析度 |
|------|--------|
| `-f "bestvideo[height<=720]"` | 720p 或更低 |
| `-f "bestvideo[height<=1080]"` | 1080p 或更低 |
| `-f "bestvideo[height<=1440]"` | 2K 或更低 |
| `-f "bestvideo[height<=2160]"` | 4K 或更低 |
| `-f "bestvideo[height]"` | 最高可用解析度 |

### 完整畫質 + 音頻合併

```bash
# 720p
yt-dlp -f "bestvideo[height<=720]+bestaudio" -o "video_720p.mp4" "URL"

# 1080p
yt-dlp -f "bestvideo[height<=1080]+bestaudio" -o "video_1080p.mp4" "URL"

# 最高畫質
yt-dlp -f "bestvideo+bestaudio" --merge-output-format mp4 -o "video_best.mp4" "URL"
```

### 常見問題：單獨下載影片/音頻

⚠️ **注意**：YouTube DASH 格式（分開的影片和音頻）需要用 `ffmpeg` 合併。

```bash
# 下載影片（無音頻）
yt-dlp -f "bestvideo[ext=mp4]" -o "video_only.mp4" "URL"

# 下載最佳音頻
yt-dlp -f "bestaudio[ext=m4a]" -o "audio.m4a" "URL"

# 合併影片和音頻
yt-dlp -f "bestvideo+bestaudio" --merge-output-format mp4 -o "output.mp4" "URL"
```

---

## 其他常用指令

### 下載字幕

```bash
# 下載所有字幕
yt-dlp --write-subs --skip-download "URL"

# 下載指定語言字幕
yt-dlp --write-subs --sub-lang zh-TW --skip-download "URL"

# 下載並嵌入字幕
yt-dlp --embed-subs --merge-output-format mp4 "URL"
```

### 下載播放列表

```bash
# 下載整個播放列表
yt-dlp -o "%(playlist)s/%(title)s.%(ext)s" "PLAYLIST_URL"

# 只下載前 3 個影片
yt-dlp --playlist-items 1-3 "PLAYLIST_URL"

# 下載特定範圍
yt-dlp --playlist-items 5-10 "PLAYLIST_URL"
```

### 其他實用選項

| 指令 | 說明 |
|------|------|
| `-c` | 繼續未完成的下載 |
| `--no-download` | 只獲取資訊，不下載 |
| `--dump-json` | 輸出影片資訊 (JSON格式) |
| `--thumbnail` | 下載縮圖 |
| `--write-thumbnail` | 儲存縮圖 |
| `-v` | 詳細輸出 (verbose) |
| `-q` | 安靜模式 (quiet) |

---

## 影片資訊查詢

```bash
# 查看所有可用格式
yt-dlp -F "URL"

# 查看詳細資訊
yt-dlp --dump-json "URL"

# 只查看標題和時長
yt-dlp --print "%(title)s - %(duration)s秒" "URL"
```

---

## 環境設定問題排查

### ffmpeg 路徑問題

Windows 上 `yt-dlp` 需要 `ffmpeg` 來合併影片和音頻。

**手動指定 ffmpeg 路徑**：
```bash
# 臨時設定 PATH (Windows PowerShell)
$env:PATH = $env:PATH + ";C:\ffmpeg\bin"

# 或指定完整路徑
"C:\ffmpeg\bin\ffmpeg.exe" -i input.mp4 ...
```

### 常見錯誤

| 錯誤 | 解決方案 |
|------|----------|
| `Decoder not found` | 安裝完整版 ffmpeg |
| `FFmpeg not found` | 將 ffmpeg 加入系統 PATH |
| `Unsupported codec` | 使用 `--merge-output-format mp4` |

---

## 參考資源

- **官方文檔**：https://github.com/yt-dlp/yt-dlp
- **ffmpeg 下載**：https://www.gyan.dev/ffmpeg/builds/
- **格式代碼說明**：https://github.com/yt-dlp/yt-dlp#format-selection

---

## 相關筆記

- [OpenClaw 多任務並行處理](/openclaw/openclaw-multi-task.md)
- [影片轉音頻 - Whisper 使用](/notes/video-to-audio-whisper.md)

---

**更新日期**：2026-02-05
**標籤**：#youtube #下載 #工具 #yt-dlp

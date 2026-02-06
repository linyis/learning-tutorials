# /youtube-video-summary - YouTube 影片摘要技能

## 概述

將 YouTube 影片自動轉換為結構化學習筆記。使用 yt-dlp 下載音頻、Whisper 語音轉文字，生成包含摘要、重點、時間戳的筆記。

## 使用方式

### OpenClaw 對話中

直接提供 YouTube 影片連結即可：

```
請幫我摘要這部影片：https://youtube.com/watch?v=...
```

### 命令列

```bash
python youtube-summary.py "YouTube_URL"
```

## 參數說明

| 參數 | 說明 |
|------|------|
| YouTube URL | 必填，影片連結 |
| --no-cleanup | 保留臨時檔案（預設會自動清理） |

## 工作流程

### Step 1: 下載音頻

使用 yt-dlp 下載影片最佳音軌：

```bash
yt-dlp -f "bestaudio[ext=m4a]" -o "temp/{video_id}.m4a" "VIDEO_URL"
```

### Step 2: 轉換格式

使用 ffmpeg 轉換為 Whisper 所需的 WAV 格式：

```bash
ffmpeg -i temp/{video_id}.m4a -ar 16000 -ac 1 temp/{video_id}.wav
```

### Step 3: 語音轉文字

使用 OpenAI Whisper 模型轉錄：

```python
import whisper

model = whisper.load_model("base")  # 可選: base, small, medium, large
result = model.transcribe("temp/{video_id}.wav", language="Chinese")
```

### Step 4: 生成摘要

從轉錄文字中提取：
- 影片主題與概述
- 章節時間戳
- 內容重點
- 實用命令/技巧

### Step 5: 自動清理 ✅

處理完成後自動刪除臨時檔案：
- `temp/{video_id}.m4a` - 下載的音頻檔案
- `temp/{video_id}.wav` - 轉換後的 WAV 檔案
- `temp/transcript.json` - Whisper 輸出檔案

## 輸出格式

生成的筆記結構：

```markdown
# YouTube 影片摘要

**影片標題**: [影片標題]
**影片連結**: https://youtube.com/watch?v=...
**處理日期**: 2026-02-06 12:00

---

## 影片概述

[簡短摘要]

## 章節重點

### [00:00 - 02:30] 開頭介紹
- 重點1
- 重點2

### [02:30 - 05:00] 主題說明
- 重點1
- 重點2

---

## 完整轉錄內容

[完整轉錄文字]

---

*由 OpenClaw youtube-video-summary 生成*
```

## 依賴工具

| 工具 | 用途 | 路徑 |
|------|------|------|
| yt-dlp | 下載影片音頻 | - |
| FFmpeg | 音頻格式轉換 | `C:\Users\linyi\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_...` |
| OpenAI Whisper | 語音轉文字 | Python whisper 套件 |

## Whisper 模型選擇

| 模型 | 大小 | 速度 | 準確度 |
|------|------|------|--------|
| tiny | 39 MB | 最快 | 較低 |
| base | 74 MB | 快 | 中等 |
| small | 244 MB | 中等 | 較高 |
| medium | 769 MB | 慢 | 高 |
| large | 1550 MB | 最慢 | 最高 |

## 儲存位置

生成的筆記儲存於：
- `learning-tutorials/notes/youtube_{video_id}.md` - 零散筆記

## 目錄結構

```
C:\Users\linyi\.openclaw\workspace\
├── youtube-summary.py              # 主腳本
├── temp/                          # 臨時檔案（自動清理）
│   └── *.m4a / *.wav             # 下載的音頻檔案
└── learning-tutorials/
    └── notes/
        └── youtube_{video_id}.md  # 生成的筆記
```

## 常見用法

| 用法 | 指令 |
|------|------|
| 摘要影片 | `請幫我摘要這部影片：https://youtube.com/watch?v=...` |
| 提取重點 | `這部影片的重點是什麼？` |
| 整理筆記 | `幫我整理這部影片的學習筆記` |

## 與 OpenClaw 整合

在 OpenClaw 對話中直接提供影片連結即可自動處理。系統會：
1. 下載並轉換音頻
2. 轉錄為文字
3. 生成結構化摘要
4. 儲存為學習筆記
5. 自動清理臨時檔案

## 注意事項

- 影片有字幕時可略過轉錄步驟（更快）
- 長影片轉錄需要較長時間
- Whisper 模型越大越準確但也越慢
- 臨時檔案會在處理完成後自動刪除

## 相關資源

- yt-dlp: https://github.com/yt-dlp/yt-dlp
- OpenAI Whisper: https://github.com/openai/whisper
- FFmpeg: https://ffmpeg.org/

# /phonetts - Telegram 錄音轉文字技能

## 概述

將 Telegram 語音訊息自動轉換為文字稿。使用 OpenAI Whisper 在本機進行語音轉文字，生成 Markdown 格式的文字稿並同步到 NAS 儲存。

## 功能流程

1. 接收 Telegram 錄音檔 → 獨立目錄
2. Whisper 本機轉文字（中文支援）
3. 產生 .md 格式文字稿
4. 更新 index.json 索引
5. 錄音備份到 NAS
6. 同步到 NAS voice-sync
7. 清除本機臨時檔案

## 使用方式

| 方式 | 指令 |
|------|------|
| 輸入命令 | `/phonetts` |
| 直接傳送錄音檔 | 自動觸發 |

## 工作流程詳解

### Step 1: 接收錄音檔

從 Telegram 接收語音訊息，儲存至獨立目錄：

```
temp/telegram-file/recording.m4a
```

### Step 2: Whisper 轉文字

使用 OpenAI Whisper 模型進行語音轉文字：

```python
import whisper

model = whisper.load_model('base')
result = model.transcribe('temp/telegram-file/audio.wav', language='Chinese')
```

### Step 3: 產生 Markdown 文字稿

生成格式化的文字稿檔案：

```markdown
---
id: 1707190400_abc123
date: 2026-02-06 12:20:00
source: Telegram
duration: 771 秒
size: 201469 bytes
---

# 錄音文字稿

## 轉錄內容

[Whisper 輸出的完整文字]
```

儲存位置：`temp/data/transcripts/{timestamp}_{random}.md`

### Step 4: 更新 index.json

維護索引資料庫：

```json
{
  "id": "1707190400_abc123",
  "filename": "file_5.m4a",
  "backup_path": "backups/file_5_20260206_1220.m4a",
  "transcript_path": "transcripts/1707190400_abc123.md",
  "date": "2026-02-06 12:20:00",
  "duration": 771,
  "size": 201469,
  "status": "done"
}
```

### Step 5: 同步到 NAS

透過 SMB 同步到 NAS：

| 類型 | NAS 路徑 |
|------|----------|
| 錄音備份 | `\\192.168.1.13\web\voice-sync\backups\{filename}_{timestamp}.m4a` |
| 文字稿 | `\\192.168.1.13\web\voice-sync\data\transcripts\{id}.md` |
| 索引 | `\\192.168.1.13\web\voice-sync\data\index.json` |

### Step 6: 清除本機

處理完成後自動清理：
- `temp/telegram-file/recording.m4a`
- `temp/telegram-file/transcript.json`

## 目錄結構

```
C:\Users\linyi\.openclaw\workspace\
├── temp/
│   ├── telegram-file/            # Telegram 錄音檔（獨立目錄）
│   │   └── recording.m4a         # 臨時錄音檔（自動清理）
│   └── data/
│       ├── index.json            # 索引資料庫
│       └── transcripts/          # 文字稿
│           └── {id}.md
├── transcribe.py                 # Whisper 轉文字腳本
└── skills/phonetts/             # Skill 檔案
```

## 與 /youtube-video-summary 區分

| 技能 | 暫存目錄 | 用途 |
|------|----------|------|
| /phonetts | `temp/telegram-file/` | Telegram 錄音檔 |
| /youtube-video-summary | `temp/*.m4a, *.wav` | YouTube 影片 |

## NAS 檢視介面

| 功能 | URL |
|------|------|
| 列表頁面 | `http://NAS_IP/voice-sync/index.php` |
| 文字稿檢視 | `http://NAS_IP/voice-sync/view.php?id={id}` |
| 播放/下載 | view.php 中的按鈕 |

## 依賴工具

| 工具 | 用途 | 備註 |
|------|------|------|
| Python | 腳本執行 | 3.x+ |
| openai-whisper | 語音轉文字 | `pip install openai-whisper` |
| FFmpeg | 音頻格式轉換 | 路徑已設定 |
| NAS (SMB) | 雲端儲存 | Synology |

## Whisper 模型選擇

| 模型 | 大小 | 速度 | 適用場景 |
|------|------|------|----------|
| tiny | 39 MB | 最快 | 快速處理 |
| base | 74 MB | 快 | 一般用途（預設） |
| small | 244 MB | 中等 | 較高準確度 |
| medium | 769 MB | 慢 | 高準確度 |
| large | 1550 MB | 最慢 | 最高準確度 |

## FFmpeg 路徑

```python
ffmpeg_path = r'C:\Users\linyi\AppData\Local\Microsoft\WinGet\Packages\Gyan.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-8.0.1-full_build\bin'
```

## 支援格式

- **輸入**: m4a, mp3, wav（從 Telegram 接收）
- **輸出**: .md 文字稿

## 注意事項

1. **獨立目錄**：`telegram-file/` 與其他技能區分，避免衝突
2. **自動清理**：每次處理後清除本機錄音檔
3. **NAS 備份**：錄音檔會備份到 NAS `backups/` 目錄
4. **索引維護**：`index.json` 記錄完整 metadata
5. **中文支援**：Whisper 預設使用中文轉錄

## 常見用法

| 用法 | 指令 |
|------|------|
| 啟動轉換 | `/phonetts` |
| 直接傳送 | 傳送語音訊息即可 |
| 查看結果 | 前往 NAS voice-sync 頁面 |

## 相關資源

- OpenAI Whisper: https://github.com/openai/whisper
- Telegram Bot API: https://core.telegram.org/bots/api

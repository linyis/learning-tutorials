# Voice Sync 專案分析

## 專案位置
- **本地**: `/mnt/nas/web/voice-sync/`
- **網址**: (需確認)

---

## 功能概述

語音錄音 + Whisper 轉文字系統

---

## 目錄結構

| 目錄/檔案 | 功能 |
|-----------|------|
| index.php | 主頁面（錄音列表） |
| view.php | 錄音檢視/播放 |
| upload.php | 錄音上傳 |
| api.php | 搜尋 API |
| config.php | 設定檔 |
| db.php | MySQL 資料庫操作 |
| data/recordings/ | 錄音檔案 |
| data/transcripts/ | 轉文字結果 |
| api/ | API 接口集合 |
| backups/ | 備份檔案 |

---

## 資料庫

- **主機**: localhost
- **資料庫**: voice_sync
- **用戶**: root / jameslin0
- **表**: voice_records

**欄位**:
- id, filename, backup_path
- transcript_path, transcript_content
- record_date, record_time
- status, duration, size

---

## API 端點

| 檔案 | 功能 |
|------|------|
| api.php | 搜尋介面 |
| api/add.php | 新增記錄 |
| api/delete.php | 刪除記錄 |
| api/update.php | 更新記錄 |
| api/live_init.php | 即時錄音初始化 |
| api/live_add.php | 即時錄音新增 |
| api/live_update.php | 即時錄音更新 |
| api/live_end.php | 即時錄音結束 |

---

## 設定 (config.php)

```php
define('DATA_DIR', __DIR__ . '/data');
define('RECORDINGS_DIR', DATA_DIR . '/recordings');
define('TRANSCRIPTS_DIR', DATA_DIR . '/transcripts');
define('OPENAI_API_KEY', 'sk-proj-...');
```

---

## 轉文字流程

1. 上傳錄音 (m4a)
2. 備份到 backups/
3. 呼叫 OpenAI Whisper API
4. 儲存轉文字結果 (.md)
5. 更新 index.json

---

## 記錄格式 (index.json)

```json
{
  "id": "1770542164_20260208_171604",
  "filename": "新錄音 5副本.m4a",
  "backup_path": "backups/新錄音 5副本_20260208_171604.m4a",
  "transcript_path": "transcripts/1770542164_20260208_171604.md",
  "date": "2026-02-08 17:16:04",
  "status": "done"
}
```

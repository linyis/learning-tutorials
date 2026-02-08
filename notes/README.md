# Notes 筆記分類規劃

## 現有筆記清單

### YouTube 影片筆記 (youtube_*.md)
| 檔案 | 主題 |
|------|------|
| `youtube_8DJfvK4QK5M.md` | [待確認] |
| `youtube_ahkTaq5lJZk.md` | [待確認] |
| `youtube_cgqndsCPO_U.md` | [待確認] |
| `youtube_dbpX4x4phZs.md` | [待確認] |
| `youtube_EncNNv6mAZI.md` | [待確認] |
| `youtube_ewycarYziTE.md` | [待確認] |
| `youtube_fNKFCwoW9oo.md` | [待確認] |
| `youtube_jz4SxHZhJok.md` | [待確認] |
| `youtube_masJoPqT-6A.md` | [待確認] |
| `youtube_O9b8tLXCTYU.md` | [待確認] |
| `youtube_oVEac2KKdC0.md` | [待確認] |
| `youtube__flMwzatago.md` | [待確認] |
| `youtube_未知.md` | 無法識別的檔名 |

### 工具筆記
| 檔案 | 主題 |
|------|------|
| `youtube-download-yt-dlp.md` | YouTube 下載工具 |
| `opencloud-ai-ecology.md` | OpenCloud AI 生態系 |

### 待整理
| 檔案 | 狀態 |
|------|------|
| 其他 `youtube_*.md` | 需要重新命名並分類 |

---

## 建議分類結構

```
notes/
├── tools/
│   ├── youtube/
│   │   ├── youtube-download-yt-dlp.md
│   │   └── youtube-下載技巧.md
│   └── ...
├── tutorials/
│   └── ...
├── cheatsheets/
│   └── ...
├── reference/
│   └── ...
└── youtube-notes/          # 或許廢除此分類，改用上方結構
```

---

## 問題診斷

### 1. youtube_*.md 檔名問題
- 影片 ID 無法識別內容
- 建議：重新觀看並重新命名為有意義的標題

### 2. 重複筆記
- `youtube-download-yt-dlp.md` 和 `youtube_HwYVKc1zyPY.md` 重複（已刪除）

### 3. 建議動作
- [ ] 逐一檢查 `youtube_*.md` 筆記，確認是否還需要
- [ ] 有價值的筆記重新命名並分類到 `tutorials/` 或 `cheatsheets/`
- [ ] 過時或無價值的筆記刪除
- [ ] 建立統一的命名規範

---

## 統一命名規範

### 檔名格式
```
YYYY-MM-DD-標題-關鍵詞.md
```

### Front Matter
```yaml
---
title: 標題
date: YYYY-MM-DD
tags: [tag1, tag2]
---
```

---

## 執行順序

1. 閱讀每個 `youtube_*.md` 筆記
2. 判斷價值：有參考價值 → 重新命名；無 → 刪除
3. 建立 `tools/`、`tutorials/`、`cheatsheets/` 目錄
4. 移動筆記到對應分類
5. 更新本 README.md

---

**更新日期**：2026-02-08

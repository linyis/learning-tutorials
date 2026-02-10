# Notes 筆記分類規劃

## 現有筆記清單

### OpenClaw 相關 (openclaw/)
| 檔案 | 主題 |
|------|------|
| `youtube_OpenClaw-Windows-安裝教學.md` | OpenClaw Windows WSL 安裝完整教學 |
| `youtube_pvlPkUauHis.md` | OpenClaw 高級使用技巧：模型容災、多 Agent 協作、記憶搜索 |

### OpenCloud / AI Agent 教程
| 檔案 | 主題 |
|------|------|
| `youtube_OAE1EWP8dIQ.md` | AI-ZENTA 教程：Agent 開發、函數調用、上下文管理 |
| `youtube_AQaGloY8yZE.md` | 黃仁勳訪談：AI 企業應用、數據主權、工具使用策略 |
| `youtube_N8N-AI-Agent-流程自動化.md` | N8N + AI Agent 流程自動化實踐 |

### 開源項目與模型
| 檔案 | 主題 |
|------|------|
| `youtube_Q48iixe1_D0.md` | NanonBot 項目介紹：RAG、AOMAgent、AI 研究框架 |
| `youtube_MiniMind-AI模型.md` | MiniMind 開源項目：微型 GPT 訓練框架 |
| `youtube_as12D1ltN8A.md` | 本地端模型 GPTOS120B 搭建踩坑記錄 |

### 實用工具筆記
| 檔案 | 主題 |
|------|------|
| `youtube-download-yt-dlp.md` | YouTube 下載工具 yt-dlp 使用指南 |
| `opencloud-ai-ecology.md` | OpenCloud AI 生態系統與原理 |

---

## 建議分類結構

```
notes/
├── openclaw/              # OpenClaw 相關筆記
│   ├── 安裝教學/
│   └── 使用技巧/
├── opencloud/             # OpenCloud / Agent 開發
├── ai-projects/           # AI 開源項目
│   ├── NanonBot/
│   ├── MiniMind/
│   └── 本地模型部署/
├── tools/                 # 實用工具
│   ├── yt-dlp/
│   └── 其他工具/
└── tutorials/            # 通用教程
```

---

## 問題診斷

### 已完成事項 ✅
- [x] 重新命名 youtube_*.md 檔案為有意義的標題
- [x] 整理 OpenClaw 相關筆記到 openclaw/ 目錄

### 待整理
| 檔案 | 狀態 |
|------|------|
| `youtube_Cursor-MCP-教程.md` | 需要重新命名（目前檔案不存在） |
| `youtube_Meta-開源AI模型.md` | 需要重新命名（目前檔案不存在） |
| `youtube_MotoBot-智能體開發.md` | 需要重新命名（目前檔案不存在） |
| `youtube_OpenClub-RNBN-新手入門.md` | 需要重新命名（目前檔案不存在） |
| `youtube_股票分析-價值投資.md` | 需要確認檔案是否存在 |
| `youtube_小米手環-設定攻略.md` | 需要確認檔案是否存在 |

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

1. ✅ 逐一檢查 `youtube_*.md` 筆記，確認是否還需要
2. [ ] 有價值的筆記重新命名並分類到對應目錄
3. [ ] 過時或無價值的筆記刪除
4. [ ] 建立統一的命名規範
5. [ ] 持續更新本 README.md

---

**更新日期**：2026-02-10

# Notes 筆記分類規劃

## 現有筆記清單

### OpenClaw / OpenCloud 官方相關
| 檔案 | 主題 | 影片 ID |
|------|------|---------|
| `youtube_OpenClaw-Windows-安裝教學.md` | OpenClaw Windows WSL 安裝完整教學 | 8DJfvK4QK5M |
| `youtube_pvlPkUauHis.md` | OpenClaw 高級使用技巧：模型容災、多 Agent 協作、記憶搜索 | pvlPkUauHis |
| `youtube_OpenCloud-Agent-教程.md` | OpenCloud Agent 教程與使用經驗分享 | masJoPqT-6A |
| `youtube_OpenCloud-使用技巧.md` | OpenCloud 設定與使用技巧詳解 | oVEac2KKdC0 |

### AI-ZENTA / OpenCloud 生態
| 檔案 | 主題 | 影片 ID |
|------|------|---------|
| `youtube_OAE1EWP8dIQ.md` | AI-ZENTA 教程：Agent 開發、函數調用、上下文管理 | OAE1EWP8dIQ |
| `youtube_AQaGloY8yZE.md` | 黃仁勳訪談：AI 企業應用策略、數據主權、工具使用 | AQaGloY8yZE |
| `youtube_O9b8tLXCTYU.md` | OpenCloud AI 生態系與原理詳解 | O9b8tLXCTYU |
| `youtube_N8N-AI-Agent-流程自動化.md` | N8N + AI Agent 流程自動化實踐 | _flMwzatago |

### AI 開源項目與工具
| 檔案 | 主題 | 影片 ID |
|------|------|---------|
| `youtube_Q48iixe1_D0.md` | NanonBot 項目：RAG 優化、AOMAgent 框架介紹 | Q48iixe1_D0 |
| `youtube_MiniMind-AI模型.md` | MiniMind 開源項目：微型 GPT 訓練框架教學 | ewycarYziTE |
| `youtube_as12D1ltN8A.md` | 本地端模型 GPTOS120B 搭建踩坑記錄 | as12D1ltN8A |
| `youtube_Meta-開源AI模型.md` | Meta 開源 AI 模型介紹與應用 | cgqndsCPO_U |
| `youtube_MotoBot-智能體開發.md` | MotoBot 項目：智能體開發與實現 | fNKFCwoW9oo |

### 開發工具與技巧
| 檔案 | 主題 | 影片 ID |
|------|------|---------|
| `youtube_Cursor-MCP-使用教程.md` | Cursor AI 編輯器 + MCP (Model Context Protocol) 教程 | jz4SxHZhJok |
| `youtube_Agent-智能體.md` | AI 智能體開發相關內容 | EncNNv6mAZI |

### 其他實用工具
| 檔案 | 主題 | 影片 ID |
|------|------|---------|
| `youtube-download-yt-dlp.md` | YouTube 下載工具 yt-dlp 完整使用指南 | - |
| `youtube_股票分析-價值投資.md` | 股票分析與價值投資相關內容 | dbpX4x4phZs |
| `youtube_小米手環-設定攻略.md` | 小米手環設定與使用攻略 | - |

### 待分類
| 檔案 | 狀態 |
|------|------|
| `youtube_OpenClub-RNBN-新手入門.md` | 待確認內容 (ahkTaq5lJZk) |

---

## 分類結構建議

```
notes/
├── openclaw/              # OpenClaw 官方相關
│   ├── 安裝教學/
│   └── 使用技巧/
├── opencloud/             # OpenCloud / Agent 開發
│   ├── AI-ZENTA/
│   └── 生態系/
├── ai-projects/           # AI 開源項目
│   ├── NanonBot/
│   ├── MiniMind/
│   ├── MotoBot/
│   └── 本地模型部署/
├── tools/                 # 實用工具
│   ├── yt-dlp/
│   ├── Cursor-MCP/
│   └── 其他/
└── tutorials/            # 通用教程
```

---

## 統一命名規範

### 檔名格式
```
youtube_影片ID-標題簡稱.md
```

### Front Matter
```yaml
---
title: 標題
date: YYYY-MM-DD
source: https://youtu.be/影片ID
---
```

---

## 執行進度

### ✅ 已完成
- [x] 整理所有 youtube_*.md 筆記列表
- [x] 補充分類與影片 ID
- [x] 移除了 [待確認] 標記

### ⏳ 待處理
- [ ] 移動筆記到對應分類目錄
- [ ] 新增缺少的 Front Matter (日期、標籤)
- [ ] 定期檢視並更新主題描述

---

**更新日期**：2026-02-10

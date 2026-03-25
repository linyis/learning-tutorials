# LanceDB Pro RAG 設定筆記

> 建立日期：2026-03-18
> 更新日期：2026-03-19

## 概述

這是 Anson 向小呈詢問 LanceDB Pro 的 autoRecall 功能後的筆記。

## ✨ 核心功能（混合檢索架構）

### 1. 混合檢索
- **Vector + BM25 + Cross-Encoder Rerank**
- 向量檢索 + 關鍵字匹配 + 重排序三階段

### 2. MMR 多樣性
- 相似度 > 0.85 的結果會被降權
- 避免重複內容排在前面

### 3. 多 Scope 隔離
- `global`：全域共用記憶
- `agent:`：特定 Agent 專屬
- `custom:`：自定義範圍
- `project:`：專案範圍
- `user:`：用戶範圍

### 4. 自適應檢索
- 自動跳過問候語、命令、emoji
- 不對無意義內容浪費檢索

### 5. 雜訊過濾
- 過濾拒絕回覆（NO_REPLY）
- 過濾 Meta 問題
- 過濾寒暄內容

### 6. 時間衰減
- **60 天半衰期**
- 舊記憶自然淡化

### 7. 記憶強化
- 根據手動 recall 頻率延長半衰期
- 常用的記憶會被強化

### 8. Session 記憶
- `/new` 指令觸發
- 對話重置時自動保存

### 9. 彈性 Embedding
- 支援任意 OpenAI 相容 embedding
- 包括：OpenAI、Gemini、Jina、Ollama

## 📝 AutoRecall 功能

### 什麼是 AutoRecall？

LanceDB Pro 的 `autoRecall: true` 會在每次 LLM 回覆前，自動從記憶資料庫中檢索相關的過往對話，注入到 context 中。

也就是說：**你問的問題會自動帶相關背景，不需要每次都重複說明**。

### 相關設定參數

1️⃣ autoRecall
   - 預設值：true
   - 說明：開關（目前已開啟）

2️⃣ candidatePoolSize
   - 預設值：12
   - 說明：每次召回多少條候選記憶

3️⃣ minScore
   - 預設值：0.6
   - 說明：相關度閾值（低於此降權）

4️⃣ hardMinScore
   - 預設值：0.62
   - 說明：低於此直接過濾掉

5️⃣ extractMinMessages
   - 預設值：2
   - 說明：連續幾則訊息觸發自動擷取

6️⃣ vectorWeight
   - 預設值：0.7
   - 說明：語意相似權重

7️⃣ bm25Weight
   - 預設值：0.3
   - 說明：關鍵字匹配權重

### 調整建議

- **召回更多細節** → 調高 `candidatePoolSize`（如 20）
- **更靈敏** → 調低 `minScore`（如 0.3）
- **更精準** → 調高 `minScore`（如 0.7）

**現有配置已是 Pro 版推薦預設，通常不需要改。**

### ⚠️ 重要提醒

- **autoRecall 官方預設為 true**（自動注入相關記憶）
- 這是官方推薦設定，無需關閉

## 📚 相關資源

- GitHub：https://github.com/lancedb/lancedb
- GitHub（Pro）：https://github.com/win4r/memory-lancedb-pro

## 資料來源

- LanceDB Pro README
- 與小呈的對話（2026-03-18）
- 長期記憶提取（2026-03-19）

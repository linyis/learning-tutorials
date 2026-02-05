# OpenClaw 多任務並行教程

**影片連結**：https://www.youtube.com/watch?v=HwYVKc1zyPY

## 簡介

本影片介紹如何在 OpenClaw 中實現多任務並行處理，透過 Telegram 多群組、Discord 多頻道或子代理等方式來提升工作效率。

---

## 多任務並行方式

OpenClaw 提供多種並行處理方式：

| 方式 | 說明 |
|------|------|
| **Telegram 多群組** | 同一 Bot 可管理多個 Telegram 群組 |
| **Discord 多頻道** | 同一 Bot 可管理多個 Discord 頻道 |
| **子代理（Sub-Agents）** | 在單一會話內派發多個子代理進行處理 |

### 子代理限制

- OpenClaw 預設最多支援 **8 個子代理**
- 可依需求自行調整

---

## Telegram 配置

### 會話類型

| 類型 | 說明 |
|------|------|
| **DM（私聊）** | 與用戶的私訊對話 |
| **Group（群組）** | 群組內的對話 |

### 核心概念

- 同一 Bot 可配置 **多個聊天會話**
- 用戶給 Bot 發私訊會形成 **各自獨立的會話**
- 需要通過 **Pairing** 來做配置

### @提及回應設置

| 情境 | 設置方式 |
|------|----------|
| **所有群都必須 @ 才回應** | 將 requireMention 改為 true |
| **某群不需要 @ 也想回應** | "[GROUPID]" : {requireMention 改為 false} 單獨設置該群的規則 |

### 多 Bot 配置

- 同一 Gateway 可配置 **多個 Bot**
- 每個 Bot 都可以 **獨立調整**

---

## Discord 配置

### 會話類型

| 類型 | 說明 |
|------|------|
| **DM（私聊）** | 與用戶的私訊對話 |
| **伺服器頻道** | 伺服器內的頻道對話 |

### 重要提醒

⚠️ **DM 預設共享主會話**，如果需要多任務處理，建議使用 **伺服器頻道**。

### 最小配置步驟

1. **創建專用伺服器**
2. **開啟開發者模式**
   - Discord 設定 → 進階 → 開啟開發者模式
3. **創建並保護機器人**
   - Discord Developer Portal 創建 App
   - 建立 Bot 用戶
4. **配置機器人權限**
   - 建議 **關閉 Public Bot**（如果只是自己用）
   - **必須開啟 `Message Content Intent`**
     - 否則機器人無法讀取用戶消息
5. **將機器人引入伺服器**
   - 透過 OAuth2 生成邀請 URL
   - 賦予必要權限
   - 邀請機器人到伺服器

### OAuth2 URL 範例

```
https://discord.com/oauth2/authorize?client_id=YOUR_CLIENT_ID&permissions=XXXX&scope=bot
```

---

## 重要配置限制

| 項目 | 預設限制 | 說明 |
|------|----------|------|
| **跨會話並行處理** | 最多 4 個 | 不同會話之間的並行數 |
| **會話內子代理並行數** | 最多 18 個 | 單一會話內的子代理數 |

> 以上數值可自行調整。

---

## 安全配置建議

### Telegram 安全設置

| 設置選項 | 建議值 | 說明 |
|----------|--------|------|
| **DM Policy** | 僅白名單用戶 | 限制私聊權限 |
| **Allow Only** | 只有自己 | 僅自己可聯繫 Bot |
| **Group Allow Only** | 只有自己 | 僅自己能在群組觸發 Bot |

### 其他安全設定

1. **口令設置**
   - 輸入口令
   - 選擇 Bot
   - 選擇 **Disable**
   - 目的：防止機器人被拉入其他群

2. **群組隱私設定**
   - 若要 Bot 能看到群組消息
   - 調整隱私群組設定

### Discord 安全設置

1. **關閉 Public Policy**
2. **伺服器設置**
   - 白名單頻道
   - 白名單用戶
3. **限制觸發用戶**
   - 僅允許指定用戶使用
   - 可限制特定群組
4. **禁止機器人加入其他群**

### 跨會話並行總結

- 跨會話並行最多支援 **4 個**
- 可配置：
  - 同一 Gateway 4 個群組
  - Discord 4 個或多個頻道
- 只要同時跨會話對話 **不超過 4 個** 即可

---

## 實用命令

| 功能 | 命令 |
|------|------|
| 重啟 Gateway | `openclaw gateway restart` |
| 查看日誌 | 定位配置問題 |
| 查看所有會話 | 監控狀態 |
| 查看子代理 | 監控子任務 |

---

## 重要文件位置

| 文件 | 說明 |
|------|------|
| OpenClaw 配置文件 | 主要設定檔 |
| Gateway 日誌 | 問題排查日誌 |

## Json Sample
'''
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "--", /* 請和 @BotFather 拿 /*
      "groups" : {
        "-100xxxxxxxxxx" : {"requireMention": false}
      }
    }
  },

'''
---

## 快速入門檢查清單

- [ ] 安裝並設定 OpenClaw
- [ ] 配置 Telegram Bot（單一）
- [ ] 配置 Discord Bot（單一）
- [ ] 測試多群組/多頻道並行
- [ ] 配置子代理
- [ ] 調整並行限制（如需要）
- [ ] 設定安全策略
- [ ] 測試並優化

---

## 相關資源

- **OpenClaw GitHub**：https://github.com/openclaw/openclaw
- **OpenClaw 文檔**：https://docs.openclaw.ai
- **Telegram Bot 設定**：https://core.telegram.org/bots
- **Discord Developer**：https://discord.com/developers/applications

---

## 相關筆記

- [YouTube 影片下載 - yt-dlp 使用](/notes/youtube-download-yt-dlp.md)
- [影片轉音頻 - Whisper 使用](/notes/video-to-audio-whisper.md)

---

**更新日期**：2026-02-05
**標籤**：#openclaw #tutorial #multi-task #telegram #discord

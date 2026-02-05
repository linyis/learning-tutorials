# Telegram 機器人配對 OpenClaw

## 建立機器人

1. 在 Telegram 找到 @BotFather
2. 輸入 `/newbot`
3. 設置機器人名稱
4. **必須以 `_bot` 結尾**
5. 取得 Token（保存好）

## OpenClaw 配置

6. 將 Token 放入 OpenClaw 的 `telegram token` 設定

## 配對流程

7. 點擊 @BotFather 回覆中的連結，打開機器人對話視窗
8. 發送任意訊息給機器人，會收到配對 ID（例如：`___ID`）
9. 在 OpenClaw 執行：`openclaw pairing approve telegram ___ID`

---

**注意**：Token 請妥善保管，不要外流。

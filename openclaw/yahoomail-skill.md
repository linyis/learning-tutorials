# Yahoo Mail Skill 開發筆記

## 完成日期
2026-02-11

## 任務背景

原本想使用 MCP Server 來管理 Yahoo Mail，但發現：
1. OpenClaw 和 Claude Desktop 的 MCP 整合方式不同
2. OpenClaw 沒有內建 MCP 協議支援
3. 現成的 `yahoo-mail-mcp-server` 只適合 Claude Desktop

**決定**：將 MCP Server 的功能移植成 OpenClaw Skill

---

## 專案結構

```
skills/yahoomail/
├── SKILL.md       # 技能說明文件
├── yahoomail.py   # Python 主程式
└── .env           # 環境變數（帳號密碼）
```

---

## 可用功能

| 指令 | 功能 | 範例 |
|------|------|------|
| `/yahoomail list [數量] [資料夾]` | 列出最近郵件 | `/yahoomail list 20` |
| `/yahoomail read <uid> [資料夾]` | 讀取郵件內容 | `/yahoomail read 106` |
| `/yahoomail search [寄件人] [日期from] [日期to] [--unread]` | 搜尋郵件 | `/yahoomail search --unread` |
| `/yahoomail readmark <uid> [資料夾]` | 標記已讀 | `/yahoomail readmark 106` |
| `/yahoomail unreadmark <uid> [資料夾]` | 標記未讀 | `/yahoomail unreadmark 106` |
| `/yahoomail archive <uid> [資料夾]` | 封存郵件 | `/yahoomail archive 106` |
| `/yahoomail delete <uid> [資料夾]` | 刪除郵件 | `/yahoomail delete 106` |
| `/yahoomail star <uid> [資料夾]` | 加星號 | `/yahoomail star 106` |
| `/yahoomail unstar <uid> [資料夾]` | 移除星號 | `/yahoomail unstar 106` |
| `/yahoomail move <uid> <目標資料夾> [來源資料夾]` | 移動郵件 | `/yahoomail move 106 Archive INBOX` |
| `/yahoomail folders` | 列出所有資料夾 | `/yahoomail folders` |

---

## SKILL.md 內容

```markdown
---
name: yahoomail
description: Yahoo Mail 管理。列出郵件、讀取郵件、搜尋郵件、標記已讀/未讀、封存、刪除等功能。
---

# /yahoomail - Yahoo Mail 管理

## 功能

透過 IMAP 管理 Yahoo Mail 郵件：
- 列出最近郵件
- 讀取郵件內容
- 搜尋郵件（寄件人、日期、關鍵字）
- 標記已讀/未讀
- 封存郵件
- 刪除郵件
- 加星號/移除星號
- 移動郵件到其他資料夾

## 使用方式

...

## 設定

需要先設定環境變數或 .env 檔案：
```
YAHOO_EMAIL=XXXX@yahoo.com.tw
YAHOO_APP_PASSWORD=你的16碼app密碼
```

## .env 檔案位置

```
C:\Users\linyi\.openclaw\workspace\skills\yahoomail\.env
```

## 注意事項

- 使用 IMAP 連接 Yahoo Mail（端口：993）
- 需要 Yahoo App Password，不是登入密碼
- UID 是永久識別碼，刪除郵件後不會改變
```

---

## 運作原理

### 整體架構

```
使用者輸入 /yahoomail list 10
        ↓
OpenClaw 解析指令
        ↓
執行 yahoomail.py list
        ↓
Python 讀取 .env 取得帳號密碼
        ↓
IMAP 協議連線 Yahoo Mail 伺服器
        ↓
取得郵件資料
        ↓
解析並格式化輸出
```

### `/yahoomail list 10` 實際發生了什麼？

**Step 1: 指令解析**
```
輸入: /yahoomail list 10
解析: python yahoomail.py list 10
```

**Step 2: 讀取環境變數 (.env)**
```python
def load_env():
    env_path = r'C:\Users\linyi\.openclaw\workspace\skills\yahoomail\.env'
    # 讀取:
    # YAHOO_EMAIL=XXXX@yahoo.com.tw
    # YAHOO_APP_PASSWORD=xxxxxxxxxxxxxxxx
```

**Step 3: IMAP 連線**
```python
def get_connection():
    mail = imaplib.IMAP4_SSL("imap.mail.yahoo.com", 993)
    mail.login(email_addr, app_password)  # 使用 App Password 登入
    return mail
```

**Step 4: 選擇資料夾並搜尋**
```python
mail.select("INBOX")  # 選擇收件匣
status, messages = mail.search(None, "ALL")  # 搜尋全部郵件
email_ids = messages[0].split()  # 取得郵件 ID 清單
```

**Step 5: 擷取最新 N 封**
```python
recent_ids = email_ids[-10:]  # 取最後 10 封（最新）
```

**Step 6: 逐一解析郵件**
```python
status, msg_data = mail.fetch(eid, "(RFC822)")
msg = email.message_from_bytes(response[1])

# 提取：
# - Subject: decode_header(msg.get("Subject"))
# - From: decode_header(msg.get("From"))
# - Date: msg.get("Date")
# - UID: eid
```

**Step 7: 格式化輸出**
```python
print(f"[INBOX] - Recent 10 emails:")
for i, mail_item in enumerate(results, 1):
    print(f"{i}. [UID:{mail_item['uid']}] {mail_item['subject']}")
    print(f"   From: {mail_item['from']}")
```

---

## IMAP 協議基礎

### IMAP 是什麼？
IMAP (Internet Message Access Protocol) 是一種郵件存取協議，讓用戶可以在伺服器上管理郵件（與 POP3 不同，IMAP 不會自動下載刪除）。

### Yahoo Mail IMAP 設定

| 項目 | 值 |
|------|-----|
| 伺服器 | imap.mail.yahoo.com |
| 端口 | 993 (SSL/TLS) |
| 加密方式 | SSL/TLS |
| 認證 | App Password |

### App Password 取得方式
1. 前往 https://login.yahoo.com/account/security
2. 點選「Generate app password」
3. 選擇「Other App」，輸入「OpenClaw」
4. 複製 16 碼密碼

### 常用 IMAP 指令（Python imaplib）

| Python 函數 | IMAP 指令 | 用途 |
|-------------|----------|------|
| `imap.login()` | AUTHENTICATE | 登入 |
| `mail.select()` | SELECT | 選擇資料夾 |
| `mail.search()` | SEARCH | 搜尋郵件 |
| `mail.fetch()` | FETCH | 擷取郵件內容 |
| `mail.store()` | STORE | 修改郵件狀態 |
| `mail.copy()` | COPY | 複製郵件 |
| `mail.logout()` | LOGOUT | 登出 |

---

## UID vs 郵件編號

### UID (Unique Identifier)
- 每封郵件的唯一識別碼
- **永久不變**：刪除郵件後不會重用
- 用於跨會話操作（如：讀取、標記、刪除）

### 郵件編號 (Sequence Number)
- 依序編號：1, 2, 3...
- **會改變**：刪除郵件後，後面的編號會遞補
- 只在當前會話有效

**範例**：
```
UID: 106, 107, 108, 109, 110
編號: 1,    2,    3,    4,    5

刪除編號 3 (UID 108) 後：
UID: 106, 107,       109, 110
編號: 1,    2,    3,    4  ← 編號 3 現在是 UID 109
```

**結論**：所有操作都使用 UID，確保正確性。

---

## 遇到的問題與解決

### 問題 1：Windows 編碼問題
- **錯誤**：`UnicodeEncodeError: 'cp950' codec can't encode character`
- **原因**：Windows CMD 使用 Big5 編碼，無法顯示某些 Emoji
- **解決**：移除所有 Emoji，改用純 ASCII 文字

### 問題 2：指令參數解析
- **現象**：`cmd_folders()` 收到不需要的參數
- **解決**：將函數改為接受 `args=None`

---

## 參考資源

- [Yahoo Mail MCP Server (原始專案)](https://github.com/jtokib/yahoo-mail-mcp-server)
- [Python imaplib 文件](https://docs.python.org/3/library/imaplib.html)
- [Yahoo Mail IMAP 設定](https://help.yahoo.com/kb/SLN4074.html)

---

## 總結

成功將 MCP Server 移植為 OpenClaw Skill，使用 Python + IMAP 協議直接管理 Yahoo Mail。

**優點**：
- 不依賴 MCP 協議，與 OpenClaw 原生整合
- 程式碼簡單易懂
- 功能完整（讀、搜、標記、刪除、封存）

**後續可擴充**：
- 支援多帳號
- 回覆郵件功能
- 附件下載

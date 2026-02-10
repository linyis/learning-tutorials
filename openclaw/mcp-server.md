# Personal Knowledge Base MCP Server

## 概述

個人知識庫 MCP Server，讓 AI Agent（Claude Desktop、Cursor 等）能夠存取個人資料。

**位置:** `C:\Users\linyi\.openclaw\workspace\mcp-server`

---

## 功能清單

### 🤖 MySQL 資料庫
| 工具函數 | 功能 |
|----------|------|
| `mysql_query(sql)` | 唯讀 SELECT 查詢（禁止 INSERT/UPDATE/DELETE） |
| `mysql_list_tables()` | 列出所有表格 |
| `mysql_describe_table(name)` | 取得表格結構 |

### 📁 專案管理
| 工具函數 | 功能 |
|----------|------|
| `list_projects()` | 列出所有已歸檔專案 |
| `get_project(name)` | 取得特定專案資訊 |
| `search_projects(query)` | 依名稱/標籤/描述搜尋 |
| `add_project(...)` | 新增專案歸檔 |

### 📝 筆記管理
| 工具函數 | 功能 |
|----------|------|
| `list_daily_notes(days)` | 列出最近 N 天的每日筆記 |
| `read_daily_note(date)` | 讀取筆記（YYYY-MM-DD 格式） |
| `write_daily_note(date, content)` | 寫入每日筆記 |

### 🧠 記憶體搜尋
| 工具函數 | 功能 |
|----------|------|
| `search_memory(query)` | 搜尋 MEMORY.md 和 daily notes |

### 📚 學習筆記
| 工具函數 | 功能 |
|----------|------|
| `search_tutorials(query)` | 搜尋 learning-tutorials |
| `list_tutorials_dirs()` | 列出目錄結構 |

### 🔧 設備列表
| 工具函數 | 功能 |
|----------|------|
| `list_ssh_hosts()` | 解析 TOOLS.md SSH 主機 |
| `list_cameras()` | 解析 TOOLS.md Camera |

---

## 檔案結構

```
mcp-server/
├── mcp_server.py        # MCP Server 主程式 (fastmcp)
├── requirements.txt     # Python 依賴
├── config.json          # 設定檔（MySQL 連線）
├── README.md            # 英文使用說明
└── data/
    └── projects.json    # 專案歸檔資料庫
```

---

## 安裝與執行

### 1. 安裝依賴
```bash
cd C:\Users\linyi\.openclaw\workspace\mcp-server
pip install -r requirements.txt
```

### 2. 設定 MySQL 環境變數
```bash
set MYSQL_HOST=localhost
set MYSQL_PORT=3306
set MYSQL_USER=your_user
set MYSQL_PASSWORD=your_password
set MYSQL_DATABASE=your_database
```

### 3. 執行 Server
```bash
python mcp_server.py
```

---

## Claude Desktop 整合

修改 `~/.claude/mcp.json`：

```json
{
  "mcpServers": {
    "personal-knowledge-base": {
      "command": "python",
      "args": ["C:\\Users\\linyi\\.openclaw\\workspace\\mcp-server\\mcp_server.py"],
      "env": {
        "MYSQL_HOST": "localhost",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "user",
        "MYSQL_PASSWORD": "password",
        "MYSQL_DATABASE": "dbname"
      }
    }
  }
}
```

---

## 專案歸檔格式

`data/projects.json`:
```json
{
  "version": "1.0",
  "projects": [
    {
      "name": "AI_Cashflow",
      "path": "C:\\Users\\linyi\\Desktop\\AI_Cashflow",
      "type": "chrome-extension",
      "description": "資產管理 Chrome 擴充功能",
      "git": true,
      "tags": ["finance", "chrome-extension", "typescript"]
    }
  ]
}
```

---

## 相關技能

- [dSSH](../dsssh/) - SSH 登入 Synology NAS
- [phonetts](./phonetts-skill.md) - Telegram 錄音轉文字
- [selftts](./selftts.md) - 手動上傳錄音轉文字

---

## 技術棧

- **fastmcp** - MCP Server 框架
- **pydantic** - 資料驗證
- **pymysql** - MySQL 連線
- **Model Context Protocol** - AI Agent 工具協議

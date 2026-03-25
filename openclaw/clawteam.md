# ClawTeam 學習筆記

**更新日期**：2026-03-24
**適用版本**：ClawTeam-OpenClaw v0.3.0（fork by win4r）

---

## 0️⃣ 安裝指南（win4r Fork）

### 第 1 步：確認前置需求

```bash
python3 --version   # 需要 3.10 以上
tmux -V             # 需要任意版本
openclaw --version  # 或 claude --version / codex --version
```

| 工具 | macOS | Ubuntu/Debian |
|------|-------|---------------|
| Python 3.10+ | `brew install python@3.12` | `sudo apt update && sudo apt install python3 python3-pip` |
| tmux | `brew install tmux` | `sudo apt install tmux` |
| OpenClaw | `pip install openclaw` | `pip install openclaw` |

### 第 2 步：Clone 並安裝 ClawTeam

⚠️ **不要**用 `pip install clawteam`（那是舊版上游），必須從這個 repo 安裝：

```bash
git clone https://github.com/win4r/ClawTeam-OpenClaw.git
cd ClawTeam-OpenClaw
pip install -e .
```

若需要 P2P 傳輸（ZeroMQ）：
```bash
pip install -e ".[p2p]"
```

若安裝失敗，先執行：
```bash
pip install hatchling
```

### 第 3 步：建立 symlink

```bash
mkdir -p ~/bin
ln -sf "$(which clawteam)" ~/bin/clawteam
```

若 `which clawteam` 找不到，手動搜尋：
```bash
find / -name clawteam -type f 2>/dev/null | head -5
```

確保 `~/bin` 在 PATH 中（加入 `~/.zshrc` 或 `~/.bashrc`）：
```bash
export PATH="$HOME/bin:$PATH"
```

### 第 4 步：安裝 OpenClaw Skill 檔案

```bash
mkdir -p ~/.openclaw/workspace/skills/clawteam
cp skills/openclaw/SKILL.md ~/.openclaw/workspace/skills/clawteam/SKILL.md
```

### 第 5 步：設定執行權限（OpenClaw 用戶）

讓 agent 可以自動執行 clawteam 指令，不需要每次手動確認：

```bash
# 設定安全模式為 allowlist
python3 -c "
import json, pathlib
p = pathlib.Path.home() / '.openclaw' / 'exec-approvals.json'
if p.exists():
    d = json.loads(p.read_text())
    d.setdefault('defaults', {})['security'] = 'allowlist'
    p.write_text(json.dumps(d, indent=2))
    print('Updated: security = allowlist')
else:
    print('找不到設定檔，請先執行一次 openclaw 再重跑此步驟')
"

# 將 clawteam 加入白名單
openclaw approvals allowlist add --agent "*" "*/clawteam"
```

### 第 6 步：驗證安裝成功

```bash
clawteam --version      # 應顯示版本號
clawteam config health  # 應全部顯示綠燈
```

若使用 OpenClaw，確認 skill 已載入：
```bash
openclaw skills list | grep clawteam
```

---

## 1️⃣ 什麼是 ClawTeam

ClawTeam 是一個多 agent 協作 CLI 工具，讓 OpenClaw（或任何 CLI agent）能夠自主分組、分配任務、互相傳訊、最後合併結果。

核心理念：人類只需要說目標，agent  swarm 自己會拆解、執行、協調。

---

## 2️⃣ 與 OpenClaw 的關係

ClawTeam-OpenClaw 這個 fork 讓 OpenClaw 成為預設 agent backend，實現：

| 功能 | 單獨使用 OpenClaw | OpenClaw + ClawTeam |
|------|-------------------|---------------------|
| 任務分配 | 手動個別通知 | Leader 自動拆分、分配 |
| 平行開發 | 共用目錄 | 每個 agent 獨立 git worktree |
| 依賴管理 | 手動輪詢 | `--blocked-by` 自動解除 |
| 溝通機制 | 只能透過 relay | 直接點對點 inbox + 廣播 |
| 觀察性 | 讀 log | Kanban 看板 + tmux 分屏視圖 |

---

## 3️⃣ 系統架構

### 3.1 資料流

```
CLI 命令（clawteam task create / inbox send / spawn）
        ↓
commands.py（Typer CLI 解析）
        ↓
TeamManager / TaskStore / MailboxManager（商業邏輯）
        ↓
MailboxManager._transport.deliver()
        ↓
FileTransport → 寫入 ~/.clawteam/teams/{team}/inboxes/{agent}/msg-*.json
   或
P2PTransport → ZMQ PUSH 到對方 + 檔案兜底
```

### 3.2 目錄結構

```
~/.clawteam/
├── teams/<team>/
│   ├── config.json         # 團隊設定
│   ├── inboxes/<agent>/    # 訊息收件匣
│   │   └── msg-*.json
│   └── events/             # 事件日誌（不刪除）
├── tasks/<team>/
│   ├── task-<id>.json      # 各任務狀態
│   └── .tasks.lock         # fcntl 鎖檔
└── workspaces/<team>/     # git worktree（可選）
```

### 3.3 Task 依賴自動解除機制

```
task A (completed)
    ↓
TaskStore._resolve_dependents_unlocked(A.id)
    ↓
遍歷所有 task，檢查 blocked_by 包含 A.id
    ↓
移除 blocked_by 中的 A.id
    ↓
若 blocked_by 變空 且 status == blocked → 改為 pending
```

**注意**：TaskStore 只更新了 task 檔案，**沒有主動通知 agent**，所以 agent 不知道自己已經解除封鎖。這是造成「卡住」的根本原因。

### 3.4 Spawn 架構

```
clawteam spawn -t <team> -n <name> --task "..."
        ↓
TmuxBackend.spawn()
        ↓
tmux new-window -t clawteam-<team>
        ↓
在 window 內執行 agent 命令（openclaw / claude / codex）
        ↓
agent 收到含 CLAWTEAM_* 環境變數 + 協調提示的 prompt
        ↓
agent 透過 clawteam CLI 與團隊互動
```

---

## 4️⃣ 常用指令

### 團隊管理
```bash
clawteam team spawn-team <name> -d "<desc>" -n leader
clawteam team discover
clawteam team cleanup <team> --force
```

### 任務管理
```bash
clawteam task create <team> "<subject>" -o <owner> --blocked-by <id>
clawteam task update <team> <id> --status completed
clawteam board show <team>
```

### Agent 啟動
```bash
clawteam spawn -t <team> -n <name> --task "<task>" --no-workspace
```

### 訊息傳遞
```bash
clawteam inbox send <team> <to> "<msg>" --from <sender>
clawteam inbox receive <team>
clawteam inbox peek <team> -a <agent>
```

---

## 5️⃣ Known Issues（踩坑記錄）

### 5.1 Auto-unblock 有時失效

**症狀**：任務鏈中（researcher → analyst → advisor），即使上游任務完成，下游任務狀態已經是 `pending` 且 `blockedBy: []`，但 agent 仍處於 idle，不會自動開始工作。

**原因**：TaskStore._resolve_dependents_unlocked 只更新了 task 檔案，沒有主動通知 agent。Agent 需要主動 poll inbox 才會知道有新任務。

**處理方式**：手動喚醒 agent
```bash
# Step 1: 確認任務狀態
clawteam board show <team>

# Step 2: 手動發送 inbox 訊息
clawteam inbox send <team> <agent> "任務已就緒，請開始工作" --from leader

# Step 3: 強制執行 inbox receive
tmux send-keys -t clawteam-<team>:<window> 'clawteam inbox receive <team>' Enter
```

**預防原則**：在第一個 agent 剛開始跑時，就預先幫下一個 agent 準備好完整上下文，並在第一個完成後立即主動轉交，不要被動等待。

---

### 5.2 Git worktree 建立失敗

**症狀**：`clawteam spawn` 失敗，錯誤訊息：`git worktree add: fatal: invalid reference: master`

**原因**：ClawTeam 預設以 `master` 為基礎分支建立 worktree，但許多 repo 的預設分支是 `main` 而非 `master`。

**解法**：加上 `--no-workspace` 忽略 worktree：
```bash
clawteam spawn -t <team> -n <name> --task "..." --no-workspace
```

---

### 5.3 串鏈任務需要手動轉交上下文

**症狀**：advisor 不會自動取得 analyst 的報告內容，導致給出的建議缺乏上游資料。

**解法**：在 analyst 完成後，立即轉發摘要給 advisor，並主動喚醒：
```bash
clawteam inbox send <team> advisor "分析摘要：..." --from leader
tmux send-keys -t clawteam-<team>:<window> 'clawteam inbox receive <team>' Enter
```

---

### 5.4 Agent session 可能「abort」

**症狀**：tmux window 顯示 `run aborted`，任務卡在 `pending`，不同於單純的 idle。

**原因**：agent 程序被系統終止或崩潰，可能是資源不足或時間過長。

**預防**：在 analyst 完成後，立即主動轉發完整摘要給 advisor 並喚醒，不要被動等待。這樣就算 advisor 重啟，手上也已經有所有資料。

---

## 6️⃣ 建議 Workflow（實戰流程）

### 標準三階段任務
```
researcher → analyst → advisor
```

**Step 1**：建立團隊
```bash
clawteam team spawn-team <team> -d "<goal>" -n leader
```

**Step 2**：依序建立任務（researcher 領頭，後面兩個用 --blocked-by）
```bash
clawteam task create <team> "研究任務" -o researcher
# 取得第一個任務 ID，例如 abc123
clawteam task create <team> "分析任務" -o analyst --blocked-by abc123
clawteam task create <team> "建議任務" -o advisor --blocked-by <第二個任務ID>
```

**Step 3**：Spawn 三個 agent（researcher 先跑，其餘等待）
```bash
clawteam spawn -t <team> -n researcher --task "研究任務內容..." --no-workspace
clawteam spawn -t <team> -n analyst --task "等待 researcher 完成..." --no-workspace
clawteam spawn -t <team> -n advisor --task "等待 analyst 完成..." --no-workspace
```

**Step 4**：研究完成後，立即轉交 analyst（不要等）
```bash
clawteam inbox send <team> analyst "研究摘要：..." --from leader
tmux send-keys -t clawteam-<team>:<window_id> 'clawteam inbox receive <team>' Enter
```

**Step 5**：分析完成後，立即轉交 advisor（不要等）
```bash
clawteam inbox send <team> advisor "研究摘要 + 分析摘要：..." --from leader
tmux send-keys -t clawteam-<team>:<window_id> 'clawteam inbox receive <team>' Enter
```

**Step 6**：完成後主動回報使用者，再清理團隊
```bash
clawteam board show <team>
clawteam team cleanup <team> --force
```

---

## 7️⃣ 模組速查

| 模組 | 檔案 | 職責 |
|------|------|------|
| TaskStore | `team/tasks.py` | 任務 CRUD、依賴追蹤、fcntl 鎖 |
| MailboxManager | `team/mailbox.py` | 訊息收發，委託 Transport |
| TmuxBackend | `spawn/tmux_backend.py` | 在 tmux window 啟動 agent |
| FileTransport | `transport/file.py` | 訊息寫入 JSON 檔案 |
| P2PTransport | `transport/p2p.py` | ZMQ P2P + 檔案兜底 |
| WorkspaceManager | `workspace/manager.py` | Git worktree 建立與管理 |
| PromptInjector | `spawn/prompt.py` | 注入協調提示到 agent prompt |

---

## 8️⃣ 與 upstream（HKUDS/ClawTeam）的差異

| 差異 | ClawTeam-OpenClaw（win4r fork） |
|------|----------------------------------|
| 預設 agent | OpenClaw | Claude Code |
| Exec 核准 | 自動設定 allowlist 模式 | 手動設定 |
| Session 隔離 | 每 tmux window 獨立 OpenClaw session | 無 |
| 安裝方式 | `pip install -e .`（不走 PyPI） | PyPI |

---

*本筆記基於 2026-03-22 實際使用經驗建立，包含兩次石油分析任務和一次台積電分析任務的觀察。*

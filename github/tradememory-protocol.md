# TradeMemory Protocol

> 建立日期：2026-03-19

## 📌 專案資訊
- **名稱**：TradeMemory Protocol
- **作者**：mnemox-ai
- **GitHub**：https://github.com/mnemox-ai/tradememory-protocol
- **官網**：https://pypi.org/project/tradememory-protocol/
- **開源協議**：MIT
- **分類**：AI 交易 · 記憶層 · MCP

## 📝 概述

AI 交易機器人的記憶層（Memory Layer），解決 200+ 交易 MCP 伺服器執行交易但無法記住發生了什麼的問題。

## ✨ 核心功能

### 1. 持久記憶
記錄每筆交易的完整上下文：
- 進場理由（entry reasoning）
- 市場狀態（market regime）
- 信心水準（confidence level）
- 交易結果（outcome）

### 2. 模式發現（Pattern Discovery）
自動找出人類無法手動發現的規律。

### 3. 結果加權回憶（Outcome-Weighted Recall）
根據五個因素加權：
- **Q（Quality）**：交易品質，+3R 得分 0.98，-3R 得分 0.02
- **Sim（Similarity）**：與當前市場上下文相似度
- **Rec（Recency）**：30 天記憶保留 71%，1 年保留 28%
- **Conf（Confidence）**：高信心狀態形成的記憶得分更高
- **Aff（Affect）**：虧損時 Caution 記憶浮現，獲利時檢查過度自信

### 4. 演化引擎（Evolution Engine）
從原始價格數據自動發現交易策略：
- **Discover**：LLM 分析價格數據，提出候選策略
- **Backtest**：向量化引擎測試每個候選
- **Select**：樣本內排名 → 樣本外驗證（Sharpe > 1.0, trades > 30, max DD）

## 📊 驚人成績

**22 個月 BTC 數據：**
- **Sharpe：3.84**
- 477 筆交易
- **91% 盈利月份**（20/22）
- **最大回撤僅 0.22%**
- **零人類策略輸入** — 完全由 LLM 自動發現

## 🔧 安裝方式

```bash
pip install tradememory-protocol
```

### MCP 設定（Claude Desktop）
```json
{
  "mcpServers": {
    "tradememory": {
      "command": "uvx",
      "args": ["tradememory-protocol"]
    }
  }
}
```

### Claude Code
```bash
claude mcp add tradememory -- uvx tradememory-protocol
```

### Docker
```bash
git clone https://github.com/mnemox-ai/tradememory-protocol.git
cd tradememory-protocol
docker compose up -d
```

## 🛠️ 15 個 MCP 工具

### 交易記憶
| 工具 | 說明 |
|------|------|
| `store_trade_memory` | 儲存交易與完整上下文 |
| `recall_similar_trades` | 找相似市場上下文的過去交易 |
| `get_strategy_performance` | 取得每策略的匯總統計 |
| `get_trade_reflection` | 深入分析交易推理與教訓 |

### 記憶層
| 工具 | 說明 |
|------|------|
| `remember_trade` | 同時儲存到五個記憶層 |
| `recall_memories` | 結果加權回憶，含完整分數分解 |
| `get_behavioral_analysis` | 持有時間、處置比率、Kelly 比較 |
| `get_agent_state` | 當前信心、風險偏好、回撤、連勝/連敗 |
| `create_trading_plan` | 條件式計劃（前瞻記憶） |
| `check_active_plans` | 匹配計劃與當前上下文 |

### 演化引擎
| 工具 | 說明 |
|------|------|
| `evolution_run` | 完整發現→回測→選擇週期 |
| `evolution_status` | 檢查運行進度 |
| `evolution_results` | 取得畢業策略及完整指標 |
| `evolution_compare` | 世代並排比較 |
| `evolution_config` | 查看/更新演化參數 |

## 📚 文件

- [OWM Framework](https://github.com/mnemox-ai/tradememory-protocol/blob/master/docs/OWM_FRAMEWORK.md) — 完整理論基礎（1,875 行）
- [Tutorial (EN)](https://github.com/mnemox-ai/tradememory-protocol/blob/master/docs/TUTORIAL.md)
- [Tutorial (中文)](https://github.com/mnemox-ai/tradememory-protocol/blob/master/docs/TUTORIAL_ZH.md)
- [API Reference](https://github.com/mnemox-ai/tradememory-protocol/blob/master/docs/API.md)

## 🔗 相關資源

- PyPI：https://pypi.org/project/tradememory-protocol/
- Smithery：https://smithery.ai/server/io.github.mnemox-ai/tradememory-protocol
- Claude Plugin：https://github.com/mnemox-ai/tradememory-plugin

## 📦 應用場景

- **Crypto**：餵入 BTC/ETH 交易，演化引擎發現人類無法找到的時機模式
- **Forex + MT5**：自動同步 MetaTrader 5 每一筆平倉交易
- **開發者**：構建有記憶的交易代理，15 個 MCP 工具 + 30 個 REST 端點

## 💡 我的分析

待补充...

## 🏷️ 標籤
- AI
- Trading
- Memory
- MCP
- Agent

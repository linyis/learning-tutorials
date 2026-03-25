# LDPlayer 安裝與網路抓包設定

**日期：** 2026-03-20
**作者：** Anson Lin

---

## 環境

- **模擬器：** LDPlayer 9（雷電模擬器）
- **安裝路徑：** `Z:\LDPlayer9`（WSL2 下：`/mnt/z/LDPlayer9`）
- **作業系統：** Windows 11
- **ADB 連接：** `127.0.0.1:5555`

---

## 完整設定流程

### 1. 啟動 ADB（Windows）
```bash
adb connect 127.0.0.1:5555
```

### 2. 啟動 MITM Proxy（Windows）
```bash
mitmproxy -p 8080
```

### 3. 設定模擬器代理
- 位置：**設定 → WiFi → 長按網路 → 修改網路 → 進階**
- 代理主機：`172.60.160.1`（模擬器的網關 IP）
- 代理連接埠：`8080`

### 4. 下載並安裝 CA 憑證

#### 4.1 下載憑證（模擬器內）
- 打開瀏覽器，訪問：`http://mitm.it`
- 點擊 **Android** 下載憑證

#### 4.2 複製憑證到模擬器系統目錄
```bash
# 從 Windows 複製到模擬器
adb -s 127.0.0.1:5555 push C:\Users\linyi\.mitmproxy\mitmproxy-ca-cert.cer /sdcard/

# 進入模擬器 shell
adb -s 127.0.0.1:5555 shell
su

# 備份並掛載 system 為可寫
cp -r /system/etc/security/cacerts /sdcard/cacerts_backup
mount -t tmpfs tmpfs /system/etc/security/cacerts
cp /sdcard/cacerts_backup/* /system/etc/security/cacerts/

# 複製憑證（需先計算 hash）
# 見下節）

# 設定權限
chmod 644 /system/etc/security/cacerts/*
```

#### 4.3 計算憑證 Hash（WSL2）
```bash
# 複製憑證到 WSL 能訪問的位置
cp /mnt/c/Users/linyi/.mitmproxy/mitmproxy-ca-cert.cer /mnt/z/LDPlayer9/mitmproxy-ca-cert.pem

# 計算 hash
openssl x509 -inform PEM -subject_hash_old -in /mnt/z/LDPlayer9/mitmproxy-ca-cert.pem | head -1
# 輸出範例：c8750f0d

# 重新命名憑證
mv /mnt/z/LDPlayer9/mitmproxy-ca-cert.pem /mnt/z/LDPlayer9/c8750f0d.0
```

#### 4.4 推送並設定憑證
```bash
# 推入模擬器
adb -s 127.0.0.1:5555 push /mnt/z/LDPlayer9/c8750f0d.0 /sdcard/

# 在模擬器 shell 中執行
cp /sdcard/c8750f0d.0 /system/etc/security/cacerts/c8750f0d.0
chmod 644 /system/etc/security/cacerts/c8750f0d.0
```

---

## 遊戲 API（可直接用 curl 下注）

### 基礎資訊
- **IP 位址**：WSL2 訪問 Windows 模擬器 → `172.20.160.1`
- **連接埠**：`5000`

### API 列表

#### 1. 查詢連線狀態
```bash
curl http://172.20.160.1:5000/status
```
回傳：
```json
{"connected":true,"roundId":1069510}
```

#### 2. 下注
```bash
curl "http://172.20.160.1:5000/bet?award=1&amount=1000"
```
參數：
- `award`: 圖案編號 (1-8)
- `amount`: 投注金額

回傳：
```json
{"amount":1000,"award":1,"name":"烤雞","ok":true,"roundId":1069510}
```

### 圖案編號對照（正確版本）
```
1=烤雞(10倍), 2=蘋果(5倍), 3=龍蝦(45倍), 4=香蕉(5倍)
5=雞腿(15倍), 6=西瓜(5倍), 7=魚(25倍), 8=草莓(5倍)
```

---

## WatchCat 遊戲分析系統

### 專案位置
- **NAS 路徑**: `/mnt/nas/web/proj/watchcat/`
- **網址**: http://linyis.synology.me/proj/watchcat/
- **資料庫**: MySQL `watchdog.watchcat_logs`

### 檔案結構
```
watchcat/
├── index.php      # 前端頁面 (AJAX)
├── data.php       # API (JSON) - 統計分析
├── api.php        # 寫入 API
├── import.php     # 匯入 JSON
├── bet.php        # 投注開關控制 (bet_on, start, end)
├── hope.php       # 期望投注推薦
└── logs/          # JSON 日誌
```

### 核心演算法

**理論機率** (按倍率反比):
- 5倍 → 20%
- 10倍 → 10%
- 15倍 → 6.7%
- 25倍 → 4%
- 45倍 → 2.2%

**最近筆數** = 基數 × 倍率
- 基數可選: 25, 50, 75, 100, 125

**偏差%** = 最近% - 全部%

### 投注策略

**斐波那契**: 1,1,2,3,5,8... (最少20局, 45倍需45局)
**達朗貝爾**: 輸+1, 贏-1 (最少20局)

### hope.php 投注推薦邏輯

**資料庫**: `watchcat_settings`
- `bet_on`: 是否投注 (0/1)
- `start`: 連續不開後開始考慮的局數
- `end`: 額外容忍局數

**邏輯流程**:
1. `bet_on=0` → 回傳 `{"hope": null}`
2. 對每個水果 (西瓜=6, 蘋果=2, 香蕉=4, 草莓=8):
   - `gap <= start` → 跳過
   - ~~`gap > start + end` → 跳過（放棄）~~ (2026-03-23 拿掉：實測 2,4,6,8 最大不開局數約 35 局)
   - 計算：`最近%` vs `總平均%`
   - `recentPct >= totalPct` → 權重未通過，跳過
3. 從通過的中找「最近% - 總平均%」差距最大（最被低估）
4. 回傳 `{"hope": id, "times": gap}`

**重要備註**:
- 2026-03-23: 拿掉 `gap > start+end` 限制
- 原因: Anson 類比後發現 id=2,4,6,8 最大不開局數約 35 局，這個限制會錯誤排除還沒開的 ID

**參數**:
- `weight=N` (可選, 預設105) - 拿最近N筆計算
- 回傳: `{"hope": id, "times": 次數}` 或 `{"hope": null}`

### bet.php API

- `bet.php` → `{"bet": 1, "start": 7, "end": 14}`
- `bet.php?change=1` → 更新 bet_on
- `bet.php?start=8&end=15` → 更新 start/end

### check_alert.php 警報腳本

**位置**: `/mnt/nas/web/proj/watchcat/check_alert.php`
**URL**: http://linyis.synology.me/proj/watchcat/check_alert.php

**警報條件**:
- 龍蝦 45x: gap 125-130 通知
- 魚 25x: gap 65-70 通知

**時間限制**: 23:30 - 09:00 不通知

**WSL cron**: `*/2 * * * * curl "http://linyis.synology.me/proj/watchcat/check_alert.php"`

### 數據來源
- mitmproxy 攔截遊戲 App API
- JSON格式: `{"r":roundId,"o":outcome,"t":totalBet,"b":[8 bets],"p":profit}`

---

## 遊戲數據分析腳本

### 腳本位置
`/mnt/c/Users/linyi/.mitmproxy/summary.py`

### 使用方式
```bash
python3 /mnt/c/Users/linyi/.mitmproxy/summary.py
```

### 輸出內容
1. 正確機率分布
2. 莊家狀態
3. 觀察
4. 結論
5-9. 各策略分析

---

## 遊戲數據記錄

### 數據格式
```json
{"r":1069312,"o":6,"t":24677040,"b":[魚,龍蝦,烤雞,雞腿,香蕉,蘋果,西瓜,草莓],"p":15319390}
```

### 欄位說明
| 欄位 | 意義 |
|------|------|
| `r` | roundId |
| `o` | 中獎圖案編號 (1-8) |
| `t` | 總投注 |
| `b` | 8種圖案投注陣列 |
| `p` | 莊家損益 (+)為賺, (-)為虧 |

### 圖案編號
```
1=烤雞🐓(10倍), 2=蘋果🍎(5倍), 3=龍蝦🦞(45倍), 4=香蕉🍌(5倍)
5=雞腿🍗(15倍), 6=西瓜🍉(5倍), 7=魚🐟(25倍), 8=草莓🍓(5倍)
```

### 數據位置
- 目錄：`/mnt/c/Users/linyi/.mitmproxy/logs/`
- 檔名：`YYYYMMDD_N.json`（每檔最多 1000 筆）

---

## 2026-03-26｜mitmproxy 架構大更新

### 新增檔案

| 檔案 | 用途 |
|------|------|
| `final-local3.py` | mitmproxy WebSocket 攔截 + ADB 自動投注 + 警報觸發 |
| `check_alert.py` | 獨立警報發送腳本（多帳號 Telegram）|
| `proxy.bat` | Windows 啟動腳本：`mitmweb -s final-local3.py --listen-port 8080` |
| `telegram-list.json` | 多帳號 Telegram 設定（token + chat_id 陣列）|
| `suggest-3.txt` | 龍蝦 45x 斐波那契策略表（20局）|
| `suggest-7.txt` | 魚 25x 斐波那契策略表（20局）|

### final-local3.py 核心架構

**Startup 流程：**
1. `load_history()` → 從 `logs/` 載入所有 .json 檔，建立 chronological `state["history"]`
2. `fetch_bet_settings()` → 從 `bet.php` 取得投注開關
3. `calc_hope()` → 滾動窗口計算 hope（in-memory）

**WebSocket 訊息處理：**
- `cmd=3002` → 每秒更新統計資料
- `cmd=3001` → 新局開始，執行 ADB 點擊（`do_betting`）
- `cmd=3003` → 停止下注，查詢下一局策略
- `cmd=2008` → 開獎結果，寫入 logs/ + POST api.php + 警報檢查

**警報觸發條件：**
- 魚 (id=7)：gap ≥ 85 局，冷卻 10 分鐘
- 龍蝦 (id=3)：本局投注 > 2億，冷卻 10 分鐘

**hope 評估對象：** `FRUIT_IDS = [2, 4, 6, 8]`（蘋果、香蕉、西瓜、草莓）

### check_alert.py 流程

```
final-local3.py → 讀取 stdin JSON (entry + gap_fish + send[]) 
               → 讀取 telegram-list.json
               → 讀取 suggest-3.txt / suggest-7.txt
               → 發送 Telegram（多帳號）
```

### 完整資料流

```
LDPlayer 遊戲
    ↓ WebSocket
mitmproxy (final-local3.py)
    ├→ 攔截解析 (cmd 3001/3002/3003/2008)
    ├→ 寫入 logs/YYYYMMDD_N.json
    ├→ POST → NAS api.php → MySQL
    ├→ hope 計算（滾動窗口 in-memory）
    ├→ ADB 點擊（投注時）
    └→ 符合條件 → call check_alert.py
           └→ Telegram 多帳號通知
               └→ 夾帶斐波那契策略表
```

### mitmproxy 啟動方式（Windows）

```bat
mitmweb -s final-local3.py --listen-port 8080
```

或雙擊 `proxy.bat`

---

## 備忘

- **模擬器網關 IP：** `172.60.160.1`
- **Proxy 連接埠：** `8080`
- **mitmproxy 日誌位置：** `C:\Users\linyi\.mitmproxy\`
- **logs/ 目錄：** `/mnt/c/Users/linyi/.mitmproxy/logs/`（每檔 1000 筆）
- **NAS 專案：** `/mnt/nas/web/proj/watchcat/`

---

## 參考資源

- [mitmproxy 官方文檔](https://docs.mitmproxy.org/)
- [Android 模擬器網路設定](https://developer.android.com/studio/run/emulator-networking)

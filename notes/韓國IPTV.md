# 韓國 IPTV 免費直播 sources 清單

> 本文整理韓國電視頻道的免費 IPTV 列表，包含使用方式與注意事項

## 簡介

韓國 IPTV 與其他國家相比，公開的穩定來源較少，主要原因在於：
1. 韓國電視台對海外播放有嚴格的地區限制（Geo-blocking）
2. 大多數直播源需要韓國 IP 位址才能觀看
3. 公開的免費來源經常變動

以下整理目前可取得的韓國 IPTV 資源：

---

## 推薦來源

### 1. iptv-org 韓語頻道庫（最推薦）

這是目前最穩定、公開的韓國頻道來源，由 iptv-org 社群維護。

**M3U 播放清單網址：**
```
https://iptv-org.github.io/iptv/languages/kor.m3u
```

**包含頻道範例：**
- ABN TV
- Arirang Radio
- BBS 佛教廣播電台
- BTN TV
- CJ OnStyle
- EBS 教育台（EBS 1、EBS 2）

**使用方法：**
1. 打開 PotPlayer（或其他支援 M3U 的播放器）
2. 按 `Ctrl + U` 貼上網址
3. 開始播放

**評價：**
- ✅ 完全免費
- ✅ 無需設定
- ✅ 自動更新
- ⚠️ 部分頻道有地區限制

---

### 2. HerbertHe/iptv-sources

這是一個聚合多個來源的项目，包含韓國頻道。

**官方展示頁面：**
https://m3u.ibert.me

**特點：**
- 聚合 8 個 IPTV 來源
- 每 2 小時自動更新
- 提供 EPG 電子節目表
- 需自行挑選頻道列表

---

### 3. 其他 GitHub 資源

| 項目 | 網址 | 說明 |
|------|------|------|
| skylover007/iptv | [GitHub](https://github.com/skylover007/iptv) | 韓國 IPTV M3U 列表 |
| diskreet90/GlobalIPTV | [GitHub](https://github.com/diskreet90/GlobalIPTV) | 韓國+日本+英文 M3U |

---

## 播放器推薦

### Windows

| 播放器 | 優點 | 官網 |
|--------|------|------|
| **PotPlayer** | 支援 M3U、界面簡潔、免費 | [Daum PotPlayer](https://potplayer.daum.net/) |
| **VLC** | 開源、多平台支援 | [VideoLAN VLC](https://www.videolan.org/vlc/) |

### 使用方式（以 PotPlayer 為例）

1. 下載並安裝 PotPlayer
2. 啟動軟體
3. 按下 `Ctrl + U`（或右键 → 打開 → URL）
4. 貼上 M3U 網址
5. 點擊確定即可播放

---

## 常見問題

### Q: 為什麼有些頻道無法播放？

**A:** 韓國大部分電視台（KBS、SBS、MBC、JTBC 等）有地區限制，只有韓國 IP 位址才能觀看。國外訪問通常會被封鎖。

### Q: 哪些頻道在海外可以觀看？

**A:** 根據測試，以下頻道較少地區限制：
- Arirang TV（英語頻道）
- EBS 教育台
- 宗教廣播頻道（如 BBS、BTN）

### Q: 需要VPN嗎？

**A:** 如需觀看受地理限制的頻道，建議使用韓國 VPN 取得韓國 IP。

---

## 進階：自定義播放清單

如果需要更完整的韓國頻道列表，可以：

1. 從 [fanmingming/live](https://github.com/fanmingming/live) 下載電視台標圖示
2. 參考範本格式自訂 M3U 檔案
3. 使用 [線上工具](https://live.fanmingming.cn/txt2m3u) 轉換格式

---

## 總結

| 來源 | 穩定度 | 容易度 | 推薦度 |
|------|--------|--------|--------|
| iptv-org | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| m3u.ibert.me | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |

對於一般使用者，建議直接使用 **iptv-org** 的韓語頻道列表，最簡單且穩定。

---

## 參考資料

- iptv-org 官方網站：https://iptv-org.github.io
- HerbertHe/iptv-sources：https://github.com/HerbertHe/iptv-sources
- m3u.ibert.me 展示頁面：https://m3u.ibert.me

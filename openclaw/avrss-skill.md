# /avrss - Nyaa RSS 搜尋技能

## 概述

搜尋 Nyaa（Sukebei）BT 站的 RSS feed，支援日文翻譯成繁體中文和 magnet 連結輸出。

## 觸發方式

```
/avrss [關鍵字] [--days N] [--limit N]
```

## 使用範例

```bash
# 基本搜尋
/avrss GANA-

# 搜尋最近 30 天，最多顯示 10 項
/avrss NHDTC- --days 30 --limit 10

# 搜尋最近 7 天
/avrss SONE- --days 7
```

## 參數說明

| 參數 | 預設值 | 說明 |
|------|--------|------|
| `關鍵字` | 必填 | 搜尋關鍵字（如番號） |
| `--days` | 7 | 顯示 N 天內的項目 |
| `--fetch-days` | 60 | 抓取 N 天內的 RSS 資料 |
| `--limit` | 25 | 最多顯示數量 |

## 輸出範例

```
=== Nyaa RSS: SONE- ===
顯示 30 天內，最多 3 項

[59 天前] SONE-991 最強女主角成為我女朋友，每天操我。恩愛的半同居者。瀨戶環奈
下載: magnet:?xt=urn:btih:185dc8bb3c76a3ffb5b5e6eb1f9760635e4b2c7f

[58 天前] SONE-992 對於那些想要被年輕女性寵愛的人...
下載: magnet:?xt=urn:btih:3e176250...

[49 天前] SONE-955 大學剛畢業的女班主任...
下載: magnet:?xt=urn:btih:14e71345...

共 3 項
```

## 技術原理

### DNS 繞過

使用 `--resolve` 參數繞過 DNS 封鎖：

```bash
curl.exe --resolve "sukebei.nyaa.si:443:198.251.89.38" "https://sukebei.nyaa.si/?page=rss&q=%5BHD%5D+{keyword}&f=0&c=0_0"
```

### RSS 解析

從 XML 中解析標題、發布日期、magnet 連結。

### 翻譯

使用 `deep_translator` 套件將日文翻譯成繁體中文：

```python
from deep_translator import GoogleTranslator
ja_to_zh = GoogleTranslator(source='auto', target='zh-TW')
```

## 檔案結構

```
skills/avrss/
├── SKILL.md           # 技能說明文件
└── scripts/
    ├── main.py        # 主程式 CLI
    ├── fetcher.py     # RSS 擷取（curl + --resolve）
    ├── parser.py      # XML 解析
    └── translator.py  # 日文翻譯成繁體中文
```

## 相關資源

- Nyaa Sukebei: https://sukebei.nyaa.si/
- deep_translator: https://pypi.org/project/deep-translator/

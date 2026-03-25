# llama.cpp 安裝筆記

> 建立日期：2026-03-18

## 概述

安裝 llama.cpp 用於本地 embedding，加速向量生成。

## 安裝路徑

- **主目錄**：`~/llama.cpp/`（即 `/home/linyis/llama.cpp/`）
- **執行檔**：`~/llama.cpp/bin/llama-server`
- **模型**：`~/llama.cpp/models/nomic-embed-text-v1.5-Q4_K_M.gguf`（81MB，Q4 量化）

## 使用方式

### 啟動 Server

```bash
~/llama.cpp/bin/llama-server \
  -m ~/llama.cpp/models/nomic-embed-text-v1.5-Q4_K_M.gguf \
  --embedding \
  -c 8192 \
  --port 8080
```

### API 呼叫

```bash
curl -X POST http://localhost:8080/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"input": "你的文字"}'
```

## 向量相容性

- 使用與 Ollama 相同的 `nomic-embed-text` 模型
- 向量完全相容，**不需要重新生成資料庫**
- 可無縫替換 LanceDB Pro 的 embedding 來源

## Ollama vs llama.cpp 速度比較

（2026-03-18 測試結果）
- **llama.cpp**：0.20 秒（10 次 embedding）
- **Ollama**：0.53 秒（10 次 embedding）
- **結論**：llama.cpp 快 2.6 倍

## Todo

- [ ] 在公司電腦（Xeon, 32GB RAM）安裝 llama.cpp
  - 下載 win-cpu-x64: https://github.com/ggml-org/llama.cpp/releases/download/b8407/llama-b8407-bin-win-cpu-x64.zip
  - 下載 qwen2.5-coder-7b Q4 GGUF 模型

## 資料來源

- 與小呈的對話（2026-03-18）
- https://github.com/ggml-org/llama.cpp
- https://huggingface.co/nomic-ai/nomic-embed-text-v1.5-GGUF

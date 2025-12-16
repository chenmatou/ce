#!/bin/bash
set -e

PRIMARY_URL="https://github.com/bia-pain-bache/BPB-Worker-Panel/releases/download/v4.0.1/worker.js"
FALLBACK_URLS=(
  "https://raw.githubusercontent.com/bia-pain-bache/BPB-Worker-Panel/main/build/unobfuscated-worker.js"
  "https://cdn.jsdelivr.net/gh/bia-pain-bache/BPB-Worker-Panel@main/build/unobfuscated-worker.js"
)

echo "下载 Worker..."
if ! wget -O origin.js "$PRIMARY_URL"; then
  for url in "${FALLBACK_URLS[@]}"; do
    if wget -O origin.js "$url"; then break; fi
  done
fi

echo "一阶段预混淆..."
javascript-obfuscator origin.js --output stage1.js \
  --compact false \
  --dead-code-injection true \
  --dead-code-injection-threshold 0.2 \
  --string-array true \
  --string-array-threshold 1 \
  --identifier-names-generator hexadecimal \
  --seed 9527

echo "二阶段企业级混淆..."
javascript-obfuscator stage1.js --output _worker.js \
  --compact true \
  --control-flow-flattening true \
  --control-flow-flattening-threshold 0.9 \
  --identifier-names-generator mangled \
  --string-array true \
  --string-array-encoding 'rc4' \
  --transform-object-keys true \
  --numbers-to-expressions true \
  --unicode-escape-sequence true \
  --target 'node' \
  --seed 9527

echo "混淆完成: _worker.js"

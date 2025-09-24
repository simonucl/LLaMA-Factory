#!/bin/bash

set -e
export DISABLE_VERSION_CHECK=1

CONFIG_DIR="/root/LLaMA-Factory/examples/train_full/vs"

CONFIGS=(
  "qwen3_1_7b_gpt-4.1_direct.yaml"
  "qwen3_1_7b_gpt-4.1_direct_cot.yaml"
  "qwen3_1_7b_gpt-4.1_multi_turn.yaml"
  "qwen3_1_7b_gpt-4.1_sequence.yaml"
  "qwen3_1_7b_gpt-4.1_vs_standard.yaml"
  "qwen3_1_7b_gpt-4.1_vs_cot.yaml"
  "qwen3_1_7b_gpt-4.1_vs_multi.yaml"
)

run_one() {
  local cfg="$1"
  echo "=========================================="
  echo "Training: $cfg"
  echo "Time: $(date)"
  echo "=========================================="
  llamafactory-cli train "$CONFIG_DIR/$cfg"
}

echo "Start Qwen3-1.7B gpt-4.1 runs: $(date)"
for c in "${CONFIGS[@]}"; do
  run_one "$c"
done
echo "Done: $(date)"




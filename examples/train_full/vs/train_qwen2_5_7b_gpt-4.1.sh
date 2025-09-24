#!/bin/bash

set -e
export DISABLE_VERSION_CHECK=1

CONFIG_DIR="/root/LLaMA-Factory/examples/train_full/vs"

CONFIGS=(
  "qwen2_5_7b_gpt-4.1_direct.yaml"
  "qwen2_5_7b_gpt-4.1_direct_cot.yaml"
  "qwen2_5_7b_gpt-4.1_multi_turn.yaml"
  "qwen2_5_7b_gpt-4.1_sequence.yaml"
  "qwen2_5_7b_gpt-4.1_vs_standard.yaml"
  "qwen2_5_7b_gpt-4.1_vs_cot.yaml"
  "qwen2_5_7b_gpt-4.1_vs_multi.yaml"
)

run_one() {
  local cfg="$1"
  echo "=========================================="
  echo "Training: $cfg"
  echo "Time: $(date)"
  echo "=========================================="
  llamafactory-cli train "$CONFIG_DIR/$cfg"
}

echo "Start Qwen2.5-7B gpt-4.1 runs: $(date)"
for c in "${CONFIGS[@]}"; do
  run_one "$c"
done
echo "Done: $(date)"



#!/bin/bash

# Train all VS configurations for Qwen3 models
# This script trains both Qwen3-4B-Base and Qwen3-1.7B-Base on all 4 VS datasets

set -e  # Exit on any error
export DISABLE_VERSION_CHECK=1
# Base directory for the configs
CONFIG_DIR="/root/LLaMA-Factory/examples/train_full/vs"

# Array of all configuration files
CONFIGS=(
    # "qwen3_4b_direct.yaml"
    "qwen3_4b_sequence.yaml" 
    "qwen3_4b_standard.yaml"
    "qwen3_4b_cot.yaml"
    "qwen3_1_7b_direct.yaml"
    "qwen3_1_7b_sequence.yaml"
    "qwen3_1_7b_standard.yaml"
    "qwen3_1_7b_cot.yaml"
)

# Function to run training for a single config
train_config() {
    local config_file="$1"
    local config_path="${CONFIG_DIR}/${config_file}"
    
    echo "=========================================="
    echo "Starting training for: ${config_file}"
    echo "Time: $(date)"
    echo "=========================================="
    
    # Run the training command
    llamafactory-cli train "${config_path}"
    
    echo "=========================================="
    echo "Completed training for: ${config_file}"
    echo "Time: $(date)"
    echo "=========================================="
    echo ""
}

# Main execution
echo "Starting VS training pipeline for all configurations"
echo "Total configs to train: ${#CONFIGS[@]}"
echo "Start time: $(date)"
echo ""

# Train each configuration
for config in "${CONFIGS[@]}"; do
    train_config "${config}"
done

echo "=========================================="
echo "All VS training configurations completed!"
echo "End time: $(date)"
echo "=========================================="

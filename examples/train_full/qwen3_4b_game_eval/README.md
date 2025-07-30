# Qwen3-4B Game Evaluation Training Configs

This directory contains training configurations for fine-tuning `qwen/qwen3-4b-base` on game evaluation datasets with different sizes and filtering strategies.

## Training Configurations

| Config File | Dataset Size | Filter | Description |
|-------------|-------------|--------|-------------|
| `qwen3_4b_sft_5k_whole.yaml` | 5,000 | None | Whole dataset, 5K examples |
| `qwen3_4b_sft_5k_win_only.yaml` | 5,000 | Win-only | Filtered by final_reward >= 1.0 |
| `qwen3_4b_sft_15k_whole.yaml` | 15,000 | None | Whole dataset, 15K examples |
| `qwen3_4b_sft_15k_win_only.yaml` | 15,000 | Win-only | Filtered by final_reward >= 1.0 |
| `qwen3_4b_sft_30k_whole.yaml` | 30,000 | None | Whole dataset, 30K examples |
| `qwen3_4b_sft_30k_win_only.yaml` | 30,000 | Win-only | Filtered by final_reward >= 1.0 |
| `qwen3_4b_sft_60k_whole.yaml` | 60,000 | None | Whole dataset, 60K examples |
| `qwen3_4b_sft_60k_win_only.yaml` | 60,000 | Win-only | Filtered by final_reward >= 1.0 |

## Training Parameters

- **Model**: `qwen/qwen3-4b-base`
- **Method**: Full fine-tuning with DeepSpeed ZeRO-2
- **Template**: `qwen`
- **Context Length**: 8192 tokens
- **Batch Size**: 1 per device, 8 gradient accumulation steps
- **Learning Rate**: 
  - 5K/15K: 2.0e-5 (2 epochs)
  - 30K: 2.0e-5 (1.5 epochs)
  - 60K: 1.5e-5 (1 epoch)

## Usage

### Sequential Training Script

Run all training configurations in sequence:

```bash
# Basic usage (runs all configs)
./run_sequential_training.sh

# Skip failed trainings and continue
./run_sequential_training.sh --skip-on-error

# Dry run (show commands without executing)
./run_sequential_training.sh --dry-run

# Start from a specific config (1-8)
./run_sequential_training.sh --start-from 3

# Show help
./run_sequential_training.sh --help
```

### Individual Training

Run a single configuration:

```bash
cd /path/to/LLaMA-Factory
llamafactory-cli train examples/train_full/qwen3_4b_game_eval/qwen3_4b_sft_5k_whole.yaml
```

## Output Directories

Models will be saved to:
- `saves/qwen3-4b/full/sft/game_eval_5k_whole/`
- `saves/qwen3-4b/full/sft/game_eval_5k_win_only/`
- `saves/qwen3-4b/full/sft/game_eval_15k_whole/`
- `saves/qwen3-4b/full/sft/game_eval_15k_win_only/`
- `saves/qwen3-4b/full/sft/game_eval_30k_whole/`
- `saves/qwen3-4b/full/sft/game_eval_30k_win_only/`
- `saves/qwen3-4b/full/sft/game_eval_60k_whole/`
- `saves/qwen3-4b/full/sft/game_eval_60k_win_only/`

## Prerequisites

1. **Dataset Registration**: Register your HuggingFace datasets in LLaMA-Factory's dataset registry
2. **Dependencies**: Ensure LLaMA-Factory and all dependencies are installed
3. **Hardware**: Sufficient GPU memory for training qwen3-4b with DeepSpeed
4. **WandB**: Configure WandB for logging (optional, can be disabled in configs)

## Dataset Names

The YAML files reference these dataset names (update according to your actual dataset names):
- `sft_qwen3_game_eval_5k_whole`
- `sft_qwen3_game_eval_5k_win_only`
- `sft_qwen3_game_eval_15k_whole`
- `sft_qwen3_game_eval_15k_win_only`
- `sft_qwen3_game_eval_30k_whole`
- `sft_qwen3_game_eval_30k_win_only`
- `sft_qwen3_game_eval_60k_whole`
- `sft_qwen3_game_eval_60k_win_only`

## Notes

- Training runs in order from smallest to largest dataset for efficient resource usage
- Each training uses the same base model but different dataset sizes and filters
- DeepSpeed ZeRO-2 configuration is used for memory efficiency
- All configurations use mixed precision (bf16) training
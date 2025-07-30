#!/bin/bash
# Sequential Training Script for Qwen3-4B Game Evaluation SFT
# Runs all training configurations in order from smallest to largest dataset
set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Training configurations in order (smallest to largest)
configs=(
    "qwen3_4b_sft_5k_whole.yaml"
    "qwen3_4b_sft_5k_win_only.yaml"
    "qwen3_4b_sft_15k_whole.yaml"
    "qwen3_4b_sft_15k_win_only.yaml"
    "qwen3_4b_sft_30k_whole.yaml"
    "qwen3_4b_sft_30k_win_only.yaml"
    "qwen3_4b_sft_60k_whole.yaml"
    "qwen3_4b_sft_60k_win_only.yaml"
)

# Function to log with timestamp
log() {
    echo -e "${BLUE}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

# Function to log success
log_success() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')] ✅ $1${NC}"
}

# Function to log error
log_error() {
    echo -e "${RED}[$(date '+%Y-%m-%d %H:%M:%S')] ❌ $1${NC}"
}

# Function to log warning
log_warning() {
    echo -e "${YELLOW}[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️  $1${NC}"
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LLAMAFACTORY_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Configuration
SKIP_ON_ERROR=${SKIP_ON_ERROR:-false}
DRY_RUN=${DRY_RUN:-false}
START_FROM=${START_FROM:-1}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --skip-on-error)
            SKIP_ON_ERROR=true
            shift
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --start-from)
            START_FROM="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --skip-on-error    Continue training even if one config fails"
            echo "  --dry-run          Show commands without executing them"
            echo "  --start-from N     Start from config number N (1-8)"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "Training order:"
            for i in "${!configs[@]}"; do
                echo "  $((i+1)). ${configs[i]}"
            done
            echo ""
            echo "Environment variables:"
            echo "  SKIP_ON_ERROR=true    Same as --skip-on-error"
            echo "  DRY_RUN=true          Same as --dry-run"
            echo "  START_FROM=N          Same as --start-from N"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Validate START_FROM
if [[ $START_FROM -lt 1 || $START_FROM -gt ${#configs[@]} ]]; then
    log_error "START_FROM must be between 1 and ${#configs[@]}"
    exit 1
fi

# Print configuration
echo "======================================================================"
echo -e "${BLUE}🚀 Qwen3-4B Game Evaluation Sequential Training${NC}"
echo "======================================================================"
log "LLaMA-Factory root: $LLAMAFACTORY_ROOT"
log "Config directory: $SCRIPT_DIR"
log "Skip on error: $SKIP_ON_ERROR"
log "Dry run: $DRY_RUN"
log "Starting from config: $START_FROM"
echo ""

# Training statistics
successful_trainings=0
failed_trainings=0
total_start_time=$(date +%s)

# Main training loop
for i in "${!configs[@]}"; do
    config_num=$((i+1))
    config="${configs[i]}"
    
    # Skip if starting from a later config
    if [[ $config_num -lt $START_FROM ]]; then
        log_warning "Skipping config $config_num: $config (starting from $START_FROM)"
        continue
    fi
    
    echo ""
    echo "======================================================================"
    log "Starting training $config_num/${#configs[@]}: $config"
    echo "======================================================================"
    
    config_start_time=$(date +%s)
    
    # Build the training command
    train_cmd="cd '$LLAMAFACTORY_ROOT' && llamafactory-cli train '$SCRIPT_DIR/$config'"
    
    if [[ $DRY_RUN == "true" ]]; then
        log "DRY RUN - Would execute: $train_cmd"
        log_success "DRY RUN - Training $config completed (simulated)"
        ((successful_trainings++))
        continue
    fi
    
    # Execute training
    log "Executing: $train_cmd"
    if eval "$train_cmd"; then
        config_end_time=$(date +%s)
        config_duration=$((config_end_time - config_start_time))
        log_success "Training $config completed in ${config_duration}s"
        ((successful_trainings++))
    else
        config_end_time=$(date +%s)
        config_duration=$((config_end_time - config_start_time))
        log_error "Training $config failed after ${config_duration}s"
        ((failed_trainings++))
        
        if [[ $SKIP_ON_ERROR == "false" ]]; then
            log_error "Stopping sequential training due to failure"
            break
        else
            log_warning "Continuing to next training (skip-on-error enabled)"
        fi
    fi
done

# Final summary
total_end_time=$(date +%s)
total_duration=$((total_end_time - total_start_time))

echo ""
echo "======================================================================"
echo -e "${BLUE}📊 Training Summary${NC}"
echo "======================================================================"
log "Total duration: ${total_duration}s ($(($total_duration / 60))m $(($total_duration % 60))s)"
log_success "Successful trainings: $successful_trainings"
if [[ $failed_trainings -gt 0 ]]; then
    log_error "Failed trainings: $failed_trainings"
else
    log "Failed trainings: $failed_trainings"
fi

# Exit with appropriate code
if [[ $failed_trainings -gt 0 && $SKIP_ON_ERROR == "false" ]]; then
    exit 1
else
    exit 0
fi
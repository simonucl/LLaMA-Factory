from transformers import AutoModelForCausalLM, AutoTokenizer
from huggingface_hub import HfApi, HfFolder, Repository, create_repo, upload_folder

# Set these variables
model_name_or_path = "/root/LLaMA-Factory/saves/octothinker/full/sft/oat_self_play_cold_start"  # e.g., "./my_model"
hf_repo_name = "simonycl/octothinker-3b-hybrid-zero-cold-start-sft"   # e.g., "johnsmith/my-cool-model"

# 1. Load model and tokenizer
model = AutoModelForCausalLM.from_pretrained(model_name_or_path)
tokenizer = AutoTokenizer.from_pretrained(model_name_or_path)

model.push_to_hub(hf_repo_name)
tokenizer.push_to_hub(hf_repo_name)

print(f"Model pushed to https://huggingface.co/{hf_repo_name}")

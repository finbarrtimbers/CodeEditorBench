#!/bin/bash
set -e
base_models=(
    "codellama/CodeLlama-7b-Instruct-hf"
	#"EleutherAI/pythia-1b"
)
datasets=("debug" "translate" "polishment" "switch")

for base_model in "${base_models[@]}"; do
    for dataset in "${datasets[@]}"; do
        echo "Running inference with base_model: $base_model and dataset: $dataset"
        python vllm_inference.py \
            --base_model "$base_model" \
            --dataset "$dataset" \
            --input_data_dir "./data/" \
            --output_data_dir "./greedy_result/" \
            --batch_size 10 \
			--swap_space=1 \
            --num_of_sequences 1 \
            --num_gpus 1 \
            --prompt_type "zero" \
            --start_idx 0 \
            --end_idx 10
    done
done

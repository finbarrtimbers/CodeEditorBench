# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CodeEditorBench is a comprehensive evaluation framework for assessing Large Language Models' code editing capabilities across four key scenarios:
- **code_debug**: Debugging and fixing errors in code
- **code_translate**: Converting code between programming languages  
- **code_polishment**: Improving code quality and style
- **code_switch**: Modifying code to meet new requirements

The repository consists of three main components:
1. **Inference Pipeline**: Uses VLLM for running LLM inference on datasets
2. **Evaluation System**: Docker-based HUSTOJ system for automated code execution and testing
3. **Prompt Management**: Modular prompt functions for different scenarios and models

## Environment Setup

```bash
# Create conda environment from config
conda env create -f coder.yml
conda activate coder

# Create output directories for inference results
mkdir -p greedy_result/{code_debug,code_translate,code_polishment,code_switch}
mkdir data  # For input datasets from HuggingFace
```

## Core Architecture

### Inference System
- **vllm_inference.py**: Main inference script supporting 14+ open-source models
- **dataset.py**: Custom PyTorch dataset for JSONL data loading
- **prompt_function/**: Contains model-specific prompt templates for each scenario
- **result_postprocess.py**: Filters and cleans model outputs for evaluation

### Evaluation System (Docker-based)
- **evaluation/judge/**: Complete HUSTOJ-based evaluation environment
- Supports Python, Java, C++ code execution with security sandboxing
- Database-driven solution tracking and metrics computation
- Templates for LeetCode-style problem formats

## Common Commands

### Environment Setup
```bash
# Create and activate conda environment
conda env create -f coder.yml
conda activate coder

# Create required directories
mkdir -p greedy_result/{code_debug,code_translate,code_polishment,code_switch}
mkdir data  # For input datasets from HuggingFace

# Download models (optional - can be run automatically)
huggingface-cli download --resume-download deepseek-ai/deepseek-coder-33b-instruct --local-dir ./model/deepseek-coder-33b-instruct
```

### Running Inference
```bash
# Single model inference with key parameters
python vllm_inference.py \
    --base_model "deepseek-ai/deepseek-coder-33b-instruct" \
    --dataset "debug" \
    --input_data_dir "./data/" \
    --output_data_dir "./greedy_result/" \
    --batch_size 64 \
    --num_gpus 8 \
    --prompt_type "zero" \
    --start_idx 0 \
    --end_idx -1

# Batch inference for all 14 supported models across all scenarios
bash vllm_inference.sh
```

### Result Processing
```bash
# Filter and clean model outputs for evaluation (paths are hardcoded in script)
python result_postprocess.py
```

### Evaluation (Docker-based HUSTOJ System)
```bash
# Pull evaluation environment
docker pull xliudg/code_editor_bench:latest

# Run evaluation container with volume mount
docker run -d -v /path/to/evaluation/judge:/home/judge --name judge xliudg/code_editor_bench
docker exec -it judge /bin/bash

# Inside container - complete evaluation pipeline:
cd /home/judge/scripts
python3 add_template.py                    # Add LeetCode templates to solutions
python3 submit_solution.py                # Submit solutions to database (default result 14)
python3 measure_polish_source_code.py     # Measure performance limits for polishment problems
python3 update_polish_lmt.py              # Update time/memory limits in database  
bash run_judge.sh                         # Start judging process (sets result to 0)
python3 compute_metrics.py                # Calculate final metrics across scenarios

# Database access
bash mysql.sh
```

## Key Implementation Details

### Supported Models (14 Open-Source)
The system supports these models with model-specific prompt formatting in `prompt_function/`:
- **WizardCoder**: WizardCoder-33B-V1.1, WizardCoder-15B-V1.0
- **DeepSeek**: deepseek-coder-33b-instruct  
- **CodeFuse**: CodeFuse-CodeLlama-34B
- **Phind**: Phind-CodeLlama-34B-v2
- **CodeLlama**: 7B/13B/34B variants (both instruct and base)
- **Magicoder**: Magicoder-S-DS-6.7B, Magicoder-S-CL-7B
- **OctoCoder**: bigcode/octocoder
- **OpenCodeInterpreter**: DS-6.7B, DS-33B

Each scenario (debug, translate, polishment, switch) has dedicated prompt modules that handle model-specific formatting automatically.

### Data Flow Architecture
1. **Input**: Raw datasets (JSONL) from HuggingFace → Custom `JsonlDataset` class
2. **Inference**: `vllm_inference.py` with VLLM engine → Raw model outputs with metadata
3. **Post-processing**: `result_postprocess.py` → Cleaned code solutions (regex-based filtering)
4. **Evaluation**: Docker HUSTOJ system → Execution results and competitive programming metrics
5. **Metrics**: Database aggregation → Final performance scores per scenario

### Evaluation System Details
- **Judging States**: Solutions progress through states 0-14 (0=queued, 4=accepted, 11=compilation error, 14=manual confirmation)
- **Database Schema**: MySQL-based with tables for problems, solutions, users, and contest results
- **Security**: Sandboxed execution environment with configurable time/memory limits
- **Languages**: Python, Java, C++ support with automated compilation and testing
- **Metrics**: Standard competitive programming results (AC/WA/TLE/MLE/CE/RE) aggregated across scenarios

### Important File Locations
- **Hard-coded paths in `result_postprocess.py`**: Lines 237 (input) and 243 (output) need modification for custom paths
- **Model downloads**: Can be automated via `huggingface-cli` or loaded from custom paths in `vllm_inference.py`
- **Evaluation data**: Must be placed in `evaluation/judge/codeeditorbench-data/` directory structure
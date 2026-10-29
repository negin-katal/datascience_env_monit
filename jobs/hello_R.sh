#!/bin/bash
#SBATCH --job-name=hello_R
#SBATCH --partition=dev_cpu
#SBATCH --ntasks=1
#SBATCH --time=00:05:00
#SBATCH --output=hello_R_%j.out

module load math/R/4.4.2-openblas
cd "$HOME/datascience_env_monit"
Rscript scripts/cluster_hello.R

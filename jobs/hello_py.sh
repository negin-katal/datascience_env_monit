#!/bin/bash
#SBATCH --job-name=hello_py
#SBATCH --partition=dev_cpu
#SBATCH --ntasks=1
#SBATCH --time=00:05:00
#SBATCH --output=hello_py_%j.out

# python3 missing or too old? See: module spider python
# module load devel/python/<version>
cd "$HOME/datascience_env_monit"
python3 scripts/cluster_hello.py

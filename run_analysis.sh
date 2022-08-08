#!/bin/sh
#SBATCH --partition=rn-long-40core
#SBATCH --exclude=rn[007-012]
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --job-name=parse_results
##SBATCH --mail-type=begin
##SBATCH --mail-type=end
##SBATCH --mail-type=fail
##SBATCH --mail-user=guilherme.duarteramosmatos@stonybrook.edu
#SBATCH --output=%x-%j.o

# Functions
slurm_info_out(){
echo "============================= SLURM JOB ================================="
date
echo
echo " The job will be started on the following node(s):"
echo "                              $SLURM_JOB_NODELIST"
echo
echo "Slurm user:                   $SLURM_JOB_USER"
echo "Run directory:                $(pwd)"
echo "Job ID:                       $SLURM_JOB_ID"
echo "Job name:                     $SLURM_JOB_NAME"
echo "Partition:                    $SLURM_JOB_PARTITION"
echo "Number of nodes:              $SLURM_JOB_NUM_NODES"
echo "Number of tasks:              $SLURM_NTASKS"
echo "Submitted from:               $SLURM_SUBMIT_HOST:$SLURM_SUBMIT_DIR"
echo "========================================================================="
echo
echo "--- SLURM job-script output ----"
}

slurm_startjob(){

## DOCK6.9 simulation
date

bash analyze_results.sh bickel_denovo_systems.dat

date
}

slurm_info_out
slurm_startjob


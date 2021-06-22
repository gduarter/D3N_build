import os, sys

if sys.version_info[:1] < (3,):
    sys.exit("This is a Python 3 script. Python 2.7 is deprecated and SHOULD NOT be used")

##if len(sys.argv) != 2:
##    print("Enter an integer number of anchors to be used.")
##    sys.exit(f"USAGE: python {sys.argv[0]} number_of_anchors")
##num_anchors = int(sys.argv[1])
#anchors = [1, 15, 30, 50, 100, 150, 250, 300, 350, 380]


with open(f"run_ud3n.sh", "w+") as f:
    script1=f'''#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --job-name=ud3n
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-user=guilherme.duarteramosmatos@stonybrook.edu
#SBATCH --output=%x-%j.o

# Functions
slurm_info_out(){{
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
}}

slurm_startjob(){{

## DOCK6.9 simulation
date

anchor_num=(1 15 30 50 100 150 250 300 350 380)

for N in "${{anchor_num[@]}}"
do
    cd unrestricted/anchor${{N}}/
    echo $(pwd)
    srun --input none --exclusive -N1 -n1 -W 0 run.${{N}}.sh &
    cd ../..
done
wait
date
}}

slurm_info_out
slurm_startjob
'''
    f.write(script1)
    f.write("\n")

with open(f"run_d3n.sh", "w+") as g:
    script2=f'''#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --job-name=d3n
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-user=guilherme.duarteramosmatos@stonybrook.edu
#SBATCH --output=%x-%j.o

# Functions
slurm_info_out(){{
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
}}

slurm_startjob(){{

## DOCK6.9 simulation
date

anchor_num=(1 15 30 50 100 150 250 300 350 380)
for N in "${{anchor_num[@]}}"
do
    cd restricted/anchor${{N}}/
    echo $(pwd)
    srun --exclusive -N1 -n1 -W 0 run.${{N}}.sh &
    cd ../..
done
wait
date
}}

slurm_info_out
slurm_startjob
'''
    g.write(script2)
    g.write("\n")

with open(f"run_denovo.sh", "w+") as h:
    script3=f'''#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --job-name=denovo
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-user=guilherme.duarteramosmatos@stonybrook.edu
#SBATCH --output=%x-%j.o

# Functions
slurm_info_out(){{
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
}}

slurm_startjob(){{

## DOCK6.9 simulation
date

anchor_num=(1 15 30 50 100 150 250 300 350 380)
for N in "${{anchor_num[@]}}"
do
    cd denovo/anchor${{N}}/
    echo $(pwd)
    srun --exclusive -N1 -n1 -W 0 run.${{N}}.sh & 
    cd ../..
done
wait
date
}}

slurm_info_out
slurm_startjob
'''
    h.write(script3)
    h.write("\n")




os.system("chmod +x *.sh")


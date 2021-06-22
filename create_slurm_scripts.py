import os, sys

if sys.version_info[:1] < (3,):
    sys.exit("This is a Python 3 script. Python 2.7 is deprecated and SHOULD NOT be used")

#if len(sys.argv) != 2:
#    print("Enter an integer number of anchors to be used.")
#    sys.exit(f"USAGE: python {sys.argv[0]} number_of_anchors")
#num_anchors = int(sys.argv[1])

#order = ['a', 'b', 'c', 'd', 'e']
#bickel_dats = ['bickel_denovo_systems_09.dat', 'bickel_denovo_systems_12_1.dat', 
#               'bickel_denovo_systems_12_2.dat', 'bickel_denovo_systems_12_3.dat',
#               'bickel_denovo_systems_12_4.dat' ]
#order = ["seventeen", "nineteen", "twentyone"]
#bickel_dats = ["bickel_denovo_systems_17.dat", "bickel_denovo_systems_19.dat", "bickel_denovo_systems_21.dat"]

order = ["40", "17"]
bickel_dats = ["bickel_denovo_systems_40.dat", "bickel_denovo_systems_17.dat"]
anchors=[1, 15, 30, 50, 100, 150, 250, 300, 350, 380]
for num in anchors:
    for elem in zip(order, bickel_dats):
        with open(f"run_ud3n.{elem[0]}.{num}.sh", "w+") as f:
            script1=f'''#!/bin/sh
#SBATCH --partition=rn-long-40core
#SBATCH --exclude=rn017
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --job-name=ud3n.{elem[0]}.{num}
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

for line in $(cat {elem[1]})
do
    echo "${{line}}"
    cd ${{line}}/unrestricted/anchor{num}
    srun --exclusive -N1 -n1 -W 0 run.${{line}}.{num}.sh &
    cd ../../..
done
wait
date
}}

slurm_info_out
slurm_startjob
'''
            f.write(script1)
            f.write("\n")

        with open(f"run_d3n.{elem[0]}.{num}.sh", "w+") as g:
            script2=f'''#!/bin/sh
#SBATCH --partition=rn-long-40core
#SBATCH --exclude=rn017
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --job-name=d3n.{elem[0]}.{num}
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

for line in $(cat {elem[1]})
do
    echo "${{line}}"
    cd ${{line}}/restricted/anchor{num}
    srun --exclusive -N1 -n1 -W 0 run.${{line}}.{num}.sh &
    cd ../../..
done
wait
date
}}

slurm_info_out
slurm_startjob
'''
            g.write(script2)
            g.write("\n")

        with open(f"run_dn.{elem[0]}.{num}.sh", "w+") as h:
            script3=f'''#!/bin/sh
#SBATCH --partition=rn-long-40core
#sbatch --exclude=rn017
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --job-name=dn.{elem[0]}.{num}
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

for line in $(cat {elem[1]})
do
    echo "${{line}}"
    cd ${{line}}/denovo/anchor{num}
    srun --exclusive -N1 -n1 -W 0 run.${{line}}.{num}.sh &
    cd ../../..
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


#!/bin/bash

python='/gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/miniconda3/envs/py37/bin/python'
script='/gpfs/projects/rizzo/gduarteramos/D3N_many_anchors/zzz.code_and_backup_inputs/calculate_statistics.py'

txtfile=$1
num_anchor=$2

while IFS= read -r pdb
do
    for ((N=1; N<=$num_anchor; N++))
    do
        cd ${pdb}/restricted/anchor${N}
        $python $script ${pdb}.driven.${N}.denovo_build.mol2
        $python $script ${pdb}.driven.${N}.denovo_rejected.mol2
        cd ../../..
    
        cd ${pdb}/unrestricted/anchor${N}
        $python $script ${pdb}.unrestricted.${N}.denovo_build.mol2
        $python $script ${pdb}.unrestricted.${N}.denovo_rejected.mol2
        cd ../../..
    done
    
done < $txtfile





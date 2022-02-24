#!/bin/bash

python='/gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/miniconda3/envs/py37/bin/python'
script1='/gpfs/projects/rizzo/gduarteramos/D3N_build/zzz.code_and_backup_inputs/calculate_statistics.py'
script2='/gpfs/projects/rizzo/gduarteramos/D3N_build/zzz.code_and_backup_inputs/calculate_statistics_rejected.py'

txtfile=$1

while IFS= read -r pdb
do
    for elem in (1 15 30 50 100 150 250 300 350 380)
    do
        cd ${pdb}/restricted/anchor${N}
        $python $script1 ${pdb}.driven.${N}.denovo_build.mol2
        $python $script2 ${pdb}.driven.${N}.denovo_rejected.mol2
        cd ../../..
    
        cd ${pdb}/unrestricted/anchor${N}
        $python $script1 ${pdb}.unrestricted.${N}.denovo_build.mol2
        $python $script2 ${pdb}.unrestricted.${N}.denovo_rejected.mol2
        cd ../../..

        cd ${pdb}/denovo/anchor${N}
        $python $script1 ${pdb}.driven.${N}.descriptors.mol2
        cd ../../..

    done

done < $txtfile





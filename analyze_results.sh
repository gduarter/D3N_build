#!/bin/bash

python='/gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/miniconda3/envs/py37/bin/python'

root=$(pwd)
script1=${root}/zzz.code_and_backup_inputs/calculate_statistics.py
script2=${root}/zzz.code_and_backup_inputs/calculate_statistics_rejected.py
resultsdir=${root}/zzz.results

txtfile=$1
anchors=(1 2 3 4 5 6 7 8 9 10 100 250 300 350 380)

mkdir -p ${resultsdir}/d3n-tight
mkdir -p ${resultsdir}/d3n-loose
mkdir -p ${resultsdir}/dn

while IFS= read -r pdb
do
    for N in "${anchors[@]}"
    do
        cd ${pdb}/restricted/anchor${N}
        $python $script1 ${pdb}.driven.${N}.denovo_build.mol2
        $python $script2 ${pdb}.driven.${N}.denovo_rejected.mol2
        cp *.csv ${resultsdir}/d3n-tight/
        cd ../../..

        cd ${pdb}/unrestricted/anchor${N}
        $python $script1 ${pdb}.unrestricted.${N}.denovo_build.mol2
        $python $script2 ${pdb}.unrestricted.${N}.denovo_rejected.mol2
        cp *.csv ${resultsdir}/d3n-loose/
        cd ../../..

        cd ${pdb}/denovo/anchor${N}
        $python $script1 ${pdb}.driven.${N}.descriptors.mol2
        cp *.csv ${resultsdir}/dn/
        cd ../../..

    done

done < $txtfile

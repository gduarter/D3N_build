#!/bin/sh

rootdir=$(pwd)
echo $rootdir

kinds=("restricted" "unrestricted" "denovo")
anchors=("1" "15" "30" "50" "100" "150" "250" "350" "380")

rm *.tmp.txt

for elem in "${kinds[@]}"
do
    for num in "${anchors[@]}"
    do
        cd ${rootdir}/${elem}/anchor${num}
        if [ "$elem" == "restricted" ]; then
            grep "Total elapsed time:" d3n.${num}.out >> ${rootdir}/times.${elem}.tmp.txt
            grep "Molecules Processed" d3n.${num}.out >> ${rootdir}/mols_proc.${elem}.tmp.txt
        elif [ "$elem" == "unrestricted" ]; then
            grep "Total elapsed time:" ud3n.${num}.out >> ${rootdir}/times.${elem}.tmp.txt
            grep "Molecules Processed" ud3n.${num}.out >> ${rootdir}/mols_proc.${elem}.tmp.txt
        else
            grep "Total elapsed time:" simple_build.${num}.out >> ${rootdir}/times.${elem}.tmp.txt
            grep "Molecules Processed" simple_build.${num}.out >> ${rootdir}/mols_proc.${elem}.tmp.txt
        fi
        cd ${rootdir}
    done
done




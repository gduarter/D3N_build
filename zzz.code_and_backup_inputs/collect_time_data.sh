#!/bin/bash

###### Help Function ########
helpFunction(){
    echo -e "\tUsage: $0 -i txtfile_w_pdbcodes"
    exit 1
}

# Assign typed arguments to variables
while getopts ":i:" opt
do
    case $opt in
        i ) TXTFILE="$OPTARG";;
        ? ) helpFunction ;;
    esac
done

# Prints helpFuntion in case the number of parameters do not match what
# the script requires
if [ -z "${TXTFILE}" ]
then
    echo "You are misusing this script"
    helpFunction
fi



###
rootdir=$(pwd)
echo $rootdir

kinds=("restricted" "unrestricted" "denovo")
anchors=("1" "15" "30" "50" "100" "150" "250" "350" "380")

rm *.tmp.txt

while IFS= read -r pdb
do
    for elem in "${kinds[@]}"
    do
        for num in "${anchors[@]}"
        do
            cd ${rootdir}/${pdb}/${elem}/anchor${num}
            if [ "$elem" == "restricted" ]; then
                grep "Total elapsed time:" d3n.${num}.out >> ${rootdir}/times.${elem}.tmp.txt
                grep "Molecules Processed" d3n.${num}.out >> ${rootdir}/mols_proc.${elem}.tmp.txt
            elif [ "$elem" == "unrestricted" ]; then
                grep "Total elapsed time:" ud3n.${num}.out >> ${rootdir}/times.${elem}.tmp.txt
                grep "Molecules Processed" ud3n.${num}.out >> ${rootdir}/mols_proc.${elem}.tmp.txt
            else
                grep "Total elapsed time:" dn.${num}.out >> ${rootdir}/times.${elem}.tmp.txt
                grep "Molecules Processed" dn.${num}.out >> ${rootdir}/mols_proc.${elem}.tmp.txt
            fi
            cd ${rootdir}
        done
    done
done < $TXTFILE



import sys
import os, shutil
import glob
import argparse

script1 = '/gpfs/projects/rizzo/gduarteramos/D3N_build/zzz.code_and_backup_inputs/calculate_statistics.py'
script2 = '/gpfs/projects/rizzo/gduarteramos/D3N_build/zzz.code_and_backup_inputs/calculate_statistics_rejected.py'


#helpstring=f'''  This script calculates the statistical quantities, creates and move CSV files
# to an appropriate directory.
#
# Usage: {sys.argv[0]} -n number_of_anchors
#'''

#parser = argparse.ArgumentParser(description=helpstring)
#parser.add_argument("-n", "--num_anchor", action="store", type=int, required=True) 
#args = parser.parse_args()
#num_anchor = args.num_anchor

directories = ["denovo", "restricted", "unrestricted"] 
prefix = ["simple.dn", "simple.d3n", "simple.ud3n"]
anchors = [1, 15, 30, 50, 100, 150, 250, 300, 350, 380] #list(range(1, num_anchor+1))

root = os.getcwd()
results = os.path.join(root, "zzz.results")
try:
    os.makedirs(results)
except:
    pass

for doublet in zip(directories, prefix):
    os.chdir(doublet[0])
    for idx in anchors:
        os.chdir(f"anchor{idx}")
        print(f"{doublet[0]}/anchor{idx}")

        if (doublet[0] == "denovo"):
            os.system(f"python {script1} {doublet[1]}.{idx}.descriptors_scored.mol2")
            pass
        else:
            os.system(f"python {script1} {doublet[1]}.{idx}.denovo_build.mol2")
            try:
                os.system(f"rm {doublet[1]}.{idx}.rejected.mol2")
            except:
                print("No all-layers rejected file here") 
                pass
            rejected = glob.glob("*rejected*.mol2")
            for mol2 in rejected:
                os.system(f"cat {mol2} >> {doublet[1]}.{idx}.rejected.mol2")
            try:
                os.system(f"python {script2} {doublet[1]}.{idx}.rejected.mol2") 
            except:
                print(f"Empty file or no file in {doublet[1]}/anchor{idx}")

        csvs = glob.glob("*.csv")
        for csv in csvs:
            current = os.path.join(root, doublet[0], f"anchor{idx}", csv)
            destination = os.path.join(results, csv)
            shutil.copy(current, destination)

        os.chdir("..")

    os.chdir(root)

print("Analysis and file organization done")






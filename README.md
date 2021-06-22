# README

## General info

* The whole test set is located at `${TESTSET_PATH}=/gpfs/projects/rizzo/yuchzhou/RCR/DOCK_testset/`.
* The file `bickel_denovo_systems.dat` contains the 57 systems to be used in our tests. 
* The test set is divided in two parts, one containing 40 molecules and another containing 17. This is meant to paralelize our jobs in the rn-long-40core or long-40core nodes.

## Setup specific info

* DOCK simulation files are contained in `/gpfs/projects/rizzo/yuchzhou/RCR/DOCK_testset/${PDB}/zzz.dock_files/`
where `${PDB}` corresponds to each line of `bickel_denovo_systems.dat`.
    * `${PDB}.lig.am1bcc.mol2` is the am1bcc charged ligand to be used as a reference.
    * `${PDB}.lig.cartmin.mol2` is the cartesian minimized ligand to be used to produced footprints.
    * `${PDB}.rec.clean.mol2` is the receptor mol2 file with hydrogen atoms.
    * `${PDB}.rec.clust.close.sph` is the file containing the spheres the simulation requires.
    * `${PDB}.rec.nrg` and `${PDB}.rec.bmp` are the grid files
* In order to avoid unnecessary copies, have your scripts point to these places instead of copies inside your
project space.

## Step-by-step

* Run the script below to generate 57 directories with their respective subdirectories and input files.

```bash
bash organize_systems.sh -i bickel_denovo_systems.sh
```

    * Make sure you read `organize_systems.sh` and change the scoring functions to whichever scoring functions you were assigned to calculate. 
    * Using Python >=3, run the script below:

```bash
python3 create_slurm_scripts.py
```

    * Make sure that you have `bickel_denovo_systems_40.dat` and `bickel_denovo_systems_17.dat` in the directory where the script is located. The script generates a plethora of slurm scripts that can be submitted using a simple for-loop:

```bash
for elem in run*.sh; do echo ${elem}; sbatch ${elem}; done
```

## More directions

    * I will update this repository when more analysis are ready.
    * `zzz.code_and_backup_inputs` contains scripts in progress. 


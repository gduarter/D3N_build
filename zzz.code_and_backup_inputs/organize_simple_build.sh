#!/bin/bash

# Author: Guilherme Duarte Ramos Matos
# Date: April 2021


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

## Define important paths
datapath='/gpfs/projects/rizzo/yuchzhou/RCR/DOCK_testset/'
parameters='/gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/parameters'

# Loop over lines in TXTFILE and create files and directories
#count=1
while IFS= read -r pdb
do
    # Create "unrestricted D3N input files
    mkdir -p ${pdb}/unrestricted
    cat <<EOF > ${pdb}/unrestricted/ud3n.in
conformer_search_type                                        denovo
dn_fraglib_scaffold_file                                     ${parameters}/fraglib_scaffold.mol2
dn_fraglib_linker_file                                       ${parameters}/fraglib_linker.mol2
dn_fraglib_sidechain_file                                    ${parameters}/fraglib_sidechain.mol2
dn_user_specified_anchor                                     no
dn_torenv_table                                              ${parameters}/fraglib_torenv.dat
dn_use_roulette                                              no
dn_name_identifier                                           random
dn_sampling_method                                           rand
dn_num_random_picks                                          20
dn_pruning_conformer_score_cutoff                            100.0
dn_pruning_conformer_score_scaling_factor                    1.0
dn_pruning_clustering_cutoff                                 100.0
dn_upper_constraint_mol_wt                                   550.0
dn_lower_constraint_mol_wt                                   300.0
dn_constraint_mol_wt                                         700.0
dn_mol_wt_cutoff_type                                        soft
dn_drive_verbose                                             yes
dn_save_all_mols                                             yes
dn_drive_clogp                                               yes
dn_lower_clogp                                               -10
dn_upper_clogp                                               10
dn_clogp_std_dev                                             2.33
dn_drive_esol                                                yes
dn_lower_esol                                                -10
dn_upper_esol                                                10
dn_esol_std_dev                                              2.15
dn_drive_qed                                                 yes
dn_lower_qed                                                 0.0
dn_qed_std_dev                                               0.18
dn_drive_sa                                                  yes
dn_upper_sa                                                  10
dn_sa_std_dev                                                1.01
dn_drive_stereocenters                                       yes
dn_upper_stereocenter                                        10
dn_start_at_layer                                            1
sa_fraglib_path                                              ${parameters}/sa_fraglib.dat
PAINS_path                                                   ${parameters}/pains_table.dat
dn_mol_wt_std_dev                                            35.0
dn_constraint_rot_bon                                        15
dn_constraint_formal_charge                                  2.0
dn_heur_unmatched_num                                        1
dn_heur_matched_rmsd                                         2.0
dn_unique_anchors                                            1
dn_max_grow_layers                                           9
dn_max_root_size                                             100
dn_max_layer_size                                            100
dn_max_current_aps                                           5
dn_max_scaffolds_per_layer                                   1
dn_write_checkpoints                                         yes
dn_write_prune_dump                                          no
dn_write_orients                                             no
dn_write_growth_trees                                        no
dn_output_prefix                                             ${pdb}.unrestricted
use_internal_energy                                          yes
internal_energy_rep_exp                                      12
internal_energy_cutoff                                       100.0
use_database_filter                                          no
orient_ligand                                                yes
automated_matching                                           yes
receptor_site_file                                           ${datapath}/${pdb}/zzz.dock_files/${pdb}.rec.clust.close.sph
max_orientations                                             1000
critical_points                                              no
chemical_matching                                            no
use_ligand_spheres                                           no
bump_filter                                                  no
score_molecules                                              yes
contact_score_primary                                        no
grid_score_primary                                           no
gist_score_primary                                           no
multigrid_score_primary                                      no
dock3.5_score_primary                                        no
continuous_score_primary                                     no
footprint_similarity_score_primary                           no
pharmacophore_score_primary                                  no
hbond_score_primary                                          no
interal_energy_score_primary                                 no
descriptor_score_primary                                     yes
descriptor_use_grid_score                                    yes
descriptor_use_pharmacophore_score                           no
descriptor_use_tanimoto                                      no
descriptor_use_hungarian                                     no
descriptor_use_volume_overlap                                yes
descriptor_use_gist                                          no
descriptor_use_dock3.5                                       no
descriptor_grid_score_rep_rad_scale                          1
descriptor_grid_score_vdw_scale                              1
descriptor_grid_score_es_scale                               1
descriptor_grid_score_grid_prefix                            ${datapath}/${pdb}/zzz.dock_files/${pdb}.rec
descriptor_volume_score_reference_mol2_filename              ${datapath}/${pdb}/zzz.dock_files/${pdb}.lig.cartmin.mol2
descriptor_volume_score_overlap_compute_method               analytical
descriptor_weight_grid_score                                 1
descriptor_weight_volume_overlap_score                       -1
minimize_ligand                                              yes
minimize_anchor                                              yes
minimize_flexible_growth                                     yes
use_advanced_simplex_parameters                              no
simplex_max_cycles                                           1
simplex_score_converge                                       0.1
simplex_cycle_converge                                       1.0
simplex_trans_step                                           1.0
simplex_rot_step                                             0.1
simplex_tors_step                                            10.0
simplex_anchor_max_iterations                                500
simplex_grow_max_iterations                                  500
simplex_grow_tors_premin_iterations                          0
simplex_random_seed                                          0
simplex_restraint_min                                        no
atom_model                                                   all
vdw_defn_file                                                ${parameters}/vdw_AMBER_parm99.defn
flex_defn_file                                               ${parameters}/flex.defn
flex_drive_file                                              ${parameters}/flex_drive.tbl
chem_defn_file                                               ${parameters}/chem.defn
EOF
    cat <<EOF > ${pdb}/unrestricted/run.${pdb}.sh
#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=ud3n.${pdb}
#SBATCH --output=%x-%j.o

echo "DOCK6 simulation started
date

/gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/bin/dock6 -i ud3n.in -o ud3n.out

echo "DOCK6 simulation ended"
date
EOF
    chmod a+wrx ${pdb}/unrestricted/run.${pdb}.sh   

    # Create D3N input files
    mkdir -p ${pdb}/restricted
    cat <<EOF > ${pdb}/restricted/d3n.in
conformer_search_type                                        denovo
dn_fraglib_scaffold_file                                     ${parameters}/fraglib_scaffold.mol2
dn_fraglib_linker_file                                       ${parameters}/fraglib_linker.mol2
dn_fraglib_sidechain_file                                    ${parameters}/fraglib_sidechain.mol2
dn_user_specified_anchor                                     no
dn_torenv_table                                              ${parameters}/fraglib_torenv.dat
dn_use_roulette                                              no
dn_name_identifier                                           random
dn_sampling_method                                           rand
dn_num_random_picks                                          20
dn_pruning_conformer_score_cutoff                            100.0
dn_pruning_conformer_score_scaling_factor                    1.0
dn_pruning_clustering_cutoff                                 100.0
dn_upper_constraint_mol_wt                                   550.0
dn_lower_constraint_mol_wt                                   300.0
dn_constraint_mol_wt                                         700.0
dn_mol_wt_cutoff_type                                        soft
dn_drive_verbose                                             yes
dn_save_all_mols                                             yes
dn_drive_clogp                                               yes
dn_lower_clogp                                               -0.5
dn_upper_clogp                                               5
dn_clogp_std_dev                                             2.33
dn_drive_esol                                                yes
dn_lower_esol                                                -5
dn_upper_esol                                                0
dn_esol_std_dev                                              2.15
dn_drive_qed                                                 yes
dn_lower_qed                                                 0.4
dn_qed_std_dev                                               0.18
dn_drive_sa                                                  yes
dn_upper_sa                                                  5
dn_sa_std_dev                                                1.01
dn_drive_stereocenters                                       yes
dn_upper_stereocenter                                        2
dn_start_at_layer                                            1
sa_fraglib_path                                              ${parameters}/sa_fraglib.dat
PAINS_path                                                   ${parameters}/pains_table.dat
dn_mol_wt_std_dev                                            35.0
dn_constraint_rot_bon                                        15
dn_constraint_formal_charge                                  2.0
dn_heur_unmatched_num                                        1
dn_heur_matched_rmsd                                         2.0
dn_unique_anchors                                            1
dn_max_grow_layers                                           9
dn_max_root_size                                             100
dn_max_layer_size                                            100
dn_max_current_aps                                           5
dn_max_scaffolds_per_layer                                   1
dn_write_checkpoints                                         yes
dn_write_prune_dump                                          no
dn_write_orients                                             no
dn_write_growth_trees                                        no
dn_output_prefix                                             ${pdb}.driven
use_internal_energy                                          yes
internal_energy_rep_exp                                      12
internal_energy_cutoff                                       100.0
use_database_filter                                          no
orient_ligand                                                yes
automated_matching                                           yes
receptor_site_file                                           ${datapath}/${pdb}/zzz.dock_files/${pdb}.rec.clust.close.sph
max_orientations                                             1000
critical_points                                              no
chemical_matching                                            no
use_ligand_spheres                                           no
bump_filter                                                  no
score_molecules                                              yes
contact_score_primary                                        no
grid_score_primary                                           no
gist_score_primary                                           no
multigrid_score_primary                                      no
dock3.5_score_primary                                        no
continuous_score_primary                                     no
footprint_similarity_score_primary                           no
pharmacophore_score_primary                                  no
hbond_score_primary                                          no
interal_energy_score_primary                                 no
descriptor_score_primary                                     yes
descriptor_use_grid_score                                    yes
descriptor_use_pharmacophore_score                           no
descriptor_use_tanimoto                                      no
descriptor_use_hungarian                                     no
descriptor_use_volume_overlap                                yes
descriptor_use_gist                                          no
descriptor_use_dock3.5                                       no
descriptor_grid_score_rep_rad_scale                          1
descriptor_grid_score_vdw_scale                              1
descriptor_grid_score_es_scale                               1
descriptor_grid_score_grid_prefix                            ${datapath}/${pdb}/zzz.dock_files/${pdb}.rec
descriptor_volume_score_reference_mol2_filename              ${datapath}/${pdb}/zzz.dock_files/${pdb}.lig.cartmin.mol2
descriptor_volume_score_overlap_compute_method               analytical
descriptor_weight_grid_score                                 1
descriptor_weight_volume_overlap_score                       -1
minimize_ligand                                              yes
minimize_anchor                                              yes
minimize_flexible_growth                                     yes
use_advanced_simplex_parameters                              no
simplex_max_cycles                                           1
simplex_score_converge                                       0.1
simplex_cycle_converge                                       1.0
simplex_trans_step                                           1.0
simplex_rot_step                                             0.1
simplex_tors_step                                            10.0
simplex_anchor_max_iterations                                500
simplex_grow_max_iterations                                  500
simplex_grow_tors_premin_iterations                          0
simplex_random_seed                                          0
simplex_restraint_min                                        no
atom_model                                                   all
vdw_defn_file                                                ${parameters}/vdw_AMBER_parm99.defn
flex_defn_file                                               ${parameters}/flex.defn
flex_drive_file                                              ${parameters}/flex_drive.tbl
chem_defn_file                                               ${parameters}/chem.defn
EOF

    cat <<EOF > ${pdb}/restricted/run.${pdb}.sh
#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=d3n.${pdb}
#SBATCH --output=%x-%j.o

echo "DOCK6 simulation started"
date

/gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/bin/dock6 -i d3n.in -o d3n.out

echo "DOCK6 simulation ended"
date
EOF
    chmod a+wrx ${pdb}/restricted/run.${pdb}.sh     


done < ${TXTFILE}

# Write job submission script

cat <<EOF > run_d3n.sh
#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=100:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --job-name=run_d3n
#SBATCH --output=%x-%j.o

# Functions
slurm_info_out(){
echo "============================= SLURM JOB ================================="
date
echo
echo " The job will be started on the following node(s):"
echo "                              \$SLURM_JOB_NODELIST"
echo
echo "Slurm user:                   \$SLURM_JOB_USER"
echo "Run directory:                \$(pwd)"
echo "Job ID:                       \$SLURM_JOB_ID"
echo "Job name:                     \$SLURM_JOB_NAME"
echo "Partition:                    \$SLURM_JOB_PARTITION"
echo "Number of nodes:              \$SLURM_JOB_NUM_NODES"
echo "Number of tasks:              \$SLURM_NTASKS"
echo "Submitted from:               \$SLURM_SUBMIT_HOST:\$SLURM_SUBMIT_DIR"
echo "========================================================================="
echo
echo "--- SLURM job-script output ----"
}

slurm_startjob(){

## DOCK6.9 simulation
date

for line in \`cat bickel_denovo_systems.dat\`
do
    echo "\${line}"
    cd \${line}/restricted
    srun --exclusive -N1 -n1 -W 0 run.\${line}.sh &
    cd ../..
done

wait

date
}

slurm_info_out
slurm_startjob

EOF



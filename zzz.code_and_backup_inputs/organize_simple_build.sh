#!/bin/sh

parameters='/gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/parameters'
datapath='/gpfs/projects/rizzo/leprentis/zinc1_ancs_freq'
dockpath='/gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_pak/bin/dock6'

anchor_num=(1 15 30 50 100 150 250 300 350 380)
for N in "${anchor_num[@]}"
do
    mkdir -p restricted/anchor${N}
    cat <<EOF > restricted/anchor${N}/run.${N}.sh
#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=d3n.${N}
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-user=guilherme.duarteramosmatos@stonybrook.edu
#SBATCH --output=%x-%j.o

echo "DOCK6 simulation started"
date

${dockpath} -i d3n.${N}.in -o d3n.${N}.out

echo "DOCK6 simulation ended"
date
EOF
    chmod a+wrx restricted/anchor${N}/run.${N}.sh
    cat <<EOF > restricted/anchor${N}/d3n.${N}.in
conformer_search_type                                        denovo
dn_fraglib_scaffold_file                                     ${parameters}/fraglib_scaffold.mol2
dn_fraglib_linker_file                                       ${parameters}/fraglib_linker.mol2
dn_fraglib_sidechain_file                                    ${parameters}/fraglib_sidechain.mol2
dn_user_specified_anchor                                     yes
dn_fraglib_anchor_file                                       ${datapath}/anchor_${N}.mol2
dn_torenv_table                                              ${parameters}/fraglib_torenv.dat
dn_use_roulette                                              no
dn_name_identifier                                           denovo
dn_sampling_method                                           rand
dn_num_random_picks                                          20
dn_pruning_conformer_score_cutoff                            100.0
dn_pruning_conformer_score_scaling_factor                    1.0
dn_pruning_clustering_cutoff                                 100.0
dn_upper_constraint_mol_wt                                   750.0
dn_lower_constraint_mol_wt                                   300.0
dn_mol_wt_cutoff_type                                        soft
dn_mol_wt_std_dev                                            35.0
dn_drive_verbose                                             yes
dn_save_all_mols                                             yes
dn_drive_clogp                                               yes
dn_lower_clogp                                               0.0
dn_upper_clogp                                               4
dn_clogp_std_dev                                             2.02
dn_drive_esol                                                no
dn_drive_tpsa                                                yes
dn_lower_tpsa                                                30.0
dn_upper_tpsa                                                110.
dn_tpsa_std_dev                                              42.0
dn_drive_qed                                                 yes
dn_lower_qed                                                 0.6
dn_qed_std_dev                                               0.19
dn_drive_sa                                                  yes
dn_upper_sa                                                  3
dn_sa_std_dev                                                0.89
dn_drive_stereocenters                                       yes
dn_upper_stereocenter                                        1
dn_start_at_layer                                            1
sa_fraglib_path                                              ${parameters}/sa_fraglib.dat
PAINS_path                                                   ${parameters}/pains_table.dat
dn_constraint_rot_bon                                        15
dn_constraint_formal_charge                                  2.0
dn_heur_unmatched_num                                        1
dn_heur_matched_rmsd                                         2.0
dn_unique_anchors                                            1
dn_max_grow_layers                                           9
dn_max_root_size                                             25
dn_max_layer_size                                            25
dn_max_current_aps                                           5
dn_max_scaffolds_per_layer                                   1
dn_write_checkpoints                                         yes
dn_write_prune_dump                                          no
dn_write_orients                                             no
dn_write_growth_trees                                        no
dn_output_prefix                                             simple.d3n.${N}
use_internal_energy                                          yes
internal_energy_rep_exp                                      12
internal_energy_cutoff                                       100.0
use_database_filter                                          no
orient_ligand                                                no
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
interal_energy_score_primary                                 yes
internal_energy_rep_exp                                      12
minimize_ligand                                              yes
minimize_anchor                                              no
minimize_flexible_growth                                     yes
use_advanced_simplex_parameters                              no
simplex_max_cycles                                           1
simplex_score_converge                                       0.1
simplex_cycle_converge                                       1.0
simplex_trans_step                                           1.0
simplex_rot_step                                             0.1
simplex_tors_step                                            10.0
simplex_grow_max_iterations                                  0
simplex_grow_tors_premin_iterations                          1000
simplex_random_seed                                          0
simplex_restraint_min                                        no
atom_model                                                   all
vdw_defn_file                                                ${parameters}/vdw_de_novo.defn
flex_defn_file                                               ${parameters}/flex.defn
flex_drive_file                                              ${parameters}/flex_drive.tbl                                                 
EOF

    mkdir -p unrestricted/anchor${N}
    cat <<EOF > unrestricted/anchor${N}/run.${N}.sh
#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=ud3n.${N}
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-user=guilherme.duarteramosmatos@stonybrook.edu
#SBATCH --output=%x-%j.o

echo "DOCK6 simulation started"
date

${dockpath} -i ud3n.${N}.in -o ud3n.${N}.out

echo "DOCK6 simulation ended"
date
EOF
    chmod a+wrx unrestricted/anchor${N}/run.${N}.sh
    cat <<EOF > unrestricted/anchor${N}/ud3n.${N}.in
conformer_search_type                                        denovo
dn_fraglib_scaffold_file                                     ${parameters}/fraglib_scaffold.mol2
dn_fraglib_linker_file                                       ${parameters}/fraglib_linker.mol2
dn_fraglib_sidechain_file                                    ${parameters}/fraglib_sidechain.mol2
dn_user_specified_anchor                                     yes
dn_fraglib_anchor_file                                       ${datapath}/anchor_${N}.mol2
dn_torenv_table                                              ${parameters}/fraglib_torenv.dat
dn_use_roulette                                              no
dn_name_identifier                                           denovo
dn_sampling_method                                           rand
dn_num_random_picks                                          20
dn_pruning_conformer_score_cutoff                            100.0
dn_pruning_conformer_score_scaling_factor                    1.0
dn_pruning_clustering_cutoff                                 100.0
dn_upper_constraint_mol_wt                                   750.0
dn_lower_constraint_mol_wt                                   300.0
dn_mol_wt_cutoff_type                                        soft
dn_mol_wt_std_dev                                            35.0
dn_drive_verbose                                             yes
dn_save_all_mols                                             yes
dn_drive_clogp                                               yes
dn_lower_clogp                                               -20.0
dn_upper_clogp                                               20.0
dn_clogp_std_dev                                             2.33
dn_drive_esol                                                no
dn_drive_tpsa                                                yes
dn_lower_tpsa                                                0.0
dn_upper_tpsa                                                999.0
dn_tpsa_std_dev                                              42.0
dn_drive_qed                                                 yes
dn_lower_qed                                                 0.0
dn_qed_std_dev                                               0.18
dn_drive_sa                                                  yes
dn_upper_sa                                                  10
dn_sa_std_dev                                                1.01
dn_drive_stereocenters                                       yes
dn_upper_stereocenter                                        20
dn_start_at_layer                                            1
sa_fraglib_path                                              ${parameters}/sa_fraglib.dat
PAINS_path                                                   ${parameters}/pains_table.dat
dn_constraint_rot_bon                                        15
dn_constraint_formal_charge                                  2.0
dn_heur_unmatched_num                                        1
dn_heur_matched_rmsd                                         2.0
dn_unique_anchors                                            1
dn_max_grow_layers                                           9
dn_max_root_size                                             25
dn_max_layer_size                                            25
dn_max_current_aps                                           5
dn_max_scaffolds_per_layer                                   1
dn_write_checkpoints                                         yes
dn_write_prune_dump                                          no
dn_write_orients                                             no
dn_write_growth_trees                                        no
dn_output_prefix                                             simple.ud3n.${N}
use_internal_energy                                          yes
internal_energy_rep_exp                                      12
internal_energy_cutoff                                       100.0
use_database_filter                                          no
orient_ligand                                                no
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
interal_energy_score_primary                                 yes
internal_energy_rep_exp                                      12
minimize_ligand                                              yes
minimize_anchor                                              no
minimize_flexible_growth                                     yes
use_advanced_simplex_parameters                              no
simplex_max_cycles                                           1
simplex_score_converge                                       0.1
simplex_cycle_converge                                       1.0
simplex_trans_step                                           1.0
simplex_rot_step                                             0.1
simplex_tors_step                                            10.0
simplex_grow_max_iterations                                  0
simplex_grow_tors_premin_iterations                          1000
simplex_random_seed                                          0
simplex_restraint_min                                        no
atom_model                                                   all
vdw_defn_file                                                ${parameters}/vdw_de_novo.defn
flex_defn_file                                               ${parameters}/flex.defn
flex_drive_file                                              ${parameters}/flex_drive.tbl 
EOF

    mkdir -p denovo/anchor${N}
    cat <<EOF > denovo/anchor${N}/run.${N}.sh
#!/bin/sh
#SBATCH --partition=rn-long
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=denovo.${N}
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
#SBATCH --mail-user=guilherme.duarteramosmatos@stonybrook.edu
#SBATCH --output=%x-%j.o

echo "DOCK6 simulation started"
date

${dockpath} -i simple_build.${N}.in -o simple_build.${N}.out
${dockpath} -i utilities.in -o utilities.out

echo "DOCK6 simulation ended"
date
EOF
    chmod a+wrx denovo/anchor${N}/run.${N}.sh
    cat <<EOF > denovo/anchor${N}/simple_build.${N}.in
conformer_search_type                                        denovo
dn_fraglib_scaffold_file                                     ${parameters}/fraglib_scaffold.mol2
dn_fraglib_linker_file                                       ${parameters}/fraglib_linker.mol2
dn_fraglib_sidechain_file                                    ${parameters}/fraglib_sidechain.mol2
dn_user_specified_anchor                                     yes
dn_fraglib_anchor_file                                       ${datapath}/anchor_${N}.mol2
dn_torenv_table                                              ${parameters}/fraglib_torenv.dat
dn_use_roulette                                              no
dn_name_identifier                                           denovo
dn_sampling_method                                           rand
dn_num_random_picks                                          20
dn_pruning_conformer_score_cutoff                            100.0
dn_pruning_conformer_score_scaling_factor                    1.0
dn_pruning_clustering_cutoff                                 100.0
dn_upper_constraint_mol_wt                                   750.0
dn_lower_constraint_mol_wt                                   300.0
dn_mol_wt_cutoff_type                                        soft
dn_mol_wt_std_dev                                            35.0
dn_drive_verbose                                             no
dn_save_all_mols                                             no
dn_drive_clogp                                               no
dn_drive_esol                                                no
dn_drive_tpsa                                                no
dn_drive_qed                                                 no
dn_drive_sa                                                  no
dn_drive_stereocenters                                       no
sa_fraglib_path                                              ${parameters}/sa_fraglib.dat
PAINS_path                                                   ${parameters}/pains_table.dat
dn_constraint_rot_bon                                        15
dn_constraint_formal_charge                                  2.0
dn_heur_unmatched_num                                        1
dn_heur_matched_rmsd                                         2.0
dn_unique_anchors                                            1
dn_max_grow_layers                                           9
dn_max_root_size                                             25
dn_max_layer_size                                            25
dn_max_current_aps                                           5
dn_max_scaffolds_per_layer                                   1
dn_write_checkpoints                                         yes
dn_write_prune_dump                                          no
dn_write_orients                                             no
dn_write_growth_trees                                        no
dn_output_prefix                                             simple.dn.${N}
use_internal_energy                                          yes
internal_energy_rep_exp                                      12
internal_energy_cutoff                                       100.0
use_database_filter                                          no
orient_ligand                                                no
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
interal_energy_score_primary                                 yes
internal_energy_rep_exp                                      12
minimize_ligand                                              yes
minimize_anchor                                              no
minimize_flexible_growth                                     yes
use_advanced_simplex_parameters                              no
simplex_max_cycles                                           1
simplex_score_converge                                       0.1
simplex_cycle_converge                                       1.0
simplex_trans_step                                           1.0
simplex_rot_step                                             0.1
simplex_tors_step                                            10.0
simplex_grow_max_iterations                                  0
simplex_grow_tors_premin_iterations                          1000
simplex_random_seed                                          0
simplex_restraint_min                                        no
atom_model                                                   all
vdw_defn_file                                                ${parameters}/vdw_de_novo.defn
flex_defn_file                                               ${parameters}/flex.defn
flex_drive_file                                              ${parameters}/flex_drive.tbl 
EOF

    cat <<EOF > denovo/anchor${N}/utilities.in
conformer_search_type                                        rigid
use_internal_energy                                          yes
internal_energy_rep_exp                                      12
internal_energy_cutoff                                       100.0
ligand_atom_file                                             simple.dn.${N}.denovo_build.mol2
limit_max_ligands                                            no
skip_molecule                                                no
read_mol_solvation                                           no
calculate_rmsd                                               no
use_database_filter                                          yes
dbfilter_max_heavy_atoms                                     999
dbfilter_min_heavy_atoms                                     0
dbfilter_max_rot_bonds                                       999
dbfilter_min_rot_bonds                                       0
dbfilter_max_hb_donors                                       999
dbfilter_min_hb_donors                                       0
dbfilter_max_hb_acceptors                                    999
dbfilter_min_hb_acceptors                                    0
dbfilter_max_molwt                                           9999.0
dbfilter_min_molwt                                           0.0
dbfilter_max_formal_charge                                   20.0
dbfilter_min_formal_charge                                   -20.0
dbfilter_max_stereocenters                                   999
dbfilter_min_stereocenters                                   0
dbfilter_max_spiro_centers                                   999
dbfilter_min_spiro_centers                                   0
dbfilter_max_clogp                                           40.0
dbfilter_min_clogp                                           -40.0
filter_sa_fraglib_path                                       /gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/parameters/sa_fraglib.dat
filter_PAINS_path                                            /gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/parameters/pains_table.dat
orient_ligand                                                no
bump_filter                                                  no
score_molecules                                              no
atom_model                                                   all
vdw_defn_file                                                /gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/parameters/vdw_AMBER_parm99.defn
flex_defn_file                                               /gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/parameters/flex.defn
flex_drive_file                                              /gpfs/projects/rizzo/gduarteramos/zzz.programs_gduarteramos/dock6_beta_rdkit/parameters/flex_drive.tbl
ligand_outfile_prefix                                        simple.dn.${N}.descriptors
write_orientations                                           no
num_scored_conformers                                        1
rank_ligands                                                 no
EOF


done
    


                                                

#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 04:00:00
#SBATCH -J Bin_QC_with_checkM
#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load CheckM/1.1.3


# Your commands

# Paths to bins to be evaluated (might have to be changed)
bins_SRR4342129=/home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342129
bins_SRR4342133=/home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342133


# Running CheckM
checkm lineage_wf -t 8 --reduced_tree -x fa $bins_SRR4342129 /home/niemi/Genome-Analysis/analyses/dna/06_evaluation/checkM_SRR4342129
checkm lineage_wf -t 8 --reduced_tree -x fa $bins_SRR4342133 /home/niemi/Genome-Analysis/analyses/dna/06_evaluation/checkM_SRR4342133                                 


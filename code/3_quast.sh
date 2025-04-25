#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 02:00:00
#SBATCH -J Quality_control_with_QUAST
#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load quast

# Your commands

# HOME_QUAST=/sw/bioinfo/quast.py
final_contigs_SRR4342129=/home/niemi/Genome-Analysis/analyses/dna/02_metagenome_assembly/megahit_results/res_SRR4342129/final.contigs.fa
final_contigs_SRR4342133=/home/niemi/Genome-Analysis/analyses/dna/02_metagenome_assembly/megahit_results/res_SRR4342133/final.contigs.fa


quast.py -t 4 $final_contigs_SRR4342129
quast.py -t 4 $final_contigs_SRR4342133




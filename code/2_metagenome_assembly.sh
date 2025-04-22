#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 10:00:00
#SBATCH -J metagenome_assembly

#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se

#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load megahit

# Your commands

dna_SRR4342129_forward=/home/niemi/Genome-Analysis/data/dna/raw_data/SRR4342129_1.paired.trimmed.fastq.gz
dna_SRR4342129_reverse=/home/niemi/Genome-Analysis/data/dna/raw_data/SRR4342129_2.paired.trimmed.fastq.gz
dna_SRR4342133_forward=/home/niemi/Genome-Analysis/data/dna/raw_data/SRR4342133_1.paired.trimmed.fastq.gz
dna_SRR4342133_reverse=/home/niemi/Genome-Analysis/data/dna/raw_data/SRR4342133_2.paired.trimmed.fastq.gz


megahit -1 $dna_SRR4342129_forward -2 $dna_SRR4342129_reverse -t 4 -o /home/niemi/Genome-Analysis/analyses/dna/02_metagenome_assembly/megahit_results/res_SRR4342129 --k-min 21 --k-max 81 --k-step 20
megahit	-1 $dna_SRR4342133_forward -2 $dna_SRR4342133_reverse -t 4 -o /home/niemi/Genome-Analysis/analyses/dna/02_metagenome_assembly/megahit_results/res_SRR4342133 --k-min 21 --k-max 81 --k-step 20



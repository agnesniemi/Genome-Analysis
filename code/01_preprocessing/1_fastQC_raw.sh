#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:40:00
#SBATCH -J fastqc_dna_rna_raw

#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load FastQC/0.11.9

# Your commands

fastqc -t 2 -o /home/niemi/Genome-Analysis/analyses/dna/01_preprocessing/fastqc_trim /home/niemi/Genome-Analysis/data/dna/raw_data/*.fastq.gz

fastqc -t 2 -o /home/niemi/Genome-Analysis/analyses/rna/01_preprocessing/fastqc_untrim /home/niemi/Genome-Analysis/data/rna/raw_data/*.fastq.gz

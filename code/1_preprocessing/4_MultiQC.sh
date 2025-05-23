#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:40:00
#SBATCH -J MultiQC

#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out



module load bioinfo-tools
module load MultiQC

# Paths to fastQC output
dna_trim_fastqc_output="/home/niemi/Genome-Analysis/analyses/dna/01_preprocessing/fastqc_trim"
rna_untrim_fastqc_output="/home/niemi/Genome-Analysis/analyses/rna/01_preprocessing/fastqc_untrim"
rna_trim_fastqc_output="/home/niemi/Genome-Analysis/analyses/rna/01_preprocessing/fastqc_trim"

# Making output directories
mkdir -p /home/niemi/Genome-Analysis/analyses/dna/01_preprocessing/multiqc_trim
mkdir -p /home/niemi/Genome-Analysis/analyses/rna/01_preprocessing/multiqc_untrim
mkdir -p /home/niemi/Genome-Analysis/analyses/rna/01_preprocessing/multiqc_trim

multiqc $dna_trim_fastqc_output -o /home/niemi/Genome-Analysis/analyses/dna/01_preprocessing/multiqc_trim
multiqc $rna_untrim_fastqc_output -o /home/niemi/Genome-Analysis/analyses/rna/01_preprocessing/multiqc_untrim
multiqc $rna_trim_fastqc_output -o /home/niemi/Genome-Analysis/analyses/rna/01_preprocessing/multiqc_trim


#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 04:00:00
#SBATCH -J Expression_analysis_with_htseq
#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load htseq/2.0.2



# Path to bam files and gff files
BAM_DIR="/home/niemi/Genome-Analysis/analyses/rna/04_rna_mapping/"
GFF_DIR_SRR4342129="/home/niemi/Genome-Analysis/analyses/dna/07_functional_annotation/clean_gff_SRR4342129"
GFF_DIR_SRR4342133="/home/niemi/Genome-Analysis/analyses/dna/07_functional_annotation/clean_gff_SRR4342133"


# Making output directories
mkdir -p /home/niemi/Genome-Analysis/analyses/dna/09_expression_analysis/SRR4342129
mkdir -p /home/niemi/Genome-Analysis/analyses/dna/09_expression_analysis/SRR4342133


# For location D1 
for bam in $BAM_DIR/SRR4342137/*_sorted.bam; do
    bin_name=$(basename "$bam" _sorted.bam)  # e.g., SRR4342137_bin_1
    bin_name=${bin_name#*_}               # removes 'SRR4342137_'
    gff="${GFF_DIR_SRR4342129}/${bin_name}_clean.gff"
    htseq-count --format bam --order pos --stranded no --type CDS --idattr ID "$bam" "$gff" > /home/niemi/Genome-Analysis/analyses/dna/09_expression_analysis/SRR4342129/${bin_name}_counts.txt
done


# For location D3
for bam in $BAM_DIR/SRR4342139/*_sorted.bam; do
    bin_name=$(basename "$bam" _sorted.bam)  # e.g., SRR4342137_bin_1
    bin_name=${bin_name#*_}
    gff="${GFF_DIR_SRR4342133}/${bin_name}_clean.gff"
    htseq-count --format bam --order pos --stranded no --type CDS --idattr ID "$bam" "$gff" > /home/niemi/Genome-Analysis/analyses/dna/09_expression_analysis/SRR4342133/${bin_name}_counts.txt
done





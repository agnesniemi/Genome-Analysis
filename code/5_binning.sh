#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 02:00:00
#SBATCH -J Binning_with_MetaBat
#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load MetaBat/2.12.1

# Your commands

# Paths to final contigs
final_contigs_SRR4342129=/home/niemi/Genome-Analysis/analyses/dna/02_metagenome_assembly/megahit_results/res_SRR4342129/final.contigs.fa
final_contigs_SRR4342133=/home/niemi/Genome-Analysis/analyses/dna/02_metagenome_assembly/megahit_results/res_SRR4342133/final.contigs.fa

# Where the output bins should be located
output_SRR4342129=/home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342129/bin
output_SRR4342133=/home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342133/bin

# Creating depth files 
jgi_summarize_bam_contig_depths --outputDepth depth_SRR4342129.txt /home/niemi/Genome-Analysis/analyses/dna/04_bwa/aln_sorted_SRR4342129.bam
jgi_summarize_bam_contig_depths --outputDepth depth_SRR4342133.txt /home/niemi/Genome-Analysis/analyses/dna/04_bwa/aln_sorted_SRR4342133.bam

metabat2 -i $final_contigs_SRR4342129 -a depth_SRR4342129.txt -o $output_SRR4342129 -t 4
metabat2 -i $final_contigs_SRR4342133 -a depth_SRR4342133.txt -o $output_SRR4342133 -t 4

# Removing intermediary files
rm depth_SRR4342129.txt
rm depth_SRR4342133.txt

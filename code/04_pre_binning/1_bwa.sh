#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 04:00:00
#SBATCH -J BWA
#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load bwa/0.7.18
module load samtools/1.20

# Your commands

# Path to forward reads
reads_forward_SRR4342129="/home/niemi/Genome-Analysis/data/dna/raw_data/SRR4342129_1.paired.trimmed.fastq.gz"
reads_forward_SRR4342133="/home/niemi/Genome-Analysis/data/dna/raw_data/SRR4342133_1.paired.trimmed.fastq.gz"

# Path to reverse reads
reads_reverse_SRR4342129="/home/niemi/Genome-Analysis/data/dna/raw_data/SRR4342129_2.paired.trimmed.fastq.gz"
reads_reverse_SRR4342133="/home/niemi/Genome-Analysis/data/dna/raw_data/SRR4342133_2.paired.trimmed.fastq.gz"

# Path to final contigs
final_contigs_SRR4342129="/home/niemi/Genome-Analysis/analyses/dna/02_metagenome_assembly/megahit_results/res_SRR4342129/final.contigs.fa"
final_contigs_SRR4342133="/home/niemi/Genome-Analysis/analyses/dna/02_metagenome_assembly/megahit_results/res_SRR4342133/final.contigs.fa"

# Indexing the final contigs files for efficient alignment
bwa index $final_contigs_SRR4342129 
bwa index $final_contigs_SRR4342133

# Aligning reads to consensus seq (final contigs) and converting output file format from .sam to .bam
bwa mem -t 8 $final_contigs_SRR4342129 $reads_forward_SRR4342129 $reads_reverse_SRR4342129 | samtools view -bS - > aln_SRR4342129.bam
bwa mem -t 8 $final_contigs_SRR4342133 $reads_forward_SRR4342133 $reads_reverse_SRR4342133 | samtools view -bS - > aln_SRR4342133.bam

# Sorting and indexing the .bam files
samtools sort -o aln_sorted_SRR4342129.bam aln_SRR4342129.bam
samtools sort -o aln_sorted_SRR4342133.bam aln_SRR4342133.bam

samtools index aln_sorted_SRR4342129.bam
samtools index aln_sorted_SRR4342133.bam

# Deleting intermediary files
rm aln_SRR4342129.bam
rm aln_SRR4342133.bam

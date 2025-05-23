#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 05:00:00
#SBATCH -J Trimming_rna_with_trimmomatic
#SBATCH --mail-type=ALL
#SBATCH --mail-user=agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load trimmomatic/0.39

# Input files
SRR4342137_R1=/home/niemi/Genome-Analysis/data/rna/raw_data/SRR4342137.1.fastq.gz
SRR4342137_R2=/home/niemi/Genome-Analysis/data/rna/raw_data/SRR4342137.2.fastq.gz
SRR4342139_R1=/home/niemi/Genome-Analysis/data/rna/raw_data/SRR4342139.1.fastq.gz
SRR4342139_R2=/home/niemi/Genome-Analysis/data/rna/raw_data/SRR4342139.2.fastq.gz

# Adapter file path (change)
ADAPTERS=/sw/apps/bioinfo/trimmomatic/0.39/rackham/adapters/TruSeq3-PE.fa

# Output directory
OUTDIR=/home/niemi/Genome-Analysis/data/rna/trimmed_data

# Trim SRR4342137
java -jar $TRIMMOMATIC_HOME/trimmomatic.jar PE -threads 4 \
    $SRR4342137_R1 $SRR4342137_R2 \
    $OUTDIR/SRR4342137_1_paired.fastq.gz $OUTDIR/SRR4342137_1_unpaired.fastq.gz \
    $OUTDIR/SRR4342137_2_paired.fastq.gz $OUTDIR/SRR4342137_2_unpaired.fastq.gz \
    ILLUMINACLIP:$ADAPTERS:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:40

# Trim SRR4342139
java -jar $TRIMMOMATIC_HOME/trimmomatic.jar PE -threads 4 \
    $SRR4342139_R1 $SRR4342139_R2 \
    $OUTDIR/SRR4342139_1_paired.fastq.gz $OUTDIR/SRR4342139_1_unpaired.fastq.gz \
    $OUTDIR/SRR4342139_2_paired.fastq.gz $OUTDIR/SRR4342139_2_unpaired.fastq.gz \
    ILLUMINACLIP:$ADAPTERS:2:30:10 \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:40


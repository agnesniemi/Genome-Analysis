#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 12:00:00
#SBATCH -J Annotation_with_eggnogmapper
#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load eggNOG-mapper/2.1.9

# Define base output directories
OUTDIR_D1="/home/niemi/Genome-Analysis/analyses/dna/11_eggnog_mapper/SRR4342129"
OUTDIR_D3="/home/niemi/Genome-Analysis/analyses/dna/11_eggnog_mapper/SRR4342133"

# Create output directories if they don't exist
mkdir -p "$OUTDIR_D1"
mkdir -p "$OUTDIR_D3"

# Annotate D1 bins
for BIN in 6 7 11 13 18 22 26 32 33 36 37; do
    faa_file="/home/niemi/Genome-Analysis/analyses/dna/07_functional_annotation/prokka_SRR4342129/prokka_bin_${BIN}/bin_${BIN}.faa"
    emapper.py -i "$faa_file" --itype proteins -o "SRR4342129_bin_${BIN}_emapper" --output_dir "$OUTDIR_D1" --cpu 8
done

# Annotate D3 bins
for BIN in 4 8 10 13 15 16 19 20 22 23 40 45; do
    faa_file="/home/niemi/Genome-Analysis/analyses/dna/07_functional_annotation/prokka_SRR4342133/prokka_bin_${BIN}/bin_${BIN}.faa"
    emapper.py -i "$faa_file" --itype proteins -o "SRR4342133_bin_${BIN}_emapper" --output_dir "$OUTDIR_D3" --cpu 8
done


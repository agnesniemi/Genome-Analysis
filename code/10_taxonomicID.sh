#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 16
#SBATCH -t 10:00:00
#SBATCH -J Taxonomic_ID_with_GTDB_Tk
#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load GTDB-Tk/2.4.0

# Define paths
SRC_DIR1="/home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342129/high_quality_bins"
SRC_DIR2="/home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342133/high_quality_bins"
OUT_DIR="/home/niemi/Genome-Analysis/analyses/dna/10_taxonomic_ID"

# Create working directories in SNIC_TMP
mkdir -p $SNIC_TMP/SRR4342129_bins
mkdir -p $SNIC_TMP/SRR4342133_bins
mkdir -p $SNIC_TMP/GTDBTK_out_2129
mkdir -p $SNIC_TMP/GTDBTK_out_2133

# Copy input files to SNIC_TMP
cp $SRC_DIR1/*.fa $SNIC_TMP/SRR4342129_bins/
cp $SRC_DIR2/*.fa $SNIC_TMP/SRR4342133_bins/

# Run GTDB-Tk from local disk
gtdbtk classify_wf \
    --genome_dir $SNIC_TMP/SRR4342129_bins \
    --out_dir $SNIC_TMP/GTDBTK_out_2129 \
    --extension fa \
    --skip_ani_screen \
    --cpus 16

gtdbtk classify_wf \
    --genome_dir $SNIC_TMP/SRR4342133_bins \
    --out_dir $SNIC_TMP/GTDBTK_out_2133 \
    --extension fa \
    --skip_ani_screen \
    --cpus 16

# Copy results back to permanent storage
mkdir -p $OUT_DIR/SRR4342129
mkdir -p $OUT_DIR/SRR4342133
cp -r $SNIC_TMP/GTDBTK_out_2129/* $OUT_DIR/SRR4342129/
cp -r $SNIC_TMP/GTDBTK_out_2133/* $OUT_DIR/SRR4342133/


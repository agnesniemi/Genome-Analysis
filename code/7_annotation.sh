#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 05:00:00
#SBATCH -J Annotation_with_Prokka
#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load prokka/1.45-5b58020


# Paths to bins and output
BINNING_DIR=/home/niemi/Genome-Analysis/analyses/dna/05_binning
OUTDIR=/home/niemi/Genome-Analysis/analyses/dna/07_functional_annotation

# Running prokka

# Annotation for SRR4342129

for bin in $BINNING_DIR/bins_SRR4342129/*.fa; do
  name=$(basename "$bin" .fa)
  prokka --cpus 4 --outdir $OUTDIR/prokka_SRR4342129/prokka_$name --prefix $name $bin
done


# Annotation for SRR4342133

for bin in $BINNING_DIR/bins_SRR4342133/*.fa; do
  name=$(basename "$bin" .fa)
  prokka --cpus 4 --outdir $OUTDIR/prokka_SRR4342133/prokka_$name --prefix $name $bin
done


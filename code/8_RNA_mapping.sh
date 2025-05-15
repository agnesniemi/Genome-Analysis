#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 04:00:00
#SBATCH -J RNA_mapping_with_bwa
#SBATCH --mail-type=ALL
#SBATCH --mail-user=agnes.niemi.0310@student.uu.se
#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load bwa/0.7.18
module load samtools/1.20

# Input reads
reads_forward_SRR4342137="/home/niemi/Genome-Analysis/data/rna/trimmed_data/SRR4342137_1_paired.fastq.gz"
reads_reverse_SRR4342137="/home/niemi/Genome-Analysis/data/rna/trimmed_data/SRR4342137_2_paired.fastq.gz"

reads_forward_SRR4342139="/home/niemi/Genome-Analysis/data/rna/trimmed_data/SRR4342139_1_paired.fastq.gz"
reads_reverse_SRR4342139="/home/niemi/Genome-Analysis/data/rna/trimmed_data/SRR4342139_2_paired.fastq.gz"

# Bin directories
BINDIR_SRR4342129="/home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342129/high_quality_bins"
BINDIR_SRR4342133="/home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342133/high_quality_bins"

# Output directories
OUTDIR="/home/niemi/Genome-Analysis/analyses/rna/04_rna_mapping"

# Mapping function
map_reads_to_bins () {
    local bin_dir=$1
    local sample_name=$2
    local reads_fwd=$3
    local reads_rev=$4

    echo "Processing $sample_name on bins in $bin_dir"

    for bin in "$bin_dir"/*.fa; do
        bin_base=$(basename "$bin" .fa)
        
        echo "Indexing $bin"
        bwa index "$bin"

        echo "Mapping $sample_name reads to $bin"
        bwa mem -t 8 "$bin" "$reads_fwd" "$reads_rev" | samtools view -bS - > "${sample_name}_${bin_base}.bam"

        echo "Sorting and indexing BAM file"
        samtools sort -o "$OUTDIR/${sample_name}_${bin_base}_sorted.bam" "${sample_name}_${bin_base}.bam"
        samtools index "$OUTDIR/${sample_name}_${bin_base}_sorted.bam"

        rm "${sample_name}_${bin_base}.bam"
    done
}

# Run mapping for each sample and bin set
map_reads_to_bins "$BINDIR_SRR4342129" "SRR4342137" "$reads_forward_SRR4342137" "$reads_reverse_SRR4342137"
map_reads_to_bins "$BINDIR_SRR4342133" "SRR4342139" "$reads_forward_SRR4342139" "$reads_reverse_SRR4342139"


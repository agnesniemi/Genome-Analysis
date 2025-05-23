import os
import pandas as pd
from glob import glob

# List of sample IDs
sample_ids = ["SRR4342129", "SRR4342133"]

# Base analysis directory
base_dir = "/home/niemi/Genome-Analysis/analyses/dna"

for sample_id in sample_ids:
    print(f"Processing sample: {sample_id}")

    # Define paths for current sample
    counts_dir = f"{base_dir}/09_expression_analysis/{sample_id}"
    annotations_dir = f"{base_dir}/11_eggnog_mapper/{sample_id}"
    prokka_dir = f"{base_dir}/07_functional_annotation/prokka_{sample_id}"
    output_dir = f"{base_dir}/12_eggnog_htseq_prokka_combined/{sample_id}"
    os.makedirs(output_dir, exist_ok=True)

    # Find all counts files
    counts_files = glob(os.path.join(counts_dir, "bin_*_counts.txt"))

    for counts_path in counts_files:
        bin_id = os.path.basename(counts_path).replace("_counts.txt", "")
        annotation_path = os.path.join(annotations_dir, f"{sample_id}_{bin_id}_emapper.emapper.annotations")
        prokka_path = os.path.join(prokka_dir, f"prokka_{bin_id}", f"{bin_id}.tsv")

        if not os.path.exists(annotation_path):
            print(f"EggNOG annotation file missing for {bin_id} in sample {sample_id}, skipping.")
            continue
        if not os.path.exists(prokka_path):
            print(f"Prokka annotation file missing for {bin_id} in sample {sample_id}, skipping.")
            continue

        # Load counts file
        counts_df = pd.read_csv(counts_path, sep="\t", header=None, names=["gene_id", "count"])

        # Load eggNOG annotation file
        annot_df = pd.read_csv(annotation_path, sep="\t", skiprows=4)

        # Merge with eggNOG annotation
        merged_df = counts_df.merge(annot_df, left_on="gene_id", right_on="#query", how="left")

        # Filter for expression > 10
        merged_df = merged_df[merged_df["count"] > 10]

        # Load Prokka annotation
        prokka_df = pd.read_csv(prokka_path, sep="\t")

        # Merge with Prokka using gene_id = locus_tag
        merged_df = merged_df.merge(prokka_df[["locus_tag", "product"]], left_on="gene_id", right_on="locus_tag", how="left")

        # Select useful columns
        columns_to_keep = ["gene_id", "count", "COG_category", "PFAMs", "product"]  # Options: ["gene_id", "count", "COG_category", "Description", "KEGG_ko", "KEGG_Pathway", "GOs", "EC", "PFAMs"]
        merged_df = merged_df[columns_to_keep]

        # Save to file
        output_file = os.path.join(output_dir, f"{bin_id}_combined.tsv")
        merged_df.to_csv(output_file, sep="\t", index=False)
        print(f"Saved: {output_file}")


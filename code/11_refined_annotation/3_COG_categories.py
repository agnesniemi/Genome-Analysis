import os
import pandas as pd
import matplotlib.pyplot as plt
from glob import glob
from collections import Counter
import matplotlib.colors as mcolors

# Directory containing the output files
base_output_dir = "/home/niemi/Genome-Analysis/analyses/dna/12_eggnog_htseq_prokka_combined"

# Sample IDs to include
sample_ids = ["SRR4342129", "SRR4342133"]
sample_label_map = {
    "SRR4342129": "D1",
    "SRR4342133": "D3"
}

# Step 1: Collect all unique COG categories from all samples
all_cogs = set()
sample_counters = {}

for sample_id in sample_ids:
    sample_dir = os.path.join(base_output_dir, sample_id)
    combined_files = glob(os.path.join(sample_dir, "bin_*_combined.tsv"))

    cog_counter = Counter()
    for file_path in combined_files:
        df = pd.read_csv(file_path, sep="\t")
        cog_column = df["COG_category"].dropna()


        for _, row in df.dropna(subset=["COG_category"]).iterrows():
            count = row["count"]
            cogs = str(row["COG_category"])
            for cog in cogs:
                if cog.isalpha():
                    cog_counter[cog] += count
                    all_cogs.add(cog)


    sample_counters[sample_id] = cog_counter

# Step 2: Assign colors consistently for all unique COGs
# Use matplotlib tab20 palette or any other qualitative palette
palette = plt.get_cmap('tab20').colors
all_cogs = sorted(all_cogs)  # sort for consistency
color_map = {cog: palette[i % len(palette)] for i, cog in enumerate(all_cogs)}

# Step 3: Plot pie charts for each sample using consistent colors
for sample_id in sample_ids:
    cog_counter = sample_counters[sample_id]
    labels = list(cog_counter.keys())
    sizes = list(cog_counter.values())
    colors = [color_map[cog] for cog in labels]

    plt.figure(figsize=(8, 8))
    plt.pie(sizes, labels=labels, autopct="%1.1f%%", startangle=90, colors=colors, textprops={"fontsize": 12})
    plt.title(f"COG Category Distribution in {sample_label_map[sample_id]}", fontsize=14)
    plt.axis("equal")

    cog_out_dir = f"/home/niemi/Genome-Analysis/analyses/dna/13_COG_categories/{sample_id}"
    os.makedirs(cog_out_dir, exist_ok=True)
    output_path = os.path.join(cog_out_dir, f"COG_pie_{sample_label_map[sample_id]}.png")
    plt.savefig(output_path, bbox_inches="tight")
    plt.close()


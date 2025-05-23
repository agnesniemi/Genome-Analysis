import csv
import os
import glob

summary_data = []

for filename in glob.glob("*_expressed.tsv"):
    sample = filename.replace("_expressed.tsv", "")
    with open(filename) as f:
        lines = f.readlines()

    gene_lines = []
    summary_start = None
    for idx, line in enumerate(lines):
        if line.strip() == "Summary":
            summary_start = idx
            break
        if line.startswith("Gene_ID") or line.strip() == "":
            continue
        if not line.startswith("__"):  # ignore non-gene entries
            gene_lines.append(line.strip().split('\t'))

    # Extract gene info
    if gene_lines:
        top_gene = max(gene_lines, key=lambda x: int(x[2]))
        top_product = top_gene[1]
        top_count = top_gene[2]
    else:
        top_product = "NA"
        top_count = "0"

    # Extract summary section
    total_genes = hypothetical = percent_hypo = "NA"
    if summary_start:
        for line in lines[summary_start + 1:]:
            if line.startswith("Total expressed genes"):
                total_genes = line.strip().split('\t')[-1]
            elif line.startswith("Hypothetical proteins"):
                hypothetical = line.strip().split('\t')[-1]
            elif line.startswith("% Hypothetical"):
                percent_hypo = line.strip().split('\t')[-1]

    summary_data.append([
        sample, total_genes, hypothetical, percent_hypo,
        top_product, top_count
    ])

# Write summary to file
with open("summary_across_bins.tsv", "w", newline='') as out:
    writer = csv.writer(out, delimiter='\t')
    writer.writerow([
        "Sample_Bin", "Total_Expressed_Genes", "Hypothetical_Proteins",
        "%_Hypothetical", "Top_Expressed_Product", "Top_Count"
    ])
    writer.writerows(summary_data)

print("[✓] Written: summary_across_bins.tsv")


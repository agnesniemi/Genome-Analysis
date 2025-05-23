import csv
import os


def extract_expressed_genes(count_file, min_count=1):
    expressed = {}
    with open(count_file, 'r') as f:
        for line in f:
            gene_id, count = line.strip().split('\t')
            if count.isdigit() and int(count) >= min_count:
                expressed[gene_id] = int(count)
    return expressed


def map_gene_to_product(prokka_tsv):
    gene_product_map = {}
    with open(prokka_tsv, 'r') as f:
        reader = csv.DictReader(f, delimiter='\t')
        for row in reader:
            gene_id = row['locus_tag']
            product = row.get('product', 'NA')
            gene_product_map[gene_id] = product
    return gene_product_map


def map_gene_to_eggnog_description(emapper_file):
    eggnog_map = {}
    with open(emapper_file, 'r') as f:
        for line in f:
            if line.startswith('#') or line.strip() == '':
                continue
            cols = line.strip().split('\t')
            if len(cols) >= 9:
                gene_id = cols[0]
                description = cols[7] if cols[7] else 'NA'
                eggnog_map[gene_id] = description
    return eggnog_map


def merge_expression_and_annotation(count_file, prokka_tsv, emapper_file, output_file, min_expression=10):
    expressed_genes = extract_expressed_genes(count_file, min_expression)
    if not expressed_genes:
        return False

    gene_to_product = map_gene_to_product(prokka_tsv)
    gene_to_eggnog = map_gene_to_eggnog_description(emapper_file) if os.path.exists(emapper_file) else {}

    result = []
    hypothetical_count = 0

    for gene_id, count in expressed_genes.items():
        product = gene_to_product.get(gene_id, 'NA')
        refined = gene_to_eggnog.get(gene_id, product)
        result.append((gene_id, product, refined, count))
        if product.lower() == 'hypothetical protein':
            hypothetical_count += 1

    result.sort(key=lambda x: x[3], reverse=True)

    total_expressed = len(result)
    with open(output_file, 'w', newline='') as out:
        writer = csv.writer(out, delimiter='\t')
        writer.writerow(['Gene_ID', 'Prokka_Product', 'eggNOG_Description', 'Count'])
        for row in result:
            writer.writerow(row)

        writer.writerow([])
        writer.writerow(['Summary'])
        writer.writerow(['Total expressed genes', total_expressed])
        writer.writerow(['Hypothetical proteins', hypothetical_count])
        writer.writerow(['% Hypothetical', f"{(hypothetical_count / total_expressed) * 100:.2f}%"])

    return True

# Config
locations = ['SRR4342129', 'SRR4342133']
bin_numbers_SRR4342129 = (6, 7, 11, 13, 18, 22, 26, 32, 33, 36, 37) 
bin_numbers_SRR4342133 = (4, 8, 10, 13, 15, 16, 19, 20, 22, 23, 40, 45)
min_expression = 10

# Create base output directory if it doesn't exist
output_base_dir = "/home/niemi/Genome-Analysis/analyses/dna/14_refined_taxonomicID"
os.makedirs(output_base_dir, exist_ok=True)

for loc in locations:
    loc_output_dir = os.path.join(output_base_dir, loc)
    os.makedirs(loc_output_dir, exist_ok=True)

    bin_numbers = bin_numbers_SRR4342129 if loc == 'SRR4342129' else bin_numbers_SRR4342133
    for i in bin_numbers:
        bin_name = f'bin_{i}'
        count_file = f"/home/niemi/Genome-Analysis/analyses/dna/09_expression_analysis/{loc}/{bin_name}_counts.txt"
        prokka_tsv = f"/home/niemi/Genome-Analysis/analyses/dna/07_functional_annotation/prokka_{loc}/prokka_{bin_name}/{bin_name}.tsv"
        emapper_file = f"/home/niemi/Genome-Analysis/analyses/dna/11_eggnog_mapper/{loc}/{loc}_{bin_name}_emapper.emapper.annotations"
        output_file = os.path.join(loc_output_dir, f"{loc}_{bin_name}_expressed.tsv")

        if os.path.exists(count_file) and os.path.exists(prokka_tsv):
            success = merge_expression_and_annotation(count_file, prokka_tsv, emapper_file, output_file, min_expression)
            if success:
                print(f"[✓] Saved: {output_file}")
            else:
                print(f"[i] Skipped {bin_name} in {loc} (no genes > {min_expression})")
        else:
            print(f"[!] Missing files for {bin_name} in {loc}")


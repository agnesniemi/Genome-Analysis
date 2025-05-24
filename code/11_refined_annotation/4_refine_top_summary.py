import os
import csv

def summarize_expression_table(file_path, sample_label):
    with open(file_path, 'r') as f:
        reader = csv.DictReader(f, delimiter='\t')
        rows = [row for row in reader if not row['Gene_ID'].startswith('__')]

    if not rows:
        return None

    expressed = [
        row for row in rows
        if row.get('Count') is not None and row['Count'].isdigit() and int(row['Count']) > 0
    ]

    total_genes = len(expressed)
    hypothetical_count = sum(1 for r in expressed if r['Prokka_Product'].lower() == 'hypothetical protein')
    percent_hypothetical = (hypothetical_count / total_genes) * 100 if total_genes else 0

    top_gene = max(expressed, key=lambda x: int(x['Count']))
    top_product = top_gene['Prokka_Product']
    top_description = top_gene['eggNOG_Description']
    top_count = top_gene['Count']

    return {
        'Sample_Bin': sample_label,
        'Total_Expressed_Genes': total_genes,
        'Hypothetical_Proteins': hypothetical_count,
        '%_Hypothetical': f"{percent_hypothetical:.2f}%",
        'Top_Expressed_Product': top_product,
        'Top_eggNOG_Description': top_description,
        'Top_Count': top_count
    }

def main():
    base_input_dir = '/home/niemi/Genome-Analysis/analyses/dna/14_refined_taxonomicID'
    base_output_dir = '/home/niemi/Genome-Analysis/analyses/dna/15_refined_tax_summary'
    locations = {
        'SRR4342129': 'D1',
        'SRR4342133': 'D3'
    }

    os.makedirs(base_output_dir, exist_ok=True)

    columns = ['Sample_Bin', 'Total_Expressed_Genes', 'Hypothetical_Proteins', '%_Hypothetical',
               'Top_Expressed_Product', 'Top_eggNOG_Description', 'Top_Count']

    for loc, site_label in locations.items():
        summary_rows = []
        input_dir = os.path.join(base_input_dir, loc)
        output_file = os.path.join(base_output_dir, f"{site_label}_summary.tsv")

        for file in os.listdir(input_dir):
            if file.endswith('_expressed.tsv'):
                full_path = os.path.join(input_dir, file)
                bin_number = file.split('_bin_')[-1].replace('_expressed.tsv', '')
                sample_label = f"{site_label}_bin_{bin_number}"

                result = summarize_expression_table(full_path, sample_label)
                if result:
                    summary_rows.append(result)

        summary_rows.sort(key=lambda x: x['Sample_Bin'])

        with open(output_file, 'w', newline='') as f:
            writer = csv.writer(f, delimiter='\t')
            writer.writerow(columns)
            for row in summary_rows:
                writer.writerow([row[col] for col in columns])

        print(f"[✓] Written summary for {loc} to {output_file}")

if __name__ == "__main__":
    main()


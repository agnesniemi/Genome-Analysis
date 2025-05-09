
#!/bin/bash

cd /home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342129

for file in *.fa; do
  # Get the base name without the extension
  base="${file%.fa}"

  # Replace all dots with underscores
  new_base="${base//./_}"

  # Reattach the extension
  new_name="${new_base}.fa"

  # Rename the file
  mv "$file" "$new_name"

done

cd /home/niemi/Genome-Analysis/analyses/dna/05_binning/bins_SRR4342133

for file in *.fa; do
  # Get the base name without the extension
  base="${file%.fa}"

  # Replace all dots with underscores
  new_base="${base//./_}"

  # Reattach the extension
  new_name="${new_base}.fa"

  # Rename the file
  mv "$file" "$new_name"

done


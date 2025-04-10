#!/bin/bash -l
#SBATCH -A uppmax2025-3-3
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 08:00:00
#SBATCH -J metagenome_assembly

#SBATCH --mail-type=ALL
#SBATCH --mail-user agnes.niemi.0310@student.uu.se

#SBATCH --output=%x.%j.out

# Load modules
module load bioinfo-tools
module load ....
# Your commands
<Command
1...>
_
<Command
2...>

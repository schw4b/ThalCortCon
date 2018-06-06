#!/bin/sh

#SBATCH --mail-type=FAIL
#SBATCH --mail-user=schwab@upd.unibe.ch
#SBATCH --time=00:55:00
#SBATCH --job-name=DGM-ThalCort14
#SBATCH --mem-per-cpu=512M
#SBATCH --output=log/slurm/slurm-%j.out
#SBATCH --error=log/slurm/slurm-%j.out
#SBATCH --array=1-1232

# submit is a symlink
srun ~/ThalCortCon/submit/DGM-ThalCort14-Slurm.R

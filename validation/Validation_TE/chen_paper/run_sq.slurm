#!/bin/bash

# Submit this script with: sbatch run_sq.slurm

#SBATCH --time=00:10:00              # walltime — adjust to your expected total sweep time
#SBATCH --ntasks-per-node=112       # cores available for mpirun inside the script
#SBATCH --nodes=1
#SBATCH --wckey=ammt
#SBATCH -J "chen-paper_module-cuboid-pattern-sq"
#SBATCH --mail-user=hailey.trankieu@inl.gov
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL


module load use.moose moose-dev-openmpi/2026.06.16

cd /projects/USU/Thermoelectric-Hailey/tetra-test/tetra/validation/Validation_TE/chen_paper

mpiexec -n 112 moose-dev-exec ../../../tetra-opt -i module_cuboid_pattern_sq.i -w
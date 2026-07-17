#!/bin/bash

# Submit this script with: sbatch run_aniso.slurm

#SBATCH --time=00:10:00
#SBATCH --ntasks-per-node=6
#SBATCH --wckey=ammt
#SBATCH -J "anisotropic"
#SBATCH --mail-user=hailey.trankieu@inl.gov
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL


module load use.moose moose-dev-openmpi/2026.06.16

cd /projects/USU/Thermoelectric-Hailey/tetra-test/tetra/verification/Verification_TE/Comsol_comp/Example_5

mpiexec -n 6 moose-dev-exec ../../../../tetra-opt -i module_cuboid_aniso.i
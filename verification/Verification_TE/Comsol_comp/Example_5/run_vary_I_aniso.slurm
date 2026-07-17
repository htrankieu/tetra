#!/bin/bash

# Submit this script with: sbatch run_vary_I_aniso.slurm

#SBATCH --time=00:30:00
#SBATCH --ntasks-per-node=20
#SBATCH --wckey=ammt
#SBATCH -J "anisotropic everything"
#SBATCH --mail-user=hailey.trankieu@inl.gov
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL


module load use.moose moose-dev-openmpi/2026.06.16

cd /projects/USU/Thermoelectric-Hailey/tetra-test/tetra/

./run_tests --spec-file verification/Verification_TE/Comsol_comp/Example_5/vary_I_aniso
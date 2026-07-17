#!/bin/bash

#SBATCH --time=00:10:00
#SBATCH --ntasks-per-node=20
#SBATCH --nodes=1
#SBATCH --wckey=ammt
#SBATCH -J "current_${i}"
#SBATCH --mail-user=hailey.trankieu@inl.gov
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL


module load use.moose moose-dev-openmpi/2026.06.16

cd /projects/USU/Thermoelectric-Hailey/tetra-test/tetra/validation/Validation_TE/TEM/mesh_study_coarse

mpiexec -n 20 moose-dev-exec ../../../../tetra-opt -i module_cuboid_pattern_mesh.i --mesh-only
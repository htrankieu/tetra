#!/bin/bash

# Submit this script with: sbatch thefilename

#SBATCH --time=4:00:00 # walltime
#SBATCH --ntasks-per-node=112 # number of processor cores (i.e. tasks)
#SBATCH --nodes=2 # number of nodes
#SBATCH --wckey ne_gen # Project Code
#SBATCH -J "my_job_name" # job name


module load use.moose moose-dev-openmpi/2025.04.22
cd /projects/USU/Thermoelectric-Working/Validation_TE/chen_paper/flow_coupling_I
mpiexec -n 224 moose-dev-exec ../../../tetra_bitterroot/tetra/tetra-opt -i module_cuboid_pattern_sq.i -w



#!/bin/bash

# Submit this script with: sbatch run_exhaust_pipe.slurm

#SBATCH --time=03:00:00 # walltime
#SBATCH --ntasks-per-node=112 # number of processor cores (i.e. tasks)
#SBATCH --nodes=5 # number of nodes
#SBATCH --wckey=ammt # Project Code
#SBATCH -J "exhaust_pipe" # job name


module load use.moose moose-dev-openmpi/2026.06.16
cd /projects/USU/Thermoelectric-Hailey/tetra-test/tetra/validation/Validation_TE/exhaust_pipe-original
mpiexec -n 560 moose-dev-exec ../../../tetra-opt -i Pipe_only.i -w
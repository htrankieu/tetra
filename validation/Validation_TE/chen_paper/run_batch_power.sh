#!/bin/bash
# Submits one SLURM job per MOOSE simulation.
# Each job runs independently on its own set of nodes.
# Usage: bash run_batch_power.sh

CURRENT=(0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5)




for i in "${CURRENT[@]}"; do
    
    sbatch <<EOF
#!/bin/bash

#SBATCH --time=00:10:00
#SBATCH --ntasks-per-node=112
#SBATCH --nodes=1
#SBATCH --wckey=neams
#SBATCH -J "current_${i}"
#SBATCH --mail-user=hailey.trankieu@inl.gov
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

echo "Starting job for current_${i} on \$(hostname) at \$(date)"

module load use.moose moose-dev-openmpi/2026.06.16

cd /projects/USU/Thermoelectric-Hailey/tetra-test/tetra/validation/Validation_TE/chen_paper

mpiexec -n 112 moose-dev-exec ../../../tetra-opt -i module_cuboid_pattern_sq.i I=${i} Outputs/file_base=current_${i} -w --use-split --split-file pattern.cpa.gz

echo "Finished job for current_${i} at \$(date)"
EOF

    echo "Submitted job for current_${i}"
done
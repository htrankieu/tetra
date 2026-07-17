#!/bin/bash
# Submits one SLURM job per MOOSE simulation.
# Each job runs independently on its own set of nodes.
# Usage: bash run_batch_temp.sh

TEMPERATURE=(325 350 375 400 425 450 475 500)




for i in "${TEMPERATURE[@]}"; do
    
    sbatch <<EOF
#!/bin/bash

#SBATCH --time=00:05:00
#SBATCH --ntasks-per-node=112
#SBATCH --nodes=1
#SBATCH --wckey=ammt
#SBATCH -J "temp_${i}"
#SBATCH --mail-user=hailey.trankieu@inl.gov
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL

echo "Starting job for temp_${i} on \$(hostname) at \$(date)"

module load use.moose moose-dev-openmpi/2026.06.16

cd /projects/USU/Thermoelectric-Hailey/tetra-test/tetra/validation/Validation_TE/chen_paper

mpiexec -n 112 moose-dev-exec ../../../tetra-opt -i module_cuboid_pattern_sq.i assigned_temperature=${i} Outputs/file_base=temperature/temp_${i} -w --use-split --split-file pattern.cpa.gz

echo "Finished job for temp_${i} at \$(date)"
EOF

    echo "Submitted job for temp_${i}"
done
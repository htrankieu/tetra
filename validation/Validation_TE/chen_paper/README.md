Authored by Hailey Tran-Kieu
Created on July 15, 2026


**run_batch_power.sh**
This is a bash script to run multiple SLURM scripts that rune the module_cuboid_pattern_sq.i input file at varying currents. RUN this in the terminal and then run **plot_power_batch.py** to plot the Power vs. Current figure (see TEM_power_batch.png).


**flow_coupling** and **flow_coupling_I** 
These cases are to test simulating 3D gas flow using the Navier Stokes Physics capabilities briefly mentioned in the paper by Guillen & Charlot. The study conducted in Guillen & Charlot only implements 1D gas flow approximation. These two folders have essentially the same input files EXCEPT one has the current set at 0 A and the other has the current set at 0.5 A, respectively. The *flow_coupling_I* folder also has a SLURM script.
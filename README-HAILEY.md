This TETRA Repository was last edited by Hailey Tran-Kieu in Summer 2026.

Please refer below for information on the contents of this TETRA folder!

NOTE: Within in each folder listed below are more README.md files that explain what the contents are!



**convergence-study**
This folder contains files for conducting a mesh convergence study to compare the MOOSE model to the analytical solution outlined in the paper by Guillen & Charlot (see Equations 25 & 26).


**verification**
This folder contains the Comsol/Jaegle verification studies where the input files were edited. You will find the anisotropic thermal expansion coefficient implementation attempts here. The folders named 0_new-runs within each Example_# folder contain the results for each version of TEJouleHeat.C with and without the negative temperature check from ThermalElectricMaterial.C.


**verfication-default**
This folder contains the Comsol/Jaegle verification studies where the input files file were NOT edited and are executed AS IS. I ran these to compare with the results from the verification folder to make sure I didn't goof somewhere when editing the input files. The folders named 0_new-runs within each Example_# folder contain the results for each version of TEJouleHeat.C with and without the negative temperature check from ThermalElectricMaterial.C.
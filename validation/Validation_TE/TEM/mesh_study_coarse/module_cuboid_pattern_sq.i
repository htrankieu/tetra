
I = 1.
leg_size = 1.6
leg_height = 1.4
elem_leg = 16
elem_height = 14
leg_spacing = 0.4
elem_spacing = 4
connect_height = 0.2
elem_connect =2
nx = 7
ny = 16
# leg_size = 1.5
# leg_height = 0.75
# elem_leg = 15
# elem_height = 7
# leg_spacing = 0.5
# elem_spacing = 5
# connect_height = 0.2
# elem_connect =2
# nx = 7
# ny = 16
TEM_length = ${fparse 2 * leg_size + 4 *leg_spacing}
x_max_line = ${fparse nx * TEM_length}
y_last_row = ${fparse -(ny-1) *(leg_size + 2* leg_spacing)}
# [GlobalParams]
#   # thermal expansion
#   displacements = 'disp_x disp_y disp_z'
# []

[Mesh]
  # parallel_type = DISTRIBUTED
  [mesh]
    type = FileMeshGenerator
    # file = pattern_mesh.cpa.gz
    file = module_cuboid_pattern_mesh_in.e
  []
[]
[Variables]
  [T]
    initial_condition = 400 #in K
  []
  [elec]
    block =  'n_leg 102 202 p_leg 104 204 interconnect_cold 101 103 201 203 interconnect_hot'
  []
[]

[Kernels]
  # Heat DT
  [HeatDiff]
    type = ADHeatConduction
    variable = T
  []
  [electric]
    type = ElectricConduction
    variable = elec
    block =  'n_leg 102 202 p_leg 104 204 interconnect_cold 101 103 201 203 interconnect_hot'
  []
  [seebeck_effect]
    type = SeebeckEnergy
    variable = elec
    temp =T
    block =  'n_leg 102 202 p_leg 104 204 interconnect_cold 101 103 201 203 interconnect_hot'
  []
  # [Peltier_effect]
  #   type = PeltierHeat
  #   variable = T
  #   block =  'n_leg 102 202 p_leg 104 204 interconnect_cold 101 103 201 203 interconnect_hot'
  # []
  # [HeatSrc]
  #   type = TEJouleHeat
  #   variable = T
  #   current_density = current_density
  #   elec = elec
  #   block =  'n_leg 102 202 p_leg 104 204 interconnect_cold 101 103 201 203 interconnect_hot'
  # []
[]

[BCs]
   [hot_temp]
    type = CoupledConvectiveHeatFluxBC
    variable = T
    boundary = 'top_plate_front'
    # T_infinity = ${fparse 181.53+273.15}
    T_infinity = T_fluid
    htc = htc # ${fparse 1/(25*20e-6)}
  []
  [cold_temp]
    type = CoupledConvectiveHeatFluxBC
    variable = T
    boundary = 'bottom_plate_back'
    T_infinity = 300
    # T_infinity = ${fparse 50.108 + 273.15}
    htc = 1e4 #${fparse 1/(25*20e-6)}
    # heat_transfer_coefficient = 5e4 #${fparse 1/(25*20e-6)}
  []
  [elec_right]
    type = ADDirichletBC
    variable = elec
    boundary = plus_BC
    value = 0
  []
  [intensity]
    type = ADNeumannBC
    variable = elec
    boundary = minus_BC
    value = ${fparse -I/(connect_height*leg_size * 1e-6)}
  []

[]
[AuxVariables]
  [T_fluid]
    initial_condition = 400
    # block = 500
  []
  [htc]
    initial_condition = 2e4
    # block = 500
  []
[]

[Functions]

  [TiNiSn_k_func]
    type = PiecewiseLinear
    x = '321.7 372.5 422.1 473.2 521.1 574.6 621.7 674.3 722.3 773.9 822.6 873.4'
    y = '4.720385 4.422786 4.20302 4.402183 4.745567 5.230883 5.038588 4.47086 4.23278 4.161814 4.537247 4.841714'
  []
  [TiNiSn_cp_func]
    type = PiecewiseLinear
    x = '301.1 317.2 372.5 420.9 474.8 521.1 574.3 621.8 674.1 722.2 773.8 822.6 873.5'
    y = '110.727127 110.727127 110.727127 110.727127 110.727127 110.727127 110.727127 110.727127 110.727127 110.727127 110.727127 110.727127 110.727127'
  []
  # [TiNiSn_S_func]
  #   type = PiecewiseLinear
  #   x = '325.0 340.0 355.0 370.0 385.0 400.0 415.0 430.0 445.0 460.0 475.0 490.0 505.0 520.0 535.0 550.0 565.0 580.0 595.0 610.0 625.0 640.0 655.0 670.0 685.0 700.0 715.0 730.0 745.0 760.0 775.0 790.0 805.0 820.0 835.0 850.0 865.0 880.0'
  #   y = '-98.619137 -107.885219 -114.335141 -121.557557 -127.420948 -134.074332 -139.388819 -145.038378 -149.217068 -153.68069 -157.458469 -160.982727 -164.011752 -166.472657 -168.857892 -171.689057 -172.756789 -173.691728 -174.72542 -174.196161 -175.844522 -175.473575 -176.253531 -175.546025 -174.919891 -173.394138 -173.217943 -171.89109 -170.367678 -169.873856 -168.434889 -166.345395 -164.295189 -162.618845 -160.913163 -158.971385 -157.154504 -155.283272'
  #   # scale_factor = 1e-1
  #   # scale_factor = 1e-6
  #   scale_factor = 1e-6
  # []
  [TiNiSn_S_func]
    type = ParsedFunction
    expression = '(0.0006 * t*t - 0.7517 * t + 64.67) *1e-6'
  []
  [TiNiSn_R_func]
    type = PiecewiseLinear
    x = '324.39962 341.49366 342.89318 395.0382 395.8469 447.2877 448.8275 498.5268 500.0929 549.3215 551.1751 599.5306 601.784 648.5707 650.832 696.3351 698.8966 743.3655 746.2517 789.4529 793.5273 836.7425 840.4479 885.0684 887.4234'
    y = '10.84395 11.55511 12.34476 13.06968 13.84695 14.70098 15.89508 17.38718 18.62257 19.67923 22.43705 26.35393 27.54039 26.20053 22.45366 19.54035 18.71153 17.28059 15.78936 14.67878 13.81452 13.14848 12.5056 11.7287 10.98754'
    scale_factor = 1e-6
  []
  [Bi2Te3_S_func]
    type = ParsedFunction
    expression = '(-6.373e-6 *t*t*t+ 0.00359*t*t - 0.0924 * t +84.605) *1e-6'
  []
  [Bi2Te3_S_func_n]
    type = ParsedFunction
    expression = '(-6.373e-6 *t*t*t+ 0.00359*t*t - 0.0924 * t +84.605) *1e-6* -1'
  []
  [Bi2Te3_R_func]
    type = ParsedFunction
    expression = '(-1.263e-7 *t*t*t + 1.327e-4 * t *t -0.0376 * t + 3.838) *1e-5'
  []
  [Bi2Te3_k_func]
    type = ParsedFunction
    expression = '(3.2e-5 * t *t -0.0216 * t + 4.949)'
  []


[]


[Materials]
  [J_mat]
    type = CurrentDensityMaterial
    temp = T
    elec = elec
    block =  'n_leg 102 202 p_leg 104 204 interconnect_cold 101 103 201 203 interconnect_hot'
  []
  [nleg_thermal]
    type = ADHeatConductionMaterial
    temp = T
    thermal_conductivity_temperature_function = Bi2Te3_k_func
    specific_heat_temperature_function = 2
    block = 'n_leg 102 202'
  []
  [pleg_thermal]
    type = ADHeatConductionMaterial
    temp = T
    thermal_conductivity_temperature_function = Bi2Te3_k_func
    specific_heat_temperature_function = 2
    block = 'p_leg 204 104'
  []

  [pleg]
    # Setup a material that will provide varying Seebeck coefficients with changing temperature
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function =Bi2Te3_S_func
    resistivity_temperature_function =Bi2Te3_R_func
    block = 'p_leg 104 204'
    # outputs = exodus
    # output_properties = 'seebeck'
  []
  [nleg]
    # Setup a material that will provide varying Seebeck coefficients with changing temperature
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function = Bi2Te3_S_func_n
    resistivity_temperature_function = Bi2Te3_R_func
    block = 'n_leg 102 202'
    # outputs = exodus
    # output_properties = 'seebeck'
  []
  [interconnect_th]
    # Copper
    type = ADHeatConductionMaterial
    temp = T
    thermal_conductivity = 398 # W/mK
    specific_heat = 0.385 # J/kgK
    block =  'interconnect_cold 101 103 201 203 interconnect_hot'
  []
  [interconnect_TE]
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function = 0
    resistivity_temperature_function = 1.77e-8
    block =  'interconnect_cold 101 103 201 203 interconnect_hot'
  []
  [plates]
    # Setup a material that will provide varying Seebeck coefficients with changing temperature
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function = 0
    resistivity_temperature_function = 1e12
    block = '500 600'
    # outputs = exodus
    # output_properties = 'seebeck'
  []
  [plates_thermal]
    type = ADHeatConductionMaterial
    temp = T
    thermal_conductivity = 22
    specific_heat = 10
    block = '500 600'
  []


[]

[Postprocessors]
  [Vmin]
    type = SideAverageValue
    boundary = minus_BC
    variable = elec
  []
  [Vmax]
    type = SideAverageValue
    boundary = plus_BC
    variable = elec
  []
  [U_load]
    type = ParsedPostprocessor
    pp_names = 'Vmax Vmin'
    expression = 'Vmax - Vmin'
  []

  [heat_in]
    type = ADSideDiffusiveFluxIntegral
    variable = T
    diffusivity = thermal_conductivity
    boundary = 'top_plate_front'
  []
  [I_out]
    type = ADSideDiffusiveFluxIntegral
    variable = elec
    diffusivity = elec_conductivity
    boundary = 'minus_BC'
  []
  [P_load]
    type = ParsedPostprocessor
    pp_names = 'I_out U_load'
    expression = '-U_load*I_out'
  []

[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  # line_search = 'none'
  # Serial for Debugging
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount  '
  petsc_options_value = '       lu         NONZERO               1e-12        '
  # petsc_options_iname = '-pc_type -pc_hypre_type'
  # petsc_options_value = 'hypre     boomeramg'
  # petsc_options_iname = '-pc_type'
  # petsc_options_value = 'lu'
  automatic_scaling = True
  nl_abs_tol = 1e-10

[]

# [Executioner]
#   type = Transient
#   scheme = bdf2
#   # solve_type = NEWTON
#   solve_type = PJFNK
#   # petsc_options_iname = '-pc_type'
#   # petsc_options_value = 'hypre'
#   dt = 1
#   end_time = 10
  # automatic_scaling = true
# []

[Outputs]
  # file_base= 'pattern_sq'
  [out]
    type = Exodus
    output_material_properties = true
  []

  # perf_graph = true
  # file_base = 'GA_results/test'
  # file_base = optimial_post
  csv = true
[]


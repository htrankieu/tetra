
I = 1
leg_size = 1.7
leg_height = 1.4
elem_leg = 17
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

  # [mesh]
  #   type = FileMeshGenerator
  #   file = module_cuboid_pattern_mesh_in.e
  # []
parallel_type=DISTRIBUTED
  [mesh]
    type = FileMeshGenerator
    file = pattern.cpa.gz
  []
[]
[Variables]
  [T]
    initial_condition = 300 #in K
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
  [Peltier_effect]
    type = PeltierHeat
    variable = T
    block =  'n_leg 102 202 p_leg 104 204 interconnect_cold 101 103 201 203 interconnect_hot'
  []
  [HeatSrc]
    type = TEJouleHeat
    variable = T
    current_density = current_density
    elec = elec
    block =  'n_leg 102 202 p_leg 104 204 interconnect_cold 101 103 201 203 interconnect_hot'
  []
[]

[BCs]
  [hot_temp]
    type = CoupledConvectiveHeatFluxBC
    variable = T
    boundary = 'top_plate_front'
    # T_infinity = ${fparse 181.53+273.15}
    T_infinity = 500
    htc = 5e4 # ${fparse 1/(25*20e-6)}
  []
  [cold_temp]
    type = CoupledConvectiveHeatFluxBC
    variable = T
    boundary = 'bottom_plate_back'
    T_infinity = 300
    # T_infinity = ${fparse 50.108 + 273.15}
    htc = 5e4 #${fparse 1/(25*20e-6)}
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

[Functions]
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
  # [plates]
  #   # Setup a material that will provide varying Seebeck coefficients with changing temperature
  #   type = ADThermalElectricMaterial
  #   temp = T
  #   seebeck_temperature_function = 0
  #   resistivity_temperature_function = 1e12
  #   block = '500 600'
  #   # outputs = exodus
  #   # output_properties = 'seebeck'
  # []
  [plates_thermal]
    type = ADHeatConductionMaterial
    temp = T
    thermal_conductivity = 22
    specific_heat = 10
    block = '500 600'
  []


[]

[Postprocessors]
  [Seebeck_avg]
    type = ADElementAverageMaterialProperty
    mat_prop = seebeck
    block = p_leg
  []
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
  line_search = basic
  # Serial for Debugging
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount  '
  petsc_options_value = '       lu         NONZERO               1e-12        '
  # petsc_options_iname = '-pc_type -pc_hypre_type'
  # petsc_options_value = 'hypre     boomeramg '
  # petsc_options_iname = '-pc_type'
  # petsc_options_value = 'lu'
  automatic_scaling = True
  nl_abs_tol = 1e-9
  nl_rel_tol = 1e-14

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
  file_base= 'pattern_sq'
  [out]
    type = Exodus
    output_material_properties = true
  []

  # perf_graph = true
  # file_base = 'GA_results/test'
  # file_base = optimial_post
  csv = true
[]
[Controls/stochastic]
  type = SamplerReceiver
[]

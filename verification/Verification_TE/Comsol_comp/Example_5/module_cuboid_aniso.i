
I = 0.7
c11 = 6.847e10
c66 = 2.335e10
c33 = 4.768e10
c44 = 2.738e10
c13 = 2.704e10
c14 = 1.325e10

# anisotropic temperature expansion coefficients (units: 1/K)
ax = 21.3e-6
ay = 14.4e-6
az = 14.4e-6

[GlobalParams]
  # thermal expansion
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
[cmg]
    type                  = CartesianMeshGenerator
    dim                   = 2
    dx                    = '0.25 1.5 0.5 1.5 0.25'
    dy                    = '0.5 0.2 10 0.2 0.5 '
    ix                    = '3 15 5 15 3'
    iy                    = '5 2 50 2 5'
    subdomain_id          = '5 5 5 5 5
                             1 1 10 1 1
                             10 2 10 4 10
                             10 3 3 3 10
                             5 5 5 5 5'
  []
  [rename_blocks]
    type                  = RenameBlockGenerator
    input                 = 'cmg'
    old_block             = '1 2 3 4 10'
    new_block             = 'interconnect_cold n_leg interconnect_hot p_leg void'
  []
  [delete_void]
    type = BlockDeletionGenerator
    input = rename_blocks
    block = 10
  []
    [pattern]
    type = PatternedMeshGenerator
    inputs = 'delete_void'
    pattern = '0'
    # bottom_boundary = 1
    # right_boundary = 2
    # top_boundary = 3
    # left_boundary = 4
  []

    [extrude]
    type = AdvancedExtruderGenerator
    input = pattern
    heights = '1.5'
    num_layers = '5'
    direction = '0 0 1'
  []
  [n_side]
    type = ParsedGenerateSideset
    input = extrude
    combinatorial_geometry = '(abs(x) <1e-6 & y > 0.5 & y < 0.7 )'
    new_sideset_name = 'n_side'
  []
  [p_side]
    type = ParsedGenerateSideset
    input = n_side
    combinatorial_geometry = '(abs(x -4) < 1e-6 & y > 0.5 & y < 0.7 )'
    new_sideset_name = 'p_side'
  []

  [EntireMesh]
    type = TransformGenerator
    input = p_side
    transform = SCALE
    vector_value = '0.001 0.001 0.001'
  []
  [pin]
    type = ExtraNodesetGenerator
    input = EntireMesh
    new_boundary = pin
    coord = '0 0 0'
  []
    [align_comsol]
    type = TransformGenerator
    input = pin
    transform = ROTATE
    vector_value = '-90 90 0'
  []
  # uniform_refine = 1
[]

[Variables]
  [T]
    initial_condition = 273.15 #in K
  []
  [elec]
    block = '1 2 3 4'
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
    # block = '12 13 14'
  []
  [seebeck_effect]
    type = SeebeckEnergy
    variable = elec
    temp =T
    block = '1 2 3 4'
  []
  [Peltier_effect]
    type = PeltierHeat
    variable = T
    block = '1 2 3 4'
  []
  [HeatSrc]
    type = TEJouleHeat
    variable = T
    current_density = current_density
    elec = elec
    block = '1 2 3 4'
  []
[]

[BCs]
  # [hot_temp]
  #   type = ADConvectiveHeatFluxBC
  #   variable = T
  #   boundary = 'top'
  #   T_infinity = ${fparse 250+273.15}
  #   heat_transfer_coefficient = 1e4 # ${fparse 1/(25*20e-6)}
  # []
  [hot_temp]
    type = ADConvectiveHeatFluxBC
    variable = T
    boundary = 'bottom'
    T_infinity = ${fparse 0 + 273.15}
    heat_transfer_coefficient = 1e7 #${fparse 1/(25*20e-6)}
  []

  [elec_right]
    type = ADDirichletBC
    variable = elec
    boundary = n_side
    value = 0
  []
  [intensity]
    type = ADNeumannBC
    variable = elec
    boundary = p_side
    value = ${fparse I/(0.0002*0.0015)}
  []
  [disp_x] 
    type = ADDirichletBC
    variable = disp_y
    boundary = 'pin'
    value = 0
  []
  [disp_y]
    type = ADDirichletBC
    variable = disp_x
    boundary = 'bottom'
    value = 0
  []
  [disp_z]
    type = ADDirichletBC
    variable = disp_z
    boundary = 'pin'
    value = 0
  []
[]


[Physics/SolidMechanics/QuasiStatic]
  [all]
    strain = SMALL
    add_variables = true
    temperature = T
    eigenstrain_names = eigenstrain
    block = 'interconnect_cold interconnect_hot p_leg n_leg 5'
  []
[]

# [Physics/SolidMechanics/QuasiStatic]
#   [all]
#     add_variables = true
#     automatic_eigenstrain_names = true
#     # generate_output = 'vonmises_stress'
#   []
# []


[Materials]
  [J_mat]
    type = CurrentDensityMaterial
    temp = T
    elec = elec
    block = '1 2 3 4'
  []
  [nleg_thermal]
    type = ADHeatConductionMaterial
    thermal_conductivity = 1.6
    specific_heat = 100
    block = 'n_leg'
  []
  [pleg_thermal]
    type = ADHeatConductionMaterial
    temperature = T
    thermal_conductivity = 1.6
    specific_heat = 100
    block = 'p_leg'
  []
  [pleg]
    # Setup a material that will provide varying Seebeck coefficients with changing temperature
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function = 0.200e-3
    resistivity_temperature_function =${fparse 1/1.1e5}
    block = p_leg
    # outputs = exodus
    # output_properties = 'seebeck'
  []
  [nleg]
    # Setup a material that will provide varying Seebeck coefficients with changing temperature
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function = -0.200e-3
    resistivity_temperature_function =${fparse 1/1.1e5}
    block = n_leg
    # outputs = exodus
    # output_properties = 'seebeck'
  []
  [interconnect_th]
    # Copper
    type = ADHeatConductionMaterial
    temperature = T
    thermal_conductivity = 350 # W/mK
    specific_heat = 0.385 # J/kgK
    block =  'interconnect_cold interconnect_hot'
  []
  [alumina_th]
    type = ADHeatConductionMaterial
    temperature = T
    thermal_conductivity = 29 # W/mK
    specific_heat = 0.385 # J/kgK
    block =  '5'
  []
  [interconnect_TE]
    # Setup a material that will provide varying Seebeck coefficients with chaing temperature
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function = 6.5e-6
    resistivity_temperature_function = ${fparse 1/5.9e8}
    block =  'interconnect_cold interconnect_hot'
  []
  [stress]
    # type = ComputeFiniteStrainElasticStress
    type = ComputeLinearElasticStress
  []
  [elasticity_tensor_alumina]
    # Standard Isotropic Elasticty Tensor
    type = ComputeIsotropicElasticityTensor
   youngs_modulus = 300e9 # MPa
    poissons_ratio = 0.22 
    block = 5 
  []
   [thermal_expansion_alumina]
    type = ComputeThermalExpansionEigenstrain
    stress_free_temperature = 273.15
    thermal_expansion_coeff = 8e-6
    temperature = T
    eigenstrain_name = eigenstrain
    block = 5
  []
  [elasticity_tensor_copper]
    # Standard Isotropic Elasticty Tensor
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 110e9 # MPa
    poissons_ratio = 0.35
    block = 'interconnect_cold interconnect_hot'
  []
  [thermal_expansion_copper]
    type = ComputeThermalExpansionEigenstrain
    stress_free_temperature = 273.15
    thermal_expansion_coeff = 17e-6
    temperature = T
    eigenstrain_name = eigenstrain
    block = 'interconnect_cold interconnect_hot'
  []
  # [elasticity_tensor_leg]
  #   # Standard Isotropic Elasticty Tensor
  #   type = ComputeIsotropicElasticityTensor
  #   youngs_modulus = 30e9 # MPa
  #   poissons_ratio = 0.23
  #   block = 'p_leg n_leg' #
  # []
  [elasticity_tensor_leg]
    # Standard Isotropic Elasticty Tensor
    type = ComputeElasticityTensor
  fill_method = symmetric21
  C_ijkl = '${c11} ${fparse c11-2*c66} ${c13} ${c14} 0 0 ${c11} ${c13} ${fparse -1*c14} 0 0 ${c33} 0 0 0 ${c44} 0 0 ${c44} 0 ${c66}'
    block = 'p_leg n_leg' #
  []

  # Anisotropic Thermal Expansion Courtesy of Daniel Schwen
  [eigenstrain_base]
    type = GenericConstantRankTwoTensor
    tensor_name = s1
    tensor_values = '${ax} ${ay} ${az} 0 0 0'
  []
  [eigenstrain]
    type = CompositeEigenstrain
    weights = 'temperature_material'
    tensors = 's1'
    coupled_variables = 'T'
    eigenstrain_name = eigenstrain
    block = 'n_leg p_leg'
  []
  [temperature_material]
    type = DerivativeParsedMaterial
    property_name = temperature_material
    coupled_variables = 'T'
    expression = 'T-273.15'
  []
[]

[Postprocessors]
  [Vmax]
    type = SideAverageValue
    boundary = p_side
    variable = elec
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []
  [Vmin]
    type = SideAverageValue
    boundary = n_side
    variable = elec
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []
  [U_load]
    type = ParsedPostprocessor
    pp_names = 'Vmax Vmin'
    expression = 'Vmax - Vmin'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [heat_in]
    type = ADSideDiffusiveFluxIntegral
    variable = T
    diffusivity = thermal_conductivity
    boundary = 'top'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []
  [I_out]
    type = ADSideDiffusiveFluxIntegral
    variable = elec
    diffusivity = elec_conductivity
    boundary = 'n_side'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []
  [P_load]
    type = ParsedPostprocessor
    pp_names = 'I_out U_load'
    expression = '-U_load*I_out'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []
  # [Vonmises_stress]
  #   type = ElementExtremeValue
  #   value_type = max
  #   variable = vonmises_stress
  # []
  # [XX_stress]
  #   type = ElementExtremeValue
  #   value_type = max
  #   variable = stress_xx
  # []
  # [XY_stress]
  #   type = ElementExtremeValue
  #   value_type = max
  #   variable = stress_xy
  # []
  # [YY_stress]
  #   type = ElementExtremeValue
  #   value_type = max
  #   variable = stress_yy
  # []
  [disp]
    type = SideAverageValue
    boundary = top
    variable = disp_x
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []
  [T_hot]
    type = SideAverageValue
    boundary = bottom
    variable = T
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []
  [T_cold]
    type = SideAverageValue
    boundary = top
    variable = T
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []
  [delta_T]
    type = ParsedPostprocessor
    pp_names = 'T_cold T_hot'
    expression = 'T_hot - T_cold'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
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
  # petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount  '
  # petsc_options_value = '       lu         NONZERO               1e-12        '
  # petsc_options_iname = '-pc_type -pc_hypre_type'
  # petsc_options_value = 'hypre     boomeramg'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  # automatic_scaling = True
  # off_diagonals_in_auto_scaling = true

  nl_abs_tol = 5e-11
[]

[Outputs]
  [out]
    type = Exodus
    output_material_properties = true
  []
  file_base = anisotropic_module
  csv = true
[]
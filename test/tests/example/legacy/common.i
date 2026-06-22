
I = 0.7

[Mesh]
[cmg]
    type                  = CartesianMeshGenerator
    dim                   = 2
    dx                    = '1'
    dy                    = '0.1 5.8 0.1'
    ix                    = '10'
    iy                    = '3 42 3'
    subdomain_id          = '1
                             2
                             3'
  []
  [rename_blocks]
    type                  = RenameBlockGenerator
    input                 = 'cmg'
    old_block             = '1 2 3'
    new_block             = 'interconnect_cold p_leg interconnect_hot'
  []


    [extrude]
    type = AdvancedExtruderGenerator
    input = rename_blocks
    heights = '1'
    num_layers = '10'
    direction = '0 0 1'
  []

  [EntireMesh]
    type = TransformGenerator
    input = extrude
    transform = SCALE
    vector_value = '0.001 0.001 0.001'
  []
    [align_comsol]
    type = TransformGenerator
    input = EntireMesh
    transform = ROTATE
    vector_value = '-90 90 0'
  []
[]



[Variables]
  [T]
    initial_condition = 273.15 #in K
  []
  [elec]
  []
[]

[Kernels]
  [HeatDiff]
    type = ADHeatConduction
    variable = T
  []
  [electric]
    type = ElectricConduction
    variable = elec
  []
  [seebeck_effect]
    type = SeebeckEnergy
    variable = elec
    temp =T
  []
  [Peltier_effect]
    type = PeltierHeat
    variable = T
  []
  [HeatSrc]
    type = TEJouleHeat
    variable = T
    current_density = current_density
    elec = elec
  []
[]

[BCs]
  [cold_temp]
    type = ADConvectiveHeatFluxBC
    variable = T
    boundary = 'bottom'
    T_infinity = ${fparse 0 + 273.15}
    heat_transfer_coefficient = 1e7
  []
  [elec_right]
    type = ADDirichletBC
    variable = elec
    boundary = bottom
    value = 0
  []
  [intensity]
    type = ADNeumannBC
    variable = elec
    boundary = top
    value = ${fparse -I/(0.001*0.001)}
  []
[]




[Materials]
  [J_mat]
    type = CurrentDensityMaterial
    temp = T
    elec = elec
  []
  [pleg_thermal]
    type = ADHeatConductionMaterial
    temp = T
    thermal_conductivity_temperature_function = leg_k
    specific_heat = 100
    block = 'p_leg'
  []
 [pleg]
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function = pleg_seebeck
    resistivity_temperature_function =leg_resistivity
    block = p_leg
  []
  [interconnect_th]
    # Copper
    type = ADHeatConductionMaterial
    temp = T
    thermal_conductivity = 350 # W/mK
    specific_heat = 0.385 # J/kgK
    block =  'interconnect_cold interconnect_hot'
  []
  [interconnect_TE]
    type = ADThermalElectricMaterial
    temp = T
    seebeck_temperature_function = 6.5e-6
    resistivity_temperature_function = ${fparse 1/5.9e8}
    block =  'interconnect_cold interconnect_hot'
  []
[]

[Postprocessors]
  [Vmax]
    type = SideAverageValue
    boundary = bottom
    variable = elec
  []
  [Vmin]
    type = SideAverageValue
    boundary = top
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
    boundary = 'top'
  []

  [I_out]
    type = ADSideIntegralMaterialProperty
    property = current_density
    component = 0
    boundary = 'bottom'
  []
  [P_load]
    type = ParsedPostprocessor
    pp_names = 'I_out U_load'
    function = '-U_load*I_out'
  []

  [T_hot]
    type = SideAverageValue
    boundary = bottom
    variable = T
  []
  [T_cold]
    type = SideAverageValue
    boundary = top
    variable = T
  []
  [delta_T]
    type = ParsedPostprocessor
    pp_names = 'T_cold T_hot'
    expression = 'T_hot - T_cold'
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
  line_search = 'basic'
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
  [csv]
    type = CSV
    create_final_symlink = true
    execute_on = 'FINAL'
  []

[]

[VectorPostprocessors]
  [line]
    type = LineValueSampler
    sort_by = 'x'
    start_point = '0.0001 -0.0005 -0.0005'
    end_point = '0.0059 -0.0005 -0.0005'
    num_points = 120
    variable = 'T elec'
    execute_on = FINAL
  []
[]


I = 0.5
leg_size = 1.7
leg_height = 1.4
elem_leg = 7
elem_height = 10
leg_spacing = 0.4
elem_spacing = 2
connect_height = 0.2
elem_connect =2
n_TE_x = 7
n_TE_y = 16
# leg_size = 1.5
# leg_height = 0.75
# elem_leg = 15
# elem_height = 7
# leg_spacing = 0.5
# elem_spacing = 5
# connect_height = 0.2
# elem_connect =2
# n_TE_x = 7
# n_TE_y = 16
TEM_length = ${fparse 2 * leg_size + 4 *leg_spacing}
x_max_line = ${fparse n_TE_x * TEM_length}
y_last_row = ${fparse -(n_TE_y-1) *(leg_size + 2* leg_spacing)}

plate_thickness = 0.8

cp = 1007
k = 0.02551
rho = 1.184
mu=1.8949e-5

[Mesh]

  [substrat_top]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = ${fparse - leg_size}
    xmax = ${fparse x_max_line + leg_size}
    nx = ${fparse n_TE_x * (2 * elem_leg + 4 *elem_spacing) + 2 * elem_leg}
    ymin = ${fparse -1 *(n_TE_y * leg_size + (n_TE_y-1) * 2 * leg_spacing)}
    ymax = 0
    ny = ${fparse n_TE_y * elem_leg + (n_TE_y-1) * 2 * elem_spacing}
    # zmin = ${fparse 2 * connect_height + leg_height+ plate_thickness}
    # zmax = ${fparse 2 * connect_height + leg_height+ 3*plate_thickness}
    # nz = 5
    # subdomain_name = top_plate
    # boundary_id_offset = 500
    # boundary_name_prefix = 'top_plate'

  []


  [EntireMesh]
    type = TransformGenerator
    input = substrat_top
    transform = SCALE
    vector_value = '0.001 0.001 0.001'
  []

[]

[Physics]
  [NavierStokes]
    [Flow]
      [flow]
        compressibility = 'incompressible'

        density = 'rho'
        dynamic_viscosity = 'mu'

        initial_pressure = 0.0

        inlet_boundaries = 'bottom'
        momentum_inlet_types = 'fixed-velocity'
        momentum_inlet_functors = '0 0.5 0'
        momentum_outlet_types = 'fixed-pressure'
        outlet_boundaries = 'top'
        pressure_functors = '0'
        wall_boundaries = 'left right'
        momentum_wall_types = 'noslip noslip'



        mass_advection_interpolation = 'average'
        momentum_advection_interpolation = 'average'
      []
    []
    [FluidHeatTransfer]
      [heat]
        add_energy_equation = true
        thermal_conductivity = 'k'
        specific_heat = 'cp'
        coupled_flow_physics = flow
        initial_temperature = 400

        energy_inlet_types = 'fixed-temperature'
        energy_inlet_functors = '400'
        energy_wall_types = 'heatflux heatflux  '
        energy_wall_functors = '0 0'

        external_heat_source = q_flux
        energy_advection_interpolation = 'average'
      []
    []
  []
[]

[AuxVariables]
  [U]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [htc]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 5e4
  []
  [T_wall]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 500
  []

[]

[AuxKernels]
  [mag]
    type = VectorMagnitudeAux
    variable = U
    x = vel_x
    y = vel_y
    # z = vel_z
  []
[]

[FunctorMaterials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'cp k rho mu'
    prop_values = '${cp} ${k} ${rho} ${mu}'
  []
  [heat_source_mat]
    type = ADParsedFunctorMaterial
    expression = 'htc*(T_wall - T_fluid)'
    functor_names = 'T_fluid T_wall htc'
    functor_symbols = 'T_fluid T_wall htc'
    property_name = q_flux
  []
[]



[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-11
  nl_abs_tol = 1e-11
[]

[Outputs]
  exodus = true
[]



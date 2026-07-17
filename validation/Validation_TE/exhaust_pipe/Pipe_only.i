
pipe_thickness = 2e-3
pipe_elem = 3

TE_size = 39.2e-3
TE_spacing = 2e-3
# elem_TE = 40
# elem_spacing = 2
nx_TE = 4
ny_TE = 5
pipe_inner = ${fparse nx_TE * TE_size + (nx_TE-1) * TE_spacing}
pipe_length = ${fparse ny_TE * TE_size + (ny_TE-1) * TE_spacing + 2 * pipe_thickness}
x_start = ${fparse pipe_thickness + 0.5 * pipe_inner}
# p_out = 1.01e5
# T_in = 600
# vel_in = 20


# A = ${fparse 0.5* pipe_inner^2}
# P_wet = ${fparse 2 * pipe_inner}
# P_hf = ${fparse P_wet}
# Dh = ${fparse 4 * A/P_wet}


[Mesh]
  [mesh]
    type = FileMeshGenerator
    file = pipe_mesh_in.e
  []
[]

[Variables]
  [T_solid]
    initial_condition = 500
  []
[]

[Materials]
  [mat]
    type = GenericConstantMaterial
    block = 1
    prop_names = 'density specific_heat thermal_conductivity'
    prop_values = '8050 466 45'
  []
[]

[AuxVariables]
  [htc]
    initial_condition = 100
  []
  [T_fluid]
    initial_condition = 600
  []
  [T_TE]
    initial_condition = 500
  []
[]

[Kernels]
  [diff]
    type = HeatConduction
    variable = T_solid
  []
  # [dt_heat]
  #   type = HeatConductionTimeDerivative
  #   variable = T_solid
  # []
[]

[BCs]
  [inner]
    type = CoupledConvectiveHeatFluxBC
    T_infinity = T_fluid
    boundary = inner_pipe
    htc = htc
    variable = T_solid
  []
  [outer]
    type = CoupledConvectiveHeatFluxBC
    T_infinity = 300
    boundary = 'left right bottom_wall'
    htc = 10
    variable = T_solid
  []
  [TE]
    type = CoupledConvectiveHeatFluxBC
    T_infinity = T_TE
    boundary = 'TE_wall '
    htc = 2e4
    variable = T_solid
  []
[]
[UserObjects]
  [T_wall_uo]
    type = NearestPointLayeredSideAverage
    boundary = inner_pipe
    direction = y
    variable =T_solid
    points = '${x_start} 0 ${x_start}'
    num_layers = 100
  []

[]

[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady
  # start_time = 0

  # [TimeStepper]
  #   type = IterationAdaptiveDT
  #   dt = 1
  # []
  # # dtmax = 5
  # end_time = 5

  line_search = basic
  solve_type = NEWTON

  # petsc_options_iname = '-pc_type'
  # petsc_options_value = 'lu'
  # petsc_options_iname = '-pc_type -pc_hypre_type'
  # petsc_options_value = 'hypre     boomeramg'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  nl_max_its = 25

   fixed_point_max_its = 300
   fixed_point_abs_tol = 1e-5
   fixed_point_rel_tol = 1e-5
   accept_on_max_fixed_point_iteration = true



[]

[Outputs]
  exodus = true

  print_linear_residuals = false
[]

[MultiApps]
  [flow]
    type = FullSolveMultiApp
    input_files = gas_THM.i
    positions = '0 0 0'
    sub_cycling = true
    max_failures = 100
    max_procs_per_app = 2
    no_restore = true
    keep_solution_during_restore = true
  []
  [TE]
    type = FullSolveMultiApp
    input_files = module_cuboid_pattern_sq.i
    positions_file = TE_positions.txt
    output_in_position = true
    no_restore = true
    keep_solution_during_restore = true
    # min_procs_per_app=110

  []
[]

[Transfers]
  [T_inner_wall]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = flow
    source_user_object = T_wall_uo
    variable = T_wall
    search_value_conflicts = false
  []
  [T_fluid]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = flow
    source_variable = T
    variable = T_fluid
    search_value_conflicts = false
  []
  [htc]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = flow
    source_variable = htc
    variable = htc
    search_value_conflicts = false
  []
  [T_fluid_tr]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = TE
    source_variable = T_solid
    variable = T_fluid
    search_value_conflicts = false
  []
  [T_TE_wall]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = TE
    source_variable = T
    variable = T_TE
    search_value_conflicts = false
  []
[]


!include common.i

[Problem]
  restart_file_base = 'pleg_cuboid_out_cp/LATEST'
[]

[Functions]
  # [leg_k]
  #   type = ConstantFunction
  #   value = 1.6
  # []
  # [leg_resistivity]
  #   type = ConstantFunction
  #   value = ${fparse 1/1.1e5}
  # []
  # [pleg_seebeck]
  #   type = ConstantFunction
  #   value = 0.200e-3
  # []
  [intensity_fn]
    type = PiecewiseLinear
    x = '0 1 1.1 4 4.1 20'
    y = '0.6 0.6 0.8 0.8 0.6 0.6'
  []
  [current_density_fn]
    type = ParsedFunction
    symbol_names = 'I'
    symbol_values = 'intensity_fn'
    expression = '-I/(0.001*0.001)'
  []
[]

[Kernels]
  [dtdt]
    type = ADHeatConductionTimeDerivative
    variable = T
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  line_search = 'basic'
  [TimeStepper]
    type = ConstantDT
    dt =0.1
  []
  end_time = 20
  start_time = 0
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

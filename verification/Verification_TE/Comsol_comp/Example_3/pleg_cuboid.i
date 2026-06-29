
!include common.i
I = 0.01

[ICs]
  [temp_ic]
    type = ConstantIC
    value = 300.15
    variable = T
  []
[]

[Functions]
  [pleg_seebeck]
    type = PiecewiseLinear
    data_file = 'seebeck_pleg.csv'
    x_index_in_file = 0
    y_index_in_file = 1
    xy_in_file_only = true
    format = columns
    # scale_factor = 1e-6
  []
  [nleg_seebeck]
    type = ParsedFunction
    symbol_names = 'seebeck'
    symbol_values = 'pleg_seebeck'
    expression = '-1*seebeck'
  []
  [leg_k]
    type = PiecewiseLinear
    data_file = 'k_pleg.csv'
    x_index_in_file = 0
    y_index_in_file = 1
    xy_in_file_only = true
    format = columns
  []
  [leg_sigma]
    type = PiecewiseLinear
    data_file = 'sigma_pleg.csv'
    x_index_in_file = 0
    y_index_in_file = 1
    xy_in_file_only = true
    format = columns
    # scale_factor = 1000
  []
  [leg_resistivity]
    type = ParsedFunction
    symbol_names = 'sigma'
    symbol_values = 'leg_sigma'
    expression = '1/sigma'
  []

  [current_density_fn]
    type = ConstantFunction
    value = ${fparse -I/(0.001*0.001)}
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
  nl_rel_tol = 5e-11
  nl_forced_its = 5
[]

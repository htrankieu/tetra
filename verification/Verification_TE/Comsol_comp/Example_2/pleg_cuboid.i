
!include common.i
I = 0.6

[ICs]
  [temp_ic]
    type = ConstantIC
    value = 273.15
    variable = T
  []
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
  [current_density_fn]
    type = ConstantFunction
    value = ${fparse -I/(0.001*0.001)}
  []
[]


[Outputs]
  checkpoint = true
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

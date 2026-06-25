!include common.i

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
  # [pleg_seebeck]
  #   type = PiecewiseLinear
  #   data_file = 'mat_prop.csv'
  #   x_index_in_file = 0
  #   y_index_in_file = 1
  #   xy_in_file_only = false
  #   format = columns
  #   scale_factor = 1e-6
  # []
  # [nleg_seebeck]
  #   type = ParsedFunction
  #   symbol_names = 'seebeck'
  #   symbol_values = 'pleg_seebeck'
  #   expression = '-1*seebeck'
  # []
  # [leg_k]
  #   type = PiecewiseLinear
  #   data_file = 'mat_prop.csv'
  #   x_index_in_file = 0
  #   y_index_in_file = 2
  #   xy_in_file_only = false
  #   format = columns
  # []
  # [leg_sigma]
  #   type = PiecewiseLinear
  #   data_file = 'mat_prop.csv'
  #   x_index_in_file = 0
  #   y_index_in_file = 3
  #   xy_in_file_only = false
  #   format = columns
  #   scale_factor = 1000
  # []
  [leg_resistivity]
    type = ParsedFunction
    symbol_names = 'sigma'
    symbol_values = 'leg_sigma'
    expression = '1/sigma'
  []
[]

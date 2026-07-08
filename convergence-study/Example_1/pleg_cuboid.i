
!include common.i


[Functions]
  [leg_k]
    type = ConstantFunction
    value = 1.6
  []
  [leg_resistivity]
    type = ConstantFunction
    value = ${fparse 1/1.1e5}
  []
  [pleg_seebeck]
    type = ConstantFunction
    value = 0.200e-3
  []
  [heatfluxexact]
    type = ParsedFunction
    expression = sin(2*x*pi)*sin(2*y*pi)*cos(2*z*pi)+300
  []
  [heatfluxforced]
    type = ParsedFunction
    expression = 2*pi*J_x*b*sin(2*y*pi)*cos(2*x*pi)*cos(2*z*pi)+2*pi*J_y*b*sin(2*x*pi)*cos(2*y*pi)*cos(2*z*pi)-2*pi*J_z*b*sin(2*x*pi)*sin(2*y*pi)*sin(2*z*pi)+12*pi^2*k*sin(2*x*pi)*sin(2*y*pi)*cos(2*z*pi)
    symbol_names = 'J_x J_y J_z b k'
    symbol_values = '-7e5 0 0 0.200e-3 1.6'
  []
  [currentdensityexact]
    type = ParsedFunction
    expression = sin(2*y*pi)*sin(2*z*pi)*cos(2*x*pi)
  []
  [currentdensityforced]
    type = ParsedFunction
    expression = -12*pi^2*s*sin(2*y*pi)*sin(2*z*pi)*cos(2*x*pi)
    symbol_names = 's'
    symbol_values = '1.1e5'
  []
[]

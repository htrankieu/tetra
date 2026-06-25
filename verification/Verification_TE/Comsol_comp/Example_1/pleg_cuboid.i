
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
[]

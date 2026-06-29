
!include common.i


[Functions]
  [leg_k]
    type = ConstantFunction
    value = 1.6 # thermal conductivity
  []
  [leg_resistivity]
    type = ConstantFunction
    value = ${fparse 1/1.1e5} # inverse of electrical conductivity
  []
  [pleg_seebeck]
    type = ConstantFunction
    value = 0.200e-3 # seebeck coefficient
  []
[]

# material properties are referenced from Table 1
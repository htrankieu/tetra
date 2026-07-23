
pipe_thickness = 2e-3
pipe_elem = 3
pipe_outs = 50e-3
outs_elem=10

TE_size_x = 36.8e-3
TE_size_y = 37.6e-3
TE_spacing = 2e-3
elem_TE = 40
elem_spacing = 2
nx_TE = 4
ny_TE = 5
pipe_inner = ${fparse nx_TE * TE_size_x + (nx_TE-1) * TE_spacing}
pipe_length = ${fparse ny_TE * TE_size_y + (ny_TE-1) * TE_spacing + 2 * pipe_outs}
x_start = ${fparse pipe_thickness + 0.5 * pipe_inner}
p_out = 1.01e5
T_in = 600
vel_in = 100


A = ${fparse  pipe_inner * 15* pipe_thickness}
P_wet = ${fparse 2*15*pipe_thickness+  pipe_inner}
P_hf = ${fparse P_wet}
Dh = ${fparse 4 * A/P_wet}


[GlobalParams]
  initial_p = ${p_out}
  initial_vel = ${vel_in}
  initial_T = ${T_in}
  gravity_vector = '0 0 0'

  rdg_slope_reconstruction = full
  scaling_factor_1phase = '1 1e-2 1e-5'
  closures = thm_closures
  fp = air
[]


[FluidProperties]
  [air]
    type = IdealGasFluidProperties
    gamma = 1.4
    k = 0.02551
    mu = 1.8949e-5
  []

[]

[Closures]
  [thm_closures]
    type = Closures1PhaseTHM
  []
[]
[AuxVariables]
  [htc]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [htc_aux]
    type = ADMaterialRealAux
    property = Hw
    variable = htc
[]
[]


[Components]
  [inlet]
    type = InletVelocityTemperature1Phase
    input =pipe:in
    vel = ${vel_in}
    T = ${T_in}
  []
  [pipe]
    type = FlowChannel1Phase
    position = '${x_start} 0 ${x_start}'
    orientation = '0 1 0 '
    length = ${pipe_length}
    n_elems = 100
    # length ='${pipe_thickness} ${TE_size} ${TE_spacing} ${TE_size} ${TE_spacing} ${TE_size} ${TE_spacing} ${TE_size} ${TE_spacing} ${TE_size} ${pipe_thickness}'
    # n_elems ='${pipe_elem} ${elem_TE} ${elem_spacing} ${elem_TE} ${elem_spacing}  ${elem_TE} ${elem_spacing}  ${elem_TE} ${elem_spacing} ${elem_TE} ${pipe_elem}'
    A = ${A}
    D_h = ${Dh}
    # axial_region_names = '1 2 3 4 5 6 7 8 9 10 11'
  []
  [outlet]
    type = Outlet1Phase
    input = pipe:out
    p = ${p_out}
  []
  [ht]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = pipe
    initial_T_wall = 500
    P_hf = ${P_hf}
  []
[]
[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  start_time = 0

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 10
  []

  end_time = 5e6

  line_search = basic
  solve_type = NEWTON

  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  nl_max_its = 25

[]

[Outputs]
  exodus = true

  [console]
    type = Console
    max_rows = 1
    outlier_variable_norms = false
  []
  print_linear_residuals = false
[]

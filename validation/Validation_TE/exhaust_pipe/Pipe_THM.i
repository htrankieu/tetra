
pipe_thickness = 2e-3
pipe_elem = 3

TE_size = 39.2e-3
TE_spacing = 2e-3
elem_TE = 20
elem_spacing = 2
nx_TE = 4
ny_TE = 5
pipe_inner = ${fparse nx_TE * TE_size + (nx_TE-1) * TE_spacing}
pipe_length = ${fparse ny_TE * TE_size + (ny_TE-1) * TE_spacing + 2 * pipe_thickness}
x_start = ${fparse pipe_thickness + 0.5 * pipe_inner}
p_out = 1.01e5
T_in = 600
vel_in = 20


A = ${fparse 0.5* pipe_inner^2}
P_wet = ${fparse 2 * pipe_inner}
P_hf = ${fparse P_wet}
Dh = ${fparse 4 * A/P_wet}


[GlobalParams]
  initial_p = ${p_out}
  initial_vel =
  initial_T = ${T_in}
  initial_vel_x = 0
  initial_vel_y = 0
  initial_vel_z = 0
  gravity_vector = '0 0 0'

  rdg_slope_reconstruction = minmod
  scaling_factor_1phase = '1 1e-3 1e-6'
  closures = thm_closures
  fp = air
[]


[FluidProperties]
  [air]
    type = IdealGasFluidProperties
    gamma = 1.4
    k = 0.02551
     mu=1.8949e-5
  []

[]

[Closures]
  [thm_closures]
    type = Closures1PhaseTHM
  []
[]

[SolidProperties]
  [steel]
    type = ThermalFunctionSolidProperties
    rho = 8050
    k = 45
    cp = 466
  []
[]

[Materials]
  [mat]
    type = ADGenericConstantMaterial
    block = 'pipe_hs:1 '
    prop_names = 'density specific_heat thermal_conductivity'
    prop_values = '8050 466 45'
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
    position = '${x_start}  0 ${x_start}'
    orientation = '0 1 0'
    length ='${pipe_thickness} ${TE_size} ${TE_spacing} ${TE_size} ${TE_spacing} ${TE_size} ${TE_spacing} ${TE_size} ${TE_spacing} ${TE_size} ${pipe_thickness}'
    n_elems ='${pipe_elem} ${elem_TE} ${elem_spacing} ${elem_TE} ${elem_spacing}  ${elem_TE} ${elem_spacing}  ${elem_TE} ${elem_spacing} ${elem_TE} ${pipe_elem}'
    A = ${A}
    D_h = ${Dh}
    axial_region_names = '1 2 3 4 5 6 7 8 9 10 11'


  []
  [outlet]
    type = Outlet1Phase
    input = pipe:out
    p = ${p_out}
  []
  [pipe_hs]
    type = HeatStructureFromFile3D
    file = 'pipe_mesh_in.e'
    position = '0 0 0'
    initial_T = ${T_in}
  []
    [ht]
    type = HeatTransferFromHeatStructure3D1Phase
    flow_channels = 'pipe'
    hs = pipe_hs
    boundary = pipe_hs:inner_pipe
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
    dt = 1
  []
  dtmax = 5
  end_time = 500

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

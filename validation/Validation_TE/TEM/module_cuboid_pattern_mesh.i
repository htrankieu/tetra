leg_size = 1.6
leg_height = 1.4
elem_leg = 8
elem_height = 7
leg_spacing = 0.4
elem_spacing = 2
connect_height = 0.2
elem_connect =2
n_TE_x = 7
n_TE_y = 16

TEM_length = ${fparse 2 * leg_size + 4 *leg_spacing}
x_max_line = ${fparse n_TE_x * TEM_length}
y_last_row = ${fparse -(n_TE_y-1) *(leg_size + 2* leg_spacing)}

plate_thickness = 0.8


[Mesh]
[cmg]
    type                  = CartesianMeshGenerator
    dim                   = 2
    dx                    = '${leg_spacing} ${leg_size} ${fparse 2*leg_spacing} ${leg_size} ${leg_spacing}'
    dy                    = '${connect_height} ${leg_height} ${connect_height}'
    ix                    = '${elem_spacing}  ${elem_leg} ${fparse 2 * elem_spacing} ${elem_leg} ${elem_spacing}'
    iy                    = '${elem_connect} ${elem_height} ${elem_connect}'
    subdomain_id          = '1 1 10 1 1
                             10 2 10 4 10
                             10 3 3 3 10'
  []
  [rename_blocks]
    type                  = RenameBlockGenerator
    input                 = 'cmg'
    old_block             = '1 2 3 4 10'
    new_block             = 'interconnect_cold n_leg interconnect_hot p_leg void'
  []
  [delete_void]
    type = BlockDeletionGenerator
    input = rename_blocks
    block = 10
  []
    [pattern]
    type = PatternedMeshGenerator
    inputs = 'delete_void'
    pattern = '0 0 0 0 0 0 0'
  []

    [extrude]
    type = AdvancedExtruderGenerator
    input = pattern
    heights = '${leg_size}'
    num_layers = '${elem_leg}'
    direction = '0 0 1'
  []
   [right_connect]
    type = GeneratedMeshGenerator
    dim = 3
    nx = ${fparse 2 *elem_spacing}
    xmin = ${x_max_line}
    xmax = ${fparse x_max_line + 2 * leg_spacing}
    ymin = 0
    ymax =${connect_height}
    ny = ${elem_connect}
    zmin = ${fparse -leg_spacing}
    zmax = ${leg_size}
    nz = ${fparse elem_spacing + elem_leg}
    boundary_name_prefix = connect_right

  []
  [stitch_right]
    # type = StitchMeshGenerator
    type = CombinerGenerator
    inputs = 'extrude right_connect'
    avoid_merging_boundaries = true
    # clear_stitched_boundary_ids = true
    # stitch_boundaries_pairs = 'right connect_right_left'
  []


   [left_connect]
    type = GeneratedMeshGenerator
    dim = 3
    nx = ${fparse 2 *elem_spacing}
    xmin = ${fparse -2* leg_spacing}
    xmax = 0
    ymin = 0
    ymax =${connect_height}
    ny = ${elem_connect}
    zmin = 0
    zmax = ${fparse leg_spacing + leg_size}
    nz = ${fparse elem_spacing + elem_leg}
    boundary_name_prefix = connect_left
  []

  [stitch_left]
    # type = StitchMeshGenerator
    type = CombinerGenerator
    inputs = 'stitch_right left_connect'
    avoid_merging_boundaries = true
    # stitch_boundaries_pairs = 'left connect_left_right'
  []

  [mirror]
    type = SymmetryTransformGenerator
    input = stitch_left
    mirror_point = '0 0 ${fparse leg_spacing + leg_size}'
    mirror_normal_vector = "0 0 1"
  []
  [turn]
    type = TransformGenerator
    transform = rotate
    vector_value = '180 180 0'
    input = stitch_left
  []
  [realign]
    type = TransformGenerator
    transform = translate
    vector_value = '${x_max_line} 0 ${leg_size}'
    input = turn
  []
  [Combine]
    type = StitchMeshGenerator
    # type = CombinerGenerator
    inputs = 'mirror realign'
    # avoid_merging_boundaries = true
    stitch_boundaries_pairs = 'connect_left_front connect_right_back'
  []

  [rotate]
    type = TransformGenerator
    transform = rotate
    vector_value = '0 90 0'
    input = Combine
  []

  [pattern_2]
    type = PatternedMeshGenerator
    inputs = 'rotate'
    pattern = '0;
               0;
               0;
               0;
               0;
               0;
               0;
               0'
    top_boundary =connect_left_front
    right_boundary =  connect_right_right
    bottom_boundary = connect_right_back
    left_boundary = connect_left_left
  []
  [BC_plus]
    type =  ParsedGenerateSideset
    input = pattern_2
    combinatorial_geometry = '(abs(x-${x_max_line}) < 1e-6 & z<0.2 & y>${fparse y_last_row - leg_size} & y< ${y_last_row} ) '
    new_sideset_name = plus_BC
    # included_boundaries = 10000
  []
  [BC_minus]
    type =  ParsedGenerateSideset
    input = BC_plus
    combinatorial_geometry = '(abs(x- ${x_max_line}) <1.e-6 & z<${connect_height} & y<0 & y>${fparse -leg_size} ) '
    new_sideset_name = minus_BC
    # included_boundaries = 10000
  []
   [remove_placeholder]
    type = BlockDeletionGenerator
    input = BC_minus
    block = 0
  []
 [generate_side_connect]
    type =  ParsedGenerateSideset
    input = remove_placeholder
    combinatorial_geometry = '(abs(x)<1e-6 ) '
    new_sideset_name = 'mod_side_connect'
    included_subdomains = 1
    # included_boundaries = 10000
  []
  [cmg_side]
    type                  = CartesianMeshGenerator
    dim                   = 2
    dx                    = '${leg_spacing} ${leg_size} ${fparse 2*leg_spacing} ${leg_size} ${leg_spacing}'
    dy                    = '${connect_height} ${leg_height} ${connect_height}'
    ix                    = '${elem_spacing}  ${elem_leg} ${fparse 2 * elem_spacing} ${elem_leg} ${elem_spacing}'
    iy                    = '${elem_connect} ${elem_height} ${elem_connect}'
    subdomain_id          = '120 101 110 101 120
                             110 102 110 104 110
                             110 103 103 103 110'
  []
  [rename_blocks_side]
    type                  = RenameBlockGenerator
    input                 = 'cmg_side'
    old_block             = '101 102 103 104 110'
    new_block             = 'interconnect_cold_side n_leg_side interconnect_hot_side p_leg_side void_side'
  []

    [pattern_side]
    type = PatternedMeshGenerator
    inputs = 'rename_blocks_side'
    pattern = '0 0 0 0 0 0 0 0'
  []
 [delete_void_side]
    type = BlockDeletionGenerator
    input = pattern_side
    block = '110 120'
  []
  [extrude_side]
    type = AdvancedExtruderGenerator
    input = delete_void_side
    heights = '${leg_size}'
    num_layers = '${elem_leg}'
    direction = '0 0 1'
  []
  [position_side]
    type = TransformGenerator
    input = extrude_side
    transform = ROTATE
    vector_value = '-180 -90 90'
    # vector_value = '-180 90 90'
  []
  [position_side_2]
    type = TransformGenerator
    input = position_side
    transform = TRANSLATE
    vector_value = '0 ${leg_spacing} 0'
  []
   [generate_side_connect_2]
    type =  ParsedGenerateSideset
    input = position_side_2
    combinatorial_geometry = '(abs(x)<1e-6 ) '
    new_sideset_name = 'mod_side_connect_side'
    included_subdomains = 101
    # included_boundaries = 10000
  []
  [combine_with_side]
    # type = CombinerGenerator
    type = StitchMeshGenerator
    inputs = 'generate_side_connect generate_side_connect_2'
    stitch_boundaries_pairs = 'mod_side_connect mod_side_connect_side'
  []
  [generate_side_connect_3]
    type =  ParsedGenerateSideset
    input = combine_with_side
    combinatorial_geometry = '(abs(x-${x_max_line})<1e-6 ) '
    new_sideset_name = 'mod_side_connect'
    included_subdomains = 1
    # included_boundaries = 10000
  []
  [cmg_side_2]
    type                  = CartesianMeshGenerator
    dim                   = 2
    dx                    = '${leg_spacing} ${leg_size} ${fparse 2*leg_spacing} ${leg_size} ${leg_spacing}'
    dy                    = '${connect_height} ${leg_height} ${connect_height}'
    ix                    = '${elem_spacing}  ${elem_leg} ${fparse 2 * elem_spacing} ${elem_leg} ${elem_spacing}'
    iy                    = '${elem_connect} ${elem_height} ${elem_connect}'
    subdomain_id          = '220 201 210 201 220
                             210 202 210 204 210
                             210 203 203 203 210'
  []
  [rename_blocks_side_2]
    type                  = RenameBlockGenerator
    input                 = 'cmg_side_2'
    old_block             = '201 202 203 204 210'
    new_block             = 'interconnect_cold_side_2 n_leg_side_2 interconnect_hot_side_2 p_leg_side_2 void_side_2'
  []

    [pattern_side_2]
    type = PatternedMeshGenerator
    inputs = 'rename_blocks_side_2'
    pattern = '0 0 0 0 0 0 0 '
  []
 [delete_void_side_2]
    type = BlockDeletionGenerator
    input = pattern_side_2
    block = '210 220'
  []
    [extrude_side_2]
    type = AdvancedExtruderGenerator
    input = delete_void_side_2
    heights = '${leg_size}'
    num_layers = '${elem_leg}'
    direction = '0 0 1'
  []
  [position_side_200]
    type = TransformGenerator
    input = extrude_side_2
    transform = ROTATE
    vector_value = '-180 -90 90'
    # vector_value = '-180 90 90'
  []
  [position_side_202]
    type = TransformGenerator
    input = position_side_200
    transform = TRANSLATE
    vector_value = '${fparse x_max_line + leg_size} ${fparse -leg_size - leg_spacing} 0'
  []
   [generate_side_connect_22]
    type =  ParsedGenerateSideset
    input = position_side_202
    combinatorial_geometry = '(abs(x-${x_max_line})<1e-6 ) '
    new_sideset_name = 'mod_side_connect_side_2'
    included_subdomains = 201
    # included_boundaries = 10000
  []
  [combine_with_side_2]
    # type = CombinerGenerator
    type = StitchMeshGenerator
    inputs = 'generate_side_connect_3 generate_side_connect_22'
    stitch_boundaries_pairs = 'mod_side_connect mod_side_connect_side_2'
  []

  [substrat_top]
    type = GeneratedMeshGenerator
    dim = 3
    xmin = ${fparse - leg_size}
    xmax = ${fparse x_max_line + leg_size}
    nx = ${fparse n_TE_x * (2 * elem_leg + 4 *elem_spacing) + 2 * elem_leg}
    ymin = ${fparse -1 *(n_TE_y * leg_size + (n_TE_y-1) * 2 * leg_spacing)}
    ymax = 0
    ny = ${fparse n_TE_y * elem_leg + (n_TE_y-1) * 2 * elem_spacing}
    zmin = ${fparse 2 * connect_height + leg_height}
    zmax = ${fparse 2 * connect_height + leg_height+ plate_thickness}
    nz = 3
    subdomain_name = top_plate
    boundary_id_offset = 500
    boundary_name_prefix = 'top_plate'

  []
   [rename_top_plate]
      type =  RenameBlockGenerator
      input = substrat_top
      old_block = 0
      new_block = 500
   []
    [combine_with_top_plate]
    # type = CombinerGenerator
    type = StitchMeshGenerator
    inputs = 'combine_with_side_2 rename_top_plate'
    stitch_boundaries_pairs = 'top top_plate_back'
  []
  [substrat_bottom]
    type = GeneratedMeshGenerator
    dim = 3
    xmin = ${fparse - leg_size}
    xmax = ${fparse x_max_line + leg_size}
    nx = ${fparse n_TE_x * (2 * elem_leg + 4 *elem_spacing) + 2 * elem_leg}
    ymin = ${fparse -1 *(n_TE_y * leg_size + (n_TE_y-1) * 2 * leg_spacing)}
    ymax = 0
    ny = ${fparse n_TE_y * elem_leg + (n_TE_y-1) * 2 * elem_spacing}
    zmin = ${fparse -plate_thickness}
    zmax = 0
    nz = 3
    subdomain_name = bottom_plate
    boundary_id_offset = 600
    boundary_name_prefix = 'bottom_plate'

  []
   [rename_bottom_plate]
      type =  RenameBlockGenerator
      input = substrat_bottom
      old_block = 0
      new_block = 600
   []
    [combine_with_bottom_plate]
    # type = CombinerGenerator
    type = StitchMeshGenerator
    inputs = 'combine_with_top_plate rename_bottom_plate'
    stitch_boundaries_pairs = 'bottom bottom_plate_front'
  []

  [EntireMesh]
    type = TransformGenerator
    input = combine_with_bottom_plate
    transform = SCALE
    vector_value = '0.001 0.001 0.001'
  []
  [move]
    type = TransformGenerator
    input = EntireMesh
    transform = TRANSLATE
    vector_value = '0.0016 0.0376 -0.0026'
  []

[]


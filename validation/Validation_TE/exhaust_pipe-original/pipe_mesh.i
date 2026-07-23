
pipe_thickness = 2
pipe_elem = 3
pipe_outs = 50
outs_elem = 20


TE_size_x = 36.8
TE_size_y = 37.6
TE_spacing = 2
elem_TE = 20
elem_spacing = 2
nx_TE = 4
ny_TE = 5
pipe_inner = ${fparse nx_TE * TE_size_x + (nx_TE-1) * TE_spacing}


[Mesh]
[cmg]
    type                  = CartesianMeshGenerator
    dim                   = 2
    dx                    = '${pipe_thickness} ${TE_size_x} ${TE_spacing} ${TE_size_x} ${TE_spacing} ${TE_size_x} ${TE_spacing} ${TE_size_x} ${pipe_thickness}'
    dy                    = '${pipe_outs} ${TE_size_y} ${TE_spacing} ${TE_size_y} ${TE_spacing} ${TE_size_y} ${TE_spacing} ${TE_size_y} ${TE_spacing} ${TE_size_y} ${pipe_outs}'
    ix                    = '${pipe_elem} ${elem_TE} ${elem_spacing} ${elem_TE} ${elem_spacing}  ${elem_TE} ${elem_spacing}  ${elem_TE} ${pipe_elem}'
    iy                    = '${outs_elem} ${elem_TE} ${elem_spacing} ${elem_TE} ${elem_spacing}  ${elem_TE} ${elem_spacing}  ${elem_TE} ${elem_spacing} ${elem_TE} ${outs_elem}'
    subdomain_id          = '5 4 4 4 4 4 4 4 5
                             1 2 3 2 3 2 3 2 1
                             1 3 3 3 3 3 3 3 1
                             1 2 3 2 3 2 3 2 1
                             1 3 3 3 3 3 3 3 1
                             1 2 3 2 3 2 3 2 1
                             1 3 3 3 3 3 3 3 1
                             1 2 3 2 3 2 3 2 1
                             1 3 3 3 3 3 3 3 1
                             1 2 3 2 3 2 3 2 1
                             5 4 4 4 4 4 4 4 5'
  []

    [extrude]
    type = AdvancedExtruderGenerator
    input = cmg
    heights = '${pipe_thickness} ${fparse 15 *pipe_thickness} '
    num_layers = '${pipe_elem} 10'
    direction = '0 0 1'
    subdomain_swaps ='1 1 2 2 3 3 4 1 5 1;
                      1 1 2 6 3 6 4 6 5 1'
  []
  [TE_boundary]
    type = SideSetsFromNormalsGenerator
    input = extrude
    new_boundary = TE_wall
    normals = '0 0 -1'
    included_subdomains = 2
  []
  [nonTE_boundary]
    type = SideSetsFromNormalsGenerator
    input = TE_boundary
    new_boundary = bottom_wall
    normals = '0 0 -1'
    included_subdomains = '3 1'
  []
  [rename]
    type = RenameBlockGenerator
    input = nonTE_boundary
    old_block = '2 3'
    new_block = '1 1'
  []
  [inner_boundary]
    type = SideSetsBetweenSubdomainsGenerator
    input = rename
    new_boundary = inner_pipe
    paired_block = 6
    primary_block = 1
  []
  [delete_center]
    type = BlockDeletionGenerator
    input = inner_boundary
    block = 6
  []
  [scale]
    type = TransformGenerator
    input = delete_center
    transform = SCALE
    vector_value = '0.001 0.001 0.001'
  []

[]


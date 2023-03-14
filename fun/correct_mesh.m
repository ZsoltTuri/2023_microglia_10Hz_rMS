function correct_mesh(var)
arguments
    var.msh_path
    var.msh_name
    var.msh_name_new
end
m = mesh_load_gmsh4([var.msh_path filesep var.msh_name]);
m.triangle_regions(m.triangle_regions == 1) = 1002;    % set tissue culture surface as GM
m.triangle_regions(m.triangle_regions == 2) = 1005;    % set petri dish surface as skin surface
m.tetrahedron_regions(m.tetrahedron_regions == 2) = 5; % set petri dish volume as skin volume
m.tetrahedron_regions(m.tetrahedron_regions == 1) = 2; % set tissue culture volume as GM volume
mesh_save_gmsh4(m, [var.msh_path filesep var.msh_name_new]);
end
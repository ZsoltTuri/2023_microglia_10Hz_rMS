function results = analyze_simulation(var)
arguments
    var.mesh_path
    var.mesh_name
    var.mso
end
m = mesh_load_gmsh4(fullfile(var.mesh_path, var.mesh_name));
% m_surf = mesh_extract_regions(m, 'elemtype', 'tri', 'region_idx', 1002); 
m_vol = mesh_extract_regions(m, 'elemtype', 'tet', 'region_idx', 2);
field_idx = get_field_idx(m_vol, 'normE', 'elements');
field = m_vol.element_data{field_idx}.tetdata;
field = field * var.mso;
results(1, 1) = mean(field);
results(1, 2) = median(field);
results(1, 3) = prctile(field, 99.9);
end
function create_bat_brain_slice(var)
arguments
    var.path
    var.folder
    var.out_path
    var.out_name
end
sep = '\\';
var.path = strrep(var.path, '\', sep);
var.out_path = strrep(var.out_path, '\', sep);
space = 32;
fname = fullfile(var.out_path, var.out_name);
fid = fopen(fname, 'wt');
fprintf(fid, strcat('cd', space, var.path, sep, var.folder, '\n'));
fprintf(fid, strcat('gmsh -3 -format stl -o', space, ['2_stl', sep, 'brain_slice.stl 1_geo', sep, 'brain_slice.geo']));
fclose(fid);
end
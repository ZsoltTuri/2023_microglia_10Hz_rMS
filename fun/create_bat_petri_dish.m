function create_bat_petri_dish(var)
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
fprintf(fid, strcat('gmsh -3 -format stl -o', space, ['2_stl', sep, 'petri_dish.stl 1_geo', sep, 'petri_dish.geo']));
fclose(fid);
end
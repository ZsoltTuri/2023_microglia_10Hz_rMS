function create_bat_invitro(var)
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
fprintf(fid, strcat('gmsh -3 -format msh2 -o', space, ['3_msh', sep, 'invitro.msh 1_geo', sep, 'invitro.geo']));
fclose(fid);
end
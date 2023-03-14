function create_invitro(var)
arguments
    var.out_path
    var.out_name
    var.stl_path
    var.stl1
    var.stl2
end

sep = '\\';
var.stl_path = strrep(var.stl_path, '\', sep);
var.out_path = strrep(var.out_path, '\', sep);
space = 32;
fname = fullfile(var.out_path, var.out_name);
fid = fopen(fname, 'wt');
fprintf(fid, strcat('Mesh.Algorithm3D = 1;\n'));
fprintf(fid, strcat('Mesh.Optimize = 1;\n'));
fprintf(fid, strcat('Mesh.OptimizeNetgen = 1;\n'));
fprintf(fid, strcat('Merge "', var.stl_path, sep, var.stl1, '";\n'));
fprintf(fid, strcat('Merge "', var.stl_path, sep, var.stl2, '";\n'));
fprintf(fid, strcat('Surface Loop(1) = {1};\n'));
fprintf(fid, strcat('Surface Loop(2) = {2};\n'));
fprintf(fid, strcat('Volume(1) = {1};\n'));
fprintf(fid, strcat('Volume(2) = {2, 1};\n'));
fprintf(fid, strcat('Physical Surface(1) = {1};\n'));
fprintf(fid, strcat('Physical Surface(2) = {2};\n'));
fprintf(fid, strcat('Physical Volume(1) = {1};\n'));
fprintf(fid, strcat('Physical Volume(2) = {2};\n'));
fclose(fid);
end
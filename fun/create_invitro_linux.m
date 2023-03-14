function create_invitro_linux(var)
arguments
    var.out_path
    var.out_name
    var.stl_path
    var.stl1
    var.stl2
end
space = 32;
fname = [var.out_path filesep var.out_name];
fid = fopen(fname, 'wt');
fprintf(fid, strcat('Mesh.Algorithm3D = 1;\n'));
fprintf(fid, strcat('Mesh.Optimize = 1;\n'));
fprintf(fid, strcat('Mesh.OptimizeNetgen = 1;\n'));
fprintf(fid, strcat('Merge "', var.stl_path, filesep, var.stl1, '";\n'));
fprintf(fid, strcat('Merge "', var.stl_path, filesep, var.stl2, '";\n'));
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
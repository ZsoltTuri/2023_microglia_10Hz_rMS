function create_bat_script(var)
arguments
    var.out_path
    var.out_name
    var.bat1
    var.bat2
    var.bat3
end
sep = '\\';
var.out_path = strrep(var.out_path, '\', sep);
space = 32;
fname = fullfile(var.out_path, var.out_name);
fid = fopen(fname, 'wt');
fprintf(fid, strcat(var.out_path, sep, var.bat1, space, '&&^\n'));
fprintf(fid, strcat(var.out_path, sep, var.bat2, space, '&&^\n'));
fprintf(fid, strcat(var.out_path, sep, var.bat3));
fclose(fid);
end
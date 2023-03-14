function create_md_file(var)
arguments
    var.out_path
    var.out_name
end
fname = fullfile(var.out_path, var.out_name);
fid = fopen(fname, 'wt');
fprintf(fid, strcat('#'));
fclose(fid);
end
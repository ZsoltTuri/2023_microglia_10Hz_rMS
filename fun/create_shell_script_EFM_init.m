function create_shell_script_EFM_init(var)
arguments
    var.out_path
    var.out_name
    var.workspace
end
sep = '\\';
linux_sep = '/';
var.out_path = strrep(var.out_path, '\', sep);
var.workspace =  strrep(var.workspace, '\', linux_sep);
space = 32;
fname = [var.out_path linux_sep var.out_name];
fid = fopen(fname, 'wt');
fprintf(fid, '#!/bin/bash \n');
fprintf(fid, strcat('cd', space, var.workspace, ' \n')); 
fprintf(fid, 'rm *.out \n');
fprintf(fid, 'git stash \n');
fprintf(fid, 'git pull origin main \n');
fprintf(fid, 'dos2unix EFM.sh \n');
fprintf(fid, 'chmod +x EFM.sh \n');  
fprintf(fid, 'sbatch  ./EFM.sh \n');
fclose(fid);
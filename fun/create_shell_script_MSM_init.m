function create_shell_script_MSM_init(var)
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
fprintf(fid, 'dos2unix MSM_mod_gen.sh \n');
fprintf(fid, 'chmod +x MSM_mod_gen.sh \n');
fprintf(fid, 'dos2unix MSM_thold_1.sh \n');
fprintf(fid, 'chmod +x MSM_thold_1.sh \n');
fprintf(fid, 'dos2unix MSM_thold_10.sh \n');
fprintf(fid, 'chmod +x MSM_thold_10.sh \n');
fprintf(fid, 'dos2unix MSM_thold_10_rTMS.sh \n');
fprintf(fid, 'chmod +x MSM_thold_10_rTMS.sh \n');
fprintf(fid, 'dos2unix MSM_thold_merge.sh \n');
fprintf(fid, 'chmod +x MSM_thold_merge.sh \n');
fprintf(fid, 'dos2unix MSM_rMS.sh \n');
fprintf(fid, 'chmod +x MSM_rMS.sh \n');
fprintf(fid, 'dos2unix MSM_rMS_analysis.sh \n');
fprintf(fid, 'chmod +x MSM_rMS_analysis.sh \n');
fprintf(fid, strcat('cd', space, var.workspace, linux_sep, 'sim_msm', linux_sep, 'Model_Generation', linux_sep, 'Jarsky_files', linux_sep, 'lib_mech \n')); 
fprintf(fid, 'nrnivmodl \n');  
fclose(fid);
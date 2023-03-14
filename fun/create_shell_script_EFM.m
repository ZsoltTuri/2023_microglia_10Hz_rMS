function create_shell_script_EFM(var)
arguments
    var.out_path
    var.out_name
    var.jobname
    var.nodes
    var.tasks
    var.tasks_nodes
    var.memory
    var.wallclock
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
fprintf(fid, '########## Begin Slurm header ########## \n');
fprintf(fid, '# Job name \n');
fprintf(fid, strcat('#SBATCH --job-name=', var.jobname, '\n'));
fprintf(fid, '# Requested number of nodes \n');
fprintf(fid, strcat('#SBATCH --nodes=', var.nodes, '\n'));
fprintf(fid, '# Requested number of tasks \n');
fprintf(fid, strcat('#SBATCH --ntasks=', var.tasks, '\n'));
fprintf(fid, '# Requested number of task per node \n');
fprintf(fid, strcat('#SBATCH --ntasks-per-node=', var.tasks_nodes, '\n'));
fprintf(fid, '# Requested memory \n');
fprintf(fid, strcat('#SBATCH --mem=', var.memory, 'gb \n'));
fprintf(fid, '# Estimated wallclock time for job \n');
fprintf(fid, strcat('#SBATCH --time=', var.wallclock, '\n'));
fprintf(fid, '# Specify queue class \n');
fprintf(fid, '#SBATCH --partition=single \n');
fprintf(fid, '# Send mail when job begins, aborts and ends \n');
fprintf(fid, '#SBATCH --mail-type=ALL \n');
fprintf(fid, '########### End Slurm header ########## \n');

fprintf(fid, strcat('echo "Submit Directory:', space, '$SLURM_SUBMIT_DIR" \n'));
fprintf(fid, strcat('echo "Working Directory:', space,  '$PWD" \n'));
fprintf(fid, strcat('echo "Running on host:', space, '$HOSTNAME" \n'));
fprintf(fid, strcat('echo "Job id:',  space, '$SLURM_JOB_ID" \n'));
fprintf(fid, strcat('echo "Job name:', space, '$SLURM_JOB_NAME" \n'));
fprintf(fid, strcat('echo "Number of nodes dedicated to the job:', space, '$SLURM_JOB_NUM_NODES" \n'));
fprintf(fid, strcat('echo "Memory per node dedicated to the job:', space, '$SLURM_MEM_PER_NODE" \n'));
fprintf(fid, strcat('echo "Total number of processes dedicated to the job:', space, '$SLURM_NPROCS" \n'));
fprintf(fid, strcat('echo "The total number of tasks available for the job:', space, '$SLURM_NTASKS" \n'));
fprintf(fid, strcat('echo "Number of requested tasks per node:', space, '$SLURM_NTASKS_PER_NODE" \n'));
fprintf(fid, strcat('echo "Number of processes per node dedicated to the job:', space, '$SLURM_JOB_CPUS_PER_NODE" \n'));

fprintf(fid, strcat('cd', space, var.workspace, linux_sep, 'src \n')); 
fprintf(fid, strcat('ml', space, ['math' linux_sep 'matlab' linux_sep 'R2020b \n']));
fprintf(fid, strcat('matlab –nodesktop -nodisplay -nojvm -singleCompThread -batch', space, '"hpc_prep_mesh"', '\n'));

fprintf(fid, strcat('cd', space, var.workspace, linux_sep, 'sim_efm \n')); 
fprintf(fid, strcat('gmsh -3 -format stl -o', space, ['2_stl' linux_sep 'brain_slice.stl 1_geo' linux_sep 'brain_slice.geo \n']));
fprintf(fid, strcat('gmsh -3 -format stl -o', space, ['2_stl' linux_sep 'petri_dish.stl 1_geo' linux_sep 'petri_dish.geo \n']));
fprintf(fid, strcat('gmsh -3 -format msh2 -o', space, ['3_msh' linux_sep 'invitro.msh 1_geo' linux_sep 'invitro.geo \n']));
 
fprintf(fid, strcat('cd', space, var.workspace, linux_sep, 'src \n'));
% fprintf(fid, strcat('matlab –nodesktop -nodisplay -nojvm -singleCompThread -batch', space, '"hpc_analyze_mesh"', '\n'));
fprintf(fid, strcat('matlab –nodesktop -nodisplay -nojvm -singleCompThread -batch', space, '"hpc_run_simnibs"', '\n'));
fclose(fid);
end
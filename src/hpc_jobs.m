%% Info
% Create shell scripts for E-field and multi-scale modeling on HPC.
% I run this script on my local PC and upload its output (shell files) to HPC via git.

%% Set preliminaries
clear; close all; clc;
repository = '2021_microglia_rMS';
sim_folder = 'sim_efm';
path = ; % define project path
addpath([path filesep 'fun'])
addpath(['SIMNIBS_' filesep 'matlab']); % add simnibs matlab
prepare_folders('path', path, 'sim_folder', sim_folder)
cd(path)
% HPC workspace 
workspace_path = ; % define HPC workspace path
workspace = [workspace_path filesep repository];

%% Prepare shell scripts for E-field modeling (create mesh, run SimNIBS)
out_name = [repository '_EFM_init.sh'];
create_shell_script_EFM_init('out_path', path, 'out_name', out_name, 'workspace', workspace);

bat_name = 'EFM.sh';
jobname = 'efield_modeling';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '32';
wallclock = '02:30:00';
create_shell_script_EFM('out_path', path, 'out_name', bat_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'workspace', workspace);

%% Prepare shell scripts for multi-scale modeling: initialize
out_name = [repository '_MSM_init.sh'];
create_shell_script_MSM_init('out_path', path, 'out_name', out_name, 'workspace', workspace);

%% Prepare shell scripts for multi-scale modeling: model generation
bat_name = 'MSM_mod_gen.sh';
jobname = 'multi_scale_modeling_model_generation';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '2';
wallclock = '00:30:00';
create_shell_script_MSM_mod_gen('out_path', path, 'out_name', bat_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'workspace', workspace);

%% Prepare shell scripts for multi-scale modeling: threshold estimation
% single synaptic input
out_name = 'MSM_thold_1.sh';
jobname = 'MSM_thold_1';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '24';
array = '1-35';
wallclock = '00:45:00';
create_shell_script_MSM_threshold('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

% 10 synaptic inputs
out_name = 'MSM_thold_10.sh';
jobname = 'MSM_thold_10';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '24';
array = '1-35';
wallclock = '04:00:00';
create_shell_script_MSM_threshold_10_pulses('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

% 10 synaptic inputs + 'rTMS'
out_name = 'MSM_thold_10_rTMS.sh';
jobname = 'MSM_thold_10_rTMS';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '24';
array = '1-35';
wallclock = '04:00:00';
create_shell_script_MSM_threshold_10_pulses_rTMS('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

% merge results  
out_name = 'MSM_thold_merge.sh';
jobname = 'MSM_thold_merge';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '4';
wallclock = '00:20:00';
create_shell_script_MSM_threshold_merge('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'workspace', workspace);

%% Prepare shell scripts for multi-scale modeling: repetitive magnetic 'stimulation'
out_name = 'MSM_rMS.sh';
jobname = 'MSM_rMS';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '30';
array = '1-35';
wallclock = '20:00:00';
create_shell_script_MSM_rMS('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

% Analyze MSM data
out_name = 'MSM_rMS_analysis.sh';
jobname = 'MSM_rMS_analysis';
nodes = '1';
tasks = '1';
tasks_nodes = '1';
memory = '45';
array = '1-35';
wallclock = '00:30:00';
create_shell_script_MSM_rMS_analysis('out_path', path, 'out_name', out_name, 'jobname', jobname, 'nodes', nodes, 'tasks', tasks, 'tasks_nodes', tasks_nodes, 'memory', memory, 'wallclock', wallclock, 'array', array, 'workspace', workspace);

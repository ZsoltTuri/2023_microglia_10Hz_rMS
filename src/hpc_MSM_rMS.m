function hpc_MSM_rMS(idx)
% 1. Perform voltage modeling for a given rMS protocol.
% 2. Perform calcium modeling for a given rMS protocol.

%% Set preliminaires
workspace_path = []; % define hpc workspace path
repository = '2021_microglia_rMS';
sim_folder = 'sim_msm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun' filesep])); 
run([workspace filesep sim_folder filesep 'Model_Generation' filesep 'lib' filesep 'init_t2n_trees.m']);

%% Load parameters
% TMS/neuron parameters
sim = 4; % 4th column is for rMS
mso = num2str(50); % maximum stimulator output
% load cell model names
model_names = load([workspace filesep 'data' filesep 'cell_model_names.mat']);
model_names = struct2cell(model_names);
model_names = vertcat(model_names{:});
model_name = model_names{idx, sim};
% load cell locations 
cell_locations = load([workspace filesep 'data' filesep 'cell_locations.mat']);
cell_locations = cell2mat(struct2cell(cell_locations));
cell_location = cell_locations(idx, :);
% load synaptic weights
synaptic_weights = load([workspace filesep 'data' filesep 'synaptic_weight_thresholds.mat']);
synaptic_weights = cell2mat(struct2cell(synaptic_weights));
synaptic_weight = synaptic_weights(idx, 3);

%% Voltage modeling
% prepare params.txt files (no synaptic input)
cd([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Code' filesep 'NEURON' filesep])
params_path = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'NEURON' filesep];
params_file = 'params.txt';
tms_amp = mso;
syn_freq = '3.000000';
syn_noise = '0.500000';
syn_weight = '0.000000'; 
syn_weight_sync = sprintf('%.7f', synaptic_weight); 
tms_offset = '2.000000';    
create_paramstxt_file('params_path', params_path, 'params_file', params_file, ...
                      'tms_amp', tms_amp, 'syn_freq', syn_freq, 'syn_noise', syn_noise, ...
                      'syn_weight', syn_weight, 'syn_weight_sync', syn_weight_sync, 'tms_offset', tms_offset)
% E-field coupling to neuronal model 
folder_name = [workspace filesep sim_folder filesep 'Models' filesep model_names{idx, sim} filesep 'Results' filesep 'E-field_Coupling' filesep];
create_folder('folder_name', folder_name)
meshfile = 'invitro_final_TMS_1-0001_Magstim_70mm_Fig8_scalar.msh';
meshpath = [workspace filesep 'sim_efm' filesep '5_simulations' filesep];
nrnloc = cell_location;
nrndpth = 0;
nrnfile = 'locs_all_seg.txt';
nrnpath = ['..' filesep '..' filesep 'Results' filesep 'NEURON' filesep 'locs' filesep]; 
nrnaxs = [];
nrnori = []; 
scale_E = 1;
respath = ['..' filesep '..' filesep 'Results' filesep 'E-field_Coupling' filesep];
parameters_file = 'parameters.txt';
create_parameter_file('meshfile', meshfile, 'meshpath', meshpath, 'nrnloc', nrnloc, 'nrndpth', nrndpth, 'nrnfile', nrnfile, 'nrnpath', nrnpath, 'nrnaxs', nrnaxs, ...
                      'nrnori', nrnori, 'scale_E', scale_E, 'respath', respath, 'parameters_file', parameters_file);
cd([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Code' filesep 'E-Field_Coupling' filesep])
couple_script([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'E-field_Coupling' filesep 'parameters.txt'])
% voltage modeling
cd([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Code' filesep 'NEURON' filesep])
system('nrniv -nogui TMS_script.hoc');

%% 2. Calcium modeling
cd([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Code' filesep 'Calcium' filesep])
% prepare folders
cpath = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'Calcium' filesep];
vpath = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'Calcium' filesep 'Converted_Voltage_Traces' filesep];
opath = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'Calcium' filesep 'Calcium_Simulation_Results' filesep];
if (not(isfolder(cpath)))
    mkdir(cpath);
    mkdir(vpath);
    mkdir(opath);
end  
disp('Created folders was successfull')
run('export_data.m')
wait_for_converting_voltage_data('folder', vpath);
% create calcium shell script
tvec = readmatrix([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'NEURON' filesep 'tvec.dat']); 
ug4_path = ['$HOME' filesep 'ug4' filesep 'bin' filesep 'ugshell'];
ex = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Code' filesep 'Calcium' filesep 'vdccFullCellCalcium.lua'];
grid = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'Calcium' filesep 'neuron_out.swc'];
numRefs = num2str(0);
setting = 'none';
dt = sprintf('%.7f', 0.05 * 1e-3); 
endTime = num2str(tvec(end));
pstep = sprintf('%.7f', 1e-3); % num2str(1.0e-5);
vmData = vpath;
outName = opath;
solver = 'GS';
minDef = num2str(1e-11);
numNewton = num2str(5); 
vSampleRate = sprintf('%.7f', abs(tvec(2) - tvec(1)) * 1e-3); 
filename = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'Calcium' filesep 'calciumshellscript.sh'];
create_calciumshellscript('ug4_path', ug4_path, 'ex', ex, 'grid', grid, 'numRefs', numRefs, 'setting', setting, 'dt', dt, 'endTime', endTime, 'pstep', pstep, 'vmData', vmData, ...
                          'outName', outName, 'solver', solver, 'minDef', minDef, 'numNewton', numNewton, 'vSampleRate', vSampleRate, 'filename', filename);
% file permission(s)
fileattrib(filename, '+x', 'a') 
% run calcium modeling
system(sprintf('sh %s', filename), '-echo');
end
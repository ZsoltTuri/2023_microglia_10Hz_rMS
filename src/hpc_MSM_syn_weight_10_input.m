function threshold = hpc_MSM_syn_weight_10_input(idx)
% Estimate the action potential threshold for rTMS at a given MSO percent.

%% Set preliminaires
workspace_path = []; % define hpc workspace path
repository = '2021_microglia_rMS';
sim_folder = 'sim_msm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun' filesep])); 
run([workspace filesep sim_folder filesep 'Model_Generation' filesep 'lib' filesep 'init_t2n_trees.m']);

%% Load parameters
% TMS/neuron parameters
sim = 2; % 2nd column = 10 synaptic inputs
mso = num2str(0); % maximum stimulator output
syn_weight_max = 0.1000000; % max synaptic weight 
% load cell model names
model_names = load([workspace filesep 'data' filesep 'cell_model_names.mat']);
model_names = struct2cell(model_names);
model_names = vertcat(model_names{:});
model_name = model_names{idx, sim};
% load cell locations  
cell_locations = load([workspace filesep 'data' filesep 'cell_locations.mat']);
cell_locations = cell2mat(struct2cell(cell_locations));
cell_location = cell_locations(idx, :);

%% Estimate action potential threshold
% prepare params.txt files 
cd([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Code' filesep 'NEURON' filesep])
params_path = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'NEURON' filesep];
params_file = 'params.txt';
tms_amp = mso;
syn_freq = '3.000000';
syn_noise = '0.500000';
syn_weight = '0.000000'; 
syn_weight_sync = num2str(syn_weight_max); 
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
% estimate the firing threshold by iteratively updating the params.txt file   
[threshold, tested_weights] = determine_synaptic_weight('path', [workspace filesep sim_folder], 'model_name', model_name, 'syn_weight_max', syn_weight_max, 'mso', mso); 
save([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'thresholds' filesep 'synaptic_weight_threshold.mat'], 'threshold');
save([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'thresholds' filesep 'synaptic_weight_threshold_history.mat'], 'tested_weights');

end
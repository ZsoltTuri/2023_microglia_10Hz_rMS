%% Info
% Merge synaptic weight threshold estimation results together. 

%% Set preliminaires
workspace_path = []; % define hpc workspace path
repository = '2021_microglia_rMS';
sim_folder = 'sim_msm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun' filesep])); 
run([workspace filesep sim_folder filesep 'Model_Generation' filesep 'lib' filesep 'init_t2n_trees.m']);

%% Load parameters
model_names = load([workspace filesep 'data' filesep 'cell_model_names.mat']);
model_names = struct2cell(model_names);
model_names = vertcat(model_names{:});

%% Get single-pulse magnetic stimulation results
nsim = 3; %1 pulse, 10 pulses, 10 pulses + rMS
thresholds = zeros(size(model_names, 1), nsim);
for idx = 1:size(model_names, 1)
    for j = 1:nsim
        model_name = model_names{idx, j};
        threshold = load([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'thresholds' filesep 'synaptic_weight_threshold.mat']);
        thresholds(idx, j) = cell2mat(struct2cell(threshold));   
        clearvars threshold
    end
end
save([workspace filesep 'data' filesep 'synaptic_weight_thresholds.mat'], 'thresholds')
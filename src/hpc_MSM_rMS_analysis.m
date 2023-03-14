function hpc_MSM_rMS_analysis(idx)
% Analyze voltage and calcium modeling data.

%% Set preliminaires
workspace_path = []; % define hpc workspace path
repository = '2021_microglia_rMS';
sim_folder = 'sim_msm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun' filesep])); 
run([workspace filesep sim_folder filesep 'Model_Generation' filesep 'lib' filesep 'init_t2n_trees.m']);

%% Load parameters
sim = 4; % 4th column is for rMS
model_names = load([workspace filesep 'data' filesep 'cell_model_names.mat']);
model_names = struct2cell(model_names);
model_names = vertcat(model_names{:});
model_name = model_names{idx, sim};
swc = load([workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'Calcium' filesep 'neuron_out.swc']);
swc(:,3:5) = swc(:,3:5) * 1e6; % convert to um 
compartments = {'soma', 'axon', 'basal', 'apical'}'; % soma = 1; axon = 2; basal = 3; apical = 4;

%% Voltage data 
path = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'NEURON' filesep];          
data = readmatrix([path filesep 'voltage_trace.dat'])'; 
tvec = readmatrix([path filesep 'tvec.dat']) * 1000; % convert to ms
for compartment = 1:size(compartments, 1)
    mask = swc(:, 2) == compartment;
    voltage_mean = mean(data(mask, :)); 
    save([workspace filesep sim_folder filesep 'Results' filesep strcat('voltage_', compartments{compartment}, '_', model_name, '.mat')], 'voltage_mean');
    clearvars mask voltage_mean
end
voltage_all_mean = mean(data);
save([workspace filesep sim_folder filesep 'Results' filesep strcat('voltage_all_', model_name, '.mat')], 'voltage_all_mean');
clearvars path data tvec compartment

%% Calcium data
path = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep 'Results' filesep 'Calcium' filesep];         
data = readmatrix([path filesep 'Calcium_Simulation_Results' filesep 'fullCalciumData.txt'])' * 1e6; % convert to umol/l
for compartment = 1:size(compartments, 1)
    mask = swc(:, 2) == compartment;
    ca_mean = mean(data(mask, :)); 
    save([workspace filesep sim_folder filesep 'Results' filesep strcat('calcium_', compartments{compartment}, '_', model_name, '.mat')], 'ca_mean');
    clearvars mask ca_mean
end
ca_all_mean = mean(data);
save([workspace filesep sim_folder filesep 'Results' filesep strcat('calcium_all_', model_name, '.mat')], 'ca_all_mean');
end
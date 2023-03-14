%% Info:
% Generate neuronal models. Rotation angle needs to be adjusted beforehand for each cell individually.

%% Set preliminaires
workspace_path = []; % define hpc workspace path
repository = '2021_microglia_rMS';
sim_folder = 'sim_msm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun' filesep])); 
run([workspace filesep sim_folder filesep 'Model_Generation' filesep 'lib' filesep 'init_t2n_trees.m']);

%% Load parameters
example_cell = 'cell_6.swc'; % we take the axon of this example cell
% load cell model names
model_names = load([workspace filesep 'data' filesep 'cell_model_names.mat']);
model_names = struct2cell(model_names);
model_names = vertcat(model_names{:});
% load rotation angles
rot_angles = load([workspace filesep 'data' filesep 'cell_rot_angles.mat']);
rot_angles = cell2mat(struct2cell(rot_angles));
% synapse distance from soma
syn_distances = load([workspace filesep 'data' filesep 'synapse_distance_from_soma.mat']);
syn_distances = cell2mat(struct2cell(syn_distances));

%% Model generation
cd([workspace filesep sim_folder filesep 'Model_Generation' filesep])
simulations = {'threshold_1pulse', 'threshold_10pulses', 'threshold_10pulses_rTMS', 'rTMS'}';
for idx = 1:size(model_names, 1)
    model_name = model_names{idx, 5};
    rot_angle = rot_angles(idx, 1);
    syn_distance = syn_distances(idx, 1);
    import_cell_2_NeMo('path', workspace, 'sim_folder', sim_folder, 'cell', model_name, 'example_cell', example_cell, 'rot_angle', rot_angle, 'syn_distance', syn_distance); 
    % copy neuronal model folder to simulation folders
    source_folder = [workspace filesep sim_folder filesep 'Models' filesep model_name filesep];
    for j = 1:size(simulations, 1) 
        folder = [workspace filesep sim_folder filesep 'Models' filesep model_names{idx, j} filesep];
        if ~exist(folder)
            mkdir(folder)
        end
        status = copyfile(source_folder, folder, 'f');
        if status == 1
            disp('Copying source folder successfull!');
        else
            disp('Error copying source folder!');
        end
    end
    % copy TMS waveform files
    for j = 1:size(simulations, 1)
        source_folder = [workspace filesep 'src' filesep 'adjusted_nemo_codes' filesep simulations{j, 1} filesep 'TMS_Waveform' filesep];
        target_folder = [workspace filesep sim_folder filesep 'Models' filesep model_names{idx, j} filesep 'Results' filesep 'TMS_Waveform' filesep];
        if ~exist(target_folder)
            mkdir(target_folder)
        end
        status = copyfile(source_folder, target_folder, 'f');
        if status == 1
            disp('Copying TMS waveforms successfull!');
        else
            disp('Error copying TMS waveforms!');
        end
    end
    % copy hoc files
    for j = 1:size(simulations, 1)
        source_folder = [workspace filesep 'src' filesep 'adjusted_nemo_codes' filesep simulations{j, 1} filesep 'hoc_codes' filesep];
        target_folder = [workspace filesep sim_folder filesep 'Models' filesep model_names{idx, j} filesep 'Code' filesep 'NEURON' filesep];
        status = copyfile(source_folder, target_folder, 'f');
        if status == 1
            disp('Copying hoc files successfull!');
        else
            disp('Error copying hoc files!');
        end
    end
    % copy couple script
    for j = 1:size(simulations, 1)
        source_folder = [workspace filesep 'src' filesep 'adjusted_nemo_codes' filesep simulations{j, 1} filesep 'couple_script' filesep];
        target_folder = [workspace filesep sim_folder filesep 'Models' filesep model_names{idx, j} filesep 'Code' filesep 'E-Field_Coupling' filesep];
        status = copyfile(source_folder, target_folder, 'f');
        if status == 1
            disp('Copying couple script files successfull!');
        else
            disp('Error couple script files!');
        end
    end
    % create folders for threshold data
    for j = 1:size(simulations, 1)      
        folder_name = [workspace filesep sim_folder filesep 'Models' filesep model_names{idx, j} filesep 'Results' filesep 'thresholds' filesep];
        create_folder('folder_name', folder_name);
        disp('Created threshold folder!');
    end
end
%% Run E-field modeling on HPC.
clear; close all; clc;

%% Set preliminaires
workspace_path = []; % define hpc workspace path
repository = '2021_microglia_rMS';
sim_folder = 'sim_efm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun'])); 
run([workspace filesep 'src' filesep 'hpc_fieldbox_parameters.m']) % load fieldbox parameters

%% Correct mesh
msh_path = [workspace filesep sim_folder filesep '3_msh'];
msh_name = 'invitro.msh';
msh_name_new = 'invitro_final.msh';
correct_mesh('msh_path', msh_path, 'msh_name', msh_name, 'msh_name_new', msh_name_new);

%% Run simulations
% stimulation intensity
ccr = 1.4;
% affine transformation matrix for the coil (stimulating from the top)
distance = 12.3;
matsimnibs = [-1 0 0 0;
              0 -1 0 0; 
              0 0 -1 distance;
              0 0 0 1];
mesh_name = 'invitro_final.msh';
mesh_path = [workspace filesep sim_folder filesep '3_msh'];
out_path = [workspace filesep sim_folder filesep '5_simulations'];
coil_path = '/simnibs_env/simnibs/ccd-files/Magstim_70mm_Fig8.ccd';
run_simulation('mesh_path', mesh_path, 'mesh_name', mesh_name, 'coil_path', coil_path, 'out_path', out_path, 'ccr', ccr, 'matsimnibs', matsimnibs)
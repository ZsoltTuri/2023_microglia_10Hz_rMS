%% Analyze mesh properties
clear; close all; clc;

%% Set preliminaires
workspace_path = []; % define hpc workspace path
repository = '2021_microglia_rMS';
sim_folder = 'sim_efm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun'])); 
run([workspace filesep 'src' filesep 'hpc_fieldbox_parameters.m']) % load fieldbox parameters

%% Load corrected mesh
msh_path = [workspace filesep sim_folder filesep '3_msh'];
msh_name = 'invitro_final.msh';
m = mesh_load_gmsh4([msh_path filesep msh_name]);
brain_slice = mesh_extract_regions(m, 'region_idx', [2 1002]);
tet_centers = mesh_get_tetrahedron_centers(brain_slice);
[tet_volumes, tet_mean_edge_sizes] = mesh_get_tetrahedron_sizes(brain_slice);

%% Get average edge length in the fieldbox (= locally refined mesh resolution)
roi_nodes = [fb.xmin, fb.ymax, fb.zmax; fb.xmin, fb.ymin, fb.zmax; fb.xmax, fb.ymax, fb.zmax; fb.xmax, fb.ymin, fb.zmax; ...
             fb.xmin, fb.ymax, fb.zmin; fb.xmin, fb.ymin, fb.zmin; fb.xmax, fb.ymax, fb.zmin; fb.xmax, fb.ymin, fb.zmin];
roi = get_fieldbox_roi('fieldbox', fb, 'coordinates', tet_centers);
mesh_edge_length(1, 1) = mean(tet_mean_edge_sizes(roi, 1));
mesh_edge_length(1, 2) = median(tet_mean_edge_sizes(roi, 1));
mesh_edge_length(1, 3) = std(tet_mean_edge_sizes(roi, 1));
save([workspace filesep sim_folder filesep '6_results' filesep 'mesh_edge_length.mat'], 'mesh_edge_length')
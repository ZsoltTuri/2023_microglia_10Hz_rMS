%% Prepare mesh for E-field modeling on HPC.
clear; close all; clc;

%% Set preliminaires
workspace_path = []; % define hpc workspace path
repository = '2021_microglia_rMS';
sim_folder = 'sim_efm';
workspace = [workspace_path filesep repository];
addpath(genpath([workspace filesep 'fun'])); 
run([workspace filesep 'src' filesep 'hpc_fieldbox_parameters.m']) % load fieldbox parameters

%% Prepare geo files
% brain slice
image = [workspace filesep 'data' filesep 'brain_slice.png'];
brainslice = [workspace filesep sim_folder filesep '1_geo' filesep 'brain_slice.geo'];
rot_angle = 30; % rotate brain slice (degree) to match its orientation during stimulation 
% fieldbox parameters
field_box = fieldbox('thickness', fb.thickness, 'VIn', fb.lc_field, 'VOut', fb.lc, 'XMax', fb.xmax, 'XMin', fb.xmin, 'YMax', fb.ymax, 'YMin', fb.ymin, 'ZMax', fb.zmax, 'ZMin', fb.zmin);
brainslice2geo_fb('image', image, 'brainslice', brainslice, 'rot_angle', rot_angle, 'resolution', fb.lc, 'shrink_factor', 650, 'fieldbox', field_box)
% petri dish
d = 35;
h = 9.8; 
z = 1;
lc = 0.5; 
geo_path = [workspace filesep sim_folder filesep '1_geo'];
out_name = 'petri_dish.geo';
create_petri_dish('diameter', d, 'height', h, 'resolution', lc, 'out_path', geo_path, 'out_name', out_name, 'z', z)
% invitro 
stl_path = [workspace filesep sim_folder filesep '2_stl'];
out_name = 'invitro.geo';
stl1 = 'brain_slice.stl';
stl2 = 'petri_dish.stl';
create_invitro_linux('out_path', geo_path, 'out_name', out_name, 'stl_path', stl_path, 'stl1', stl1, 'stl2', stl2);
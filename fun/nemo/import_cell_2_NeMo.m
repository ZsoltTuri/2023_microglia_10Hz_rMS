function import_cell_2_NeMo(var)
% Convert ASC Neurolicida files to SWC format and prepare the cell to be
% compatible with the NeMo Toolbox. 
arguments
    var.path
    var.sim_folder
    var.cell
    var.example_cell
    var.rot_angle
    var.syn_distance
end
%% set parameters
soma_idx = 1;
axon_idx = 2;
basal_idx = 3;
apical_idx = 4;
folder_asc = [var.path filesep 'data' filesep 'neurolucida_ASC'];
folder_swc = [var.path filesep 'data' filesep 'swc'];
%%  Approve the ASC file and convert it to SWC file format
tree = neurolucida_tree([folder_asc filesep strcat(var.cell, '.ASC')], '-r -c');
% xplore_tree(tree, '-2')
% Rename rnames
% tree.rnames 
tree.rnames{3} = 'Soma';
% xplore_tree(tree, '-1')
% Convert
swc_tree(tree, [folder_swc filesep strcat(var.cell, '.swc')]);
%% Prepare cell for NeMo 
% Rename compartment labels
cd(var.path)
tree_swc = load_tree([folder_swc filesep strcat(var.cell, '.swc')]);
tree_swc.R(tree_swc.R == 1) = 5;
tree_swc.R(tree_swc.R == 3) = 1;
tree_swc.R(tree_swc.R == 4) = 3;
tree_swc.R(tree_swc.R == 5) = 4;
% xplore_tree(tree_swc, '-2')
% xplore_tree(tree_swc, '-1')

% Translate cell
index = find(tree_swc.R == soma_idx);
x = tree_swc.X(index, 1);
y = tree_swc.Y(index, 1);
z = tree_swc.Z(index, 1);
tree_swc1 = tran_tree(tree_swc, [-mean(x) -mean(y) -mean(z)]); 
% xplore_tree(tree_swc1, '-2')

% Rotate cell 
tree_swc2 = rot_tree(tree_swc1, [0 0 var.rot_angle]);
% xplore_tree(tree_swc2, '-2')

% Remove old axon
tree_swc3 = strip_axon(tree_swc2);

% Get axon from one example cell
cell_axon = load_tree([var.path filesep var.sim_folder filesep 'Model_Generation' filesep 'morphos' filesep var.example_cell]);
% xplore_tree(cell_axon, '-2')
index = find(cell_axon.R == axon_idx); 
cell_axon.dA = cell_axon.dA(index, index);
cell_axon.X = cell_axon.X(index, 1);
cell_axon.Y = cell_axon.Y(index, 1);
cell_axon.Z = cell_axon.Z(index, 1);
cell_axon.D = cell_axon.D(index, 1);
cell_axon.R = cell_axon.R(index, 1);
cell_axon.rnames = {'5' '1' '3' '4'};
cell_axon.name = 'cell_axon';
cell_axon = tran_tree(cell_axon, [0, abs(max(cell_axon.Y))], 0); 
% xplore_tree(cell_axon, '-2')

% Add axon to cell
cell_combined = cat_tree(tree_swc3, cell_axon);
% cell_combined1 = elimt_tree(cell_combined);
cell_combined.R(cell_combined.R == 3) = 4;
cell_combined.R(cell_combined.R == 2) = 3;
cell_combined.rnames = {'1' '3' '4'};
% xplore_tree(cell_combined, '-2');

% Correct labels
index = ismember(cell_combined.X(:), cell_axon.X(:));
cell_combined.R(index) = 2;
% unique(cell_combined.R)
cell_combined.rnames = {'1' '2' '3' '4'};
% xplore_tree(cell_combined, '-2');
swc_tree(cell_combined, [var.path filesep var.sim_folder filesep 'Model_Generation' filesep 'morphos' filesep strcat(var.cell, '.swc')]);
 
%% Model generation
cd([var.path filesep var.sim_folder filesep 'Model_Generation'])
Jarsky_model('input_cell', strcat(var.cell, '.swc'), 'syn_distance', var.syn_distance);
% Export neuron segment location
cd([var.path filesep var.sim_folder filesep 'Models' filesep var.cell filesep 'Code' filesep 'NEURON'])
system('nrniv save_locations.hoc')
end
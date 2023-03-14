function prepare_folders(var)
% Prepare folders within a given simulation folder
arguments
    var.path
    var.sim_folder
end
create_folder('folder_name', [var.path filesep var.sim_folder]); 
sub_folders = {'1_geo', '2_stl', '3_msh', '4_shell', '5_simulations', '6_results', '7_figures'}';
for j = 1:length(sub_folders)
    sfolder = sub_folders{j, 1};
    create_folder('folder_name', [var.path filesep var.sim_folder filesep sfolder]); 
    create_md_file('out_path', [var.path filesep var.sim_folder filesep sfolder], 'out_name', 'init.md')
end
end
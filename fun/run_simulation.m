function run_simulation(var)
arguments
    var.mesh_path
    var.mesh_name
    var.coil_path
    var.out_path
    var.ccr
    var.matsimnibs
end
% start session 
S = sim_struct('SESSION');
% define I/O
S.fnamehead = [var.mesh_path filesep var.mesh_name]; 
S.pathfem  = var.out_path;
% simulation output fields
S.fields = 'eE';
% coil
S.poslist{1} = sim_struct('TMSLIST');
S.poslist{1}.fnamecoil = var.coil_path; 
% coil's affine transformation matrix
S.poslist{1}.pos(1).matsimnibs = var.matsimnibs;                                    
% adjust conductivities (https://simnibs.github.io/simnibs/build/html/documentation/conductivity.html)
S.poslist{1}.anisotropy_type = 'scalar';  
S.poslist{1,1}.cond(1,2).value = 0.275;   % 2 = GM, here -> GM
S.poslist{1,1}.cond(1,5).value = 1.654;   % 5 = Scalp, here -> CSF
% stimulation intensity
S.poslist{1}.pos(1).didt = var.ccr * 1000000;
run_simnibs(S)
end
function create_paramstxt_file(var)
arguments
    var.params_path
    var.params_file
    var.tms_amp
    var.syn_freq
    var.syn_noise
    var.syn_weight
    var.syn_weight_sync
    var.tms_offset
end
    space = 32;
    fid = fopen([var.params_path filesep var.params_file], 'wt');
    fprintf(fid, '/******E-field specification and quasipotential file location\n');
    fprintf(fid, 'E_UNIFORM 0\n');
    fprintf(fid, ['..' filesep '..' filesep 'Results' filesep 'E-field_Coupling' filesep 'quasipotentials.txt\n']);
    fprintf(fid, strcat('TMSAMP', space, var.tms_amp, '\n'));
    fprintf(fid, '/****Random synaptic parameters***\n');
    fprintf(fid, strcat('SYN_FREQ', space, var.syn_freq, '\n'));
    fprintf(fid, strcat('SYN_NOISE', space, var.syn_noise, '\n'));
    fprintf(fid, strcat('SYN_WEIGHT', space, var.syn_weight, '\n'));
    fprintf(fid, '/****Synchoronous synaptic parameters***\n');
    fprintf(fid, strcat('SYN_WEIGHT_SYNC', space,  var.syn_weight_sync, '\n'));
    fprintf(fid, strcat('TMS_OFFSET', space, var.tms_offset, '\n'));
    fclose(fid);
end
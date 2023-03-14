function matrix = extract_voltage_trace(var)
arguments
    var.voltage_data
    var.neuron_data
    var.compartment_idx % 1: soma; 2: axon; 3: basal; 4: apical
end
% read voltage data
v_trace = readmatrix(fullfile(var.voltage_data))';
% read neuron to extract its compartments (stored in the 2nd column)
load(fullfile(var.neuron_data));
% subset data to the desired neuronal compartment
mask = neuron_out(:, 2) == var.compartment_idx;
v_trace_subset = v_trace(mask, :);
% calculate the mean of the selected compartmental parts
v_trace_subset = mean(v_trace_subset);
matrix = v_trace_subset;
end
function matrix = get_action_potentials(var)
arguments
    var.data
end
[pks, locs, w, p] = findpeaks(var.data);
mask = pks >= 0;
if mask == false
    matrix = double.empty();
else
    matrix(:, 1) = pks(mask);  % local maxima (peaks) of the input signal  
    matrix(:, 2) = p(mask);    % prominences of the peaks
    matrix(:, 3) = locs(mask); % indices at which the peaks occur
end
end
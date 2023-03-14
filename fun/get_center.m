function [x, y] = get_center(cols, boundary)
center_col = zeros(length(cols));

for i = 1: length(cols)
    min_col = min(boundary(:, cols(i)));
    max_col = max(boundary(:, cols(i)));
    center_col(i) = (((max_col - min_col)) / 2) + min_col; 
end

x = center_col(1);
y = center_col(2);

end





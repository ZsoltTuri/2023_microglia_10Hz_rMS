function [boundary] = get_boundary(bw, val)

BW = bw;
dim = size(BW);
col = round(dim(2) / 2);
row = min(find(BW(:,col)));
b = bwtraceboundary(BW,[row, col],'N');
boundary(:, 1) = b(:, 2);
boundary(:, 2) = b(:, 1);
boundary(:, 2) = -boundary(:, 2) + max(boundary(:, 2));
boundary = boundary(val:val:end,:);

end
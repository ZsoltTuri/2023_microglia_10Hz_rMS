function [out] = boundary2mm(boundary, factor)

out = boundary(:,:) ./ factor;

end
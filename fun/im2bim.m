function [out] = im2bim(im, rev)
% Convert image to binary image
I = imread(im);
BW = im2bw(I);
if (exist('rev', 'var'))
    BW = ~BW;
else
    BW = BW;
end
out = BW;
end
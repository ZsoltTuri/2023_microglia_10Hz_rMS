function roi = get_hexahedron_roi(var)
% calculate tetrahedron volumes and their signs
% https://stackoverflow.com/questions/53962225/how-to-know-if-a-line-segment-intersects-a-triangle-in-3d-space
arguments
    var.convex_hull
    var.roi_nodes
    var.point
end
vol = zeros(size(var.convex_hull, 1), 1);
for ii = 1:size(var.convex_hull, 1)
    p1 = var.roi_nodes(var.convex_hull(ii, 1), :);
    p2 = var.roi_nodes(var.convex_hull(ii, 2), :);
    p3 = var.roi_nodes(var.convex_hull(ii, 3), :);
    vol(ii, 1) = tetrahedronVolume(p1, p2, p3, var.point);   
end
mask(:, 1) = vol(:, 1) > 0;
is_outside = any(mask == true);
roi = all(is_outside == false);
end
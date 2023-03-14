function brainslice2geo(var)
arguments
    var.image
    var.brainslice
    var.rot_angle
    var.resolution
    var.shrink_factor
    %var.fieldbox
end
%% 
% Convert image to binary image
BW = im2bim(var.image, 'rev');
% imshow(BW)

% Trace and resample the boundary of the brain slice 
boundary = get_boundary(BW, 20);
% scatter(boundary(:, 1), boundary(:, 2), 'g', 'LineWidth', 3)

% Convert boundary to mm
boundary_mm = boundary2mm(boundary, var.shrink_factor);
% scatter(boundary_mm(:, 1), boundary_mm(:, 2), 'g', 'LineWidth', 3)

% Center
[center(1), center(2)] = get_center([1, 2], boundary_mm);
% scatter(boundary_mm(:, 1), boundary_mm(:, 2), 'g', 'LineWidth', 3)
% hold on
% scatter(center(1), center(2), 'r', 'LineWidth', 4)
b_mm(:, 1) = boundary_mm(:, 1) - center(1);
b_mm(:, 2) = boundary_mm(:, 2) - center(2);
% scatter(b_mm(:, 1), b_mm(:, 2), 'g', 'LineWidth', 3)

% rotate brain slice to match its orientation during stimulation 
theta_deg = var.rot_angle;
theta_rad = deg2rad(theta_deg); 
rot_mat = [cos(theta_rad) -sin(theta_rad);
           sin(theta_rad) cos(theta_rad)];

for i = 1: length(b_mm)
    culture(i, :) = (rot_mat * b_mm(i, :)')';
end
% scatter(culture(:, 1), culture(:, 2), 'g', 'LineWidth', 3)

% % Cubic spline interpolation
% t = 1:numel(culture(:, 1));
% pp = spline(t, culture');
% tInterp = linspace(1,numel(culture(:, 1)));
% xyInterp = ppval(pp, tInterp);
% % Show the result
% plot(xyInterp(1,:),xyInterp(2,:))

%% Prepare GEO file

% determine the brain slice parameters:
lc = var.resolution; % resolution of the mesh
d = 2; % distance from the bottom of the petri dish
t = 0.3; % thickness of the brain slice

% Points 
% brain slice (base)
point_base = zeros(size(culture));
point_base(:, 1) = culture(:, 1); 
point_base(:, 2) = culture(:, 2);
point_base(:, 3) = d;
point_base(:, 4) = lc;
% brain slice (top)
point_top = point_base;
point_top(:, 3) = d + t;
% centers
point_centers = [0 0 d lc; 0 0 d+t lc];
% combine
points = [point_base; point_top; point_centers];
points(:, 5) = 1:length(points);
points = points(:, [5, 1:4]);

% Lines 
% connect brain slice base points
idx_base(:, 1) = 1:length(point_base);
line_base(:, 1) = idx_base;
line_base(:, 2) = vertcat(idx_base(2:end, 1), idx_base(1, 1));
% connect brain slice top points 
idx_top(:, 1) = idx_base + length(idx_base);
line_top(:, 1) = idx_top;
line_top(:, 2) = vertcat(idx_top(2:end, 1), idx_top(1, 1));
% connect base with base center
idx_base_center = idx_top(end) + 1;
line_base_center(:, 1) = line_base(:, 1);
line_base_center(:, 2) = idx_base_center;
% connect top with top center
idx_top_center = idx_base_center + 1;
line_top_center(:, 1) = line_top(:, 1);
line_top_center(:, 2) = idx_top_center;
% connect base with top
line_base_top(:, 1) = idx_base;
line_base_top(:, 2) = idx_top;
% combine
lines = vertcat(line_base, line_top, line_base_center, line_top_center, line_base_top);
lines(:, 3) = 1:length(lines);
lines = lines(:, [3, 1:2]);

% Line loops
% base loop
lineloop_base(:, 1) = 1:233;
lineloop_base(:, 2) = [468:699, 467];
lineloop_base(:, 3) = -1 * (467:699);
% top loop
lineloop_top(:, 1) = -1 * (234:466);
lineloop_top(:, 2) = -1 * [701:932, 700];
lineloop_top(:, 3) = 700:932;
% combine
lineloops_tri = vertcat(lineloop_base, lineloop_top);
lineloops_tri(:, 4) = (length(lines) + 1):(length(lines) + size(lineloops_tri, 1)); 
lineloops_tri = lineloops_tri(:, [4, 1:3]);
% wall loop
lineloops_sqr(:, 1) = (lineloops_tri(end, 1) + 1):(lineloops_tri(end, 1) + 233);
lineloops_sqr(:, 2) = -1 * (1:233);
lineloops_sqr(:, 3) = -1 * [934:1165, 933];
lineloops_sqr(:, 4) = 234:466;
lineloops_sqr(:, 5) = 933:1165;

% Plane Surfaces
plane_surface(:, 1) = vertcat(lineloops_tri(:, 1), lineloops_sqr(:, 1));
plane_surface(:, 2) = plane_surface(:, 1);

%% Write to GEO file
fid = fopen(var.brainslice, 'wt');
% Points 
fprintf(fid, '//Points \n');
for P = 1:size(points, 1)
    fprintf(fid, 'Point(%d) = {%d, %d, %d, %d}; \n', points(P, :));
end
% Lines (base)
fprintf(fid, '//Lines \n');
for L = 1:size(lines, 1)
    fprintf(fid, 'Line(%d) = {%d, %d}; \n', lines(L, :));
end
% Line loops (triangles = base & top)
fprintf(fid, '//Line loops \n');
for LL = 1:length(lineloops_tri)
    fprintf(fid, 'Line Loop(%d) = {%d, %d, %d}; \n', lineloops_tri(LL, :));
end
% Line loops (squares = wall)
for LLs = 1:length(lineloops_sqr)
    fprintf(fid, 'Line Loop(%d) = {%d, %d, %d, %d}; \n', lineloops_sqr(LLs, :));
end
% Plane Surface
fprintf(fid, '//Plane Surface \n');
for PS = 1:length(plane_surface) 
     fprintf(fid,  'Plane Surface (%d) = {%d}; \n', plane_surface(PS, :));
end
% % Fieldbox
% space = 32; 
% fprintf(fid, '//Fieldbox \n');
% fprintf(fid, 'Field[1] = Box; \n');
% fprintf(fid, strcat('Field[1].Thickness =', space, num2str(var.fieldbox(1)), '; \n'));
% fprintf(fid, strcat('Field[1].VIn =', space, num2str(var.fieldbox(2)), '; \n'));
% fprintf(fid, strcat('Field[1].VOut =', space, num2str(var.fieldbox(3)), '; \n'));
% fprintf(fid, strcat('Field[1].XMax =', space, num2str(var.fieldbox(4)), '; \n'));
% fprintf(fid, strcat('Field[1].XMin =', space, num2str(var.fieldbox(5)), '; \n'));
% fprintf(fid, strcat('Field[1].YMax =', space, num2str(var.fieldbox(6)), '; \n'));
% fprintf(fid, strcat('Field[1].YMin =', space, num2str(var.fieldbox(7)), '; \n'));
% fprintf(fid, strcat('Field[1].ZMax =', space, num2str(var.fieldbox(8)), '; \n'));
% fprintf(fid, strcat('Field[1].ZMin =', space, num2str(var.fieldbox(9)), '; \n'));
% fprintf(fid, 'Background Field = 1; \n');
fclose(fid);
end

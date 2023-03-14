function create_petri_dish(var)
arguments
    var.diameter
    var.height
    var.resolution
    var.out_path
    var.out_name
    var.z
end
% Points
rad = var.diameter/2;
z = var.z;
col1 = zeros(5, length(rad));
col1(1, :) = zeros(1, length(rad));
col1(2, :) = rad;
col1(3, :) = zeros(1, length(rad));
col1(4, :) = -1 * rad; 
col1(5, :) = zeros(1, length(rad));
col1 = [col1; col1];
col2 = zeros(5, length(rad));
col2(1, :) = zeros(1, length(rad));
col2(2, :) = zeros(1, length(rad));
col2(3, :) = rad;
col2(4, :) = zeros(1, length(rad));
col2(5, :) = -1 * rad; 
col2 = [col2; col2];
col3 = [repelem(z, 5, 1); repelem(var.height, 5, 1)];
col4 = repelem(var.resolution, length(col1), 1);

% Circle
cir = zeros(8, 3);
cir(:, 1) = [2 3 4 5 7 8 9 10];
cir(:, 2) = [repelem(1, 4, 1); repelem(6, 4, 1)];
cir(:, 3) = [3 4 5 2 8 9 10 7];

% Line
lin = zeros(4, 3);
lin(:, 1) = 9:12; %idx
lin(:, 2) = [2 3 4 5];
lin(:, 3) = [7 8 9 10];

% Line loops
linloop = zeros(6, 5);
linloop(:, 1) = 13:18; %idx
linloop(:, 2) = [-1 5  1 2 3 4];
linloop(:, 3) = [-2 6 10 11 12 9];
linloop(:, 4) = [-3 7 -5 -6 -7 -8];
linloop(:, 5) = [-4 8 -9 -10 -11 -12];

% Plane surface
psurf = 13:14;

% Ruled surface
rsurf = 15:18;

%% Write to output

for i = 1:length(rad)
    fname = [var.out_path filesep var.out_name];
    fid = fopen(fname, 'wt');
    
    % Points
    fprintf(fid, '//Point \n');
    for p = 1:10
        fprintf(fid, 'Point(%d) = {%d, %d, %d, %d}; \n', p, col1(p, i), col2(p, i), col3(p, 1), col4(p, 1));
    end
    
    % Circle
    fprintf(fid, '//Circle \n');
    for c = 1:length(cir)
        fprintf(fid, 'Circle(%d) = {%d, %d, %d}; \n', c, cir(c, 1), cir(c, 2), cir(c, 3));
    end
    
    % Line
    fprintf(fid, '//Line \n');
    for l = 1:length(lin)
        fprintf(fid, 'Line(%d) = {%d, %d}; \n', lin(l, 1), lin(l, 2), lin(l, 3));
    end
    
    % Line loop
    fprintf(fid, '//Line Loop \n');
    for ll = 1:length(linloop)
        fprintf(fid, 'Line Loop(%d) = {%d, %d, %d, %d}; \n', linloop(ll, 1), linloop(ll, 2), linloop(ll, 3), linloop(ll, 4), linloop(ll, 5));
    end
    
    % Plane Surface
    fprintf(fid, '//Plane Surface \n');
    for ps = 1:length(psurf)
        fprintf(fid, 'Plane Surface(%d) = {%d}; \n', psurf(ps), psurf(ps));
    end
    
    % Ruled Surface
    fprintf(fid, '//Ruled Surface \n');
    for rs = 1:length(rsurf)
        fprintf(fid, 'Ruled Surface(%d) = {%d}; \n', rsurf(rs), rsurf(rs));
    end
    
    fclose(fid);
end
end


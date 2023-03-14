function edge = edge_length_triangle(var)
arguments
    var.mesh
    var.triangle
end
edge = zeros(1, 3);
edge(1, 1) = norm(var.mesh.nodes(var.triangle(1, 1), :) - var.mesh.nodes(var.triangle(1, 2), :));
edge(1, 2) = norm(var.mesh.nodes(var.triangle(1, 1), :) - var.mesh.nodes(var.triangle(1, 3), :));
edge(1, 3) = norm(var.mesh.nodes(var.triangle(1, 2), :) - var.mesh.nodes(var.triangle(1, 3), :));
end
function edge = edge_length_tetrahedron(var)
arguments
    var.mesh
    var.tetrahedron
end
edge = zeros(1, 6);
edge(1, 1) = norm(var.mesh.nodes(var.tetrahedron(1, 1), :) - var.mesh.nodes(var.tetrahedron(1, 2), :)); 
edge(1, 2) = norm(var.mesh.nodes(var.tetrahedron(1, 1), :) - var.mesh.nodes(var.tetrahedron(1, 3), :));
edge(1, 3) = norm(var.mesh.nodes(var.tetrahedron(1, 1), :) - var.mesh.nodes(var.tetrahedron(1, 4), :));
edge(1, 4) = norm(var.mesh.nodes(var.tetrahedron(1, 2), :) - var.mesh.nodes(var.tetrahedron(1, 3), :));
edge(1, 5) = norm(var.mesh.nodes(var.tetrahedron(1, 2), :) - var.mesh.nodes(var.tetrahedron(1, 4), :));
edge(1, 6) = norm(var.mesh.nodes(var.tetrahedron(1, 3), :) - var.mesh.nodes(var.tetrahedron(1, 4), :));
end
function roi = get_fieldbox_roi(var)
arguments
    var.fieldbox
    var.coordinates
end
mask_axis = zeros(length(var.coordinates), 3);
mask_axis(:, 1) = var.fieldbox.xmin < var.coordinates(:, 1) &  var.fieldbox.xmax > var.coordinates(:, 1);
mask_axis(:, 2) = var.fieldbox.ymin < var.coordinates(:, 2) &  var.fieldbox.ymax > var.coordinates(:, 2);
mask_axis(:, 3) = var.fieldbox.zmin < var.coordinates(:, 3) &  var.fieldbox.zmax > var.coordinates(:, 3);
roi = zeros(length(var.coordinates), 1, 'logical');
roi = all(mask_axis == 1, 2);
end
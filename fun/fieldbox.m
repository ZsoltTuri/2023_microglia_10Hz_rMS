function output = fieldbox(var)
% Local mesh density is adjusted using a field box generated at a specific
% mesh location.

arguments
    var.thickness 
    var.VIn  % mesh resolution within the fieldbox
    var.VOut % mesh resolution outside the fieldbox
    var.XMax
    var.XMin
    var.YMax
    var.YMin
    var.ZMax
    var.ZMin
end
output(1, 1) =  var.thickness;
output(2, 1) =  var.VIn;
output(3, 1) =  var.VOut;
output(4, 1) =  var.XMax;
output(5, 1) =  var.XMin;
output(6, 1) =  var.YMax;
output(7, 1) =  var.YMin;
output(8, 1) =  var.ZMax;
output(9, 1) =  var.ZMin;
end
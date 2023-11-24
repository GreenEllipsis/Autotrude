include <BOSL2/std.scad>
flat_side_length = 24.24;
p2 = [142,128];
p3 = [993,592];
image_length = sqrt(pow(p3.x-p2.x, 2) + pow(p3.y-p2.y,2));
scale_factor=flat_side_length / image_length;
p1 =   [1084+2.00/scale_factor,128+2.44/scale_factor];
A = p1 - p2; // A is p1 relative to origin
angle = -atan(A.y/A.x);
blade_points = [
    p1,
    [1380,412],
    [1726,605],
    [1601,833],
    [1235,632],
    p3,
    p2
    ];
    

//polygon(blade_points);
linear_extrude(1) mirror(FRONT) scale(scale_factor) rotate(angle) translate([-148,-128]) polygon(blade_points);

function rotate_point(p, angle=angle) =
    [(p[0] * cos(angle) - p[1] * sin(angle)), (p[0] * sin(angle) + p[1] * cos(angle))];
    
scaled_points = [for (p = blade_points) rotate_point([(p[0] - p2.x)*scale_factor, (p[1] - p2.y)*scale_factor])];
polygon(scaled_points);

// Now you can use or save the scaled and translated polygon.

   
    
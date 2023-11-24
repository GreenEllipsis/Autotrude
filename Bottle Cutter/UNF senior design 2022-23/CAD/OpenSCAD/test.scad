include <BOSL2/std.scad>
depth = 10;
plinth_diam=5;
plinthfn=32;


ycopies(l) cyl(h=depth, d=plinth_diam, $fn=plinthfn);
                cube([plinth_diam, l, depth], center=true);
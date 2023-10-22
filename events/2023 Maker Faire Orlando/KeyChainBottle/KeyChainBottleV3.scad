include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>
use <logo.scad>
use <recycling_symbol.scad>;


id=21.74;;
wall_t = 2;
od=id+wall_t*2;
logo_h=4;
base_h = 12;
$fs = 1; //.4; //0.4;
$fa = 9;//5; //5;
epsilon=0.01;
text_size = 4.7;
text_d = od - text_size/2;
logo_d = od+wall_t;
tag_fwd = od+2;
text_h = 0.9;
engrave_h = 0.7;
kern=[-0.6,-1.9,-.8,-.8,-.6,-.8,-2.7,-2.7,-2.7,-.6,-1.3,-2.7,-1.3,-2.7,-.8,-1.8]; // for DejaVu Sans
//kern=[-0.5,-1.6,-.7,-.7,-.5,-.7,-2.4,-2.4,-2.4,-.5,-1.1,-2.4,-1.2,-2.5,-.7,-1.6]; // for DejaVu Sans Condensed Bold
//kern=[-1,-1.9,-1,-1,-1,-1,-2.4,-2.4,-2.4,-1,-1.6,-2.4,-1.8,-2.7,-1,-1.9]; // for Calibri:syle=Bold
tab_d=8;
font="DejaVu Sans:style=Condensed Bold";
//font="Calibri:style=Bold";


module add() {
    // neck
    rotate(204) difference() {
        down(12) pco1810_neck();
        cube(od*2, anchor=TOP);
    }
    // stop ring
    torus(d_maj=od, d_min=2, anchor=TOP, $fs=2);
    // base
    up(epsilon) difference() {
        cyl(h=base_h, d=od, anchor=TOP);
        up(epsilon) cyl(h=base_h+epsilon, d=id, anchor=TOP);
    }
    // tab
    down(base_h) hull() {
        cyl(d=od, h=wall_t, anchor=BOTTOM)
        attach(FRONT,BACK) cyl(d=tab_d, h=wall_t);
    }
    // logo
//    down(base_h-0.6) rotate([180,0,0]) resize([logo_d, logo_d, 0], auto=true) logo(3d=true, bottle=false, nozzle=false);
    // text
    path = path3d(arc(360, d=od, angle=[-31, 359]));
    down(text_size + 5) 
    path_text(path, "greenellipsis.org", font=font, kern=kern,
    size=text_size, h=text_h, offset=-epsilon, lettersize = text_size);
}

module subtract() {
    // logo
      fwd(od/2+tab_d/2) cyl(h=base_h*10, d=5, anchor=CENTER);
      down(base_h) cube(od*2, anchor=TOP);
    // recycling symbol
    color("red") down(base_h-engrave_h+epsilon) recycling_symbol(type="", number=1, size=16.1, h=engrave_h, pos=[0,0,0], rot=[180,0,0], $fn=$fn, $fs=$fs, $fa=$fa);
    //logo
    down(base_h-(wall_t+epsilon)) rotate([180,0,0]) resize([id-2, id-2, 1], auto=true) linear_extrude(engrave_h) logo(3d=false, bottle=true, nozzle=true);
//
}

difference() { 
    add();
    subtract();
}
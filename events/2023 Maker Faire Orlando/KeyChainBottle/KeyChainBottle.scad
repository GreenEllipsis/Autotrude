include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>
use <logo.scad>
use <recycling_symbol.scad>;


big_d = 46;

// version_1 parameters
base_h = 2;
$fs = 1; //0.4;
$fa = 12; //5;
epsilon=0.01;
text_size = 4;
text_h = 3;
text_d = big_d - text_size/2;
strip_w = 3;
strip_l = 40+big_d;
strip_t = 0.8;
strip_catch_h = 0.6;
slot_w = strip_w*1.25;
slot_h = strip_t + strip_catch_h + 0.2;
slot_clearance_h = strip_t + strip_catch_h*2 + 0.4;

// version_2 parameters
clearance_d = 33;




module version2_add() {
    // logo
    rotate([180,0,0]) resize([big_d, big_d, 12]) logo(3d=true);
}
module version2_subtract() {
    // threads cutout
    cyl(d=clearance_d, h=20, anchor=BOTTOM);
}

module version2_add2() {
        down(12) pco1810_neck();
}

module version2_subtract2() {
        // trim bottom
    side=big_d*2;
    #cube([side,side,side], anchor=TOP);

}

module version1_add() {
    // threads
    down(12) pco1810_neck();
    cyl(d=big_d, h=base_h, anchor=BOTTOM, texture="trunc_ribs", tex_size=[4,0.5]);
    path = path3d(arc(360, d=big_d-text_size, angle=[-2, 359]));
    // text
    color("DodgerBlue") path_text(path, "greenellipsis.org", font="Lucida Sans Typewriter:style=Bold",
    size=text_size, h=text_h, offset=base_h, lettersize = text_size, normal=UP);
    path_reduce = path3d(arc(360, d=big_d-text_size, angle=[283, 290+90]));
    color("DodgerBlue") path_text(path_reduce, "Reduce", font="Lucida Sans Typewriter:style=Bold",
    size=text_size, h=text_h, offset=base_h, lettersize = text_size, normal=UP);
    path_reuse = path3d(arc(360, d=big_d-text_size, angle=[203, 195+90]));
    color("DodgerBlue") path_text(path_reuse, "Reuse", font="Lucida Sans Typewriter:style=Bold",
    size=text_size, h=text_h, offset=base_h, lettersize = text_size, normal=UP);
    // lanyard
    cube([strip_w, strip_l, strip_t], anchor=[0,-1,-1], spin=180)
        align(BACK+TOP) color("green") cube([strip_w, strip_catch_h, strip_catch_h]);

}

module version1_subtract() {
    side=big_d+epsilon;
    // trim bottom
    cube([side,side,side], anchor=TOP);
    //logo
    rotate([180,0,0]) resize([big_d*0.9, big_d*0.9, 1.6]) logo(3d=true);
    // recycling symbol
    recycling_symbol(type="", size=16.1, h=0.6, pos=[0,0,base_h-0.6+epsilon], rot=[0,0,180]);
    // slot
    fwd(big_d/2-5) rotate([-20,0,0]) cube([slot_w, slot_h, base_h*2], anchor=BOTTOM);
    down(-epsilon) fwd(big_d/2-5-1.5/2) cube([slot_w, slot_clearance_h, base_h*.7], anchor=BOTTOM);

}

difference() {
    union() {
        difference() {
            version2_add();
            version2_subtract();
        }
        version2_add2();
    }
    version2_subtract();
}
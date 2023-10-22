include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>
use <logo.scad>
use <recycling_symbol.scad>;


big_d = 46;

base_h = 1.8;
$fs = 2;//.4; //0.4;
$fa = 10;//5; //5;
epsilon=0.01;
text_size = 4.9;
text_d = big_d - text_size/2;
d=32.58;
logo_d = d+3;
clearance_d = 33;
tag_fwd = d+2;



module add() {
    sprue_d = 2;
    // base
    difference() {
        hull()
        {
            cyl(d=d, h=base_h, anchor=BOTTOM);
            fwd(tag_fwd) cyl(d=d, h=base_h, anchor=BOTTOM);
        }
        fwd(tag_fwd) cyl(d=d, h=base_h*4, , anchor=CENTER);
    }
    // logo
    up(0.8) fwd(tag_fwd) {
        rotate([180,0,0]) resize([logo_d, logo_d, 8.5]) logo(3d=true);
        torus(d_maj= d, d_min = sprue_d, $fa=5, $fs=0.4);
        fwd(2) rotate([90,0]) cyl(d=sprue_d, h=d-2, anchor=CENTER);
    }
    down(12) pco1810_neck();
}
module subtract() {
    side=d*4;
    skin_t = 0.2;
    text_h = base_h - skin_t;
    // trim bottom
    cube([side,side,side], anchor=TOP);
    // text
    path = path3d(arc(360, d=d-text_size/2, angle=[-72, 359]));
    rotate(180) mirror([0,1]) up(text_h/2) path_text(path, "GreenEllipsis.org", font="Lucida Sans Typewriter:style=Bold",
    size=text_size, h=text_h, offset=-epsilon, lettersize = text_size, normal=UP);
    // recycling symbol
    color("red") down(epsilon) recycling_symbol(type="", number=1, size=16.1, h=text_h+epsilon, pos=[0,0,skin_t+epsilon], rot=[0,0,180], $fn=$fn, $fs=$fs, $fa=$fa);

}

difference() { 
    add();
    subtract();
}
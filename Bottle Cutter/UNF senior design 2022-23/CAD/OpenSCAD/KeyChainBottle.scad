include <BOSL2/std.scad>
include <BOSL2/bottlecaps.scad>

// we are going for a modest interference fit onto the shaft. Set screws as a backup.
threaded_h = 26.85;
key_h = 15.20;
key_d = 27.8;
spline_t = 3.1;
spline_h = 1.8;
threaded_d = 37.10;
top_h = 1.5;
top_d = key_d-3;
shaft_d = 8.55; // 8.05 too small
screw_d = 2.8;
$fs = 0.4;
$fa = 5;
epsilon=0.01;

module add() {
    pco1810_cap(h=threaded_h, d=threaded_d, anchor=TOP, orient=DOWN, texture="knurled");
    up(threaded_h) 
    cylinder(d1=threaded_d, d2=key_d, h=key_h/2, anchor=BOTTOM)
        position(TOP) cylinder(d=key_d, h=key_h/2-top_h, anchor=BOTTOM)
        position(TOP) cylinder(d=top_d, h=top_h, anchor=BOTTOM);
}

module subtract() {
    cylinder(d=shaft_d, h= key_h) // shaft
    xcyl(h=threaded_d, d=screw_d); // set screw taps
    cube([shaft_d/2+spline_h, spline_t, key_h], anchor=BOTTOM+LEFT); // spline
}

difference() {
    add();
up(threaded_h+epsilon) subtract();
}
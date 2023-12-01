// (C) 2023 Brian Alano, Green Ellipsis
// Released under the Creative Common 2.0 International Attribution license (CC BY 2.0)
// https://creativecommons.org/licenses/by/2.0/deed.en

// Work in progress

include <BOSL2/std.scad>
spool_r = 144.68;
arc_len = 35;
big_hole_d = 2.0;
t = big_hole_d*5;
w = 15;
small_hole_d = 1.0;
lanyard_hole_d = 2.0;
epsilon= 0.01;
/* [Hidden] */
angle = arc_len/(2*3.1415*spool_r) * 360;

// basic body
difference() {
	pie_slice(r=spool_r+w, h=t, ang=angle, anchor=CENTER, spin=-angle/2) show_anchors();
	down(epsilon) cyl(r=spool_r, h=t+epsilon*4) ;
} 
// holes

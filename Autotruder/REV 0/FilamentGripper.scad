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
/* [Rendering] */
preview_fa = 12;
preview_fs = 5;
render_fa = 5;
render_fs = 0.4;
/* [Hidden] */
angle = arc_len/(2*3.1415*spool_r) * 360;
$fa = $preview ? preview_fa : render_fa;
$fs = $preview ? preview_fs : render_fs;

// basic body
//difference() {
//	pie_slice(r=spool_r+w, h=t, ang=angle, anchor=CENTER, spin=-angle/2) show_anchors();
//} 
// holes
//   torus(r_maj|d_maj, r_min|d_min, [center], ...) [ATTACHMENTS];
//   torus(or|od, ir|id, ...) [ATTACHMENTS];
difference() {
  intersection() {
    resize([0,0,t]) torus(r_maj=spool_r, r_min=w);
    color("red") pie_slice(r=spool_r+w, h=t, ang=angle, anchor=CENTER, spin=-angle/2);
  }
  torus(r_maj=spool_r, d_min = max(big_hole_d, lanyard_hole_d));
  down(epsilon) cyl(r=spool_r, h=t+epsilon*4) ;
  translate([spool_r-lanyard_hole_d*sqrt(2), 0, 0]) color("blue") cyl(d=lanyard_hole_d, h=t*3, anchor=TOP, orient=LEFT+BACK);
  translate([spool_r-big_hole_d*sqrt(2), 0, 0]) color("blue") cyl(d=big_hole_d, h=t*3, anchor=TOP, orient=LEFT+FWD);
  translate([spool_r-big_hole_d*3*sqrt(2), 0, 0]) color("blue") cyl(d=small_hole_d, h=t*3, anchor=TOP, orient=LEFT+FWD);
}
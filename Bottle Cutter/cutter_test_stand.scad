// cutter test stand
bearing_d = 4.8; //tap hole
//counterbore_sz = [5, 8.8]; // h, d
bearing_sz = [4.66, 16]; //h, d
overlap = 1.5; // tolerance is about 0.8, so 0.8+2x material thickness, minimum
base_sz= [130, 24, 5];
mount_d = 5;
extrusion_w = 20;
guide_d = 7.7; // tap hole?
$fs= $preview ? 4 : 0.4;
$fa = $preview ? 12 : 5;
rod_d=7.9;
rod_offset = 25;
rod_rotation=[5, -10, 0];
X = [1,0,0];

module reflect(v) {
  mirror(v) children();
  children();
}

r1 = guide_d/2+1;
r2 = bearing_sz.y/2;
guide_offset = sqrt(r1*r2+r1^2);
difference() {
  union() {
    // base
    cube(base_sz, center=true);
    //rod boss
    reflect(X) translate([rod_offset, guide_offset/2, -base_sz.z/2+2]) rotate(rod_rotation) cylinder(h=base_sz.z*2, d=rod_d*1.5);
  }
  //base mounting holes
  reflect(X) translate([base_sz.x/2-extrusion_w/2, 0]) cylinder(h=2*base_sz.z, d=mount_d, center=true);
  // bearing mounting holes
  reflect(X) translate([-overlap/2+bearing_sz.y/2,guide_offset/2]) cylinder(h=2*base_sz.z, d=bearing_d, center=true);
  // bottle guide mounting hole
  reflect(X) translate([0, -guide_offset/2]) cylinder(h=base_sz.z*2, d=guide_d, center=true);
  reflect(X) translate([rod_offset, guide_offset/2, -base_sz.z/2+2]) rotate(rod_rotation) cylinder(h=400, d=rod_d);
}
%translate([rod_offset, guide_offset/2, -base_sz.z/2+2]) rotate(rod_rotation) cylinder(h=400, d=rod_d);




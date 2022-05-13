w=20;
length=18.5;
base_h=5;
through_hole_d=5.15;
filament_h=34;
counterbore_d=7.75;
counterbore_h=1;
arm_t=5.9;
gusset_w=5.25;
bearing_d=22.25;
through_hole_x=8.9; // distance from back to edge of through_hole
epsilon=0.01;
bearing_wall_t=2.1;
bearing_t=7;

through_hole_center=[through_hole_x+through_hole_d/2, w/2];


module add() {
    // base
    cube([length, w, base_h]);
    // arm
    cube([arm_t, w, filament_h]);
    translate([0, w/2, filament_h]) rotate([0,90,0]) cylinder(h=bearing_t+bearing_wall_t, d=bearing_d+arm_t*2);
    // gusset
    translate([0,w-gusset_w,base_h]) rotate([-90, -90]) linear_extrude(gusset_w) polygon([[0,0], [length, 0], [0, length]]);
    
}
    
difference() {
    
    add();
    // through hole
    translate(through_hole_center) {
        translate([0,0,-epsilon]) cylinder(h=base_h+epsilon*2, d=through_hole_d);
        translate([0,0,base_h-counterbore_h]) cylinder(h=counterbore_h+epsilon, d=counterbore_d);
    }
    // bearing pocket
    translate([bearing_wall_t,w/2,filament_h]) rotate([0,90,0]) cylinder(h=bearing_t+epsilon, d=bearing_d);
    
}
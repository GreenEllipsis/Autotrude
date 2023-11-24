include <BOSL2/std.scad>
base_size=[150,178, 5];
mounting_hole_spacing = 110;
ring_center_offset = [0, 19, 0];
ring_t=5;
ring_funnel_h=12;
ring_od = 110.6;
ring_id = 110;
ring_h = 32;
bar_d = 12.45;
bar_spacing = 63.5;
ring_back = 19;
bar_forward = 70; // forward of ring center
bar_slot_h = 20;
m4_hole_d = 4.1;
$fs=1;
$fa=1;

module add() {
    // base
    cuboid(base_size, rounding=10, edges="Z") attach(TOP ) {
        // ring
        back(ring_back)    ring();
        // bar slots
        fwd(bar_forward) bar_slots();
    }
}

module subtract() {
//    mounting holes
    back(ring_back+51) mounting_holes();
    back(ring_back+51-100) mounting_holes();
    // fan hole
    back(ring_back) {
        cylinder(h=base_size.z*2, d=35, center=true);
       mirror_copy(RIGHT) mirror_copy(BACK) fwd(16) left(16) cylinder(h=base_size.z*2, d=m4_hole_d, center=true);   
    }
    // cutter mount
    cutter_slots();
    
    foot_mounts();
    
    // set screw holes
    fwd(bar_forward) up(bar_slot_h/2) cylinder(d=3.8, h=base_size.x, center=true, orient=LEFT);
}

module bar_slots() {
    mirror_copy(RIGHT) 
    left(bar_spacing/2)
    tube(od=bar_d+10, id=bar_d, h=bar_slot_h, anchor=BOTTOM);
}

module mounting_holes() {
    mirror_copy(RIGHT) left(mounting_hole_spacing/2) cylinder(h=base_size.z*2, d=5.3, center=true);
}

module slot(d, l, h) {
    ycopies(l) cyl(h=h, d=d);
    cube([d, l, h], center=true);
}

module cutter_slots() {
    back(42) left(45) ycopies(30) rotate(90) slot(l=40, h=base_size.z*2, d=m4_hole_d);
}

module foot_mounts() {
    xcopies(base_size.x-15) ycopies(base_size.y-15) cylinder(h=base_size.z*2, d=3.8, center=true);
}

module ring() {
    inner_ring_adjust=40;
    inner_ring_od = ring_id - inner_ring_adjust;
    inner_ring_angle = 90;
    
    module ring_add() {
            tube(id=ring_od, wall=ring_t, h=ring_h, anchor=BOTTOM)
            attach(TOP)
            tube(id1=ring_od, id2=ring_od+ring_funnel_h*2, od1=ring_od + ring_t*2, od2= ring_od +ring_t+ ring_funnel_h*2, h= ring_funnel_h, anchor=BOTTOM);
    }
    
    module inner_ring_add() {
    tube(od=inner_ring_od+4, wall=ring_t+2, h=ring_h-10, anchor=BOTTOM)
        attach(TOP)
        tube(od=inner_ring_od, wall=ring_t, h=ring_h-(ring_h-10), anchor=BOTTOM)
            attach(TOP)
            tube(id1=inner_ring_od-ring_t*2, id2=inner_ring_od-ring_funnel_h*2-ring_t, od1=inner_ring_od, od2= inner_ring_od-ring_funnel_h*2, h= ring_funnel_h, anchor=BOTTOM);
    }
    
    
    difference() {
        ring_add();
        cube(ring_od, anchor=BOTTOM+RIGHT+FRONT);
        up(ring_h/2) rot_copies(rots=[-15:-30:-205]) cylinder(h=ring_od, d=ring_h*2/3, $fn=4, orient=BACK);
    }
    
    left(inner_ring_adjust/2) difference() {
        inner_ring_add();
        pie_slice(
    h=ring_h+ring_funnel_h+1, r=ring_od, ang=360-inner_ring_angle, center=false,
    anchor = BOTTOM,
    spin=180+inner_ring_angle);
    }
}

difference() {
    add();
    subtract();
}
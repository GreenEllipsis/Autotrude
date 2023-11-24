// Brian Alano
// (C) Brian Alano, 2023, All rights reserved
// Autotruder REV 0

include <BOSL2/std.scad>
include <BOSL2/extrusion_vslot.scad>
include <BOSL2/power_supply.scad>

frame_length = 400;
frame_width = 130;
v_profile= 20;
thick_plate_t = 5;
thin_plate_t = 1.2;
default_fillet = 2.5;
M4_through_hole_d = 4.2;
M3_through_hole_d = 3.2;
ps_model = "JOYLIT S-120-24";
cross_brace_length = frame_width - v_profile*2;
vslot_distance =frame_width - v_profile;
// power supply parameters
ps = power_supply_model_params(ps_model);
hole_center_s = ps[4][1][1][0] - ps[4][0][1][0];
ps_hole_back_s = ps[1].y - ps[4][3][1][1];

// rendering
epsilon = 0.02;
// frame
module frame(anchor, spin, orient) {
    p1 = [frame_length/2, (frame_width-v_profile)/2, v_profile/2];
    size = [frame_length, frame_width, v_profile];
    anchors = [
        named_anchor("front_left_top",  [-p1.x, -p1.y, p1.z],, TOP, 0),
        named_anchor("front_left_bottom", [-p1.x, -p1.y, -p1.z], BOTTOM, 0),
        named_anchor("front_right_top", [p1.x, -p1.y, p1.z], TOP, 0),
        named_anchor("front_right_bottom", [p1.x, -p1.y, -p1.z], BOTTOM, 0),
        named_anchor("back_left_top", [-p1.x, p1.y, p1.z], TOP, 0),
        named_anchor("back_left_bottom", [-p1.x, p1.y, -p1.z], BOTTOM, 0),
        named_anchor("back_right_top", [p1.x, p1.y, p1.z], TOP, 0),
        named_anchor("back_right_bottom", [p1.x, p1.y, -p1.z], BOTTOM, 0)
    ];
    
    module shape() {
        rotate([0, 90]) {
            fwd((cross_brace_length+v_profile)/2) extrusion_vslot(profile=v_profile, height=frame_length, anchor=CENTER) ; 
            back((cross_brace_length+v_profile)/2) extrusion_vslot(profile=v_profile, height=frame_length, anchor=CENTER) ; 
        }
        rotate([90, 0]) {
            left((frame_length-v_profile)/2) extrusion_vslot(profile=v_profile, height=cross_brace_length, anchor=CENTER) ; 
            right((frame_length-v_profile)/2) extrusion_vslot(profile=v_profile, height=cross_brace_length, anchor=CENTER) ; 
        }
    }
    
    attachable(anchor,spin,orient, size=size, anchors=anchors) {
        color("DimGray") shape();
        children();
    }
}

// power supply assembly
module power_supply() {
    ps = power_supply_model_params(ps_model);
    hole_center_s = ps[4][1][1][0] - ps[4][0][1][0];
    echo(hole_center_s= hole_center_s);
    recolor("silver") power_supply_model(ps_model, spin=90 , anchor=CENTER, orient=UP) {
        right(hole_center_s/2) position("hole0") recolor("YellowGreen") basic_mounting_plate(slot_length=hole_center_s+M3_through_hole_d, anchor=CENTER+TOP, spin=90);
        right(hole_center_s/2) position("hole2") recolor("YellowGreen") basic_mounting_plate(slot_length=hole_center_s, slot_d =M3_through_hole_d, anchor=CENTER+TOP, spin=90);
    }
}

module basic_mounting_plate(width=10, slot_length=90,slot_d=3, center, anchor, spin=0, orient=UP) {
    slot_total_length = slot_length + slot_d;
    anchor = get_anchor(anchor, center, -[1,1,1], -[1,1,1]);
    size = scalar_vec3([width,frame_width,thick_plate_t]);
	anchors = [
		named_anchor("hole_back_top", [0,vslot_distance/2,thick_plate_t/2], TOP, 0),
		named_anchor("hole_front_top", [0,-vslot_distance/2,thick_plate_t/2], TOP, 0),
		named_anchor("hole_back_bottom", [0,vslot_distance/2,-thick_plate_t/2], BOTTOM, 0),
		named_anchor("hole_front_bottom", [0,-vslot_distance/2,-thick_plate_t/2], BOTTOM, 0),
		named_anchor("slot_front_top", [0,slot_length/2,thick_plate_t/2], TOP, 0),
        
	];
        
    module shape() {
        difference() {
            // plate
            linear_extrude(thick_plate_t, center=true) rect([width, frame_width], rounding = default_fillet);
            // slot through-holes
            yflip_copy() back(vslot_distance/2) cyl(d = M4_through_hole_d, h = thick_plate_t + 2*epsilon, anchor=CENTER);
            // power supply through-slot
            linear_extrude(thick_plate_t+2*epsilon, center=true) rect([M3_through_hole_d, slot_total_length], rounding = M3_through_hole_d/2);
        }
    }
    
    attachable(anchor,spin,orient, size=size, anchors=anchors) {
        shape();
        children();
    }
}

//frame() show_anchors();
//power_supply(anchor=TOP);
//basic_mounting_plate(anchor=CENTER)  show_anchors() position(FRONT) recolor("red") sphere(2);

//show_anchors();
//position(CENTER+BACK) back(90)
////cube(40, anchor=BOTTOM, orient=TOP);
//extrusion_vslot(profile=20, height=220, anchor=FRONT) ;

frame()
    // first power supply mounting bracket attached to frame
    attach("front_right_bottom") recolor("YellowGreen") right(ps_hole_back_s) basic_mounting_plate(slot_length=hole_center_s+M3_through_hole_d, anchor="hole_front_bottom")
    // power supply attached to first bracket
    attach("slot_front_top") recolor("silver") power_supply_model(ps_model, spin=90 , anchor="hole3", orient=UP)
    // second power supply mounting bracket attached to power supply
    attach("hole0") recolor("YellowGreen") basic_mounting_plate(slot_length=hole_center_s, slot_d =M3_through_hole_d, anchor="slot_front_top", spin=90, orient=UP);





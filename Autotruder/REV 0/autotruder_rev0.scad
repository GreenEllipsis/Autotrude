// Brian Alano
// (C) Brian Alano, 2023, All rights reserved
// Autotruder REV 0

include <BOSL2/std.scad>
include <BOSL2/extrusion_vslot.scad>
include <BOSL2/power_supply.scad>

/* [Model Selections] */
frame_options = "F"; // [F:V-Slot 2020 Extrusion]
power_supply_options = "P"; // [P:JOYLIT S-120-24]
control_board_options = "C"; // [C:MKS Robin Nano V3.x]

/* [Visibility] */
//hide_tags ="23269BBA03 power_supply";
hide_tags = "";

/* [Dimensions] */
frame_length = 400;
frame_width = 130;
thick_plate_t = 5;
thin_plate_t = 1.2;
default_fillet = 2.5;

/* [Hole Sizes] */
M4_through_hole_d = 4.2;
M3_through_hole_d = 3.2;

/* [Hidden] */
// options processing
v_profile= frame_options == "F" ? 20 : 0;
ps_model = power_supply_options == "P" ? "JOYLIT S-120-24" : "unsupported";

// frame calculations
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
        recolor("DimGray") tag("frame") shape();
        children();
    }
}

// power supply assembly
//module power_supply() {
//    ps = power_supply_model_params(ps_model);
//    hole_center_s = ps[4][1][1][0] - ps[4][0][1][0];
//    echo(hole_center_s= hole_center_s);
//    recolor("silver") power_supply_model(ps_model, spin=90 , anchor=CENTER, orient=UP) {
//        right(hole_center_s/2) position("hole0") recolor("YellowGreen") basic_mounting_plate(slot_length=hole_center_s+M3_through_hole_d, anchor=CENTER+TOP, spin=90);
//        right(hole_center_s/2) position("hole2") recolor("YellowGreen") basic_mounting_plate(slot_length=hole_center_s, slot_d =M3_through_hole_d, anchor=CENTER+TOP, spin=90);
//    }
//}

module basic_mounting_plate(width=10, slot_length=90,slot_d=3, text, center, anchor, spin=0, orient=UP) {
    slot_total_length = slot_length + slot_d;
    txt = is_def(text) ? text : "";

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
            // part number
            right(width*.5) down(thick_plate_t/2) rotate([0,180,-90]) linear_extrude(1, center=true) text(text=txt, size=M3_through_hole_d, halign="center", valign="top");        }
        
    }
    
    attachable(anchor,spin,orient, size=size, anchors=anchors) {
        shape();
        children();
    }
}

// M3 slotted mounting bracket
module part_23269BBA03(center, spin=0) {
        tag("23269BBA03") recolor("YellowGreen") 
        basic_mounting_plate(
          slot_length=hole_center_s+M3_through_hole_d, 
          slot_d =M3_through_hole_d,
          text="P/N 23269BBA03", 
          anchor="hole_front_bottom", 
          center=center, 
          spin=spin
        )
        children();
}

module control_board_assy() {
  //Project Box dimensions
  // 89.6 x 130.2
  pcb_w = 84;
  pcb_l = 110;
  cb_padding_x = 1.8+1;
  cb_padding_y = 1.8+8.5;
  pcbHeight = 1.6;
  basePlaneThickness  = 1.25;
  standoffHeight = 6;
  pcbPos = [pcb_w+cb_padding_x, pcb_l+cb_padding_y, basePlaneThickness + standoffHeight];
  force_tag("control_board_assy") union() {
    color("LightYellow") translate([0,0,0]) rotate([0,0,0]) 
      import("23329BBA01 MKS Robin Nano V3 Project Box Base.stl");
    color("YellowGreen") 
      import("23329BBA02 MKS Robin Nano V3 Project Box Lid.stl");
    color("Gray") translate(pcbPos) rotate(90)
      import("MKS Robin Nano V3.1.stl");
  }
  children();
}

hide(hide_tags) 
frame()
// first power supply mounting bracket attached to frame
attach("front_right_bottom")  right(ps_hole_back_s) part_23269BBA03()
// power supply attached to first bracket
attach("slot_front_top") recolor("silver") 
  tag("power_supply") power_supply_model(ps_model, spin=90 , anchor="hole3", orient=UP)
// second power supply mounting bracket attached to power supply
attach("hole0") left(ps_hole_back_s) part_23269BBA03(spin=-90);

hide(hide_tags) translate([-70, 45, -10]) rotate([180,0,-90]) control_board_assy();

// TESTS
//part_23269BBA03(center=true) show_anchors();
//control_board_assy();


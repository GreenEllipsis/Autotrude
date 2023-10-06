heater_z = 4.25;
ptfe_to_bracket_x = 60.0;
bracket_to_through_hole_x = 13.0;
width=52.0;
epsilon = 0.01;
bracket_t = 3.05;
screw_head_h = 5;
wall_t = bracket_t;
wall_h = 18.7 + screw_head_h;
bracket_h = 31.60;
bracket_to_hole_x = 19.25;
base_hole_d = 5.4;
base_h = screw_head_h + bracket_t;
bracket_to_center_y = 28.6;
bracket_to_center_z = 16.3;
bracket_to_base_hole1 = 7.95;
filament_slot_w = 5;
filament_d = 1.85;
filament_slot_d = 2;
ptfe_boss_h = 2;
ptfe_boss_id = 4;
ptfe_boss_od = ptfe_boss_id + 2;
base_hole1_to_hole2 = 22.1;
$fs = 0.4;
$fa =4;


module form_support() {
    module add() {
        // base
        cube([ptfe_to_bracket_x - (bracket_h - bracket_t), width, base_h]);
        translate([0, 0, base_h]) hull() 
        {
            translate([ 0, 0, 0]) cube([ptfe_to_bracket_x - bracket_to_through_hole_x, width, epsilon]);
            translate([0, 0, heater_z - epsilon]) cube([ptfe_to_bracket_x, width, epsilon]);
        }
        //wall
        translate([-wall_t, 0, 0]) cube([wall_t, width, wall_h]);
        // ptfe boss
        translate([-epsilon, bracket_to_center_y - filament_slot_w/2, bracket_to_center_z + screw_head_h]) {
            //filament slot
            rotate([0, 90]) hull() {
                cylinder(d=ptfe_boss_od, h=ptfe_boss_h);
                translate([0, filament_slot_w]) cylinder(d=ptfe_boss_od, h=ptfe_boss_h);

            }
        }
    }

    module subtract() {
        filament_slot_h = wall_t*2 + ptfe_boss_h*2;
        // base holes
        translate([ptfe_to_bracket_x - bracket_to_hole_x, bracket_to_base_hole1, 0]) {
            cylinder(d= base_hole_d, h=bracket_h);
            translate([0, base_hole1_to_hole2, 0]) cylinder(d= base_hole_d, h=bracket_h);
        }
        translate([epsilon, bracket_to_center_y - filament_slot_w/2, bracket_to_center_z + screw_head_h]) {
            //filament slot
            rotate([0, -90]) hull() {
                cylinder(d=filament_d, h=filament_slot_h, center=false);
                translate([0, filament_slot_w]) cylinder(d=filament_d, h=filament_slot_h, center=false);
            }
            //ptfe slot
            rotate([0, 90]) hull() {
                cylinder(d=ptfe_boss_id, h=ptfe_boss_h*2, center=true);
                translate([0, filament_slot_w]) cylinder(d=ptfe_boss_id, h=ptfe_boss_h*2, center=true);
            }
        }
    }
    
    difference() {
        add();
        subtract();
    }
}

form_support();
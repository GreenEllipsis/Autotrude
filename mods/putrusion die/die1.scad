$fs=.4;
$fa=5;
epsilon=0.01;

module die1() {
    start_d = 0.6;
    start_r = start_d/2;
    end_d = 1.6;
    end_r = end_d/2;
    h=10.5;
    block_size=[23,16,23];
    slot_pos = [block_size.x/2-h/2, block_size.y/2+end_d-start_d];
    nozzle_pos = [block_size.x/2+h/2-end_d, block_size.y/2];
grub_screw_pos=[2,8];
screw_size=3;
clamp_screw_pos=[20.5,8];
heater_pos=[14.5,4];
heater_size=6;
thermistor_pos=[2,5.75];
thermistor_size=3.1;
cube_size=[(block_size.x-heater_pos.x)*1.01, 1.6, block_size.y*1.01];
    module ideal() {
        hull() {
            translate(concat(slot_pos, block_size.z)) cube([h-end_d, start_d, epsilon]);
            translate(concat(nozzle_pos, -epsilon)) cylinder(epsilon, end_d);
        }
    }    

    difference()
    {
        translate([-0,-0,0]) cube(block_size);
        hull() {
            translate([0,0, block_size.z])         
                linear_extrude(epsilon) projection(cut=false) ideal();

            translate(concat(nozzle_pos, -epsilon)) cylinder(epsilon, end_d);
        }
        
    }
}


// E3D V6
module e3dv6() {
    difference() {
        block=[23,16,11.5];
        grub_screw_pos=[2,8];
        screw_size=3;
        nozzle_size=6;
        nozzle_pos=[8,8];
        clamp_screw_pos=[20.5,8];
        heater_pos=[14.5,4];
        heater_size=6;
        thermistor_pos=[2,5.75];
        thermistor_size=3.1;
        cube_size=[(block.x-heater_pos.x)*1.01, 1.6, block.y*1.01];
        cube(block);
        translate([0,0,-epsilon]) {
            translate(grub_screw_pos) cylinder(h=block.z*1.01/2, d=screw_size);
            translate(nozzle_pos) cylinder(h=block.z*1.01, d=nozzle_size);
            translate(clamp_screw_pos) cylinder(h=block.z*1.01, d=screw_size);
        }
        mirror([0,0,1]) rotate([-90,0,0]) translate([0,0,-epsilon]) {
            translate(heater_pos) cylinder(h=block.y*1.01, d=heater_size);
            translate(thermistor_pos) cylinder(h=block.y*1.01, d=thermistor_size);
            translate([heater_pos.x+cube_size.x/2, heater_pos.y, block.y/2]) cube(cube_size, center=true);
        }
    }
}

die1();
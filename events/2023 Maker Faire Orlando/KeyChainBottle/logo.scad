/*
logo v1.1.0
(C) 2023 Brian Alano
# Minor changes
added nozzle=true|false, bottle=true|false, arrows=true|false parameters to logo()
*/
$fa = 12;//6;
r=100;
t=12;
theta=90;
arrow_w = 20;
coin_d = 50;
coin_h = 3;
e=0.01;
text="   Green Ellipsis  ";
text_scale=2.7;
text_radius=coin_d/5;

// todo add recycling symbol
// Utility functions
module sector(radius, angles, fn = 24) {
    r = radius / cos(180 / fn);
    step = -360 / fn;

    points = concat([[0, 0]],
        [for(a = [angles[0] : step : angles[1] - 360]) 
            [r * cos(a), r * sin(a)]
        ],
        [[r * cos(angles[1]), r * sin(angles[1])]]
    );

    difference() {
        circle(radius, $fn = fn);
        polygon(points);
    }
}

module arc(radius, angles, width = 1, fn = 24, 3d=false) {
    if (3d) {
        arc3d(radius, angles, width, fn);
    } else {
        difference() {
            sector(radius + width, angles, fn);
            sector(radius, angles, fn);
        }
    }
} 

module arc3d(radius, angles, width, fn) {
    rotate(angles.x) rotate_extrude(angle=angles.y-angles.x)
    translate([radius+width/2, 0]) circle(d=width);
}

module arrowhead(width = 1, angle=0, half=false) {
    pts = half == false ? 
        width*[[0,0], [1,-0.2], [0, 1], [-1, -0.2]]
        : width*[[0,0], [1,-0.2], [0, 1]];
    rotate(angle+90) polygon(pts);
}

module arrowhead3d(arrow_w, angle, scale=[1,1,1]) {
 scale(scale) rotate([0, -90, angle]) rotate_extrude(angle=360) arrowhead(arrow_w, -90, half=true);
}

function included_angle(r, s) = s/r*180/3.14159;

module arrow(r, t, a1=0, a2=90, end="", 3d=false) {  
    if (3d) {
        difference() {
            union() {
                arc(r - t/2, [a1, a2], t, 360/$fa, 3d=true);
                translate(r*[cos(a2), sin(a2)]) rotate(a2-90) arrowhead3d(arrow_w,0, scale=[1,1,0.5]);
                if (end=="round") color("red", 0.5) translate(r*[cos(a1), sin(a1)]) circle(t/2);
            }
            if (end=="fork") translate(r*[cos(a1), sin(a1)]) rotate(a1+45) {
                cube(t*sqrt(2), center=true);    
            }
        }
    } else {
        difference() {
            union() {
                arc(r - t/2, [a1, a2], t, 360/$fa);
                translate(r*[cos(a2), sin(a2)]) rotate(a2-90) arrowhead(arrow_w,0);
                if (end=="round") color("red", 0.5) translate(r*[cos(a1), sin(a1)]) circle(t/2);
            }
            if (end=="fork") translate(r*[cos(a1), sin(a1)]) rotate(a1+45) square(t*sqrt(2)*[1,1], center=true);    
        }
    }
}

module bottle(s, 3d) {
    // cap
    
    cap_size=[s*.2,s*.2];
    bottle_w = s*2*.4;
    bottle_h = s*1.15;
    
    module bottle2d() {
        translate([0, r*0.8]) {
            offset(s*.05) offset(-s*.05) square(cap_size, center=true);
            // lip
            translate([0, -cap_size.y/2]) {
                offset(s*.02) offset(-s*.02) square([s*.25,s*.05], center=true);
                // neck
                translate([0, -cap_size.y/4]) {
                    square([cap_size.x*0.8,cap_size.y*.5], center=true);
                    translate([0,-cap_size.y*.75/2-bottle_w/2+s*.05]) {
                        circle(d=bottle_w);
                        translate([0, -bottle_h/2]) offset(s*0.2) offset(-s*0.2) square([bottle_w, bottle_h], center=true);
                    }
                }
            }
        }
    }
    
    if (3d) {
        max_y = cap_size.y + s*.05 + cap_size.y*0.5 + bottle_w + bottle_h;
        rotate([-90,0,0]) rotate_extrude(angle=360) difference() {
            bottle2d();
            translate([0, -max_y]) square([bottle_w, max_y*2]);
        }
    } else {
        bottle2d();
    }
}

module arrows(3d=false, nozzle=true) {
    gap = -t/4; // degrees
    end_gap = gap/2; // +included_angle(r, t/2); // for round end
    start_gap = gap/2+included_angle(r, arrow_w);
    drip_r = t/8;
    arrow(r, t, -90, 30-start_gap, 3d=3d);
    arrow(r, t, 30+end_gap, 150-start_gap, "fork", 3d);
    arrow(r, t, 150+end_gap, 270-start_gap-15, "fork", 3d);
    translate([-drip_r-t/2,-r-t/2]) {
        if (3d) {
            translate([0, t/2]) rotate([0,90,0]) cylinder(d=t, h=drip_r+t);
        } else {
            square([drip_r+t/2, t]);
        }
    }
    if (nozzle) {
        translate([-drip_r-t/2,-r+t/2+drip_r]) {
            arc(radius=drip_r, angles=[180, 270], width=t, fn=360/$fa, 3d=3d);
            translate([0,0]) {
                arc(radius=drip_r, angles=[90,180], width=t, fn=360/$fa, 3d=3d);
                translate([0,drip_r*2+t]) {
                    arc(radius=drip_r, angles=[-90,0], width=t, fn=360/$fa, 3d=3d);
                    translate([drip_r+t/2, t/8]) {
                        if (3d) {
                            rotate([-90,0,0]) cylinder(d=t, h=t/4, center=true);
                        } else {
                            square([t, t/4], center=true);
                        }
                        // nozzle
                        nozzle_s = t*.35;
                        translate([0, t/4/2 + t/8]) {
                            if (3d) {
                                rotate([-90,0,0]) rotate_extrude(angle=360) polygon(nozzle_s*[[1, 0], [3, 2], [0.1, 2]]);
                                translate([0, nozzle_s*2+nozzle_s]) {
                                    rotate([-90,0,0]) cylinder(d=nozzle_s*10, h=nozzle_s*2, center=true, $fn=6);
                                    translate([0, nozzle_s*5/2]) rotate([-90,0,0]) cylinder(d=nozzle_s*8, h=nozzle_s*3, center=true);
                                }
                            } else {
                                polygon(nozzle_s*[[1, 0], [3, 2], [-3, 2], [-1, 0]]);
                                translate([0, nozzle_s*2+nozzle_s]) {
                                    square([nozzle_s*10, nozzle_s*2], center=true);
                                    translate([0, nozzle_s*5/2]) square([nozzle_s*8, nozzle_s*3], center=true);
                                }
                            }
                            
                        }
                    }
                }
            }
        } // endif nozzle
    }
}

module logo(3d=false, bottle=true, arrows=true, nozzle=true) {
    if (bottle) bottle(r*.7, 3d=3d);
    if (arrows) mirror([-1,0,0]) arrows(3d=3d, nozzle=nozzle);
}

module coin_blank(h=coin_h) {
    cylinder(d=coin_d, h=h, center=true);
}

// original by https://openhome.cc/eGossip/OpenSCAD/TextCircle.html
// modified by Brian Alano
// scale: multiply text size by scale
module revolve_text(radius, chars, font="Courier New; Style = Bold", scale=1) {
    PI = 3.14159;
    circumference = 2 * PI * radius;
    chars_len = len(chars);
    font_size = scale * circumference / chars_len;
    step_angle = 360 / (chars_len);
    for(i = [0 : chars_len - 1]) {
        rotate(-i * step_angle) 
            translate([0, radius + font_size / 2, 0]) 
                text(
                    chars[i], 
                    font = font, 
                    size = font_size, 
                    valign = "baseline", halign = "center"
                );
    }
}

module ring(d1, d2, h, center=false) {
    inner_d = d1 > d2 ? d2 : d1;
    outer_d = d1 > d2 ? d1 : d2;
    difference() {
        cylinder(h=h, d=outer_d, center=center);
        translate([0,0,-h/2]) cylinder(h=h*2, d=inner_d, center=center);
    }
}

module words() {
    #revolve_text(text_radius, text, font="Corbel:style=Bold", scale=text_scale);
    //revolve_text(coin_d*.3/2, " Green Ellipsis", font="Corbel:style=Bold", scale=1.5);
}

module coin(3d=false) {
    text_h = 1.6;
    emboss_h = 3d ? 4 : 1;
    h = 3d ? 2 : coin_h;
    module add() {
        coin_blank(h=h);
        translate([0,0, h/2]) {
            resize([coin_d*.9, coin_d*.9, 0], auto=[true, true, true]) {
                if (3d) {
                    difference() {
                        logo(3d);
                        translate([0,0,-0.1]) rotate([180,0,0]) cylinder(r=r*2, h=t*4);
                    }
                } else {
                    linear_extrude(1) logo();
                }
            }
            ring(coin_d, coin_d - 0.8, 0.3);
        }
    }

    
    difference() {
        add();
        rotate([0,180,0]) translate([0,0, coin_h/2-text_h+e]) linear_extrude(text_h) words();
    }
}

//ring(coin_d, coin_d - 0.8, 0.3);


//coin(3d=true);
//coin_blank();
//words();

//x = 35;
//
gap = -t/4; // degrees
start_gap = gap/2+included_angle(r, arrow_w);
//arrow(r, t, -90, 30-start_gap, 3d=true);

//arrows(true);
//%arrows(true);
logo(bottle=false, nozzle=false);
//resize([20, 20, 4]) logo(3d=true);
//logo(false);


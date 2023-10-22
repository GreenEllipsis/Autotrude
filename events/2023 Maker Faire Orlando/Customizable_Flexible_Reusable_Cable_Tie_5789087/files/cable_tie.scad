//TPU Cable Tie
//By Ben Caron 12/30/2022
// modified for TPU or PET by Brian Alano
// V1.1.0

/*[ Basic ]*/

bump_count = 3;
bump_shape = 1; //[1:one-way, 2:both-ways]
make_double_tie = 0; //[0:false, 1:true]
filament = "PET";// ["PET","TPU"]

/*[ Double Slot ]*/

make_double_slot = 0; //[0:false, 1:true]
//spacing between each slot
double_slot_spacing = 6;

/*[ Mounting Hole ]*/

make_mounting_hole = 0; //[0:false, 1:true]
mounting_hole_ID = 3.5; 
mounting_hole_OD = 9;
//distance from slot to hole center
mounting_hole_offset = 12;
mounting_hole_thick = 2; //[0.2:0.2:4]

/*[ Advanced ]*/
base_thick = .6; //[0.2:0.2:4]
end_thick = 0.6; //[0.2:0.2:4]
base_wide = 3;
end_radius = 7;
slot_height = 1.1;
//distance from last bump to slot
slot_distance = 45;
tab_slot_w = 0.4;
// ratio of tab length to base thickness, defining stiffness of the tab
tab_slot_length_ratio = 7.5; 

bump_pitch = 8;
bump_height = 1.5;

tip_long = 5;
tip_wide = 2;   


/* [Hidden] */
epsilon = 0.01;
quality = 10;  //curve quality
quality_small = quality*4;
quality_large = quality*4*2;
tab_slot_length = base_thick*tab_slot_length_ratio;

slot_long = base_wide+1;
base_long = slot_distance + (bump_count-1)*bump_pitch + bump_height;
mounting_hole_offset2 = mounting_hole_offset + double_slot_spacing*make_double_slot;
_end_thick = max(end_thick, base_thick);
_mounting_hole_thick = max(mounting_hole_thick, end_thick);

//Main build
double_tie()
{
    union()
    {
        if(make_mounting_hole)
            build_BaseWithHole();
        else
            build_Base();
        place_bumps();
    }
}


module build_BaseWithHole()
{
    
    difference()
    {
        
        union()
        {
            build_Base();
            
            //mounting hole outside
            linear_extrude(_mounting_hole_thick)
            translate([-mounting_hole_offset2,0])
            circle(mounting_hole_OD/2, $fn=quality_large);
            
            //connect mounting hole to base
            linear_extrude(min(_end_thick, _mounting_hole_thick))
            translate([-mounting_hole_offset2, -(mounting_hole_OD<=end_radius*2?mounting_hole_OD:end_radius*2)/2])
            square([mounting_hole_offset-slot_height/2-epsilon, mounting_hole_OD<=end_radius*2?mounting_hole_OD:end_radius*2]);
        }
        
        //mounting hole cut
        translate([-mounting_hole_offset2, 0, -_mounting_hole_thick/2])
        linear_extrude(_mounting_hole_thick*2)
        circle(mounting_hole_ID/2, $fn=quality_small);
    }
}

module build_Base()
{
    union()
    {
        linear_extrude(base_thick)
        union()
        {
            //base
            translate([slot_height/2+end_radius*.75,-base_wide/2])
            square([base_long-slot_height/2-end_radius*0.75,base_wide]);
            
            //Tip
            translate([base_long,0])
            polygon([[tip_long,-tip_wide/2],[tip_long,tip_wide/2],[-0,base_wide/2],[-0,-base_wide/2]]);
            
            
        }
            
        linear_extrude(_end_thick)
        difference()
        {
            union()
            {
                //end
                circle(end_radius, $fn=quality_large);
                
                if(make_double_slot)
                {
                    translate([-double_slot_spacing,0])
                    circle(end_radius, $fn=quality_large);
                    
                    translate([-double_slot_spacing/2,0])
                    square([double_slot_spacing,end_radius*2],center=true);
                }
            }
            
            //slot
            square([slot_height,slot_long], center=true);
            if(make_double_slot)
            {
                translate([-double_slot_spacing,0])
                square([slot_height,slot_long], center=true);
            }
            // tabs
            if (filament == "PET") {
                translate([0,(slot_long-tab_slot_w)/2]) square([tab_slot_length, tab_slot_w], center=true);
                translate([0,-(slot_long-tab_slot_w)/2]) square([tab_slot_length, tab_slot_w], center=true);
            }
        }
    }
}

module build_Bump_shape()
{
    if(bump_shape == 2)
        build_Bump();
    else
    {
        translate([-bump_height, 0])
        scale([2,1,1])
        difference()
        {
            build_Bump();
            
            linear_extrude(bump_height+base_thick+epsilon)
            translate([-bump_height, -base_wide/2])
            square([bump_height+epsilon, base_wide+epsilon]);
        }
    }
}

module build_Bump()
{
    rotate([0,-90,0])
    intersection()
    {
        translate([base_thick, -base_wide/2])
        rotate([-90,-90,0])
        linear_extrude(base_wide)
        difference()
        {
            circle(bump_height, $fn=quality_small);
            
            translate([-bump_height,-bump_height*2-epsilon])
            square([bump_height*2, bump_height*2]);
        }
        
        cut_ofs = 1;
        cut_rad = sqrt(pow(base_wide/2,2)+pow(cut_ofs,2));
        translate([base_thick-cut_ofs, 0, -bump_height])
        linear_extrude(bump_height*2)
        circle(cut_rad, $fn=quality_small);
    }
}

module place_bumps()
{
    translate([slot_distance,0,0])
    for ( i = [0:1:bump_count-1])
    {
        translate([i*bump_pitch,0,0])
        build_Bump_shape();
    }
}

module double_tie()
{
    union()
    {
        //original
        translate([mounting_hole_offset2,0])
        children();
        
        if(make_double_tie)
        {
            //mirrored copy
            mirror([1,0,0])
            translate([mounting_hole_offset2,0])
            children();
            
            if(!make_mounting_hole)
            {
                //connect the two copies
                linear_extrude(base_thick)
                square([mounting_hole_offset*2-slot_height,(base_wide+end_radius*2)/2], center=true);
            }
        }
    }
}

module copy_mirror(vec)
{
    children();
    mirror(vec)
    children();
}


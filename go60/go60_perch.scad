
// MoErgo Go60 Perch - V1.2
// Keyboard positioning base with a centered portrait phone cradle.
//
// Units: mm

// ---------- Measured OEM bottom bar ----------
bar_length = 106.43;
bar_width  = 11.89;

// ---------- Pocket fit ----------
clearance_each_side = 0.21;
pocket_length = bar_length + 2*clearance_each_side;  // 106.85
pocket_width  = bar_width  + 2*clearance_each_side;  // 12.31
pocket_depth  = 2.0;

// ---------- Printed structure ----------
base_thickness = 4.5;
pad_border = 4.0;
rail_width = 8.0;

// ---------- Phone cradle ----------
// The 18 mm slot leaves room for a phone up to 16 mm thick with its case.
phone_width = 82;
phone_slot_depth = 18;
phone_lip_width = 48;
phone_lip_thickness = 6;
phone_lip_height = 10;
phone_back_width = 64;
phone_back_thickness = 6;
phone_back_height = 48;
phone_recline_deg = 15;

// ---------- Positioning ----------
splay_deg = 15;
near_inner_gap = 73.0;

// Crossbar Y locations
rear_rail_y  = 34;
front_rail_y = -34;

// ---------- Derived ----------
pad_length = pocket_length + 2*pad_border;
pad_width  = pocket_width  + 2*pad_border;

near_centerline_gap = near_inner_gap + pocket_width;

s = sin(splay_deg);
left_cx  = -near_centerline_gap/2 - s*pocket_length/2;
right_cx = -left_cx;

// 2D capsule, long axis along local Y
module capsule2d(len, wid) {
    r = wid/2;
    hull() {
        translate([0, -(len/2-r)]) circle(r=r, $fn=64);
        translate([0,  (len/2-r)]) circle(r=r, $fn=64);
    }
}

module pad2d(cx, ang) {
    translate([cx,0])
        rotate(ang)
            capsule2d(pad_length, pad_width);
}

module pocket2d(cx, ang) {
    translate([cx,0])
        rotate(ang)
            capsule2d(pocket_length, pocket_width);
}

// A deliberately over-long rail.
// It runs from the centerline of the left pad to the centerline of the right
// pad, guaranteeing substantial overlap with each angled side pad.
module rail2d(ypos) {
    rail_len = right_cx - left_cx;
    translate([(left_cx + right_cx)/2, ypos])
        square([rail_len, rail_width], center=true);
}

module perch_outline_2d() {
    union() {
        pad2d(left_cx,   splay_deg);
        pad2d(right_cx, -splay_deg);
        rail2d(rear_rail_y);
        rail2d(front_rail_y);
    }
}

module phone_cradle() {
    // The deck joins the rear rail; the narrow stem joins the front rail.
    // Its front edge stays inside the gap between the keyboard pockets.
    linear_extrude(height=base_thickness)
        union() {
            translate([-phone_width/2, -18]) square([phone_width, 52]);
            translate([-10, front_rail_y]) square([20, 20]);
        }

    // The front lip keeps the phone's bottom edge in the slot.
    translate([-phone_lip_width/2,
               -phone_slot_depth/2-phone_lip_thickness,
               base_thickness-0.1])
        cube([phone_lip_width, phone_lip_thickness,
              phone_lip_height+0.1]);

    // A shallow recline prints upright without support material.
    hull() {
        translate([-phone_back_width/2, phone_slot_depth/2,
                   base_thickness-0.1])
            cube([phone_back_width, phone_back_thickness, 1]);
        translate([-phone_back_width/2,
                   phone_slot_depth/2 + tan(phone_recline_deg)*phone_back_height,
                   base_thickness+phone_back_height-1])
            cube([phone_back_width, phone_back_thickness, 1]);
    }
}

union() {
    difference() {
        linear_extrude(height=base_thickness)
            perch_outline_2d();

        // Shallow locating pockets
        translate([0,0,base_thickness-pocket_depth])
            linear_extrude(height=pocket_depth+0.2) {
                pocket2d(left_cx,   splay_deg);
                pocket2d(right_cx, -splay_deg);
            }
    }
    phone_cradle();
}

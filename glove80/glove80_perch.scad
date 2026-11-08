// Glove80 perch: inner foot sockets, desk-supported outer feet, and a phone cradle.
// Units: millimetres. The leg centres come from MoErgo's custom-mounting diagram.
// Socket fit is a starting value; measure your own feet before printing.

// ---------- Fit and positioning ----------
foot_socket_diameter = 12.5;  // opening measured from the 22° on-desk reference
socket_wall = 2.5;
socket_insert_depth = 6;
socket_base_flare = 3;
socket_pad_border = 1;
socket_rim_offset = -4.5;
socket_base_shift_fraction = 0.18;
outer_socket_height = 18;
tent_deg = 22;
with_palmrests = false;   // adds the palm-rest inner socket on each half
outer_sockets = false;    // true gives the outer feet raised locating sockets too
base_thickness = 4.5;
frame_rail_width = 7;
cross_rail_width = 8;
inner_foot_gap = 111.3;     // thumb-row socket spacing in the reference mount
splay_deg = 10.1;           // rear-to-thumb socket vector in the reference mount

// MoErgo leg-stud positions, oriented with the rear row first. The first four
// points are on the keyboard: rear outer, rear inner, middle outer/fixed,
// middle inner/thumb. The final two points are on the optional palm rest.
// Local x grows toward the centre of the keyboard.
leg_centres = [
    [0, -82.375], [101, -82.375],
    [0,   6.625], [140, 6.625],
    [0,  82.375], [101, 82.375]
];

// ---------- Phone cradle ----------
phone_width = 82;
phone_slot_depth = 18;
phone_lip_width = 48;
phone_lip_top_width = 38;
phone_lip_thickness = 6;
phone_lip_height = 10;
phone_back_width = 64;
phone_back_top_width = 52;
phone_back_thickness = 6;
phone_back_height = 48;
phone_recline_deg = 15;
phone_forward = 4;
phone_rearward = 45;  // shifts the phone away from the thumb clusters
phone_cable_gap = 14;           // space between the front lip halves
rear_cable_width = 18;          // rear entry for a charging connector
rear_cable_side_height = 11;    // chamfered top avoids a long bridge
with_front_logo = true;
logo_height = 23;
logo_recess_depth = 0.8;

$fn = 64;

socket_outer_diameter = foot_socket_diameter + 2*socket_wall;
foot_pad_diameter = socket_outer_diameter + socket_base_flare
                    + 2*socket_pad_border;
active_leg_indices = outer_sockets
    ? (with_palmrests ? [0, 1, 2, 3, 4, 5] : [0, 1, 2, 3])
    : (with_palmrests ? [1, 3, 5] : [1, 3]);

function socket_rim_height(point) =
    (outer_sockets ? outer_socket_height : socket_rim_offset)
    + tan(tent_deg)*point[0];

function world_foot(side, point) = [
    side*(inner_foot_gap/2
          + cos(splay_deg)*(140-point[0])
          + sin(splay_deg)*(point[1]-6.625)),
    -sin(splay_deg)*(140-point[0])
    + cos(splay_deg)*(point[1]-6.625)
];

function bezier2d(a, b, c, d, t) = [
    for (axis = [0:1])
        pow(1-t,3)*a[axis] + 3*pow(1-t,2)*t*b[axis]
        + 3*(1-t)*t*t*c[axis] + t*t*t*d[axis]
];

// Rotate each keyboard half outwards about its innermost leg. This keeps the
// phone clearance independent of the selected splay angle.
module place_half(side) {
    translate([side*inner_foot_gap/2, 0])
        rotate(-side*splay_deg)
            scale([-side, 1])
                translate([-140, -6.625])
                    children();
}

module leg_pad_2d(point) {
    translate(point) circle(d=foot_pad_diameter);
}

module beam_2d(a, b, width=frame_rail_width) {
    hull() {
        translate(a) circle(d=width);
        translate(b) circle(d=width);
    }
}

module curved_beam_2d(a, b, c, d, width=frame_rail_width) {
    steps = 18;
    for (i = [0:steps-1])
        beam_2d(bezier2d(a,b,c,d,i/steps),
                bezier2d(a,b,c,d,(i+1)/steps), width);
}

module half_frame_2d() {
    union() {
        for (i = active_leg_indices) leg_pad_2d(leg_centres[i]);

        // The keyboard's two inner legs are at the rear and thumb cluster.
        curved_beam_2d(leg_centres[1], [94, -54], [129, -20],
                       leg_centres[3]);
        if (with_palmrests)
            beam_2d(leg_centres[3], leg_centres[5]);

        if (outer_sockets) {
            beam_2d(leg_centres[0], leg_centres[2]);
            beam_2d(leg_centres[0], leg_centres[1]);
            beam_2d(leg_centres[2], leg_centres[3]);
            if (with_palmrests) {
                beam_2d(leg_centres[2], leg_centres[4]);
                beam_2d(leg_centres[4], leg_centres[5]);
            }
        }
    }
}

module half_sockets() {
    for (i = active_leg_indices)
        let(point=leg_centres[i], rim_z=socket_rim_height(leg_centres[i]))
            hull() {
                // Wider roots blend the tilted sockets into the flat rails.
                translate([point[0]+rim_z*socket_base_shift_fraction,
                           point[1], 0])
                    cylinder(h=base_thickness,
                             d=socket_outer_diameter+socket_base_flare);
                translate([point[0], point[1], rim_z])
                    rotate([0, -tent_deg, 0])
                        cylinder(h=0.8, d=socket_outer_diameter);
            }
}

module half_socket_bores() {
    for (i = active_leg_indices)
        let(point=leg_centres[i], rim_z=socket_rim_height(leg_centres[i]))
            translate([point[0], point[1], rim_z])
                rotate([0, -tent_deg, 0])
                    translate([0, 0, -socket_insert_depth])
                        cylinder(h=socket_insert_depth+2,
                                 d=foot_socket_diameter);
}

module phone_deck_2d() {
    hull()
        for (x = [-phone_width/2+9, phone_width/2-9])
            for (y = [-18+9, 34-9])
                translate([x,y]) circle(r=9);
}

module base_2d() {
    difference() {
        union() {
            translate([0, -phone_rearward]) phone_deck_2d();
            for (side = [-1, 1]) {
                place_half(side) half_frame_2d();
                rear = world_foot(side, leg_centres[1]);
                thumb = world_foot(side, leg_centres[3]);
                curved_beam_2d([side*30,-13-phone_rearward],
                               [side*48,-31-phone_rearward],
                               [rear[0]+side*6,rear[1]+12], rear,
                               cross_rail_width);
                curved_beam_2d([side*30,24-phone_rearward],
                               [side*46,27-phone_rearward],
                               [side*51,-3], thumb, cross_rail_width);
            }
        }
        // Open the deck from its rear edge to just ahead of the phone port.
        deck_rear_y = -18-phone_rearward;
        phone_port_y = phone_forward-phone_rearward;
        translate([-rear_cable_width/2, deck_rear_y-1])
            square([rear_cable_width, phone_port_y-deck_rear_y+8]);
    }
}

module front_logo_recess() {
    // Match the phone-facing plane. The mark sits above the cable arch
    // and between the two existing side cutouts.
    face_slope = tan(phone_recline_deg)*phone_back_height
                 /(phone_back_height-1);
    face_angle = atan(face_slope);
    face_y = phone_slot_depth/2;
    // The phone-facing slope begins at the top of the lower hull cube.
    face_z = base_thickness+0.9;
    logo_center_z = 38;
    logo_surface_y = (logo_center_z-face_z)/cos(face_angle);

    translate([0, face_y, face_z])
        rotate([90-face_angle, 0, 0])
            translate([0, logo_surface_y, -logo_recess_depth])
                linear_extrude(height=logo_recess_depth+0.25)
                    offset(delta=0.15)  // keep thin points visible with a 0.4 mm nozzle
                        resize([0, logo_height], auto=true)
                            import("glove80_mark.svg", center=true);
}

module phone_cradle() {
    // The base supplies the deck's upper surface.
    for (side = [-1, 1]) {
        lower_width = (phone_lip_width-phone_cable_gap)/2;
        upper_width = (phone_lip_top_width-phone_cable_gap)/2;
        hull() {
            translate([side*(phone_cable_gap/2+lower_width/2),
                       -phone_slot_depth/2-phone_lip_thickness/2,
                       base_thickness+0.4])
                cube([lower_width, phone_lip_thickness, 1], center=true);
            translate([side*(phone_cable_gap/2+upper_width/2),
                       -phone_slot_depth/2-phone_lip_thickness/2,
                       base_thickness+phone_lip_height-0.5])
                cube([upper_width, phone_lip_thickness, 1], center=true);
        }
    }

    difference() {
        hull() {
            translate([-phone_back_width/2, phone_slot_depth/2,
                       base_thickness-0.1])
                cube([phone_back_width, phone_back_thickness, 1]);
            translate([-phone_back_top_width/2,
                       phone_slot_depth/2 + tan(phone_recline_deg)*phone_back_height,
                       base_thickness+phone_back_height-1])
                cube([phone_back_top_width, phone_back_thickness, 1]);
        }

        for (side = [-1, 1])
            scale([side, 1, 1])
                translate([0, 40, 0])
                    rotate([90, 0, 0])
                        linear_extrude(height=40)
                            polygon([[-25, 15], [-21, 15],
                                     [-16, 42], [-20, 42]]);

        // Keep the cable path open through the bottom of the rear backrest.
        translate([0, 40, 0])
            rotate([90, 0, 0])
                linear_extrude(height=40)
                    polygon([[-rear_cable_width/2, -1],
                             [ rear_cable_width/2, -1],
                             [ rear_cable_width/2, rear_cable_side_height],
                             [0, rear_cable_side_height+rear_cable_width/2],
                             [-rear_cable_width/2, rear_cable_side_height]]);

        if (with_front_logo) front_logo_recess();
    }
}

union() {
    difference() {
        union() {
            linear_extrude(height=base_thickness) base_2d();
            for (side = [-1, 1]) place_half(side) half_sockets();
        }

        // Short angled recesses locate the keyboard feet or leg adapters.
        for (side = [-1, 1]) place_half(side) half_socket_bores();
    }

    // Face the lip toward the user.
    translate([0, phone_forward-phone_rearward, 0])
        rotate([0, 0, 180]) phone_cradle();
}

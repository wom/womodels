// Visual clearance aid only. The translucent block is not exported with the STL.
include <glove80_perch.scad>

// Estimated Pixel 9 Pro XL and Peak Design case envelope; measure your case
// for a precise fit check.
phone_case_width = 84;
phone_case_thickness = 15;
phone_case_height = 168;

%translate([0, phone_forward-phone_rearward, base_thickness])
    rotate([phone_recline_deg, 0, 0])
        translate([-phone_case_width/2, -phone_case_thickness/2, 0])
            cube([phone_case_width, phone_case_thickness, phone_case_height]);

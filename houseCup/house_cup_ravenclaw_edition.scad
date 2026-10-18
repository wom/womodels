// Handle-free Ravenclaw Edition of the House Cup.
// This is a single fused, static print; it is not a moving print-in-place assembly.
// Designed for upright printing with supports off, using the original mini scale.

use <house_cup_mini.scad>;

S = 0.55;
BADGE_CENTER_Y = -17*S;

module base_ravenclaw_full(){
  difference(){
    union(){
      tapered_rounded_box(118,88,112,82,12,9,8);
      translate([0,0,12]) tapered_rounded_box(104,74,96,66,8,7,6);
      translate([0,0,20]) tapered_rounded_box(88,58,82,52,5,5,4);
      translate([0,0,24.4]) cylinder(h=4.6,r1=29,r2=27);
      plaque_landing();
    }
    translate([0,0,3]) rounded_box(78,50,11,4);
  }
}

module base_ravenclaw_mini(){
  scale([S,S,S]) base_ravenclaw_full();
}

module cup_no_handles_mini(){
  difference(){
    union(){
      stem_mini();
      bowl_shell_mini();
    }
    for(a=[0:60:300]) arch_groove_one(a);
  }
}

module ravenclaw_plaque_mini(){
  plaque_t = 3.6;
  union(){
    linear_extrude(height=plaque_t) scale([S,S]) shield2d(76,76);
    translate([0,0,plaque_t-0.35]) linear_extrude(height=0.75)
      scale([S,S]) difference(){ shield2d(68,68); offset(delta=-2.2) shield2d(68,68); }

    translate([0,23*S,plaque_t-0.25]) linear_extrude(height=0.9)
      text("RAVENCLAW",size=4.1,halign="center",valign="center",font="DejaVu Serif:style=Bold");
    translate([0,13*S,plaque_t-0.25]) linear_extrude(height=0.9)
      text("HOUSE CUP",size=3.7,halign="center",valign="center",font="DejaVu Serif:style=Bold");
    translate([0,2.8,plaque_t-0.25]) linear_extrude(height=0.9)
      text("2026",size=3.4,halign="center",valign="center",font="DejaVu Serif:style=Bold");

    // Raised Ravenclaw shield and R replace the removable badge and magnets.
    translate([0,BADGE_CENTER_Y,plaque_t-0.2])
      linear_extrude(height=1.0) scale([S,S]) shield2d(32,38);
    translate([0,BADGE_CENTER_Y+0.7,plaque_t+0.45]) linear_extrude(height=0.9)
      text("R",size=9.0,halign="center",valign="center",font="DejaVu Serif:style=Bold");
  }
}

module ravenclaw_edition(){
  union(){
    base_ravenclaw_mini();
    // Lower the stem 1 mm into the solid pedestal so the cup is fused to the base.
    translate([0,0,14.95]) cup_no_handles_mini();
    // Embed the plaque into its landing to make the front crest part of the same solid.
    translate([0,-43.5*S,38.5*S]) rotate([90,0,0]) ravenclaw_plaque_mini();
  }
}

ravenclaw_edition();

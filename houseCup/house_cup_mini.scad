$fn=96;

// HOUSE CUP MINI — MK3.9S / ~3 inch assembled / SUPPORT-OFF TARGET

S = 0.55;
MAG_R = 3.2;       // 6.4 mm pocket for nominal 6 mm magnets
MAG_DEPTH = 2.25;
BADGE_MAG_X = 3.6;
BADGE_MAG_Y = 4.0;
BADGE_CENTER_Y = -17*S;

module rr2d(w,h,r){ offset(r=r) square([w-2*r,h-2*r],center=true); }
module rounded_box(w,h,z,r){ linear_extrude(height=z,center=false) rr2d(w,h,r); }
module tapered_rounded_box(w1,h1,w2,h2,z,r1=7,r2=5){
  hull(){
    linear_extrude(height=0.8) rr2d(w1,h1,r1);
    translate([0,0,z-0.8]) linear_extrude(height=0.8) rr2d(w2,h2,r2);
  }
}

module shield2d(w=52,h=62){
  polygon(points=[[-w/2,h/2-7],[-w/2+5,h/2],[w/2-5,h/2],[w/2,h/2-7],
                  [w/2-2,2],[w/2-8,-h/2+14],[0,-h/2],[-w/2+8,-h/2+14],[-w/2+2,2]]);
}

module keyed_pin(x=0,z=25){
  translate([x,-45.8,z]) rotate([0,45,0]) cube([4.2,4.4,4.2],center=true);
}
module plaque_landing(){
  translate([0,-40,4]) rotate([90,0,0]) linear_extrude(height=5)
    polygon(points=[[-30,0],[30,0],[29,13],[26,20],[20,26],[13,28],
                    [-13,28],[-20,26],[-26,20],[-29,13]]);
}
module base_full(){
  difference(){
    union(){
      translate([0,0,0]) tapered_rounded_box(118,88,112,82,12,9,8);
      translate([0,0,12]) tapered_rounded_box(104,74,96,66,8,7,6);
      translate([0,0,20]) tapered_rounded_box(88,58,82,52,5,5,4);
      translate([0,0,24.4]) cylinder(h=4.6,r1=29,r2=27);
      plaque_landing();
      keyed_pin(-20,22.5);
      keyed_pin( 20,22.5);
    }
    translate([0,0,24.5]) cylinder(h=9,r=10.35);
    translate([0,0,3]) rounded_box(78,50,11,4);
  }
}

// --- SUPPORT-OFF GOBLET ---
// Built directly in MINI dimensions so support angles are controlled after scaling.
module stem_mini(){
  union(){
    cylinder(h=4.4,r=5.4);
    translate([0,0,4.2]) cylinder(h=2.2,r1=6.2,r2=5.3);
    translate([0,0,6.2]) cylinder(h=13.7,r1=4.9,r2=3.7);
    translate([0,0,18.7]) cylinder(h=2.2,r1=5.7,r2=6.2);
    // Capital grows at <=45 deg and overlaps bowl by 1.2 mm.
    translate([0,0,20.1]) cylinder(h=2.6,r1=6.2,r2=8.8);
  }
}

// Cross-section: every outward-facing expansion is <= 45 degrees.
module bowl_shell_mini(){
  translate([0,0,21.5])
    rotate_extrude(convexity=10)
      polygon(points=[
        // OUTER profile bottom -> top
        [6.5,0.0],
        [9.2,3.0],
        [12.4,7.0],
        [15.0,12.0],
        [17.2,17.5],
        [18.8,24.0],
        [19.8,30.0],
        [20.2,33.5],
        // chamfered rim: +2.3 mm radius over +2.4 mm Z
        [22.5,35.9],
        [22.5,38.0],
        // INNER profile top -> bottom; no flat underside to rim
        [18.7,38.0],
        [18.7,35.9],
        [18.0,33.5],
        [17.4,30.0],
        [16.3,24.0],
        [14.7,18.0],
        [12.7,13.0],
        [10.3,9.0],
        [8.0,6.2],
        [5.8,5.0],
        [0.0,5.0],
        [0.0,0.0]
      ]);
}

// Top edges are slightly diamond/chamfered by subtracting rotated cubes in Z.
module handle_socket_cuts_mini(){
  // Exact V4.2 socket geometry, just expressed directly in mini dimensions.
  // Keeping these rectangular preserves compatibility with the existing handle tabs.
  for(s=[-1,1]){
    translate([s*(34.6*S),-7*S,76*S]) cube([3.8*S,6.4*S,6.4*S],center=true);
    translate([s*(35.6*S),-7*S,94*S]) cube([3.2*S,6.4*S,6.4*S],center=true);
  }
}

// Shallow recessed pointed-arch marks: decoration without projecting overhangs.
// These are intentionally subtle at mini scale.
module arch_groove_one(a=0){
  rotate([0,0,a]) {
    // vertical pair
    translate([18.5,-2.0,39.0]) cube([2.2,0.75,5.0],center=true);
    translate([18.5, 2.0,39.0]) cube([2.2,0.75,5.0],center=true);
    // pointed cap via two 45-deg cuts
    translate([18.5,-1.05,42.0]) rotate([45,0,0]) cube([2.2,0.75,3.2],center=true);
    translate([18.5, 1.05,42.0]) rotate([-45,0,0]) cube([2.2,0.75,3.2],center=true);
  }
}

module cup_mini(){
  difference(){
    union(){ stem_mini(); bowl_shell_mini(); }
    handle_socket_cuts_mini();
    for(a=[0:60:300]) arch_groove_one(a);
  }
}

module handle2d(){
  union(){
    difference(){
      hull(){
        translate([0,0]) scale([1.00,1.12]) circle(r=25);
        translate([8,0]) scale([0.82,1.02]) circle(r=22);
      }
      translate([2,0]) scale([0.88,1.06]) circle(r=16.5);
      translate([-33,-34]) square([26,68]);
    }
    polygon(points=[[-9,13],[13,13],[18,16.5],[13,20],[-9,20]]);
    polygon(points=[[-9,-4],[13,-4],[18,-1],[13,2],[-9,2]]);
    translate([10,17]) difference(){ circle(r=7.2); circle(r=3.7); translate([-8,-8]) square([8,16]); }
    translate([10,-17]) difference(){ circle(r=7.2); circle(r=3.7); translate([-8,-8]) square([8,16]); }
    polygon(points=[[24,-4],[34,0],[24,4]]);
  }
}
module handle_raw_full(){
  linear_extrude(height=6) handle2d();
  translate([-6,14,-4.7]) cube([6,5,4.7]);
  translate([-6,-3,-6.0]) cube([6,4,6.0]);
}
module handle_full(){ translate([0,0,6]) mirror([0,0,1]) handle_raw_full(); }
module handle_mini(){ scale([S,S,S]) handle_full(); }
module handle_raw_mini(){ scale([S,S,S]) handle_raw_full(); }

module base_mini(){ scale([S,S,S]) base_full(); }

// Mini plaque: 6x2 magnet pockets.
module main_plaque_mini(){
  plaque_t = 3.6;
  difference(){
    union(){
      linear_extrude(height=plaque_t) scale([S,S]) shield2d(76,76);
      translate([0,0,plaque_t-0.35]) linear_extrude(height=0.75)
        scale([S,S]) difference(){ shield2d(68,68); offset(delta=-2.2) shield2d(68,68); }
      translate([0,23*S,plaque_t-0.25]) linear_extrude(height=0.9)
        text("HOGWARTS",size=4.1,halign="center",valign="center",font="DejaVu Serif:style=Bold");
      translate([0,13*S,plaque_t-0.25]) linear_extrude(height=0.9)
        text("HOUSE CUP",size=3.7,halign="center",valign="center",font="DejaVu Serif:style=Bold");
      translate([0,2.8,plaque_t-0.25]) linear_extrude(height=0.9)
        text("2026",size=3.4,halign="center",valign="center",font="DejaVu Serif:style=Bold");
    }
    for(x=[-20*S,20*S])
      translate([x,-16*S,-0.15]) linear_extrude(height=2.25)
        rotate(45) square([2.9,2.9],center=true);
    translate([0,BADGE_CENTER_Y,plaque_t-0.48])
      linear_extrude(height=0.65) scale([S,S]) shield2d(32,38);
    for(x=[-BADGE_MAG_X,BADGE_MAG_X])
      translate([x,BADGE_CENTER_Y+BADGE_MAG_Y,plaque_t-MAG_DEPTH])
        cylinder(h=MAG_DEPTH+0.2,r=MAG_R);
  }
}

module house_badge_mini(letter="G"){
  badge_t = 3.1;
  difference(){
    union(){
      linear_extrude(height=badge_t) scale([S,S]) shield2d(30,36);
      translate([0,1*S,badge_t-0.2]) linear_extrude(height=0.95)
        text(letter,size=9.0,halign="center",valign="center",font="DejaVu Serif:style=Bold");
    }
    // Full-size 6.4 x 2.25 mm pockets. With supports OFF, Prusa bridges the short roof.
    for(x=[-BADGE_MAG_X,BADGE_MAG_X])
      translate([x,BADGE_MAG_Y,-0.15]) cylinder(h=MAG_DEPTH+0.15,r=MAG_R);
  }
}

module assembled_mini(){
  color("#24201d") base_mini();
  color("#c79a32") translate([0,0,29*S]) cup_mini();
  color("#c79a32") translate([38.7*S,-4*S,77*S]) rotate([90,0,90]) handle_raw_mini();
  color("#c79a32") mirror([1,0,0]) translate([38.7*S,-4*S,77*S]) rotate([90,0,90]) handle_raw_mini();
  color("#c79a32") translate([0,-45*S,38.5*S]) rotate([90,0,0]) main_plaque_mini();
  color("#7b1f24") translate([0,-45*S-3.3, (38.5*S)+(BADGE_CENTER_Y)]) rotate([90,0,0]) house_badge_mini("G");
}

part="assembled"; // base | cup | handle | plaque | G | S | R | H | assembled
if(part=="base") base_mini();
else if(part=="cup") cup_mini();
else if(part=="handle") handle_mini();
else if(part=="plaque") main_plaque_mini();
else if(part=="G") house_badge_mini("G");
else if(part=="S") house_badge_mini("S");
else if(part=="R") house_badge_mini("R");
else if(part=="H") house_badge_mini("H");
else assembled_mini();

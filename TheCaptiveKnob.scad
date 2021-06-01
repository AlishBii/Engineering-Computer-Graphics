// Create captive knob
intersection() {
rotate_extrude(convexity = 5, $fn = 24) difference() {
square([13.5, 25]);
hull() for(i = [20, 22]) translate([5, i, 0]) rotate(-45)
square(20);
translate([6, 13, 0]) square(8);
translate([7, 20, 0]) square(20);
}
union() {
translate([0, 0, 70]) cube(100, center = true);
for(i = [0:30:90-1], j = [0:3:20-1]) translate([0, 0, j])
rotate(i + j * 45 / 3) cylinder(r = 15, r2 = 12.25, h = 3, $fn = 4);
for(i = [0:30:90-1], j = [0:3:20-1]) translate([0, 0, j])
rotate(i + j * 45 / 3 + 45) cylinder(r = 15, r1 = 12.25, h = 3,
$fn = 4);
}
}

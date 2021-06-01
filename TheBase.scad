tolerance = .4; 
// Create rails for slider
linear_extrude(100, convexity = 5) intersection() {
square([80, 20], center = true);
for(i = [0, 1]) mirror([i, 0, 0]) translate([20, 0, 0]) rotate(-45)
square(100);
}
// Create the base
difference() {
linear_extrude(25, convexity = 5) square([80, 20], center = true);
rotate_extrude(convexity = 5, $fn = 24) difference() {
offset(tolerance + (1/cos(180/24) - 1) * 20) difference() {
square([14, 25]);
difference() {
hull() for(i = [20 + tolerance*0, 22 - tolerance*0])
translate([5, i, 0]) rotate(-45) square(20);
translate([0, 23, 0]) square(7);
}
translate([7, 20, 0]) square(20);
}
translate([-100, -10, 0]) square(100);
}
}

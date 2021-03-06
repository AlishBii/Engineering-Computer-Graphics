fn = 12; // Fragment number- OpenSCAD polygon sides parameter
tolerance = .4; // Spacing parameter (make bigger if parts stick together)
pitch = 4; // Screw pitch
function profile(d = 10, pitch = 2) = [[0, d/2 - pitch/4], [pitch * .3, d/2],
[pitch * .5, d/2], [pitch * .8, d/2 - pitch/4], [pitch, d/2 - pitch/4]];
//a function that generates the points for the thread profile
intersection() {
rawthread(profile = profile(10, pitch), turns = 100/pitch,
internal = false, fn = fn);
hull() for(i = [0, 80]) translate([0, 0, i]) cylinder(r = 20, r2 = 3,
h = 20);
}

// Create separate slider next
translate([0, 50, 0]) difference() {
linear_extrude(15, convexity = 5) square([80, 20], center = true);
rotate([0, 2, 0]) {
linear_extrude(100, center = true, convexity = 5) offset(tolerance)
    for(i = [0, 1]) mirror([i, 0, 0]) translate([20, 0, 0]) rotate(-45)
square(100);
translate([0, 0, -25]) rawthread(profile = profile(10 + tolerance *
2, pitch),
turns = 100/pitch, internal = true, fn = fn);
}
}

//The following module actually creates the thread
module rawthread(profile = [[0, 5], [.25, 6], [.5, 6], [.75, 5], [1, 5]],
turns = 5,
internal = false, fn = 20
) {
lead = profile[len(profile) - 1][0] - profile[0][0];
length = turns * lead;
echo(lead);
echo(length);
points = concat(
[[0, 0, 0]],
[for(i = [0:len(profile) - 2]) [profile[i][1], 0, profile[i][0]]],
[for(z = [0:lead:length], a = [360/fn:360/fn:360],
point = [for(i = [0:len(profile) - 2])
[profile[i][0], (profile[i][1] + (z + a / 360) *
(profile[len(profile) - 1][1] - profile[0][1])) *
(internal ? 1 / cos(180 / fn) : 1)]])
[point[1] * cos(a), point[1] * sin(a), z + point[0] + a/360 *
lead]],
[[0, 0, length + lead + profile[len(profile) - 2][0] - profile[0][0]]]
);
faces = concat(
[for(i = [0:fn - 1]) [0, i * (len(profile) - 1) + 1, (i + 1) *
(len(profile) - 1) + 1]],
[for(i = [0:len(profile) - 2]) [0, (i == len(profile) - 2) ?
(len(profile) - 1) *
fn + 1 : i + 2, i + 1]],
[for(i = [for(z = [0:(turns - 0)], j = [0:len(profile) - 3], a =
[0:fn - 1])
quad(
1 + (z * fn + a) * (len(profile) - 1) + j,
1 + (z * fn + a) * (len(profile) - 1) + (len(profile) - 1) + j,
1 + (z * fn + a) * (len(profile) - 1) + ((j == (len(profile)
- 2)) ?
fn * (len(profile) - 1) : j + 1) + (len(profile) - 1),
1 + (z * fn + a) * (len(profile) - 1) + ((j == (len(profile)
- 2)) ?
fn * (len(profile) - 1) : j + 1)
)], v = i) v],//*/
[for(i = [for(z = [0:turns - 1], j = [len(profile) - 2], a = [0:fn - 1])
quad(
1 + (z * fn + a) * (len(profile) - 1) + j,
1 + (z * fn + a) * (len(profile) - 1) + (len(profile) - 1) + j,
1 + (z * fn + a) * (len(profile) - 1) + fn * (len(profile) - 1) +
(len(profile) - 1),
1 + (z * fn + a) * (len(profile) - 1) + fn * (len(profile) - 1)
)], v = i) v],//*/
[for(i = [0:len(profile) - 2]) [len(points) - 1, len(points) - 1,
len(points) - 1]
- [0, (i == len(profile) - 2) ? (len(profile) - 1) * fn + 1 :
i + 2, i + 1]],
[for(i = [0:fn - 1]) [len(points) - 1, len(points) - 1,
len(points) - 1] - [0, i * (len(profile) - 1) + 1, (i + 1) *
(len(profile) - 1) + 1]]
);
translate([0, 0, -lead]) polyhedron(points, faces, convexity = 10);
}
function quad(a, b, c, d, r = false) = r ? [[a, b, c], [c, d, a]] :
[[c, b, a], [a, d, c]];
//create triangles from quad

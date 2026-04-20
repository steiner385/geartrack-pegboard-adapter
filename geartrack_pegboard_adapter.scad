// GearTrack-to-Pegboard Adapter
// Slides into Gladiator GearTrack/GearWall channels and presents
// standard 1/4" pegboard holes for your existing hooks.
//
// Self-contained — no external STL dependencies.
// Bracket profile traced from CosmicProphet's GearTrack Mounting
// Brackets (Thingiverse thing:4075984), licensed CC BY 4.0.
//
// Print settings:
//   Orientation: flat on bed
//   Infill: 50-80%, rectilinear
//   Perimeters: 3+
//   Material: PLA or PETG (PETG recommended for garage use)
//   Supports: not required

/* [Pegboard] */

// Columns across (horizontal, along the track). Even numbers only.
width = 4; // [2, 4, 6, 8]

// Rows tall (vertical, up the wall)
height = 3; // [1:1:12]

// Hole diameter in mm (standard = 6.35 / 1/4 inch)
hole_dia = 6.35;

// Hole center-to-center spacing in mm (standard = 25.4 / 1 inch)
hole_spacing = 25.4;

/* [Plate] */

// Plate thickness in mm
plate_thick = 5.0; // [3:0.5:8]

// Margin around outermost holes in mm
plate_margin = 10.0; // [5:1:15]

/* [Standoff] */

// Space behind plate for hook backs (mm). Standard hooks need 15-20mm.
standoff = 17.0; // [12:1:25]

// Rib thickness in mm (horizontal direction)
rib_thick = 4.0; // [3:0.5:6]

/* [Advanced] */

// Tab width in mm (along the track)
tab_width = 10; // [8:1:14]

// Print just one bracket tab to test GearTrack fit
test_clip = false;

/* [Hidden] */

$fn = 40;

// ----- BRACKET PROFILE -----
// 2D cross-section of the GearTrack engagement tab.
// Traced from CosmicProphet's Gearwall_Bracket_10mm.stl
// (Thingiverse thing:4075984, CC BY 4.0)
// X = depth (negative = wall, positive = room)
// Y = height (vertical)
_bracket_profile = [
    [  -9.94, -68.00],
    [ -11.00, -64.50],
    [  -6.82, -62.50],
    [  10.52, -62.00],
    [ -10.98, -57.50],
    [   2.94, -56.00],
    [  -8.01,   7.50],
    [  -5.25,  12.00],
    [  -9.00,  12.50],
    [  10.59,  19.00],
    [  -5.40,  21.00],
    [  -9.00,  26.00],
    [  -5.75,  31.50],
    [  -6.11,  32.00],
    [  -5.00,  32.00],
    [  -8.60,  26.00],
    [  -4.50,  20.50],
    [  11.00,  19.00],
    [   2.82,  12.50],
    [   3.40,  11.00],
    [  -5.14,   7.00],
    [   2.99, -57.00],
    [ -10.59, -58.00],
    [  11.00, -62.00],
    [  10.42, -63.00],
    [ -10.60, -64.50],
    [  -7.14, -68.00]
];

// ----- DERIVED -----
plate_w = (width - 1) * hole_spacing + 2 * plate_margin;
plate_h = (height - 1) * hole_spacing + 2 * plate_margin;

num_tabs = max(1, ceil(width / 4));

bracket_height = 100;  // Y span of bracket profile
bracket_y_min  = -68;
bracket_front  = 11;   // Front face X position

num_gaps = width - 1;

// Edge-to-edge tab distribution
// 1 tab → center gap; 2+ → first, last, then evenly between
function tab_gap_index(i, n, gaps) =
    (n == 1) ? floor(gaps / 2) :
    floor(i * (gaps - 1) / (n - 1));

function gap_z(gap_idx) =
    plate_margin + (gap_idx + 0.5) * hole_spacing;

// ----- MODULES -----

module bracket_tab() {
    linear_extrude(height = tab_width)
        polygon(points = _bracket_profile);
}

module pegboard_plate() {
    difference() {
        cube([plate_thick, plate_h, plate_w]);
        for (col = [0 : width - 1]) {
            for (row = [0 : height - 1]) {
                translate([-1, plate_margin + row * hole_spacing, plate_margin + col * hole_spacing])
                    rotate([0, 90, 0])
                        cylinder(h = plate_thick + 2, d = hole_dia);
            }
        }
    }
}

module rib() {
    cube([standoff, plate_h, rib_thick]);
}

// ----- ASSEMBLY -----

if (test_clip) {
    bracket_tab();
} else {
    plate_y_offset = bracket_y_min + (bracket_height - plate_h) / 2;

    for (i = [0 : num_tabs - 1]) {
        gi = tab_gap_index(i, num_tabs, num_gaps);
        rz = gap_z(gi);

        translate([0, 0, rz - tab_width / 2])
            bracket_tab();

        translate([bracket_front, plate_y_offset, rz - rib_thick / 2])
            rib();
    }

    translate([bracket_front + standoff, plate_y_offset, 0])
        pegboard_plate();
}

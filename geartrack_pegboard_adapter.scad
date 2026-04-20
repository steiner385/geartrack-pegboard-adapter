// GearTrack-to-Pegboard Adapter
// Slides into Gladiator GearTrack/GearWall channels and presents
// standard 1/4" pegboard holes for your existing hooks.
//
// Requires: Gearwall_Bracket_10mm.stl (included)
//   Bracket profile by CosmicProphet (Thingiverse thing:4075984)
//   Licensed under CC BY 4.0
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

// Tab width in mm (matches bracket STL)
tab_width = 10; // [8:1:14]

// Print just one bracket tab to test GearTrack fit
test_clip = false;

/* [Hidden] */

$fn = 40;

plate_w = (width - 1) * hole_spacing + 2 * plate_margin;
plate_h = (height - 1) * hole_spacing + 2 * plate_margin;

// 1 tab per 4 columns, minimum 1
num_tabs = max(1, ceil(width / 4));

// Bracket STL: X: -11..11 (22mm), Y: -67.9..32.1 (100mm), Z: 0..10
bracket_height = 100;
bracket_y_min  = -67.9;
bracket_front  = 11;

num_gaps = width - 1;

// Edge-to-edge tab distribution
// 1 tab → center gap
// 2+ tabs → first gap, last gap, then evenly between
function tab_gap_index(i, n, gaps) =
    (n == 1) ? floor(gaps / 2) :
    floor(i * (gaps - 1) / (n - 1));

function gap_z(gap_idx) =
    plate_margin + (gap_idx + 0.5) * hole_spacing;

module bracket_tab() {
    import("Gearwall_Bracket_10mm.stl", convexity=10);
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

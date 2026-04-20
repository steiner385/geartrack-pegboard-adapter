// GearTrack-to-Pegboard Adapter
// Slides into Gladiator GearTrack/GearWall channels and presents
// standard 1/4" pegboard holes for your existing hooks.
//
// Self-contained — no external dependencies.
// Bracket profile derived from CosmicProphet's GearTrack Mounting
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

// Gusset size in mm (triangular reinforcement at rib joints)
gusset = 10.0; // [6:1:15]

/* [Advanced] */

// Tab width in mm (along the track)
tab_width = 10; // [8:1:14]

// Print just one bracket tab to test GearTrack fit
test_clip = false;

/* [Hidden] */

$fn = 40;

// ----- BRACKET PROFILE -----
// GearTrack engagement tab built from overlapping rectangles.
// Each C-clip piece overlaps neighbors by 1-2mm to form one solid.
// Derived from CosmicProphet's Gearwall_Bracket_10mm.stl
// (Thingiverse thing:4075984, CC BY 4.0)

module bracket_tab() {
    linear_extrude(height = tab_width) {
        // --- Lower C-clip ---
        // Back plate (spans full lower hook height, overlaps arms)
        translate([-11, -68])   square([5, 12]);     // X:-11 to -6, Y:-68 to -56
        // Bottom arm (under lower rail, overlaps back plate)
        translate([-7, -63.5])  square([18, 2]);     // X:-7 to 11, Y:-63.5 to -61.5
        // Front post (connects bottom and top arms)
        translate([10, -63.5])  square([1, 7]);      // X:10 to 11, Y:-63.5 to -56.5
        // Top arm (over lower rail, overlaps back plate and bridge)
        translate([-11, -58.5]) square([15, 2]);     // X:-11 to 4, Y:-58.5 to -56.5

        // --- Bridge ---
        translate([-8, -57])    square([12, 64]);    // X:-8 to 4, Y:-57 to 7

        // --- Upper C-clip ---
        // Back plate (spans full upper hook, overlaps bridge and arms)
        translate([-9, 7])      square([5, 26]);     // X:-9 to -4, Y:7 to 33
        // Inner plate (overlaps bridge top)
        translate([-5, 7])      square([9, 7]);      // X:-5 to 4, Y:7 to 14
        // Bottom arm (under upper rail, overlaps back plate)
        translate([-6, 18.5])   square([17, 2]);     // X:-6 to 11, Y:18.5 to 20.5
        // Front post
        translate([10, 18.5])   square([1, 3]);      // X:10 to 11, Y:18.5 to 21.5
        // Top arm (over upper rail, overlaps back plate)
        translate([-6, 20])     square([2, 2]);      // X:-6 to -4, Y:20 to 22
    }
}

// ----- DERIVED -----
plate_w = (width - 1) * hole_spacing + 2 * plate_margin;
plate_h = (height - 1) * hole_spacing + 2 * plate_margin;

num_tabs = max(1, ceil(width / 4));

bracket_height = 100;
bracket_y_min  = -68;
bracket_front  = 11;

num_gaps = width - 1;

function tab_gap_index(i, n, gaps) =
    (n == 1) ? floor(gaps / 2) :
    floor(i * (gaps - 1) / (n - 1));

function gap_z(gap_idx) =
    plate_margin + (gap_idx + 0.5) * hole_spacing;

// ----- MODULES -----

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

module gusset_wedge(leg_x, leg_z, h) {
    polyhedron(
        points = [
            [0, 0, 0], [leg_x, 0, 0], [0, 0, leg_z],
            [0, h, 0], [leg_x, h, 0], [0, h, leg_z]
        ],
        faces = [
            [0, 2, 1], [3, 4, 5],
            [0, 1, 4, 3], [1, 2, 5, 4], [0, 3, 5, 2]
        ]
    );
}

// ----- ASSEMBLY -----

if (test_clip) {
    bracket_tab();
} else {
    plate_y_offset = bracket_y_min + (bracket_height - plate_h) / 2;

    for (i = [0 : num_tabs - 1]) {
        gi = tab_gap_index(i, num_tabs, num_gaps);
        rz = gap_z(gi);
        g = gusset;

        // Bracket tab
        translate([0, 0, rz - tab_width / 2])
            bracket_tab();

        // Vertical rib
        translate([bracket_front, plate_y_offset, rz - rib_thick / 2])
            rib();

        // Gussets (4 wedges per rib)
        translate([bracket_front, plate_y_offset, rz - rib_thick / 2])
            gusset_wedge(g, -g, plate_h);
        translate([bracket_front, plate_y_offset, rz + rib_thick / 2])
            gusset_wedge(g, g, plate_h);
        translate([bracket_front + standoff, plate_y_offset, rz - rib_thick / 2])
            gusset_wedge(-g, -g, plate_h);
        translate([bracket_front + standoff, plate_y_offset, rz + rib_thick / 2])
            gusset_wedge(-g, g, plate_h);
    }

    // Pegboard plate
    translate([bracket_front + standoff, plate_y_offset, 0])
        pegboard_plate();
}

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
// GearTrack engagement tab built from rectangular sections.
// Geometry derived from CosmicProphet's Gearwall_Bracket_10mm.stl
// (Thingiverse thing:4075984, CC BY 4.0)
// Each entry: [x, y, width, height]
_bracket_rects = [
    [ -10.1, -68.0,   3.1,  1.0],  // Bottom tab (hooks under lower rail)
    [ -11.0, -64.5,   0.4,  0.5],  // Back catch
    [  -7.4, -64.0,   0.6,  1.0],  // Lower transition
    [  -7.2, -63.0,  17.7,  0.5],  // Under lower rail (C-clip)
    [  -6.8, -62.5,  17.7,  0.5],  // Under lower rail cont.
    [  10.5, -62.0,   0.5,  0.5],  // Front post lower
    [ -11.0, -58.0,   0.4,  0.5],  // Back wall return
    [ -11.0, -57.5,  13.0,  0.5],  // Over lower rail
    [ -10.8, -57.0,  13.8,  0.5],  // Over lower rail cont.
    [   2.5, -56.5,   0.8,  0.5],  // Front edge taper
    [   2.9, -56.0,   0.5,  0.5],  // Front edge taper cont.
    [  -8.0,   7.0,   3.0,  1.0],  // Upper tab (hooks under upper rail)
    [  -5.4,  11.0,   8.8,  1.5],  // Back plate / bridge top
    [  -9.0,  12.5,  11.8,  0.5],  // Rear extension
    [  10.6,  19.0,   0.4,  0.5],  // Front post upper
    [  -4.0,  19.5,  15.0,  0.5],  // Under upper rail (C-clip)
    [  -5.0,  20.0,  15.8,  0.5],  // Under upper rail cont.
    [  -5.3,  20.5,   0.8,  0.5],  // Over upper rail taper
    [  -5.4,  21.0,   0.5,  0.5],  // Over upper rail taper cont.
    [  -9.0,  26.0,   0.4,  0.5],  // Rear feature
    [  -6.1,  31.5,   1.1,  1.0],  // Top tab
    // Bridge connecting lower and upper hooks
    [  -8.0, -56.0,  11.4, 63.0],  // Main bridge plate
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
        for (r = _bracket_rects)
            translate([r[0], r[1]])
                square([r[2], r[3]]);
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

// Triangular gusset wedge.
// Right-triangle cross-section in X-Z plane, extruded in Y.
// leg_x = length along rib (X direction)
// leg_z = length along surface (Z direction)
// h = height (Y direction)
module gusset_wedge(leg_x, leg_z, h) {
    // Triangle defined in X-Z, extruded along Y via polyhedron
    polyhedron(
        points = [
            [0,  0,  0],           // 0: origin corner
            [leg_x, 0, 0],         // 1: along rib
            [0,  0,  leg_z],       // 2: along surface
            [0,  h,  0],           // 3: origin top
            [leg_x, h, 0],         // 4: along rib top
            [0,  h,  leg_z]        // 5: along surface top
        ],
        faces = [
            [0, 2, 1],            // bottom triangle
            [3, 4, 5],            // top triangle
            [0, 1, 4, 3],         // rib face
            [1, 2, 5, 4],         // hypotenuse
            [0, 3, 5, 2]          // surface face
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

        // Bracket tab
        translate([0, 0, rz - tab_width / 2])
            bracket_tab();

        // Vertical rib
        translate([bracket_front, plate_y_offset, rz - rib_thick / 2])
            rib();

        // Gussets: 4 wedges per rib (back-left, back-right, front-left, front-right)
        g = gusset;

        // Back-left: at bracket face, spreading in -Z direction
        translate([bracket_front, plate_y_offset, rz - rib_thick / 2])
            gusset_wedge(g, -g, plate_h);

        // Back-right: at bracket face, spreading in +Z direction
        translate([bracket_front, plate_y_offset, rz + rib_thick / 2])
            gusset_wedge(g, g, plate_h);

        // Front-left: at plate face, spreading in -Z direction
        translate([bracket_front + standoff, plate_y_offset, rz - rib_thick / 2])
            gusset_wedge(-g, -g, plate_h);

        // Front-right: at plate face, spreading in +Z direction
        translate([bracket_front + standoff, plate_y_offset, rz + rib_thick / 2])
            gusset_wedge(-g, g, plate_h);
    }

    // Pegboard plate
    translate([bracket_front + standoff, plate_y_offset, 0])
        pegboard_plate();
}

# GearTrack Pegboard Adapter

A 3D-printable adapter that slides into Gladiator GearTrack/GearWall channels and presents standard 1/4" pegboard holes — so you can reuse your existing pegboard hooks on GearTrack.

![Adapter concept](https://img.shields.io/badge/OpenSCAD-Customizable-blue)

## Features

- **Exact GearTrack fit** — uses the proven bracket profile from [CosmicProphet's GearTrack Mounting Brackets](https://www.thingiverse.com/thing:4075984)
- **Standard pegboard holes** — 1/4" (6.35mm) holes on 1" (25.4mm) centers
- **Parametric** — customize width, height, standoff depth, and more in OpenSCAD or Thingiverse Customizer
- **Hook clearance** — adjustable standoff (default 17mm) behind the pegboard plate for hook backs
- **Smart tab distribution** — GearTrack tabs placed at the edges and evenly distributed, never behind holes

## Pre-generated STLs

| File | Width × Height | Tabs | Description |
|------|---------------|------|-------------|
| `Test_Clip` | — | 1 | Print first to verify GearTrack fit |
| `2x2` | 2 × 2 | 1 | Single hook spot |
| `4x3` | 4 × 3 | 1 | Compact tool cluster |
| `4x4` | 4 × 4 | 1 | Square panel |
| `4x6` | 4 × 6 | 1 | Tall narrow panel |
| `4x8` | 4 × 8 | 1 | Very tall panel |
| `6x3` | 6 × 3 | 2 | Wide short panel |
| `6x4` | 6 × 4 | 2 | Wide standard panel |
| `8x3` | 8 × 3 | 2 | Near max bed width (220mm) |
| `8x4` | 8 × 4 | 2 | Largest single print |

## Customizer Parameters

- **Width**: Columns across (even: 2, 4, 6, 8)
- **Height**: Rows tall (1–12)
- **Standoff**: Hook clearance behind plate (12–25mm, default 17)
- **Plate thickness**: 3–8mm (default 5)
- **Hole diameter**: Default 6.35mm (1/4")
- **Hole spacing**: Default 25.4mm (1")
- **Test clip mode**: Print just the GearTrack tab to verify fit

## Print Settings

- **Orientation**: Flat on bed
- **Infill**: 50–80%, rectilinear
- **Perimeters**: 3+
- **Material**: PLA or PETG (PETG recommended for garage use)
- **Supports**: Not required

## Usage

1. Print the **Test Clip** first to verify it slides into your GearTrack
2. If too tight, increase tolerance by scaling the clip 99% in your slicer
3. Choose or customize a pegboard size
4. Print, slide into GearTrack from the end, and hang your hooks

## Files

- `geartrack_pegboard_adapter.scad` — Parametric OpenSCAD source (Customizer compatible)
- `Gearwall_Bracket_10mm.stl` — Required bracket profile dependency
- `GearTrack_Pegboard_*.stl` — Pre-generated common sizes

## Attribution

GearTrack bracket profile by [CosmicProphet](https://www.thingiverse.com/thing:4075984), licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

## License

This work is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).

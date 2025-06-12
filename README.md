# Invisible Stone Furnaces

## Overview
This Factorio mod makes stone furnaces completely invisible while maintaining their full functionality. You can still interact with them, automate them with inserters, and they will continue smelting normally - they just won't clutter your visual space anymore.

## Features
- **Complete stone furnace invisibility**: Stone furnaces become invisible
- **Full functionality preserved**: Smelting, automation, and interaction remain unchanged
- **Mod compatibility**: Works with other furnace and smelting mods
- **Performance optimized**: Uses data-stage modifications for minimal runtime impact
- **Optional settings**: Toggle functionality and hover visibility

## Usage
1. Install the mod
2. All stone furnaces will automatically become invisible
3. Furnaces still function normally - you can click where they are to interact
4. Use mod settings to customize behavior if needed

## Settings
- **Enable Invisible Stone Furnaces**: Toggle the invisibility effect on/off (default: enabled)
- **Show Furnaces on Hover**: Show furnace outlines when hovering (default: disabled, requires restart)

## Requirements
- Factorio 2.0+

## Installation
1. Download the mod files
2. Extract the contents into your Factorio mods directory, typically located at:
   - Windows: `%APPDATA%\Factorio\mods`
   - macOS: `~/Library/Application Support/factorio/mods`
   - Linux: `~/.factorio/mods`
3. Launch Factorio and enable the mod in the mod settings menu

## How It Works
The mod modifies stone furnace prototypes during Factorio's data stage to replace all visual sprites with empty/transparent sprites while preserving:
- Collision boxes (so you can still click on them)
- Selection boxes (so you can still select them)
- All functional properties (smelting recipes, energy consumption, etc.)
- Inserter connection points
- Mod compatibility

This approach is very performance-friendly since it doesn't require any runtime scripting for the basic invisibility effect.

## Compatibility
- Works with all stone furnace interactions
- Compatible with inserter and belt automation
- Works with other furnace enhancement mods
- No conflicts with smelting or logistics mods
- Performance friendly - no runtime scripting for basic invisibility

## Troubleshooting
- If furnaces appear visible, check that the mod setting "Enable Invisible Stone Furnaces" is turned on
- Some modded furnace interactions might require a game restart after installation
- Use the `/toggle-furnace-visibility` command for debugging
- Remember that furnaces are still there even if invisible - you can click on their location

## Use Cases
- Clean factory aesthetics without losing functionality
- Reducing visual clutter in dense smelting setups
- Creating "hidden" smelting operations
- Better screenshots and videos of your factory

## Acknowledgments
Thanks to the Factorio community for their support and feedback during the development of this mod. Enjoy your enhanced factory experience!
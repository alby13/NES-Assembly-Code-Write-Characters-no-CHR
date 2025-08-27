# NES Text Display Example

This repository contains a simple NES (Nintendo Entertainment System) ROM example that displays the text "GROK 4 RULES!" on a black background. It demonstrates basic PPU (Picture Processing Unit) setup, loading custom font tiles into CHR RAM, palette configuration, and nametable writing for text rendering. No external graphics files are required—all tile data is embedded in the code.

This is a minimal, self-contained assembly code example using the iNES format, suitable for emulation (e.g., with FCEUX or Mesen). It uses CHR RAM instead of CHR ROM, enabling dynamic graphics loading.

## Features
- Displays static text in white on a black background.
- Custom 8x8 font tiles for uppercase letters, numbers, and symbols.
- No sprites, scrolling, or input handling—just basic rendering.
- NMI handler to reset scroll positions.
- Compatible with NROM mapper (no bank switching).

## How It Works
The code initializes the NES hardware, loads font patterns into CHR RAM, sets up palettes, writes the text to the nametable at position $20C4 (centered on row 6), and enables rendering. The background is black due to the palette configuration and blank tiles in unused nametable areas.

For a more detailed breakdown, see the comments in the code.

## Assembly Code
The full source code (in 6502 assembly, compatible with assemblers like NESASM or ca65) is posted. 

## Building and RunningSave the code as text_display.asm.
Assemble it into a .nes ROM using an assembler like NESASM: nesasm text_display.asm -o text_display.nes.

Run in an NES emulator (e.g., FCEUX): Open the .nes file and power on.

##Notes
The font is 1-bit (white on black); expand by modifying bitplane 1 for more colors.

To clear the full nametable (for reliability on hardware), add a loop to set $2000-$23BF to $00 after the second VBlank wait.

This example is educational—extend it for games or demos!

##License
This code is released fully open source, able to be used, modified, shared, commercially used, anything without any permission. This is true open-source.

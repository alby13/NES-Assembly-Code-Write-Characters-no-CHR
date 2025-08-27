; Full updated code with text changed to "GROK 4 RULES!" (all uppercase, 13 characters).
; Added CHR tiles for new characters: G (tile $09), K ($0A), 4 ($0B), U ($0C), S ($0D).
; Updated LoadCHR to copy $E0 bytes (14 tiles × 16 bytes).
; Adjusted nametable position to $20C4 (row 6, column 4) for better centering of the longer string.
; Retained the working fixes: NMI enabled, scroll reset in NMI handler.

  .inesprg 1 ; 1x 16KB PRG code
  .ineschr 0 ; 0x 8KB CHR data (using CHR RAM)
  .inesmap 0 ; mapper 0 = NROM
  .inesmir 1 ; background mirroring
;;;;;;;;;;;;;;;
  .bank 0
  .org $C000
RESET:
  SEI ; disable IRQs
  CLD ; disable decimal mode
  LDX #$40
  STX $4017 ; disable APU frame IRQ
  LDX #$FF
  TXS ; Set up stack
  INX ; now X = 0
  STX $2000 ; disable NMI
  STX $2001 ; disable rendering
  STX $4010 ; disable DMC IRQs
vblankwait1: ; First wait for vblank to make sure PPU is ready
  BIT $2002
  BPL vblankwait1
clrmem:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
  INX
  BNE clrmem
vblankwait2: ; Second wait for vblank, PPU is ready after this
  BIT $2002
  BPL vblankwait2
LoadCHR:
  ; Load character patterns into CHR RAM
  LDA $2002 ; read PPU status to reset latch
  LDA #$00 ; CHR starts at $0000
  STA $2006 ; write high byte of CHR address
  LDA #$00
  STA $2006 ; write low byte of CHR address
 
  LDX #$00 ; start at 0
LoadCHRLoop:
  LDA font_data, x ; load font pattern data
  STA $2007 ; write to CHR RAM
  INX
  CPX #$E0 ; copy 224 bytes (14 tiles × 16 bytes each)
  BNE LoadCHRLoop
LoadPalettes:
  LDA $2002 ; read PPU status to reset the high/low latch
  LDA #$3F
  STA $2006 ; write the high byte of $3F00 address
  LDA #$00
  STA $2006 ; write the low byte of $3F00 address
 
  ; Load background palette
  LDA #$0F ; Background color (black)
  STA $2007
  LDA #$30 ; Text color (white)
  STA $2007
  LDA #$16 ; Red color
  STA $2007
  LDA #$1A ; Green color
  STA $2007
 
  ; Fill remaining palette slots with black
  LDX #$04
LoadPalettesLoop:
  LDA #$0F ; Black for other palette entries
  STA $2007 ; write to PPU
  INX
  CPX #$20 ; Load all 32 palette bytes
  BNE LoadPalettesLoop
LoadText:
  ; Write "GROK 4 RULES!" to nametable
  LDA $2002 ; reset PPU address latch
  LDA #$20 ; nametable $2000 + $C4
  STA $2006
  LDA #$C4 ; position for text (row 6, column 4)
  STA $2006
 
  LDX #$00
LoadTextLoop:
  LDA hello_text, x ; load text data
  STA $2007 ; write to nametable
  INX
  CPX #$0D ; 13 characters in "GROK 4 RULES!"
  BNE LoadTextLoop
  ; Enable rendering - WITH NMI, background from Pattern 0
  LDA #%10000000 ; Enable NMI, background from Pattern 0
  STA $2000
 
  LDA #%00001010 ; enable background rendering only
  STA $2001
Forever:
  JMP Forever ; infinite loop
NMI:
  LDA #$00
  STA $2005  ; Horizontal scroll 0
  STA $2005  ; Vertical scroll 0
  RTI
;;;;;;;;;;;;;;;
; Font data - proper NES CHR format (16 bytes per 8x8 tile)
font_data:
  ; Tile 0: Blank/Space
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1
 
  ; Tile 1: 'H'
  .db $42,$42,$42,$7E,$42,$42,$42,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1
 
  ; Tile 2: 'E'
  .db $7E,$40,$40,$7C,$40,$40,$7E,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1
 
  ; Tile 3: 'L'
  .db $40,$40,$40,$40,$40,$40,$7E,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1
 
  ; Tile 4: 'O'
  .db $3C,$42,$42,$42,$42,$42,$3C,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1
 
  ; Tile 5: 'W'
  .db $42,$42,$42,$5A,$5A,$66,$42,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1
 
  ; Tile 6: 'R'
  .db $7C,$42,$42,$7C,$44,$42,$42,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1
 
  ; Tile 7: 'D'
  .db $78,$44,$42,$42,$42,$44,$78,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1
 
  ; Tile 8: '!'
  .db $18,$18,$18,$18,$00,$18,$18,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1

  ; Tile 9: 'G'
  .db $3C,$42,$40,$5E,$42,$42,$3C,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1

  ; Tile A: 'K'
  .db $42,$44,$48,$70,$48,$44,$42,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1

  ; Tile B: '4'
  .db $08,$18,$28,$48,$7E,$08,$08,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1

  ; Tile C: 'U'
  .db $42,$42,$42,$42,$42,$42,$3C,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1

  ; Tile D: 'S'
  .db $3C,$42,$40,$3C,$02,$42,$3C,$00 ; Plane 0
  .db $00,$00,$00,$00,$00,$00,$00,$00 ; Plane 1

; Text to display - tile numbers corresponding to characters
hello_text:
  .db $09,$06,$04,$0A,$00,$0B,$00,$06,$0C,$03,$02,$0D,$08 ; "GROK 4 RULES!"
;;;;;;;;;;;;;;;
  .bank 1
  .org $FFFA ; interrupt vectors
  .dw NMI ; NMI handler
  .dw RESET ; Reset handler
  .dw 0 ; IRQ handler

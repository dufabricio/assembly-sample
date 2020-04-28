    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000       ; defines the origin of the ROM at $F000

Start:
    CLEAN_START    ; Macro to safely clear the memory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start a new frame bu turning on VBLANK and VSYNK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
NextFrame:    
    lda #2          ; same as binary value %00000010
    sta VBLANK      ; turn on VBLANK
    sta VSYNC       ; turn on VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate the three lines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    sta WSYNC       ; first scanline
    sta WSYNC       ; second scanline
    sta WSYNC       ; third scanline

    lda #0
    sta VSYNC       ; turno off VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Let the TIA output the recommended 37 scanlines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #37         ; X = 37 ( to count 37 scanlines )
LoopVBlank:
    sta WSYNC       ; hit WSYNC and wait for the next scanline
    dex             ; X--
    bne LoopVBlank  ; loop while X != 0

    lda #0
    sta VBLANK      ; turn off VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 192 visible scanlines (kernel)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #192        ; counter for 192 visible scanlines
LoopVisible:
    stx COLUBK      ; set the background color
    sta WSYNC       ; wait for newxt scanline
    dex             ; X--
    bne LoopVisible ; loop while X != 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ouput 30 more scanlines (overscan)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #2
    sta VBLANK      ; turn on VBLANK
    ldx #30         ; counter for overscan 30 lines
LoopOverScan:
    sta WSYNC       ; wait for next scanline
    dex             ; X--
    bne LoopOverScan; loop while X != 0

    jmp NextFrame   ; back to Next Frame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete rom size with 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    org $FFFC
    .word Start
    .word Start








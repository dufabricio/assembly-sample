    processor 6502

    include "vcs.h"
    include "macro.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start out ROM code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    seg code
    org $F000       ; defines the origin of the ROM at $F000

Reset:
    CLEAN_START     ; Macro to safely clear the memory

    ldx #$80        ; blue background color
    stx COLUBK

    lda #$1C         ; yellow playfield color
    sta COLUPF      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start a new frame by configuring VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
StartFrame:
    lda #2
    sta VBLANK
    sta VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate the three scanlines of VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    REPEAT 3
      sta WSYNC
    REPEND
    lda #0
    sta VSYNC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Generate the 37 recommended scanlines of VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    REPEAT 37
      sta WSYNC
    REPEND
    lda #0
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the CTRLPF Register to allow playfield reflection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ldx #%00000001 ; CTRLPF register (D0 means reflect the PF)
    stx CTRLPF
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw the 192 visible scanlines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

   ; Skip 7 scanlines with no PF set
   ldx #0
   stx PF0
   stx PF1
   stx PF2
   REPEAT 7
   	sta WSYNC
   REPEND     
   
   ; Set the PF0 to 1110 (LSB first) and PF1-POF2 as 1111 1111
   ldx #%11100000
   stx PF0
   ldx #%11111111
   stx PF1
   stx PF2
   REPEAT 7
   	sta WSYNC
   REPEND
   
   ; Set the next 164 lines only PF0 third bid enabled
   ldx #%00100000
   stx PF0
   ldx #0
   stx PF1
   stx PF2
   REPEAT 164
   	sta WSYNC
   REPEND
   
   ; Set the PF0 to 1110 (LSB first) and PF1-POF2 as 1111 1111
   ldx #%11100000
   stx PF0
   ldx #%11111111
   stx PF1
   stx PF2
   REPEAT 7
   	sta WSYNC
   REPEND
   
   ; Skip 7 vertical lines with no PF set
   ldx #0
   stx PF0
   stx PF1
   stx PF2
   REPEAT 7
   	sta WSYNC
   REPEND  
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Output 30 more VBLANK overscan lines to complete out frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    lda #2
    sta VBLANK
    REPEAT 30
    	sta WSYNC
    REPEND
    lda #0
    sta VBLANK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Loop Nex Frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 

    jmp StartFrame

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Complete Rom Size 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC
    .word Reset
    .word Reset


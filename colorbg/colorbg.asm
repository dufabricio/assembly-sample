    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000    ; defines the origin of the ROM at $F000

START:
    ;CLEAN_START  ; Macro to safely clear the memory

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set background luminosit color to yellow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    lda #$1E     ; Load colo into A ($1E is NTSC yellow)
    sta COLUBK  ; store A to BackgroundColor Address $09

    jmp START    ; Repeat from START

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fill ROM size to exaclty 4KB
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    org $FFFC    ; Defines orrigin to $FFFC
    .word START  ; Reset vector at $FFFC (where proam starts)
    .word START  ; Interrupt vector at $FFFE (unused in the VCS)


*TABLE MAKING SUBROUTINE
*------------------------
*       THIS SUBROUTINE MAKES THE MOVE TABLE FOR THE PLAY. IT READS THE KEYBOARD DEBOUNCES THE KEY AND
*STORES VALID DATA.  THE PROGRAM ALSO UPDATES THE BLINKING PLAYER.  THE BLINKING PLAYER
*SIGNALS THE OPERATOR AS TO WHICH PLAYER'S MOVES ARE BEING UPDATED.
*
TABLER  LDAA BLINKL
        CMPA #$00
        BNE  B3
        INC  BLINKR
        BNE  B4
        LDAA $220               PRESET BLINKR, BLINKL
        STAA BLINKR
        STAA BLINKL
B3      INC  BLINKL
        LDAA PORT3
        ANDA #$F0
        ORAA PNUML
        STAA PORT3
        BRA  B5
B4      LDAA PORT3
        ANDA #$F0
        LDAB PNUMR
        ADDB #$08
        STAB DUM1
        ORAA DUM1
        STAA PORT3
B5      LDAA FLAG2L
        CMPA #$00
        BNE  B6
        JSR  KEYL
        LDAA VALIDL
        CMPA #$00
        BEQ  B6
        STAA MMBR
        JSR  DECODE
        LDAA CMNDL
        STAA MULT
        JSR  TTEN
        LDAA MULT
        ADDA PNUML
        STAA INDEX
        JSR  INDEXR
        LDAA MMBR
        STAA ,X
        INC  CMNDL
        LDAA CMNDL
        CMPA #$05
        BNE  B6
        CLR  CMNDL
        INC  PNUML
        LDAA PNUML
        CMPA #$05
        BNE  B6
        LDAA #$01
        STAA FLAG2L
B6      LDAA FLAG2R
        CMPA #$00
        BNE  B16
        JSR  KEYR
        LDAA VALIDR
        CMPA #$00
        BEQ  B16
        STAA MMBR
        JSR  DECODE
        LDAA CMNDR
        STAA MULT
        JSR  TTEN
        LDAA MULT
        ADDA PNUMR
        STAA INDEX
        JSR  INDEXR
        LDAA MMBR
        STAA 5,X
        INC  CMNDR
        LDAA CMNDR
        CMPA #$05
        BNE  B16
        CLR  CMNDR
        INC  PNUMR
        LDAA PNUMR
        CMPA #$05
        BNE  B16
        LDAA #$01
        STAA FLAG2R
* UPDATE LED'S
*
B16     LDAB PORT1
        ANDB #$C0
        LDAA FLAG2L
        CMPA #$00
        BEQ  B18
        LDAA FLAG2R
        CMPA #00
        BEQ  B17
        ORAB #$3F
        BRA  B20
B17     ORAB #$1F
        BRA  B20
B18     LDAA FLAG2R
        CMPA #$00
        BEQ  B19
        ORAB #$3B
        BRA  B20
B19     ORAB #$1B
B20     STAB PORT1
        RTS
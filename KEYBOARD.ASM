*KEYBOARD READ SUBROUTINE
*--------------------------
*       THIS SUBROUTINE READS AND DEROUNCES THE LEFT KEYBOARD
*
*
KEYL    CLR     VALIDL
        LDAA    #$04            INITIALIZE STROBE
SCANL   STAA    STROBE
        LDAA    PORT1
        ANDA    #$CO
        ORAA    STROBE
        COMA
        STAA    PORT1
        LDAB    PORT2
        COMB
        ASLB                    REMOVE SPURIOUS BITS
        ASLB
        ASLB
        ASLB
        ASLB    B CONTAINS HIGH ORDER CODE
        CMPB #00                KEY DEPRESSED?
        BEQ     SHIFTL
        STAB    CRNTL           YES
        LDAA    #$01
        STAA    FLAG1L
        CMPB    OLDL
        BEQ     B1L
        LDAA #$FC       PRESET COUNTL
        STAA COUNTL
        STAB    OLDL
        BRA     SHIFTL
B1L     LDAA    COUNTL
        INCA
        BEQ     SHIFTL          BRANCHES IF COUNT ALREADY $FF
        STAA    COUNTL
        INCA
        BNE     SHIFTL          BRANCHES IF COUNT NOT $FF
        ORAB    STROBE          KEY DEBOUNCED
        STAB    VALIDL
SHIFTL  LDAA    STROBE          NO, SHIFT STROBE
        ASRA
        BCC     SCANL
        LDAB    FLAG1L
        CMPB    #$00
        BEQ     B2L
        CLR     FLAG1L
        BRA     B2L
B2L     LDAA #$FC       PRESET COUNTL
        STAA COUNTL
KRTL    RTS
 PAGE
*KEYBOARD READ SUBROUTINE
*------------------------
*       THIS SUBROUTINE READS AND DEBOUNCES THE RIGHT KEYBOARD
*
KEYR    CLR     VALIDR
        LDAA    #$04    INITIALIZE STROBE
SCANR   STAA    STROBE
        ASLA
        ASLA
        ASLA
        STAA    STRBO
        LDAA    PORT1
        ANDA    #$C0
        ORAA    STRBO
        COMA
        STAA    PORT1
        LDAB    PORT2
        COMB
        ASLB                    REMOVE SPURIOUS BITS
        ASLB
        ASLB
        ASLB
        ASLB
        CMPB    #$00
        BEQ     SHIFTR
        STAB    CRNTR
        LDAA    #$01
        STAA    FLAG1R
        CMPB    OLDR
        BEQ     B1R
        LDAA #$FC       PRESET COUNTR
        STAA COUNTR 
        STAB    OLDR
        BRA     SHIFTR
B1R     LDAA    COUNTR
        INCA
        BEQ     SHIFTR          BRANCHES IF COUNT ALREADY $FF
        STAA    COUNTR
        INCA
        BNE     SHIFTR          BRANCHES IF COUNT NOT $FF
        ORAB    STROBE
        STAB    VALIDR
SHIFTR  LDAA    STROBE
        ASRA                    SHIFT STROBE
        BCC     SCANR
        LDAB    FLAG1R
        CMPB    #$00
        BEQ     B2R
        CLR     FLAG1R
        BRA     KRTR
B2R     LDAA #$FC 
        STAA COUNTR     PRESET COUNTER
KRTR    RTS
*KEYBOARD DECODE SUBROUTINE
*--------------------------
*       THIS SUBROUTINE CONVERTS THE KEY NUMBER TO A MOVE COMMAND.
*
DECODE  LDAA    MMBR 
DECODM  ASLA
        BCC     B7
        ASRA
        ASRA
        BCS     B8
        ASRA
        BCS     B9
        LDAA    #$F0            KEY1 PRESSED
        BRA     B10
B9      LDAA    #$A0            KEY2 PRESSED
        BRA     B10
B8      LDAA    #$E0            KEY3 PRESSED
        BRA     B10
B7      ASLA
        BCC     B11
        ASRA
        ASRA
        ASRA
        BCS     B12
        ASRA
        BCS     B13
        LDAA    #$50            KEY4 PRESSED
        BRA     B10
B13     LDAA    #$00            KEY5 PRESSED
        BRA     B10
B12     LDAA    #$40            KEY6 PRESSED
        BRA     B10
B11     ASRA
        ASRA
        ASRA
        BCS     B14
        ASRA
        BCS     B15
        LDAA    #$D0            KEY7 PRESSED
        BRA     B10
B15     LDAA    #$80            KEY8 PRESSED
        BRA     B10
B14     LDAA    #$C0            KEY9 PRESSED
B10     STAA    MMBR
        RTS
 PAGE
********************************************************
*
*
*     TTEN ACCEPTS MULT AND RETURNS MULT*10
*          10M = (8+2)M
TTEN    LDAA    MULT 
        ASLA
        TAB
        ASLA
        ASLA
        ABA
        STAA    MULT 
        RTS
****************************************************************
****************************************************************
*    INDEXR COMPUTES AN ABSOLUTE ADDRESS FOR THE INDEX REGISTER
*            REGX=TABLE+INDEX
*
INDEXR  CLC
        LDAA    INDEX 
        ADCA    TABPT+1 
        STAA    MULT 
        LDAA    TABPT 
        BCC     B6A
        INCA
B6A     STAA    DUM1 
        LDX     DUM1
        RTS
PAGE
*SRINE SUBROUTINE
*----------------
*       THIS PROGRAM GENERATES FOUR 1/3 SECOND PULSES TO CONTROL THE SIRNE
*THE PULSE IS HIGH FOR 1/3 SECONDS AND LOW FOR 2/3 SECONDS
*
SRINE   LDAA #$02       SET LOOP COUNTER
        STAA COUNT 
SRINE1  LDAA PORT3      GENERATE START PULSE TO BLOW SRINE
        ORAA #$40 
        STAA PORT3 
        LDX  #$25       SET WAIT COUNTER
        JSR  WAIT       CALL WAIT SUBROUTINE
        LDAA PORT3      GENERATE STOP PULSE TO BLOW SRINE  SET OFFENSE TEAM TO WHITE
        ANDA #$9F 
        STAA PORT3 
        LDX  #$200      SET WAIT COUNTER
        JSR  WAIT       CALL WAIT
        DEC  COUNT      TEST FOR FINISHED LOOP
        BNE  SRINE1
        RTS             RETURN
 PAGE
*WAIT SUBROUTINE
*---------------
*       THIS PROGRAM IS A WAIT LOOP TO USE UP TIME
*THE LENGTH OF TIME IS CONTROLLED BY THE VALUE OF THE X REGISTER
*
WAIT    CLRB            CLEAR THE B REGISTER
WAITX   DECB            DECREMENT
        BNE  WAITX      TEST FOR FINISHED
        DEX             DECREMENT X
        BNE  WAITX      TEST FOR FINISHED
        RTS             RETURN
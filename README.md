# US4357014
Transcription of the M6800 code in the patent [US4357014](https://patents.google.com/patent/US4357014)

Note: File names are arbitrary based on the header in the routine listings

## Build instructions
Compile using [motorola-6800-assembler](https://github.com/JimInCA/motorola-6800-assembler)

`as0 FOOTBALL.ASM VARTABLE.S MAIN.S KEYBOARD.S TABLE.S`

Output will be called `FOOTBALL.s19`, convert to binary using [srecord](http://srecord.sourceforge.net/).
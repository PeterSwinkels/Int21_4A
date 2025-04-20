DEFINT A-Z

TYPE RegTypeX
 ax AS INTEGER
 bx AS INTEGER
 cx AS INTEGER
 dx AS INTEGER
 bp AS INTEGER
 si AS INTEGER
 di AS INTEGER
 flags AS INTEGER
 ds AS INTEGER
 es AS INTEGER
END TYPE

DECLARE SUB INTERRUPTX (intnum AS INTEGER, inRegisters AS RegTypeX, outRegisters AS RegTypeX)

DIM Blocks(&H0 TO &H6) AS INTEGER
DIM FarHeap AS LONG
DIM FCB1 AS STRING
DIM FCB2 AS STRING
DIM Parameters AS STRING
DIM Program AS STRING
DIM Registers AS RegTypeX

CLS

Parameters = ""
Program = "" + CHR$(&H0)

FCB1$ = STRING$(&H25, &H0)
FCB2$ = STRING$(&H25, &H0)
Parameters = CHR$(LEN(Parameters)) + Parameters + CHR$(&HD) + CHR$(&H0)

Blocks(&H0) = &H0
Blocks(&H1) = SADD(Parameters)
Blocks(&H2) = VARSEG(Parameters)
Blocks(&H3) = SADD(FCB1$)
Blocks(&H4) = VARSEG(FCB1$)
Blocks(&H5) = SADD(FCB2$)
Blocks(&H6) = VARSEG(FCB2$)

Registers.ax = &H4B00
Registers.ds = VARSEG(Program)
Registers.dx = SADD(Program)
Registers.es = VARSEG(Blocks(LBOUND(Blocks)))
Registers.bx = VARPTR(Blocks(LBOUND(Blocks)))
FarHeap = SETMEM(&HFFFF0000)
INTERRUPTX &H21, Registers, Registers
FarHeap = SETMEM(FarHeap)
Registers.ax = Registers.ax AND &HFF

IF NOT Registers.ax = &H0 THEN
 PRINT "Return code: "; HEX$(Registers.ax AND &HFF)
END IF


// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// r3 = r0
  @0
  D=M
  @3
  M=D
// r2 = 0
  @2
  M=0
// while {
(LOOP)
//   break if r3 == 0
  @3
  D=M
  @END
  D;JEQ
//   r2 += r1
  @2
  D=M
  @1
  D=D+M
  @2
  M=D
//   r3 -= 1
  @3
  M=M-1
// }
  @LOOP
  0;JMP
(END)

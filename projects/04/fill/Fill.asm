// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input. 
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel. When no key is pressed, the
// program clears the screen, i.e. writes "white" in every pixel.

// r0 = screen
  @SCREEN
  D=A
  @R0
  M=D
// while {
(LOOP)
// r1 = 0
  @R1
  M=0

// if kbd != 0 {
  @KBD
  D=M
  @NOKEY
  D;JEQ

// r1 = -1
  @R1
  M=-1
// }
(NOKEY)

//  *r0 = r1
  @R1
  D=M
  @R0
  A=M
  M=D
//   r0 += 1
  @R0
  M=M+1
//   r0 &= !8192
  @8192
  D=!A
  @R0
  M=M&D
// }
  @LOOP
  0;JMP

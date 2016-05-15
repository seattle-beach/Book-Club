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
//   if kbd == 0 { // no key is pressed
  @KBD
  D=M
  @NOKEY
  D;JNE
//     r1 = 0
  @R1
  M=0
  @ENDIF
  0;JMP
//   } else { // a key is pressed
(NOKEY)
//     r1 = 1
  @R1
  M=-1
//   }
(ENDIF)
//  *r0 = r1
  @R1
  D=M
  @R0
  A=M
  M=D
//   r0 += 1
  @R0
  M=M+1
//   r0 &= !32
  @8192
  D=!A
  @R0
  M=M&D
// }
  @LOOP
  0;JMP

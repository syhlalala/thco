 <69bf>     LI R1 00bf
 <3120>     SLL R1 R1 0000
 <9943>     LW R1 R2 0003
 <22fe>     BEQZ R2 fffe
 <0800>     NOP
 <9942>     LW R1 R2 0002
 <69f8>     LI R1 00f8
 <3120>     SLL R1 R1 0000
 <d940>     SW R1 R2 0000
 <2af6>     BNEZ R2 fff6
 <0800>     NOP
 <ef00>     JR R7
 <0800>     NOP


 ----------------------

 LI R3 0
 LI R4 1
 LI R0 F8
 SLL R0 R0 0
 LI R1 BF
 SLL R1 R1 0
 LW R1 R2 03
 BEQZ R2 FE
 NOP
 LW R1 R2 02
 ADDIU3 R0 R5 0
 ADDU R3 R5 R5
 ADDU R4 R5 R5
 SW R5 R2 0
 LI R5 1E
 CMP R2 R5
 BTNEZ 3
 NOP
 ADDIU R3 40
 LI R4 0
 ADDIU R4 1
 B 7F0
 NOP
 JR R7
 NOP
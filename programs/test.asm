NOP

	LI R1 0x55

	LI R0 0x0052
	CMP R0 R1
	BTEQZ L1	
	NOP	

	LI R0 0x0044
	CMP R0 R1
	BTEQZ L2
	NOP	
	
	LI R0 0x0041
	CMP R0 R1
	BTEQZ L3
	NOP	
	
	LI R0 0x0055
	CMP R0 R1
	BTEQZ L4
	NOP	

	LI R0 0x0047
	CMP R0 R1
	BTEQZ L5
	NOP	


L1:
	MFPC R7 
	ADDIU R7 0x0003  
	NOP
	B TESTW 	
	NOP
	LI R6 0x00BF 
	SLL R6 R6 0x0000 
	LI R0 0x004F
	SW R6 R0 0x0000
	NOP
L2:
	MFPC R7 
	ADDIU R7 0x0003  
	NOP
	B TESTW 	
	NOP
	LI R6 0x00BF 
	SLL R6 R6 0x0000 
	LI R0 0x004B
	SW R6 R0 0x0000
	NOP
L3:
	MFPC R7 
	ADDIU R7 0x0003  
	NOP
	B TESTW
	NOP 	
	LI R6 0x00BF 
	SLL R6 R6 0x0000 
	LI R0 0x000A
	SW R6 R0 0x0000
	NOP
L4:
	MFPC R7 
	ADDIU R7 0x0003  
	NOP
	B TESTW 	
	NOP
	LI R6 0x00BF 
	SLL R6 R6 0x0000 
	LI R0 0x000D
	SW R6 R0 0x0000
	NOP
L5:


	B L5
	NOP


TESTW:	
	NOP	 		
	LI R6 0x00BF 
	SLL R6 R6 0x0000 
	ADDIU R6 0x0001 
	LW R6 R0 0x0000 
	LI R6 0x0001 
	AND R0 R6 
	BEQZ R0 TESTW     ;BF01&1=0 ÔòµÈ´ý	
	NOP		
	JR R7
	NOP 
	

TESTR:	
	NOP	
	LI R6 0x00BF 
	SLL R6 R6 0x0000 
	ADDIU R6 0x0001 
	LW R6 R0 0x0000 
	LI R6 0x0002
	AND R0 R6 
	BEQZ R0 TESTR   ;BF01&2=0  ÔòµÈ´ý	
	NOP	
	JR R7
	NOP 
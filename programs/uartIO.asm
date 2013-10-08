	NOP


	LI R4 0x23
	NOP
	NOP
	NOP
	NOP
	MFPC R0
	NOP
	NOP
	NOP
	NOP
	ADDIU R0 0x0A
	NOP
	NOP
	NOP
	NOP
	B UART_WRITE_CHECK
	NOP
	NOP
	NOP
	NOP
	MFPC R0
	NOP
	NOP
	NOP
	NOP
	ADDIU R0 0x0A
	NOP
	NOP
	NOP
	NOP
	B UART_READ_CHECK
	NOP
	NOP
	NOP
	NOP
	ADDIU3 R5 R4 0x0
	NOP
	NOP
	NOP
	NOP
	MFPC R0
	NOP
	NOP
	NOP
	NOP
	ADDIU R0 0x0A
	NOP
	NOP
	NOP
	NOP
	B UART_WRITE_CHECK
	NOP
	NOP
	NOP
	NOP
	DEAD:
	B DEAD
	NOP
	NOP


;uart 写入 r5
UART_WRITE_CHECK:
	LI R6 0xBF
	NOP
	NOP
	NOP
	NOP
	SLL R6 R6 0x0
	NOP
	NOP
	NOP
	NOP
	CHECK_WRITEREADY:
		LW R6 R5 0x1
		NOP
		NOP
		NOP
		NOP
		LI R7 0x01
		NOP
		NOP
		NOP
		NOP
		AND R5 R7
		NOP
		NOP
		NOP
		NOP
		BEQZ R5 CHECK_WRITEREADY
		NOP
	SW R6 R4 0x0
	NOP
	NOP
	NOP
	NOP
	JR R0
	NOP
	NOP
	NOP
	NOP

;uart 输入 r5
UART_READ_CHECK:
	LI R6 0xBF
	NOP
	NOP
	NOP
	NOP
	SLL R6 R6 0x0
	NOP
	NOP
	NOP
	NOP
	CHECK_DATAREADY:
		LW R6 R5 0x1
		NOP
		NOP
		NOP
		NOP
		LI R7 0x02
		NOP
		NOP
		NOP
		NOP
		AND R5 R7
		NOP
		NOP
		NOP
		NOP
		BEQZ R5 CHECK_DATAREADY
		NOP
	LW R6 R5 0x0
	NOP
	NOP
	NOP
	NOP
	JR R0
	NOP
	NOP
	NOP
	NOP
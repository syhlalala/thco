------------------------------------
-- 2012-11-17 19:59:06
-- Author : Keqing Chen
-- alu 
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity alu is
	port (
		instruction	:	in std_logic_vector (15 downto 0);
		op1, b, imm	:	in std_logic_vector (15 downto 0);
		t_chose	:	in std_logic_vector (1 downto 0);
		t_result	:	out std_logic;
		choseIMM	:	in std_logic;

		c 	:	out std_logic_vector (15 downto 0);
		
		ops	:	out std_logic_vector (15 downto 0)
	);
end entity;

architecture main of alu is

--	type OPERATION is (
--		AND_OP,
--		NEG_OP,
--		NOT_OP,
--		XOR_OP,
--		OR_OP,
--		SUB_OP,
--		SHL_OP,
--		SHR_OP,
--		SHRA_OP,
--		ADD_OP,
--		NULL_OP
--	);
	signal AND_OP,
    NEG_OP,
	NOT_OP,
    XOR_OP,
    OR_OP,
    SUB_OP,
    SHL_OP,
    SHR_OP,
    SHRA_OP,
    ADD_OP,
    NULL_OP	:	std_logic_vector(3 downto 0);

	signal last5, last2, last2x, op	:	std_logic_vector(3 downto 0);
	signal eq, ga, gu	:	std_logic;
	signal op2	:	std_logic_vector(15 downto 0);
	signal cv_in_op1, cv_in_op2	:	integer;
	--signal cv_un_op1, cv_un_op2	:	unsigned;

begin
	--! ADDIU 01001 +
	--! ADDIU3 01000  +
	--! ADDSP3 00000  +
	-- ADDU 11100  +
	--! LW 10011  +
	--! LW_SP 10010  + 
	-- SW 11011  +
	-- SW_RS 01100  +
	-- SW_SP 11010  +

	-- AND 11101  & ------ 01100
	-- NEG 11101  0- ------ 01011
	-- NOT 11101  ~ ------ 01111
	-- XOR 11101  ^ ------ 01110
	-- OR 11101  | ------ 01101

	-- SUBU 11100  - ------- 11

	-- SLL 00110  << -------- 00
	-- SLLV 11101  << -------- 00100

	-- SRA 00110  >> a -------- 11
	-- SRAV 11101 >> a -------- 00111

	-- SRL 00110  >> u -------- 10
	-- SRLV 11101  >> u -------- 00110
	
	
	AND_OP <= "0001";
	NEG_OP <= "0010";
	NOT_OP <= "0011";
	XOR_OP <= "0100";
	OR_OP <= "0101";
	SUB_OP <= "0110";
	SHL_OP <= "0111";
	SHR_OP <= "1000";
	SHRA_OP <= "1001";
	ADD_OP <= "1010";
	NULL_OP <= "0000";
	

	op2 <= b when choseIMM = '0' else imm;

	with instruction(4 downto 0) select
		last5 <= 
			AND_OP when "01100",
			NEG_OP when "01011",
			NOT_OP when "01111",
			XOR_OP when "01110",
			OR_OP when "01101",
			SHL_OP when "00100",
			SHR_OP when "00110",
			SHRA_OP when "00111",
			NULL_OP when others;

	with instruction(1 downto 0) select
		last2 <= 
			SHL_OP when "00",
			SHR_OP when "10",
			SHRA_OP when "11",
			NULL_OP when others;

	
	last2x <= SUB_OP when instruction(1 downto 0) = "11" 
			else ADD_OP;

	with instruction(15 downto 11) select
		op <=
			last5 when "11101",
			last2 when "00110",
			last2x when "11100",
			ADD_OP when others;


	ops <= op & last5 & last2 & last2x;

	with op select
		c <=
			op1 and op2 when "0001",
			"0000000000000000" - op1 when "0010",
			not op1 when "0011",
			op1 xor op2 when "0100",
			op1 or op2 when "0101",
			op1 - op2 when "0110",
			to_stdlogicvector(to_bitvector(op1) sll conv_integer(op2)) when "0111",
			to_stdlogicvector(to_bitvector(op1) srl conv_integer(op2)) when "1000",
			to_stdlogicvector(to_bitvector(op1) sra conv_integer(op2)) when "1001",
			op1 + op2 when "1010",
			(others => '0') when others;
			
	cv_in_op1 <= conv_integer(op1);
	cv_in_op2 <= conv_integer(op2);
	--cv_un_op1 <= unsigned(op1);
	--cv_un_op2 <= unsigned(op2);
	
	eq <= '0' when op1 = op2 else '1';
	ga <= '1' when cv_in_op1 < cv_in_op2 else '0';
	gu <= '1' when op1 < op2 else '0';
	
	with t_chose select
		t_result <=
			eq when "00",
			ga when "01",
			gu when "10",
			'0' when others;

end architecture ; -- main

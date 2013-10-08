------------------------------------
-- 2012-11-17 16:42:36
-- Author : Keqing Chen
-- register_split
-- no register 1111
-- write_back_en and op2_mux
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity register_split is
	port (
		instruction	:	in std_logic_vector (15 downto 0);
		rs, rt, rd	:	out std_logic_vector (3 downto 0);
		write_back	:	out std_logic; -- [0 : no] [1 : yes]
		choseBIMM	:	out std_logic; -- [0 : B] [1 : IMM] on ALU
		t_en	:	out std_logic; -- [0 : no] [1 : yes]
		t_chose	:	out std_logic_vector (1 downto 0) -- [00 : != ] [01 : <] [10 : u > ]
	);
end entity;

architecture main of register_split is

	signal r10, r7, r4	:	std_logic_vector (3 downto 0);
	signal ih, sp, ra, empty	:	std_logic_vector (3 downto 0);

	signal result, last5, next3, last8, last1	:	std_logic_vector (11 downto 0);

	signal t_tmp	:	std_logic_vector (1 downto 0);

begin
	--! ADDIU 01001 (10) (~) (10)
	--! ADDIU3 01000 (10) (~) (7)
	--! ADDSP3 00000 (sp) (~) (10)
	--! ADDU 11100 (10) (7) (4)
	-- ADDSP 01100 011 (SP) () (SP)
	-- AND 11101 (10) (7) (10) 01100
	--! BEQZ 00100 (10) () ()
	--! BNEZ 00101 (10) () ()
	-- CMP 11101 (10) (7) () 01010
	--! CMPI 01110 (10) () ()
	-- JALR 11101 (10) () (ra) 11000000
	-- JR 11101 (10) () () 00000000
	-- JRRA 11101 (ra) () () 00100000
	--! LW 10011 (10) () (7)
	--! LW_SP 10010 (sp) () (10)
	--? MFIH 11110 (ih) () (10) 0 = 0
	-- MFPC 11101 () () (10) 01000000
	--! MOVE 01111 (7) () (10)
	--? MTIH 11110 (10) () (ih) 0 = 1
	-- MTSP 01100 100 (7) () (sp)
	-- NEG 11101 (7) () (10) 01011
	-- NOT 11101 (7) () (10) 01111
	-- OR 11101 (10) (7) (10) 01101
	--! SLL 00110 (7) () (10)
	-- SLLV 11101 (7) (10) (7) 00100
	-- SLT 11101 (10) (7) () 00010
	--! SLTI 01010 (10) () ()
	-- SLTU 11101 (10) (7) () 00011
	--! SLTUI 01011 (10) () ()
	--! SRA 00110 (7) () (10)
	-- SRAV 11101 (7) (10) (7) 00111
	--! SRL 00110 (7) () (10)
	-- SRLV 11101 (7) (10) (7) 00110
	--! SUBU 11100 (10) (7) (4)
	--! SW 11011 (10) (7) ()
	-- SW_RS 01100 010 (sp) (ra) ()
	--! SW_SP 11010 (sp) (10) ()
	-- XOR 11101 (10) (7) (10) 01110
	--! LI 01101 (10) () ()

	r10 <= "0" & instruction(10 downto 8);
	r7 <= "0" & instruction(7 downto 5);
	r4 <= "0" & instruction(4 downto 2);
	ih <= "1000";
	sp <= "1001";
	ra <= "1010";
	empty <= "1111";

	rs <= result (11 downto 8);
	rt <= result (7 downto 4);
	rd <= result (3 downto 0);

------------ enable ------------
	write_back <= '0' when result(3 downto 0) = empty
		else '1';

	choseBIMM <= '1' when result(7 downto 4) = empty or instruction(15 downto 11) = "11011" or instruction(15 downto 11) = "11010"
		else '0';

	t_en <= '1' when instruction(15 downto 11) = "01010" --SLTI
			or instruction(15 downto 11) = "01011" --SLTUI
			or instruction(15 downto 11) = "01110" --CMPI
			or (instruction(15 downto 11) = "11101" and instruction(4 downto 0) = "00010") --SLT
			or (instruction(15 downto 11) = "11101" and instruction(4 downto 0) = "00011") --SLTU
			or (instruction(15 downto 11) = "11101" and instruction(4 downto 0) = "01010") --CMP
		else '0';

	t_tmp <= "10" when instruction(15 downto 11) = "01011" --SLTUI
			or (instruction(15 downto 11) = "11101" and instruction(4 downto 0) = "00011") --SLTU
		else "01";

	t_chose <= "00" when instruction(15 downto 11) = "01110" --CMPI
			or (instruction(15 downto 11) = "11101" and instruction(4 downto 0) = "01010") --CMP
		else t_tmp;
--------------------------------

	--get result
	with instruction(15 downto 11) select
		result <=
			last1 when "11110",
			last5 when "11101",
			next3 when "01100",

			r10 & empty & r10 when "01001", -- ADDIU
			r10 & empty & r7 when "01000", -- ADDIU3
			sp & empty & r10 when "00000", -- ADDSP3
			r10 & r7 & r4 when "11100", -- ADDU, SUBU
			r10 & empty & empty when "00100", -- BEQZ
			r10 & empty & empty when "00101", -- BNEZ
			r10 & empty & empty when "01110", -- CMPI
			r10 & empty & r7 when "10011", -- LW
			sp & empty & r10 when "10010", -- LW_SP
			r7 & empty & r10 when "01111", -- MOVE
			r7 & empty & r10 when "00110", -- SLL, SRA, SLV
			r10 & empty & empty when "01010", -- SLTI
			r10 & empty & empty when "01011", -- SLTUI
			r10 & r7 & empty when "11011", -- SW
			sp & r10 & empty when "11010", -- SW_SP
			empty & empty & r10 when "01101", -- LI
			(others => '1') when others;

	--last 1
	last1 <= ih & empty & r10 when instruction(0) = '0'
		else r10 & empty & ih;

	--last 8
	with instruction(7 downto 0) select
		last8 <=
			r10 & empty & ra when "11000000", -- JALR
			r10 & empty & empty when "00000000", --JR
			ra & empty & empty when "00100000", -- JRRA
			empty & empty & r10 when "01000000", -- MFPC
			(others => '1') when others;

	--last 5
	with instruction(4 downto 0) select
		last5 <=
			r10 & r7 & r10 when "01100", --AND
			r10 & r7 & empty when "01010", --CMP
			last8 when "00000", -- JALR JR JRRA MFPC
			r7 & empty & r10 when "01011", --NEG
			r7 & empty & r10 when "01111", --NOT
			r10 & r7 & r10 when "01101", --OR
			r7 & r10 & r7 when "00100", --SLLV
			r10 & r7 & empty when "00010", --SLT
			r10 & r7 & empty when "00011", --SLTU
			r7 & r10 & r7 when "00111", -- SRAV
			r7 & r10 & r7 when "00110", --SRLV
			r10 & r7 & r10 when "01110", --XOR
			(others => '1') when others;

	--next 3
	with instruction(10 downto 8) select
		next3 <=
			r7 & empty & sp when "100", -- MTSP
			sp & ra & empty when "010", -- SW_RS
			sp & empty & sp when "011", -- ADDSP
			(others => '1') when others;



end architecture ; -- main 
------------------------------------
-- 2012-11-23 10:34:18
-- Author : Keqing Chen
-- bypass
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity bypass is
	port (
		a_1, a_2, b_2, imm_2, pc_2, c_2, a_3, imm_3, pc_3, c_3, memread_3	:	in std_logic_vector(15 downto 0);
		instruction_1, instruction_2, instruction_3	:	in std_logic_vector(15 downto 0);
		write_back_data	:	in std_logic_vector(15 downto 0);

		rs_1, rs_2, rt_2, rd_2, rd_3, rd_4	:	in std_logic_vector(3 downto 0);

		writeback_2, writeback_3, writeback_4	:	in std_logic;

		a1_out, a2_out, b2_out	:	out std_logic_vector(15 downto 0);
		pause_signal	:	out std_logic
	);
end entity;

architecture main of bypass is

	signal result_3, a_c_3, pc_c_3	:	std_logic_vector(15 downto 0);
	signal result_2, a_c_2, pc_c_2	:	std_logic_vector(15 downto 0);
	signal less_mem, isJ	:	std_logic;
	signal use23, ause34, buse34	:	std_logic_vector(1 downto 0); -- [0: 2] [1: 3]

begin

--------------------- EXE <----- MEM & WB -------------------------
	a_c_3 <= c_3 when instruction_3(15 downto 8) = "01100011"
			else a_3;

	pc_c_3 <= pc_3 when instruction_3(7 downto 0) = "01000000"
			else c_3;

	with instruction_3(15 downto 11) select
		result_3 <=
			a_c_3 when "11110"| "01100",
			imm_3 when "01101",
			memread_3 when "10011"|"10010",
			pc_c_3 when "11101",
			c_3 when others;

	ause34(0) <= '1' when writeback_3 = '1' and rs_2 = rd_3
			else '0';
	ause34(1) <= '1' when writeback_4 = '1' and rs_2 = rd_4
			else '0';
	
	buse34(0) <= '1' when writeback_3 = '1' and rt_2 = rd_3
			else '0';
	buse34(1) <= '1' when writeback_4 = '1' and rt_2 = rd_4
			else '0';

	with ause34 select
		a2_out <= 
			result_3 when "01" | "11",
			write_back_data when "10",
			a_2 when others;
	
	with buse34 select
		b2_out <=
			result_3 when "01" | "11",
			write_back_data when "10",
			b_2 when others;

--	a2_out <= result_3 when writeback_3 = '1' and rs_2 = rd_3
--		else a_2;
--	b2_out <= result_3 when writeback_3 = '1' and rt_2 = rd_3
--		else b_2;
	
	


-------------------- ID <----- EXE & MEM ----------------------
	a_c_2 <= c_2 when instruction_2(15 downto 8) = "01100011"
			else a_2;

	pc_c_2 <= pc_2 when instruction_2(7 downto 0) = "01000000"
			else c_2;

	with instruction_2(15 downto 11) select
		result_2 <=
			a_c_2 when "11110"| "01100",
			imm_2 when "01101",
			pc_c_2 when "11101",
			c_2 when others; 
	
	with instruction_1(7 downto 0) select
		isJ <=
			'1' when "11000000" | "00000000" | "00100000",
			'0' when others;

	less_mem <= '1' when instruction_2(15 downto 11) = "10011" or instruction_2(15 downto 11) = "10010"
		else '0';

	use23(0) <= '1' when writeback_2 = '1' and rs_1 = rd_2 and ((instruction_1(15 downto 11) = "11101" and isJ = '1')
		or instruction_1(15 downto 11) = "00100" or instruction_1(15 downto 11) = "00101" )
		else '0';
	use23(1) <= '1' when writeback_3 = '1' and rs_1 = rd_3 and ((instruction_1(15 downto 11) = "11101" and isJ = '1')
		or instruction_1(15 downto 11) = "00100" or instruction_1(15 downto 11) = "00101" )
		else '0';

	with use23 select
		a1_out <=
			result_2 when "01" | "11",
			result_3 when "10",
			a_1 when others;

	pause_signal <= '0' when use23(0) = '1' and less_mem = '1'
		else '1';


end architecture ; -- main

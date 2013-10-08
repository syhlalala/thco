------------------------------------
-- 2012-11-17 19:27:49
-- Author : Keqing Chen
-- writeback_data 
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity writeback_data is
	port (
		imm, a, c, memread, pc	:	in std_logic_vector (15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		data 	:	out std_logic_vector (15 downto 0)
	);
end entity;

architecture main of writeback_data is

	signal pc_c, a_c	:	std_logic_vector (15 downto 0);

begin
	-- a, MFIH 11110 -- MTIH 11110 --  MTSP 01100
	-- imm, LI 01101
	-- memread, LW 10011 -- LW_SP 10010
	-- pc, MFPC 11101
	-- C, others
	
	a_c <= c when instruction(15 downto 8) = "01100011"
			else a;

	pc_c <= pc when instruction(7 downto 0) = "01000000"
			else c;

	with instruction(15 downto 11) select
		data <=
			a_c when "11110"| "01100",
			imm when "01101",
			memread when "10011"|"10010",
			pc_c when "11101",
			c when others;

end architecture ; -- main

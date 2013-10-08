------------------------------------
-- 2012-11-18 21:16:02
-- Author : Keqing Chen
-- branch 
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity branch is
	port (
		imm, a, pc, pc2	:	in std_logic_vector (15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		t 	:	in std_logic;
		ae0_test : out std_logic;

		next_pc	:	out std_logic_vector (15 downto 0)
	);
end entity;

architecture main of branch is

	signal pc_tmp, pc_tmp2	:	std_logic_vector (15 downto 0);
	signal ae0	:	std_logic;

begin
	ae0_test <= ae0;
	ae0 <= '0' when a = "0000000000000000" else '1';
	with instruction(7 downto 0) select
		pc_tmp2 <=
			a when "11000000"| "00000000"| "00100000",
			pc when others;

	with instruction(10 downto 8) & t select
		pc_tmp <=
			pc2 + imm when "0000" | "0011",
			pc when others;
	with instruction(15 downto 11) & ae0 select
		next_pc <=
			pc2 + imm when "000100" | "000101" | "001000" | "001011",
			pc_tmp when "011000" | "011001",
			pc_tmp2 when "111010" | "111011",
			pc when others;



end architecture ; -- main

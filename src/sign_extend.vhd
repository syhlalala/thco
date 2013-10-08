------------------------------------
-- 2012-11-17 15:50:26
-- Author : Keqing Chen
-- sign_extend 
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity sign_extend is
	port (
		instruction	:	in std_logic_vector (15 downto 0);
		imm	:	out std_logic_vector (15 downto 0)
	);
end entity;

architecture main of sign_extend is

	signal sign_bit	:	std_logic;
	signal sign_long	:	std_logic_vector (15 downto 0);
	signal shift	:	std_logic_vector (15 downto 0);

begin

	-- 10 ~ 0 00010 (1)
	-- 7 ~ 0 01001 00000 01100011 10010 01010 11010 01100 00100 01100000 01100001 (1)
	-- 7 ~ 0 01101 11111 (0) -- add int
	-- 3 ~ 0 01000 (1)
	-- 4 ~ 0 10011 11011 (1)
	-- 4 ~ 2 00110..00 00110..11 (1~7 -> 1~7; 0 -> 8)

	with instruction(15 downto 11) select
		sign_bit <=
			instruction(10) when "00010",
			instruction(7) when "01001" | "00000"| "10010"| "01010"| "11010"| "01100"| "00100"| "00101",
			'0' when "01101",
			instruction(4) when "10011"| "11011",
			instruction(4) when "00110",
			instruction(3) when "01000",
			'0' when others;
	sign_long <= (others => sign_bit);

	shift <= "0000000000001000" when instruction(4 downto 2) = "000"
		else "0000000000000" & instruction(4 downto 2);

	with instruction(15 downto 11) select
		imm <=
			sign_long(15 downto 11) & instruction(10 downto 0) when "00010",
			sign_long(15 downto 8) & instruction(7 downto 0) when "01001"| "00000"| "01100"| "10010"| "01010"| "11010"| "00100"| "00101",
			sign_long(15 downto 8) & instruction(7 downto 0) when "01101"| "11111",
			sign_long(15 downto 4) & instruction(3 downto 0) when "10011"| "11011",
			shift when "00110",
			sign_long(15 downto 4) & instruction(3 downto 0) when "01000",
			(others=>'0') when others;

end architecture ; -- main

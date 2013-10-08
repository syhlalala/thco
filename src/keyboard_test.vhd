------------------------------------
-- 2012-11-25 11:58:33
-- Author : Keqing Chen
-- keyboard_test
------------------------------------
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity keyboard_test is
	port(
		ps2data, ps2clock, clk_right, rst	:	in std_logic;
		oLed	:	out std_logic_vector (15 downto 0);
		iKey	:	in std_logic_vector (1 to 4)
	);
end keyboard_test;

architecture main of keyboard_test is
component keyboard_top is
	port (
		ps2data, ps2clock, clk_right, rst	:	in std_logic;
		rdn	:	in std_logic;
		ready	:	out std_logic;
		data	:	out std_logic_vector (5 downto 0)
	);
end component ;

	signal rst_in 	: 	std_logic;
	signal clk_f 	: 	std_logic;

begin
	rst_in <= not rst;

	keyboard_top_port :	keyboard_top port map (
		ps2data => ps2data,
		ps2clock => ps2clock,
		rst => rst,
		clk_right => clk_right,
		ready => oLed(15),
		data => oLed(5 downto 0),
		rdn => not iKey(1)
	);

	oLed(14 downto 6) <= (others => '0');

end architecture;


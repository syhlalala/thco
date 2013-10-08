----------------------------------------------------------------------------------
-- Create Date:    00:03:17 11/22/2012 
-- Design Name: syhlalal
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use Ieee.std_logic_unsigned.all;


entity regist_test is
	port (
		switch : in std_logic_vector(15 downto 0);
		oLed	:	out std_logic_vector(15 downto 0);
		ram1_addr	:	out std_logic_vector(17 downto 0);
		iKey	:	in std_logic_vector(1 to 4);
		clk	:	in std_logic
	);
end regist_test;

architecture main of regist_test is
component regist
	port (
  		clk	:	in std_logic;
		rs, rt, rd	:	in std_logic_vector (3 downto 0);
		r_data	:	in std_logic_vector (15 downto 0);
		a_out, b_out	:	out std_logic_vector (15 downto 0);

		wr_en	:	in std_logic
  	) ;
end component;

signal tmp : std_logic_vector(15 downto 0);
begin
	tmp <= "000000000000"&switch(3 downto 0);
	REGIST_PORT	: regist port map (
		clk => clk,
		rs => switch(15 downto 12),
		rt => switch(11 downto 8),
		rd => switch(7 downto 4),
		r_data => tmp,
		a_out => oLed,
		b_out => ram1_addr(15 downto 0),
		wr_en => iKey(1)
	);
	ram1_addr(17 downto 16) <= "00";

end main;


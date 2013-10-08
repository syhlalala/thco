-------------------------------------------------------
-- Create Date:    11:43:32 11/18/2012 
-- Design Name:    Keqing Chen
-------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity uart_test is
	port (
		clk_right	:	in std_logic;
		ram1_data	:	inout std_logic_vector (15 downto 0);
		tbre, tsre, data_ready	:	in std_logic;
		rdn, wrn	:	out std_logic;
		
		oLed	:	out std_logic_vector(15 downto 0);
		switch	:	in std_logic_vector(15 downto 0);
		iKey	:	in std_logic_vector(4 downto 1);
		ram1_en	:	out std_logic
	);
end uart_test;

architecture main of uart_test is
component uart
	port (
		clk	:	in std_logic;
		data	:	inout std_logic_vector(7 downto 0);
		tbre, tsre, data_ready 	:	in std_logic;
		wrn, rdn 	:	out std_logic;

		data_in	:	in std_logic_vector(7 downto 0);
		data_out 	:	out std_logic_vector (7 downto 0);
		wr_en	:	in std_logic; --[0 : read] [1 : write]
		enable 	:	in std_logic
	);
end component;

	signal tmp	:	std_logic;
	
begin
	ram1_en <= '1';
	tmp <= '0' when  iKey(1) = '1' else '1';
	oLed(15) <= data_ready;
	oLed(14) <= tbre;
	oLed(13) <= tsre;
	oLed(12 downto 8) <= (others => '0');

	TEST	:	uart port map (
		clk => clk_right,
		data => ram1_data (7 downto 0),
		tbre => tbre,
		tsre => tsre,
		data_ready => data_ready,
		rdn => rdn,
		wrn => wrn,
		
		data_in => switch (7 downto 0),
		data_out => oLed (7 downto 0),
		wr_en => switch(15),
		enable => tmp
	);

end main;


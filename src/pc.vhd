------------------------------------
-- 2012-11-14 20:14:33
-- Author : Keqing Chen
-- pc
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity pc is
	port (
		clk, rst	:	in std_logic;

		pc_in	:	in std_logic_vector (15 downto 0); -- input
		pc_out	:	out std_logic_vector (15 downto 0); -- output
		pc_plus1	:	out std_logic_vector (15 downto 0); -- pc + 1

		pc_en	:	in std_logic; -- [1: pc work] [0: stop pc]

		pc_int_pause	:	in std_logic
	);
end entity;

architecture main of pc is

	signal pc_reg	:	std_logic_vector (15 downto 0);
	signal enable	:	std_logic;

begin

	pc_out <= pc_reg;
	pc_plus1 <= pc_reg + 1;
	enable <= pc_en and pc_int_pause;

	pc_change : process( clk, rst, enable )
	begin
		if rst = '0' then
			pc_reg <= (others => '0');
		elsif enable = '0' then
			
		elsif clk'event and clk = '1' then
			pc_reg <= pc_in;
		end if ;
	end process ; -- pc_change

end architecture ; -- main

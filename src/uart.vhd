------------------------------------
-- 2012-11-18 02:23:17
-- Author : Keqing Chen
-- uart 
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity uart is
	port (
		clk, rst	:	in std_logic;
		data	:	inout std_logic_vector(7 downto 0);
		tbre, tsre, data_ready 	:	in std_logic;
		wrn, rdn 	:	out std_logic;

		data_in	:	in std_logic_vector(7 downto 0);
		data_out 	:	out std_logic_vector (7 downto 0);
		wr_en	:	in std_logic; --[0 : read] [1 : write]
		enable 	:	in std_logic
	);
end entity;

architecture main of uart is

	type SWITCH_STATE is (
		READING,
		WRITING,
		IDLE,
		IDLE_READ
	);

	signal data_tmp 	:	std_logic_vector(7 downto 0);
	signal state 	:	SWITCH_STATE;
	signal chose	:	SWITCH_STATE;
	signal chose_tmp	:	SWITCH_STATE;
	signal enable_tmp 	:	std_logic := '0';

begin

	data <= data_in when wr_en = '1'
		else (others => 'Z');
	data_out <= data_tmp;
	chose_tmp <= WRITING when wr_en = '1'
		else READING;
	chose <= chose_tmp when enable_tmp = '1'
		else IDLE;
	enable_tmp <= enable;

	read_write_logic : process( clk )
	begin
		if rst = '0' then
			state <= IDLE;
			rdn <= '1';
			wrn <= '1';
		elsif clk'event and clk = '1' then
			case( state ) is
			
				when IDLE =>
					rdn <= '1';
					wrn <= '1';
					state <= chose;
				when READING =>
					rdn <= '0';
					state <= IDLE_READ;
				when WRITING =>
					wrn <= '0';
					state <= IDLE;
				when IDLE_READ =>
					data_tmp <= data;
					rdn <= '1';
					state <= IDLE;
				when others =>
					state <= IDLE;
			
			end case ;

		end if;
	end process ; -- read_write_logic
end architecture ; -- main

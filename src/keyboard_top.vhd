----------------------------------------------------------------------------------
-- 13:21:48 11/25/2012
-- Author:	Keqing Chen
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity keyboard_top is
	port (
		ps2data, ps2clock, clk_right, rst	:	in std_logic;
		rdn 	:	in std_logic;
		ready	:	out std_logic;
		data	:	out std_logic_vector (5 downto 0)
	);
end keyboard_top;

architecture main of keyboard_top is
component Keyboard is
	port (
		datain, clkin	: 	in std_logic ; -- PS2 clk and data
		fclk, rst 	: 	in std_logic ;  -- filter clock
	--	fok : out std_logic ;  -- data output enable signal
		scancode 	: 	out std_logic_vector(7 downto 0) -- scan code signal output
	);
end component ;

	type state_key is (
		IDLE,
		F0,
		CODE
	);
	
	signal st, next_st, f0_next	:	state_key;

	signal rst_in, is_reading, read_tmp 	: 	std_logic;
	signal data_lock, data_out	:	std_logic_vector(7 downto 0);

begin
	rst_in <= not rst;
--	data <= data_out;
	ready <= read_tmp;
	with data_out select
		data <= 
			"000001" when "00011100" , 
			"000010" when "00110010" , 
			"000011" when "00100001" , 
			"000100" when "00100011" , 
			"000101" when "00100100" , 
			"000110" when "00101011" , 
			"000111" when "00110100" , 
			"001000" when "00110011" , 
			"001001" when "01000011" , 
			"001010" when "00111011" , 
			"001011" when "01000010" , 
			"001100" when "01001011" , 
			"001101" when "00111010" , 
			"001110" when "00110001" , 
			"001111" when "01000100" , 
			"010000" when "01001101" , 
			"010001" when "00010101" , 
			"010010" when "00101101" , 
			"010011" when "00011011" , 
			"010100" when "00101100" , 
			"010101" when "00111100" , 
			"010110" when "00101010" , 
			"010111" when "00011101" , 
			"011000" when "00100010" , 
			"011001" when "00110101" , 
			"011010" when "00011010" , 
			"110000" when "01000101" , 
			"110001" when "00010110" , 
			"110010" when "00011110" , 
			"110011" when "00100110" , 
			"110100" when "00100101" , 
			"110101" when "00101110" , 
			"110110" when "00110110" , 
			"110111" when "00111101" , 
			"111000" when "00111110" , 
			"111001" when "01000110" , 
			"100111" when "01001110" , 
			"100101" when "01010101" , 
			"100011" when "01000001" , 
			"100100" when "01001001" , 
			"000000" when "00101001" , 
			"011110" when "01011010" ,
			"000000" when others;


	Keyboard_port :	Keyboard port map (
		datain => ps2data,
		clkin => ps2clock,
		rst => rst_in,
		fclk => clk_right,
		scancode => data_lock
	);

	is_reading <= '0' when rdn = '1'
		else read_tmp;
	next_st <= F0 when data_lock = "11110000"
		else IDLE;
	f0_next <= F0 when data_lock = "11110000"
		else CODE;

	DATAREADY : process ( clk_right, rst )
	begin
		if rst = '0' then
			read_tmp <= '0';
			st <= IDLE;
		elsif clk_right'event and clk_right = '1' then
			case st is
				when IDLE =>
					read_tmp <= is_reading;
					st <= next_st;
				when F0 =>
					st <= f0_next;
				when CODE =>
					data_out <= data_lock;
					read_tmp <= '1';
					st <= IDLE;
				when others =>
					st <= IDLE;
			end case;
		end if;
	end process;

end main;


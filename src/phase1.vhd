------------------------------------
-- 2012-11-19 00:49:18
-- Author : Keqing Chen
-- phase1 -IF/ID
------------------------------------
-- 2012-11-24 14:43:15
-- Author : Keeqing Chen
-- another work : interrupt
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity phase1 is
	port (
		clk, enable, rst	:	in std_logic;
		pc_in, instruction_in	:	in std_logic_vector (15 downto 0);
		pc_out, instruction_out	:	out std_logic_vector (15 downto 0);

		pause_pc	:	out std_logic
	);
end entity;

architecture main of phase1 is

	signal pc, instruction	:	std_logic_vector (15 downto 0);
	signal state_int 	:	std_logic_vector (3 downto 0);

	signal start_state	:	std_logic_vector (3 downto 0);

	signal pc_int, instruction_int 	:	std_logic_vector (15 downto 0);
	signal imm_tmp 	:	std_logic_vector(3 downto 0);

begin

	pc_out <= pc;
	instruction_out <= instruction;


---------------- interrupt --------------
	start_state <= "0001" when instruction(15 downto 8) = "11111000"
		else "0000";

	pause_pc <= '0' when state_int > "0000" and state_int < "1001"
		else '1';

	--pc_int <= pc_in when state_int = "0000" or state_int > "1010"
	--	else pc;

	pc_int <= pc_in;

	with state_int select
		instruction_int <=
			"1110111001000000" when "0001", -- <ee40> 	MFPC R6
			"0100111000000000" when "0010", -- <4e00> 	ADDIU R6 00 <- (>_<)~
			"0110001111111111" when "0011", -- <63ff> 	ADDSP FF
			"1101011000000000" when "0100", -- <d600> 	SW_SP R6 00
			"011011100000" & imm_tmp when "0101", -- <6e00> 	LI R6 00
			"0110001111111111" when "0110", -- <63ff> 	ADDSP FF
			"1101011000000000" when "0111", -- <d600> 	SW_SP R6 00
			"0110111000000111" when "1000", -- <6e07> 	LI R6 07 
			"1110111000000000" when "1001", -- <ee00> 	JR R6
			--"0000100000000000" when "1010", -- <0800> 	NOP
			instruction_in when others;

	interrupt_process : process( clk, rst, enable)
	begin
		if rst = '0' then
			state_int <= "0000";
		elsif enable = '0' then
			
		elsif clk'event and clk = '0' then
			case( state_int ) is
				when "0000" =>
					state_int <= start_state;
					imm_tmp <= instruction(3 downto 0);
				when "0001" => 
					state_int <= "0010";
				when "0010" =>
					state_int <= "0011";
				when "0011" =>
					state_int <= "0100";
				when "0100" =>
					state_int <= "0101";
				when "0101" =>
					state_int <= "0110";
				when "0110" =>
					state_int <= "0111";
				when "0111" =>
					state_int <= "1000";
				when "1000" =>
					state_int <= "1001";
				when "1001" =>
					state_int <= "1010";
--				when "1010" =>
--					state_int <= "0000";
				when others =>
					state_int <= "0000";
			end case ;
		end if;
	end process ; -- interrupt_process
	
-------------------------------------------------------

	record_process : process( clk, enable, rst )
	begin
		if rst = '0' then
			instruction <= (others => '0');
			pc <= (others => '0');
		elsif enable = '0' then
		elsif clk'event and clk = '1' then
			pc <= pc_int;
			instruction <= instruction_int;
		end if;
	end process ; -- record

end architecture ; -- main

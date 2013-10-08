------------------------------------
-- 2012-11-14 20:14:33
-- Author : Keqing Chen
-- memory 
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity memory is
	port (
		clk, rst 	:	in std_logic;
		ram2_data	:	inout std_logic_vector (15 downto 0);
		ram2_en, ram2_we, ram2_oe	:	out std_logic;
		ram2_addr 	:	out std_logic_vector (17 downto 0);
		ram1_data	:	inout std_logic_vector (15 downto 0);
		tbre, tsre, data_ready 	:	in std_logic;
		wrn, rdn 	:	out std_logic;
		
		enables_test	:	out std_logic_vector(2 downto 0);

		address_pc	:	in std_logic_vector (15 downto 0);
		data_pc	:	out std_logic_vector (15 downto 0);

		address, data_in	:	in std_logic_vector (15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		data_out	:	out std_logic_vector (15 downto 0);
		
		
		hs,vs: out STD_LOGIC; 
		r,g,b: out STD_LOGIC_vector(2 downto 0);
		
		ps2data, ps2clock	:	in std_logic
	);
end entity;

architecture main of memory is

component uart
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
end component;

component sram
	port (
		clk_high, rst	:	in std_logic;

		ram_en, ram_we, ram_oe	:	out std_logic;
		ram_addr	:	out std_logic_vector (17 downto 0);
		ram_data 	:	inout std_logic_vector (15 downto 0);

		ram_data_in	:	in std_logic_vector (15 downto 0);
		ram_addr_ro	:	in std_logic_vector (15 downto 0); -- read only memory
		ram_addr_wr	:	in std_logic_vector (15 downto 0); -- read and write memory
		ram_data_out_ro,
		ram_data_out_wr	:	out std_logic_vector (15 downto 0);

		wr_en	:	in std_logic -- read and write enable [0 : read] [1 : write]
	);
end component;

component top_vga
	port(
		address	:	in std_logic_vector(10 downto 0);
		data	:	in std_logic_vector(5 downto 0);
		enable	:	in std_logic;
	
		clk_right,rst: in std_logic;
		hs,vs: out STD_LOGIC; 
		r,g,b: out STD_LOGIC_vector(2 downto 0)
	);
end component;

component keyboard_top is
	port (
		ps2data, ps2clock, clk_right, rst	:	in std_logic;
		rdn	:	in std_logic;
		ready	:	out std_logic;
		data	:	out std_logic_vector (5 downto 0)
	);
end component ;


	signal uart_data, ram_data	:	std_logic_vector (15 downto 0);
	signal uart_wr_en, uart_enable, ram_wr_en	:	std_logic;
	signal uart_write	:	std_logic;
	signal write_read	:	std_logic;
	signal vga_enable	:	std_logic;
	signal key_data	:	std_logic_vector(5 downto 0);
	signal key_rdn, key_ready : std_logic;

begin
	ram1_data(15 downto 8) <= (others => 'Z');
	enables_test <= uart_enable & uart_wr_en & ram_wr_en;
	
	uart_write <= '1' when tbre = '1' and tsre = '1' else '0';

	write_read <= '1' when 
			instruction(15 downto 11) = "11011" or instruction (15 downto 8) = "01100010" or instruction (15 downto 11) = "11010"
		else '0';

	with address select
		data_out <=
			uart_data when "1011111100000000", --BF00
			"00000000000000" & data_ready & uart_write when "1011111100000001", --BF01
			"0000000000" & key_data when "1011111100000010", --BF02
			"000000000000000" & key_ready when "1011111100000011", --BF03
			ram_data when others;

	uart_enable <= '1' when 
			address = "1011111100000000" and (instruction(15 downto 11) = "10011" or instruction (15 downto 11) = "10010" or write_read = '1')
		else '0';

	ram_wr_en <= write_read;
	uart_wr_en <= write_read;
	
	key_rdn <= '1' when instruction(15 downto 11) = "10011" and address = "1011111100000010"
		else '0';
	
	vga_enable <= '1' when address(15 downto 11) = "11111" and ram_wr_en = '1'
		else '0';

	uart_data (15 downto 8) <= (others => '0');

	port_uart : uart port map(
		clk => clk,
		data => ram1_data (7 downto 0),
		tbre => tbre,
		tsre => tsre,
		data_ready => data_ready,
		wrn => wrn,
		rdn => rdn,
		rst => rst,

		data_in => data_in (7 downto 0),
		data_out => uart_data (7 downto 0),
		wr_en => uart_wr_en,
		enable => uart_enable
	);

	port_sram : sram port map (
		clk_high => clk,

		ram_en => ram2_en,
		ram_we => ram2_we,
		ram_oe => ram2_oe,
		ram_addr => ram2_addr,
		ram_data => ram2_data,
		rst => rst,

		ram_data_in => data_in,
		ram_addr_ro => address_pc,
		ram_addr_wr => address,
		ram_data_out_ro => data_pc,
		ram_data_out_wr => ram_data,

		wr_en => ram_wr_en
	);
	
	port_vga : top_vga port map (
		address => address(10 downto 0),
		data => data_in(5 downto 0),
		enable => vga_enable,
		
		clk_right => clk,
		rst => rst,
		hs => hs,
		vs => vs,
		r => r,
		g => g,
		b => b
	);
	
	keyboard_top_port :	keyboard_top port map (
		ps2data => ps2data,
		ps2clock => ps2clock,
		rst => rst,
		clk_right => clk,
		ready => key_ready,
		data => key_data,
		rdn => key_rdn
	);


end architecture ; -- main

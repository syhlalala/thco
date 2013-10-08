----------------------------------------------------------------------------------
-- Create Date:    23:50:42 11/14/2012 
-- Design Name:    Keqing Chen
----------------------------------------------------------------------------------
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity sram_test is
	port (
		clk_right, clk,rst	:	in std_logic;
		ram2_data	:	inout std_logic_vector (15 downto 0);
		ram2_addr	:	out	std_logic_vector (17 downto 0);
		ram2_en, ram2_we, ram2_oe	:	out std_logic;
		
		switch	:	in std_logic_vector (15 downto 0);
		
		oLed	:	out std_logic_vector (15 downto 0);
		
		ram1_addr	:	out std_logic_vector (17 downto 0);
		
		iKey	:	in std_logic_vector (1 to 4);
		ram1_en	:	out std_logic
	);
end sram_test;

architecture main of sram_test is

component sram 
	port (
		clk_high,rst	:	in std_logic;

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

signal data : std_logic_vector(15 downto 0);
signal data1,data2 : std_logic_vector(15 downto 0);

signal addr1, addr2	: std_logic_vector(15 downto 0);

signal ram2_addr_tmp : std_logic_vector(17 downto 0);

begin
	ram2_addr <= ram2_addr_tmp;

	ram1_en <= '1';
	TEST : sram port map (
		rst => rst,
		clk_high => clk_right,
		ram_en	=> ram2_en,
		ram_oe	=> ram2_oe,
		ram_we	=> ram2_we,
		ram_addr	=> ram2_addr_tmp,
		ram_data	=> ram2_data,
		ram_data_in => data,
		ram_addr_ro => addr1,
		ram_addr_wr => addr2,
		
		ram_data_out_ro => data1,
		ram_data_out_wr => data2,
		
		wr_en => not iKey(1)
	);
	
	addr1 <= switch; 
	addr2 <= "1000000000100001";
	
	data <= "00000000" & switch (15 downto 8);
	
	oLed <= data1;

	ram1_addr <= iKey(1 to 1) & "0" & addr1 (15 downto 0);

end main;


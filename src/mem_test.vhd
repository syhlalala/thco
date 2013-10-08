----------------------------------------------------------------------------------
-- Create Date:    23:50:42 11/14/2012 
-- Design Name:    Keqing Chen
----------------------------------------------------------------------------------
library IEEE;

use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity mem_test is
	port (
		clk_right, rst	:	in std_logic;
		ram2_data	:	inout std_logic_vector (15 downto 0);
		ram2_addr	:	out	std_logic_vector (17 downto 0);
		ram2_en, ram2_we, ram2_oe	:	out std_logic;
		switch	:	in std_logic_vector (15 downto 0);
		oLed	:	out std_logic_vector (15 downto 0);
		wrn, rdn	:	out std_logic;
		tbre, tsre, data_ready	:	in std_logic;
		ram1_data	:	inout std_logic_vector (15 downto 0);
		
		iKey	:	in std_logic_vector (1 to 4)
	);
end mem_test;

architecture main of mem_test is

component memory 
	port (
		clk,rst 	:	in std_logic;
		ram2_data	:	inout std_logic_vector (15 downto 0);
		ram2_en, ram2_we, ram2_oe	:	out std_logic;
		ram2_addr 	:	out std_logic_vector (17 downto 0);
		ram1_data	:	inout std_logic_vector (15 downto 0);
		tbre, tsre, data_ready 	:	in std_logic;
		wrn, rdn 	:	out std_logic;

		address_pc	:	in std_logic_vector (15 downto 0);
		data_pc	:	out std_logic_vector (15 downto 0);

		address, data_in	:	in std_logic_vector (15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		data_out	:	out std_logic_vector (15 downto 0)
	);
end component;

signal  address_pc_tmp	:	std_logic_vector(15 downto 0);
signal	data_pc_tmp	:	std_logic_vector(15 downto 0);
signal	address_tmp	:	std_logic_vector(15 downto 0);
signal	data_in_tmp	:	std_logic_vector(15 downto 0);
signal	instruction_tmp	:	std_logic_vector(15 downto 0);
signal	data_out_tmp	:	std_logic_vector(15 downto 0);

begin

	instruction_tmp <= "0000000000000000";
	--LW 1001100000000000
	--SW 1101100000000000
	address_pc_tmp <= "0000000000000000";
	address_tmp <= "1000000000010001";
	data_in_tmp <= switch;
	oLed <= data_pc_tmp;
	
	TEST : memory port map (
		rst => rst,
		clk	=> clk_right,
		ram2_data => ram2_data,
		ram2_en => ram2_en,
		ram2_we => ram2_we,
		ram2_oe => ram2_oe,
		ram2_addr => ram2_addr,
		ram1_data => ram1_data,
		tbre => tbre,
		tsre => tsre,
		data_ready => data_ready,
		wrn => wrn,
		rdn => rdn,
		address_pc => address_pc_tmp,
		data_pc => data_pc_tmp,
		address => address_tmp,
		data_in => data_in_tmp,
		instruction => instruction_tmp,
		data_out => data_out_tmp
	);


end main;


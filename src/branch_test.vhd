----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:54 11/22/2012 
-- Design Name: 
-- Module Name:    branch_test - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity branch_test is
	port (
		oLed : out std_logic_vector(15 downto 0);
		ram1_addr : out std_logic_vector( 17 downto 0)
	);
end branch_test;

architecture main of branch_test is

component branch
	port (
		imm, a, pc, pc2	:	in std_logic_vector (15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		t 	:	in std_logic;
		ae0_test : out std_logic;

		next_pc	:	out std_logic_vector (15 downto 0)
	);
end component;

signal instruction_tmp, imm_tmp, a_tmp, pc_tmp, pc2_tmp : std_logic_vector(15 downto 0);
signal t_tmp : std_logic;

begin
	instruction_tmp <= "0010101011100111";
	imm_tmp <= "0000000011100111";
	a_tmp <= "0000000000001111";
	pc_tmp  <= "0000000000011111";
	pc2_tmp <= "0000000000011110";
	t_tmp <= '0';
	ram1_addr(16 downto 0) <= (others => '0');
	BRANCH_TEST : branch port map (
		imm => imm_tmp,
		a => a_tmp,
		pc => pc_tmp,
		pc2 => pc2_tmp,
		instruction => instruction_tmp,
		t => t_tmp,
		ae0_test => ram1_addr(17),
		
		next_pc => oLed
	);
	
end main;


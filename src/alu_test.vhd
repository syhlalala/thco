library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_test is
	port (
		switch	:	in std_logic_vector (15 downto 0);
		oLed	:	out std_logic_vector (15 downto 0);
		ram1_addr	:	out std_logic_vector (17 downto 0)
	);
end alu_test;

architecture Behavioral of alu_test is
	component alu
		port (
			instruction	:	in std_logic_vector (15 downto 0);
			op1, b, imm	:	in std_logic_vector (15 downto 0);
			t_chose	:	in std_logic_vector (1 downto 0);
			t_result	:	out std_logic;
			choseIMM	:	in std_logic;

			c 	:	out std_logic_vector (15 downto 0)
		);
	end component;
signal ins	:	std_logic_vector(15 downto 0);
signal op1_tmp	:	std_logic_vector(15 downto 0);
signal b_tmp	:	std_logic_vector(15 downto 0);
signal imm_tmp	:	std_logic_vector(15 downto 0);
signal t_chose_tmp	:	std_logic_vector(1 downto 0);
signal choseIMM_tmp	:	std_logic;
signal zero_pre	:	std_logic_vector(11 downto 0);

begin
	ins <= "0011000100100000";
	zero_pre <= (others => '0');
	op1_tmp <= "0000000010111111";
	b_tmp <= zero_pre & switch(11 downto 8);
	imm_tmp <= "0000000000001000";
	t_chose_tmp <= "00";
	choseIMM_tmp <= '1';
	
	MAIN : alu port map (
		instruction	=> ins,
		op1 => op1_tmp,
		b => b_tmp,
		imm => imm_tmp,
		t_chose => t_chose_tmp,
		t_result => ram1_addr(17),
		choseIMM => choseIMM_tmp,
		c => oLed
	);
	ram1_addr(16 downto 0) <= (others => '0');
end Behavioral;


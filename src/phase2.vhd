------------------------------------
-- 2012-11-19 01:06:45
-- Author : Keqing Chen
-- phase2 - ID/EXE
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity phase2 is
	port (
		clk, enable, rst	:	in std_logic;
		pc_in, instruction_in,  a_in, b_in, imm_in	:	in std_logic_vector (15 downto 0);
		pc_out, instruction_out,  a_out, b_out, imm_out	:	out std_logic_vector (15 downto 0);
		rs_in, rt_in, rd_in 	:	in std_logic_vector (3 downto 0);

		rs_out, rt_out, rd_out 	:	out std_logic_vector (3 downto 0);

		write_back_in	:	in std_logic; -- [0 : no] [1 : yes]
		choseBIMM_in	:	in std_logic; -- [0 : B] [1 : IMM] on ALU
		t_en_in	:	in std_logic; -- [0 : no] [1 : yes]
		t_chose_in	:	in std_logic_vector (1 downto 0); -- [00 : != ] [01 : <] [10 : u > ]

		write_back_out	:	out std_logic; -- [0 : no] [1 : yes]
		choseBIMM_out	:	out std_logic; -- [0 : B] [1 : IMM] on ALU
		t_en_out	:	out std_logic; -- [0 : no] [1 : yes]
		t_chose_out	:	out std_logic_vector (1 downto 0); -- [00 : != ] [01 : <] [10 : u > ]
		
		hazard	:	in std_logic
	);
end entity;

architecture main of phase2 is

	signal pc, instruction, a, b, imm	:	std_logic_vector (15 downto 0);
	signal rs, rt, rd 	:	std_logic_vector (3 downto 0);
	signal write_back	:	std_logic; -- [0 : no] [1 : yes]
	signal choseBIMM	:	std_logic; -- [0 : B] [1 : IMM] on ALU
	signal t_en	:	std_logic; -- [0 : no] [1 : yes]
	signal t_chose	:	std_logic_vector (1 downto 0); -- [00 : != ] [01 : <] [10 : u > ]
	
	signal instruction_hazard	:	std_logic_vector (15 downto 0);
	signal t_en_hazard, write_back_hazard	:	std_logic;

begin

	pc_out <= pc;
	instruction_out <= instruction;
	write_back_out <= write_back;
	choseBIMM_out <= choseBIMM;
	t_en_out <= t_en;
	t_chose_out <= t_chose;
	a_out <= a;
	b_out <= b;
	imm_out <= imm;
	rs_out <= rs;
	rd_out <= rd;
	rt_out <= rt;
	
	t_en_hazard <= t_en_in when hazard = '1'
		else '0';
	write_back_hazard <= write_back_in when hazard = '1'
		else '0';
	instruction_hazard <= instruction_in when hazard = '1'
		else "0000100000000000";

	record_process : process( clk, enable, rst )
	begin
		if rst = '0' then
			instruction <= (others => '0');
			pc <= (others => '0');
			write_back <= '0';
			t_en <= '0';
		elsif enable = '0' then
		elsif clk'event and clk = '1' then
			pc <= pc_in;
			instruction <= instruction_hazard;
			write_back <= write_back_hazard;
			choseBIMM <= choseBIMM_in;
			t_en <= t_en_hazard;
			t_chose <= t_chose_in;
			a <= a_in;
			b <= b_in;
			imm <= imm_in;
			rs <= rs_in;
			rd <= rd_in;
			rt <= rt_in;
		end if;
	end process ; -- record

end architecture ; -- main

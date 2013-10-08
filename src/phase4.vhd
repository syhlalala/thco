------------------------------------
-- 2012-11-19 01:32:11
-- Author : Keqing Chen
-- phase4 - MEM/WB
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity phase4 is
	port (
		clk, enable, rst	:	in std_logic;
		pc_in, instruction_in,  a_in, b_in, c_in, imm_in, mem_data_in	:	in std_logic_vector (15 downto 0);
		pc_out, instruction_out,  a_out, b_out, c_out, imm_out, mem_data_out	:	out std_logic_vector (15 downto 0);

		rs_in, rt_in, rd_in 	:	in std_logic_vector (3 downto 0);

		rs_out, rt_out, rd_out 	:	out std_logic_vector (3 downto 0);

		write_back_in	:	in std_logic; -- [0 : no] [1 : yes]
		choseBIMM_in	:	in std_logic; -- [0 : B] [1 : IMM] on ALU
		t_en_in	:	in std_logic; -- [0 : no] [1 : yes]
		t_chose_in	:	in std_logic_vector (1 downto 0); -- [00 : != ] [01 : <] [10 : u > ]

		write_back_out	:	out std_logic; -- [0 : no] [1 : yes]
		choseBIMM_out	:	out std_logic; -- [0 : B] [1 : IMM] on ALU
		t_en_out	:	out std_logic; -- [0 : no] [1 : yes]
		t_chose_out	:	out std_logic_vector (1 downto 0) -- [00 : != ] [01 : <] [10 : u > ]
	);
end entity;

architecture main of phase4 is

	signal pc, instruction, a, b, c, imm, mem_data	:	std_logic_vector (15 downto 0);
	signal rs, rt, rd 	:	std_logic_vector (3 downto 0);
	signal write_back	:	std_logic; -- [0 : no] [1 : yes]
	signal choseBIMM	:	std_logic; -- [0 : B] [1 : IMM] on ALU
	signal t_en	:	std_logic; -- [0 : no] [1 : yes]
	signal t_chose	:	std_logic_vector (1 downto 0); -- [00 : != ] [01 : <] [10 : u > ]

begin

	pc_out <= pc;
	instruction_out <= instruction;
	write_back_out <= write_back;
	choseBIMM_out <= choseBIMM;
	t_en_out <= t_en;
	t_chose_out <= t_chose;
	a_out <= a;
	b_out <= b;
	c_out <= c;
	imm_out <= imm;
	mem_data_out <= mem_data;
	rs_out <= rs;
	rd_out <= rd;
	rt_out <= rt;

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
			instruction <= instruction_in;
			write_back <= write_back_in;
			choseBIMM <= choseBIMM_in;
			t_en <= t_en_in;
			t_chose <= t_chose_in;
			a <= a_in;
			b <= b_in;
			c <= c_in;
			imm <= imm_in;
			mem_data <= mem_data_in;
			rs <= rs_in;
			rd <= rd_in;
			rt <= rt_in;
		end if;
	end process ; -- record

end architecture ; -- main

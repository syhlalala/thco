------------------------------------
-- 2012-11-21 19:32:29
-- Author : Keqing Chen
-- top_cpu
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity top_cpu is
	port (
		clk, clk_right, rst	:	in std_logic;
		iKey	:	in std_logic_vector(1 to 4);
		oLed	:	out std_logic_vector (15 downto 0);
		switch 	:	in std_logic_vector (15 downto 0);

		wrn, rdn 	:	out std_logic;
		data_ready, tbre, tsre	:	in std_logic;
		ram1_data	:	inout std_logic_vector(15 downto 0);

		ram1_en	:	out std_logic;

		ram2_data	:	inout std_logic_vector(15 downto 0);
		ram2_addr	:	out std_logic_vector(17 downto 0);
		ram2_en, ram2_oe, ram2_we	:	out std_logic;
		
		ram1_addr	:	out std_logic_vector(17 downto 0);
		
		hs,vs: out STD_LOGIC; 
		red, green, blue: out STD_LOGIC_vector(2 downto 0);
		ps2data, ps2clock	:	in std_logic
	);
end entity;

architecture main of top_cpu is

component alu
	port (
		instruction	:	in std_logic_vector (15 downto 0);
		op1, b, imm	:	in std_logic_vector (15 downto 0);
		t_chose	:	in std_logic_vector (1 downto 0);
		t_result	:	out std_logic;
		choseIMM	:	in std_logic;

		c 	:	out std_logic_vector (15 downto 0);
		
		ops :	out std_logic_vector (15 downto 0)
	);
end component;

component branch
	port (
		imm, a, pc, pc2	:	in std_logic_vector (15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		t 	:	in std_logic;
		ae0_test : out std_logic;

		next_pc	:	out std_logic_vector (15 downto 0)
	);
end component;

component memory
	port (
		clk, rst 	:	in std_logic;
		ram2_data	:	inout std_logic_vector (15 downto 0);
		ram2_en, ram2_we, ram2_oe	:	out std_logic;
		ram2_addr 	:	out std_logic_vector (17 downto 0);
		ram1_data	:	inout std_logic_vector (15 downto 0);
		tbre, tsre, data_ready 	:	in std_logic;
		wrn, rdn 	:	out std_logic;
		
		enables_test : out std_logic_vector(2 downto 0);

		address_pc	:	in std_logic_vector (15 downto 0);
		data_pc	:	out std_logic_vector (15 downto 0);

		address, data_in	:	in std_logic_vector (15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		data_out	:	out std_logic_vector (15 downto 0);
		
		hs,vs: out STD_LOGIC; 
		r,g,b: out STD_LOGIC_vector(2 downto 0);
		
		ps2data, ps2clock	:	in std_logic
	);
end component;

component pc
	port (
		clk, rst	:	in std_logic;

		pc_in	:	in std_logic_vector (15 downto 0); -- input
		pc_out	:	out std_logic_vector (15 downto 0); -- output
		pc_plus1	:	out std_logic_vector (15 downto 0); -- pc + 1

		pc_en	:	in std_logic; -- [1: pc work] [0: stop pc]
		pc_int_pause	:	in std_logic
	);
end component;

component phase1
	port (
		clk, enable, rst	:	in std_logic;
		pc_in, instruction_in	:	in std_logic_vector (15 downto 0);
		pc_out, instruction_out	:	out std_logic_vector (15 downto 0);
		pause_pc 	:	out std_logic
	);
end component;

component phase2
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
end component;

component phase3
	port (
		clk, enable, rst	:	in std_logic;
		pc_in, instruction_in,  a_in, b_in, c_in, imm_in	:	in std_logic_vector (15 downto 0);
		pc_out, instruction_out,  a_out, b_out, c_out, imm_out	:	out std_logic_vector (15 downto 0);

		rs_in, rt_in, rd_in 	:	in std_logic_vector (3 downto 0);

		rs_out, rt_out, rd_out 	:	out std_logic_vector (3 downto 0);

		write_back_in	:	in std_logic; -- [0 : no] [1 : yes]
		
		write_back_out	:	out std_logic -- [0 : no] [1 : yes]
	);
end component;

component phase4
	port (
		clk, enable, rst	:	in std_logic;
		pc_in, instruction_in,  a_in, b_in, c_in, imm_in, mem_data_in	:	in std_logic_vector (15 downto 0);
		pc_out, instruction_out,  a_out, b_out, c_out, imm_out, mem_data_out	:	out std_logic_vector (15 downto 0);

		rs_in, rt_in, rd_in 	:	in std_logic_vector (3 downto 0);

		rs_out, rt_out, rd_out 	:	out std_logic_vector (3 downto 0);

		write_back_in	:	in std_logic; -- [0 : no] [1 : yes]
		
		write_back_out	:	out std_logic -- [0 : no] [1 : yes]
	);
end component;

component regist
	port (
  		clk, rst	:	in std_logic;
		rs, rt, rd, rm	:	in std_logic_vector (3 downto 0);
		r_data	:	in std_logic_vector (15 downto 0);
		a_out, b_out, m_out	:	out std_logic_vector (15 downto 0);

		wr_en	:	in std_logic;
		zero_equal	:	out std_logic; -- A == 0
		
		t_in	:	in std_logic;
		t_out	:	out std_logic;
		t_en	:	in std_logic
  	) ;
end component;

component register_split
	port (
		instruction	:	in std_logic_vector (15 downto 0);
		rs, rt, rd	:	out std_logic_vector (3 downto 0);
		write_back	:	out std_logic; -- [0 : no] [1 : yes]
		choseBIMM	:	out std_logic; -- [0 : B] [1 : IMM] on ALU
		t_en	:	out std_logic; -- [0 : no] [1 : yes]
		t_chose	:	out std_logic_vector (1 downto 0) -- [00 : != ] [01 : <] [10 : u > ]
	);
end component;

component sign_extend
	port (
		instruction	:	in std_logic_vector (15 downto 0);
		imm	:	out std_logic_vector (15 downto 0)
	);
end component;

component writeback_data
	port (
		imm, a, c, memread, pc	:	in std_logic_vector (15 downto 0);
		instruction	:	in std_logic_vector (15 downto 0);
		data 	:	out std_logic_vector (15 downto 0)
	);
end component;

component bypass
	port (
		a_1, a_2, b_2, imm_2, pc_2, c_2, a_3, imm_3, pc_3, c_3, memread_3	:	in std_logic_vector(15 downto 0);
		instruction_1, instruction_2, instruction_3	:	in std_logic_vector(15 downto 0);
		write_back_data	:	in std_logic_vector(15 downto 0);

		rs_1, rs_2, rt_2, rd_2, rd_3, rd_4	:	in std_logic_vector(3 downto 0);

		writeback_2, writeback_3, writeback_4	:	in std_logic;

		a1_out, a2_out, b2_out	:	out std_logic_vector(15 downto 0);
		pause_signal	:	out std_logic

	);
end component;

--------- val ----------
	signal ugly0	:	std_logic;

	signal enable_all	:	std_logic;
	signal clock	:	std_logic;

	signal next_pc, curr_pc, pc_plus1	:	std_logic_vector(15 downto 0);
	signal instruction :	std_logic_vector(15 downto 0);

	signal instruction_1, instruction_2, instruction_3, instruction_4 : std_logic_vector(15 downto 0);
	signal pc_1, pc_2, pc_3, pc_4 : std_logic_vector(15 downto 0);

	signal write_back, choseBIMM, t_en :	std_logic;
	signal t_chose, t_chose_2	:	std_logic_vector(1 downto 0);
	signal register_data	:	std_logic_vector(15 downto 0);
	signal a, b 	:	std_logic_vector(15 downto 0);

	signal write_back_1, write_back_2, write_back_3, write_back_4 	:	std_logic;
	signal t_result, t	:	std_logic;

	signal imm 	:	std_logic_vector(15 downto 0);


	signal choseIMM_2, t_en_2	:	std_logic;

	signal rs, rt, rd, rs_2, rs_3, rs_4, rt_2, rt_3, rt_4, rd_2, rd_3, rd_4	:	std_logic_vector(3 downto 0);
	signal a_2, a_3, a_4, b_2, b_3, b_4, c_3, c_4, imm_2, imm_3, imm_4, m_3, a1_out, a2_out, b2_out	:	std_logic_vector(15 downto 0);

	signal c 	:	std_logic_vector(15 downto 0);
	signal mem_data, mem_data_4	:	std_logic_vector (15 downto 0);

	signal count 	:	std_logic_vector (24 downto 0);
	signal ops		:	std_logic_vector (15 downto 0);
	
	signal pause_signal, clock_auto	:	std_logic;

	signal pause_pc 	:	std_logic;

begin
	CLOCK_DEMPULTIPLY : process (clk_right, rst)
	begin
		if rst = '0' then
			count <= (others => '0');
		elsif clk_right'event and clk_right = '1' then
			count <= count + 1;
		end if;
	end process;

	clock_auto <= clk_right;

	oLed <= instruction_2;
	ram1_addr(15 downto 0) <= curr_pc(15 downto 0);
	ram1_addr(17 downto 16) <= pause_pc & pause_signal;
	--ram1_addr(17) <= '0';
	
	ram1_en <= '1';
	clock <= clk when switch(1) = '1' else count(2);

	enable_all <= '1';

	PC_PORT : pc port map (
		rst => rst,
		clk => clock,
		pc_in => next_pc,
		pc_out => curr_pc,
		pc_plus1 => pc_plus1,
		pc_en => pause_signal,
		pc_int_pause => pause_pc
	);

	PHASE1_PORT : phase1 port map (
		rst => rst,
		clk => clock,
		enable => pause_signal,
		pc_in => pc_plus1,
		instruction_in => instruction,
		pc_out => pc_1,
		instruction_out => instruction_1,
		pause_pc => pause_pc
	);

	REGISTER_SPLIT_PORT : register_split port map (
		instruction => instruction_1,
		rs => rs,
		rt => rt,
		rd => rd,
		write_back => write_back,
		choseBIMM => choseBIMM,
		t_en => t_en,
		t_chose => t_chose
	);

	REGIST_PORT : regist port map (
		clk => clock_auto,
		rst => rst,
		rs => rs,
		rt => rt,
		rd => rd_4,
		rm => rt_3,
		r_data => register_data,
		a_out => a,
		b_out => b,
		m_out => m_3,

		wr_en => write_back_4,
		zero_equal => ugly0,

		t_in => t_result,
		t_out => t,
		t_en => t_en_2
	);

	SIGN_EXTEND_PORT : sign_extend port map (
		instruction => instruction_1,
		imm => imm
	);

	BRANCH_PORT : branch port map (
		imm => imm,
		a => a1_out,
		pc => pc_plus1,
		pc2 => pc_1,
		--ae0_test => ram1_addr(16),

		instruction => instruction_1,

		t => t,

		next_pc => next_pc
	);

	PHASE2_PORT : phase2 port map (
		rst => rst,
		clk => clock,
		enable => enable_all,
		pc_in => pc_1,
		instruction_in => instruction_1,
		a_in => a1_out,
		b_in => b,
		imm_in => imm,
		rs_in => rs,
		rt_in => rt,
		rd_in => rd,
		write_back_in => write_back,
		choseBIMM_in => choseBIMM,
		t_en_in => t_en,
		t_chose_in => t_chose,
		instruction_out => instruction_2,
		pc_out => pc_2,

		a_out => a_2,
		b_out => b_2,
		imm_out => imm_2,

		rs_out => rs_2,
		rt_out => rt_2,
		rd_out => rd_2,

		write_back_out => write_back_2,
		choseBIMM_out => choseIMM_2,
		t_en_out => t_en_2,
		t_chose_out => t_chose_2,
		hazard => enable_all
	);

	ALU_PORT : alu port map (
		instruction => instruction_2,
		op1 => a2_out,
		b => b2_out,
		imm => imm_2,
		t_chose => t_chose_2,
		t_result => t_result,
		choseIMM => choseIMM_2,

		c => c,
		ops => ops
	);

	PHASE3_PORT : phase3 port map (
		rst => rst,
		clk => clock,
		enable => enable_all,
		pc_in => pc_2,
		instruction_in => instruction_2,
		a_in => a2_out,
		b_in => b2_out,
		c_in => c,
		imm_in => imm_2,

		rs_in => rs_2,
		rt_in => rt_2,
		rd_in => rd_2,

		write_back_in => write_back_2,

		pc_out => pc_3,
		instruction_out => instruction_3,
		a_out => a_3,
		b_out => b_3,
		c_out => c_3,

		imm_out => imm_3,

		rs_out => rs_3,
		rt_out => rt_3,
		rd_out => rd_3,
		write_back_out => write_back_3
	);

	MEMORY_PORT : memory port map (
		clk => clock_auto,
		rst => rst,
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

		address_pc => curr_pc,
		data_pc => instruction,

		address => c_3,
		data_in => m_3,
		
		--enables_test => ram1_addr(17 downto 15),

		instruction => instruction_3,
		data_out => mem_data,
		
		hs => hs,
		vs => vs,
		r => red,
		g => green,
		b => blue,
		
		ps2data => ps2data,
		ps2clock => ps2clock
	);

	PHASE4_PORT : phase4 port map (
		rst => rst,
		clk => clock,
		enable => enable_all,
		pc_in => pc_3,
		instruction_in => instruction_3,
		a_in => a_3,
		b_in => b_3,
		c_in => c_3,
		imm_in => imm_3,
		mem_data_in => mem_data,
		rs_in => rs_3,
		rt_in => rt_3,
		rd_in => rd_3,
		write_back_in => write_back_3,

		pc_out => pc_4,
		instruction_out => instruction_4,
		a_out => a_4,
		b_out => b_4,
		c_out => c_4,
		imm_out => imm_4,
		mem_data_out => mem_data_4,
		rs_out => rs_4,
		rt_out => rt_4,
		rd_out => rd_4,
		write_back_out => write_back_4
	);

	WRITE_BACK_PORT : writeback_data port map(
		imm => imm_4,
		a => a_4,
		c => c_4,
		memread => mem_data_4,
		pc => pc_4,
		instruction => instruction_4,
		data => register_data
	);
	
	BYPASS_PORT	: bypass port map (
		a_1 => a,
		a_2 => a_2,
		b_2 => b_2,
		imm_2 => imm_2,
		pc_2 => pc_2,
		c_2 => c,
		a_3 => a_3,
		imm_3 => imm_3,
		pc_3 => pc_3,
		c_3 => c_3,
		memread_3 => mem_data,
		instruction_1 => instruction_1,
		instruction_2 => instruction_2,
		instruction_3 => instruction_3,
		rs_1 => rs,
		rs_2 => rs_2,
		rt_2 => rt_2,
		rd_2 => rd_2,
		rd_3 => rd_3,
		writeback_2 => write_back_2,
		writeback_3 => write_back_3,
		
		a1_out => a1_out,
		a2_out => a2_out,
		b2_out => b2_out,
		pause_signal => pause_signal,
		
		write_back_data => register_data,
		writeback_4 => write_back_4,
		rd_4 => rd_4 
	);

end architecture ; -- main

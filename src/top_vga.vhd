--------------------------------------
-- 2012-11-24 18:44:32
-- Author : Yihan Sun & Keqing Chen
--------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity top_vga is
	port(
		-- test
--		switch	:	in std_logic_vector(15 downto 0);
--		iKey	:	in std_logic_vector(1 to 4);
		------ 
	
		address	:	in std_logic_vector(10 downto 0);
		data	:	in std_logic_vector(5 downto 0);
		enable	:	in std_logic;
	
		clk_right,rst: in std_logic;
		hs,vs: out STD_LOGIC; 
		r,g,b: out STD_LOGIC_vector(2 downto 0)
	);
end top_vga;

architecture main of top_vga is 

component vga_640480 is
	port(
		address		:		  out STD_LOGIC_VECTOR(10 DOWNTO 0);
		ram_data	:         in std_logic_vector(5 downto 0);
		rom_address	:         out std_logic_vector(11 downto 0);
		reset       :         in  STD_LOGIC;
		q		    :		  in STD_LOGIC_VECTOR(8 downto 0);
		clk_0       :         in  STD_LOGIC; --50M clock
		hs,vs       :         out STD_LOGIC;
		r,g,b       :         out STD_LOGIC_vector(2 downto 0)
	);
end component;

component v_rom IS
	port (
		clka: IN std_logic;
		addra: IN std_logic_VECTOR(11 downto 0);
		douta: OUT std_logic_VECTOR(8 downto 0)
	);
end component;

component gpu_ram IS
	port (
		clka: IN std_logic;
		wea: IN std_logic_VECTOR(0 downto 0);
		addra: IN std_logic_VECTOR(10 downto 0);
		dina: IN std_logic_VECTOR(5 downto 0);
		douta: OUT std_logic_VECTOR(5 downto 0);
		clkb: IN std_logic;
		web: IN std_logic_VECTOR(0 downto 0);
		addrb: IN std_logic_VECTOR(10 downto 0);
		dinb: IN std_logic_VECTOR(5 downto 0);
		doutb: OUT std_logic_VECTOR(5 downto 0)
	);
end component;


	signal address_tmp	:	std_logic_vector(6 downto 0);
	signal clk_0	: 	std_logic;
	signal q_tmp	: 	std_logic_vector(8 downto 0);
	signal address_ram	: 	std_logic_vector(15 downto 0); 
	signal ram_data_m	: 	std_logic_vector(5 downto 0);
	signal address_rom	: 	std_logic_vector(11 downto 0);
	signal address_ram_m	: 	std_logic_vector(10 downto 0);
	
	signal data_b	:	std_logic_vector(5 downto 0);
	
	-- test
	signal address_b	:	std_logic_vector(10 downto 0);
	signal data_in_b	:	std_logic_vector(5 downto 0);
	signal en_b	:	std_logic_vector(0 downto 0);
begin

	-- test
--	en_b(0) <= not iKey(1);
--	address_b <= "000" & switch(7 downto 0);
--	data_in_b <= switch(15 downto 10);

	en_b(0) <= enable;
	address_b <= address;
	data_in_b <= data;
	
	vga_640480_port: vga_640480 port map(
		address=>address_ram_m, 
		ram_data=>ram_data_m,
		rom_address=>address_rom,
		reset=>rst, 
		q=>q_tmp, 
		clk_0=>clk_right, 
		hs=>hs, vs=>vs, 
		r=>r, g=>g, b=>b
	);
					
	vga_rom_port : v_rom port map	(	
		clka => clk_right,
		addra => address_rom,
		douta => q_tmp
	);
	
	gpu_ram_port : gpu_ram port map (
		clka => clk_right,
		wea => "0", --read only
		addra => address_ram_m,
		dina => (others => '0'),
		douta => ram_data_m,
		clkb => clk_right,
		web => en_b,
		addrb => address_b,
		dinb => data_in_b,
		doutb => data_b
	);

	--ram_data_m <= "000111";
	--address_ram <= "0000000" & address_ram_m;
					
end architecture;
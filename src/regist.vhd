------------------------------------
-- 2012-11-15 10:16:55
-- Author : Keqing Chen
-- register
------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity regist is
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
end entity ; -- regist

architecture main of regist is
	
	type reg_array is array (integer range 0 to 15) of
		std_logic_vector (15 downto 0);

	signal reg 	:	reg_array;
	signal t	:	std_logic;

begin
	a_out <= reg ( CONV_INTEGER(rs) );
	b_out <= reg ( CONV_INTEGER(rt) );
	m_out <= reg ( CONV_INTEGER(rm) );
	t_out <= t;

	zero_equal <= '1' when reg ( CONV_INTEGER(rs) ) = 0
		else '0';

	reg_write : process( clk, rst )
	begin
		if rst='0' then
			for i in 0 to 15 loop
				reg(i) <= (others => '0');
			end loop;
		elsif wr_en = '1' then
			if clk'event and clk = '1' then
				reg ( CONV_INTEGER(rd) ) <= r_data;
			end if;
		end if ;
	end process ; -- reg_write
	
	reg_t : process ( clk, rst )
	begin
		if rst ='0' then
			t <= t_in;
		elsif t_en = '1' then
			if clk'event and clk = '1' then
				t <= t_in;
			end if;
		end if;
	end process; -- reg_t

end architecture ; -- main
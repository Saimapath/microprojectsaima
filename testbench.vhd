LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity IITB_CPUtb is
end entity IITB_CPUtb;

architecture bhv of IITB_CPUtb is
	component main_dataflow is 
	port(
	clk: in std_logic;
	 reset: in std_logic;
	out0: out std_logic_vector(15 downto 0);
			out1: out std_logic_vector(15 downto 0);
			out2: out std_logic_vector(15 downto 0);
			out3: out std_logic_vector(15 downto 0);
			out4: out std_logic_vector(15 downto 0);
			out5: out std_logic_vector(15 downto 0);
			out6: out std_logic_vector(15 downto 0);
			out7: out std_logic_vector(15 downto 0);
			c_flag: out std_logic;
			z_flag: out std_logic);
end component main_dataflow;

--signal set: std_logic_vector(7 downto 0):="01000011";
signal clk,c,z: std_logic := '0';
signal rout0,rout1,rout2,rout3,rout4,rout5,rout6,rout7: std_logic_vector(15 downto 0);
signal reset: std_logic := '0';
constant clk_period : time := 10 ns;
begin
	dut_instance: main_dataflow port map(clk,reset,rout0,rout1,rout2,rout3,rout4,rout5,rout6,rout7,c,z);
	clk <= not clk after clk_period/2 ;
	--reset <= not reset after 100*clk_period ;
end bhv;
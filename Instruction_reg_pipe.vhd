library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity Instruction_reg_pipe is
	port (input:in std_logic_vector(15 downto 0);
			w_enable, clk: in std_logic;
			IR_80: out std_logic_vector(8 downto 0);
			IR_50: out std_logic_vector(5 downto 0);
			--IR_70: out std_logic_vector(7 downto 0);
			IR_1512: out std_logic_vector(3 downto 0);
			IR_119, IR_86, IR_53: out std_logic_vector(2 downto 0);
			IR_2 : out std_logic;
			IR_01:out std_logic_vector(1 downto 0);
			IR_out: out std_logic_vector(15 downto 0));
end entity Instruction_reg_pipe;

architecture bhv of Instruction_reg_pipe is
	
	signal s, stor: std_logic_vector(15 downto 0):="0000000000000000";
	
	begin
		s(15 downto 0)<= stor(15 downto 0);
		edit_process: process(clk,w_enable,input,stor)
		begin
			if(clk='1' and clk'event and w_enable='1') then
				stor(15 downto 0)<=input(15 downto 0);
			else
				stor(15 downto 0)<=stor(15 downto 0);
			end if;
		end process;
			
		IR_80<= s(8 downto 0);
		IR_50<= s(5 downto 0);
	--	IR_70<= s(7 downto 0);
		IR_1512<= s(15 downto 12);
		IR_119<= s(11 downto 9);
		IR_86<= s(8 downto 6);
		IR_53<= s(5 downto 3);
		IR_2<=s(2);
		IR_01<=s(1 downto 0);
		IR_out<=s;
end architecture bhv;
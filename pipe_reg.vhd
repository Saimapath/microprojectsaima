library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity pipe_reg is
	port (--initial: in std_logic_vector(15 downto 0);
	input:in std_logic_vector(15 downto 0);
			Enable, clock: in std_logic;
			output: out std_logic_vector(15 downto 0));
end entity pipe_reg;

architecture beh of pipe_reg is
	signal storage: std_logic_vector(15 downto 0):="0000000000000000";
	begin
	--storage<=initial;
	--storage(15 downto 0)<= initial(15 downto 0);
		output(15 downto 0)<= storage(15 downto 0);
		edit_process: process(clock,storage,Enable,input)
		begin
			if(clock='1' and clock'event and Enable='1') then
				storage(15 downto 0)<=input(15 downto 0);
			else
				storage(15 downto 0)<=storage(15 downto 0);
			end if;
		end process;
end architecture beh;
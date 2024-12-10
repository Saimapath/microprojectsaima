library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity stallc_pipe is
	port (--initial: in std_logic_vector(15 downto 0);
	input:in std_logic_vector(2 downto 0);
			disable, clock: in std_logic;
			output: out std_logic_vector(2 downto 0));
end entity stallc_pipe;

architecture beh of stallc_pipe is
	signal storage: std_logic_vector(2 downto 0):="000";
	begin
	--storage<=initial;
	--storage(15 downto 0)<= initial(15 downto 0);
		output(2 downto 0)<= storage(2 downto 0);
		edit_process: process(clock,storage,disable,input)
		begin
			if(clock='1' and clock'event and disable='0') then
				storage(2 downto 0)<=input(2 downto 0);
			else
				storage(2 downto 0)<=storage(2 downto 0);
			end if;
		end process;
end architecture beh;
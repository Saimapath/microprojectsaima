library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity leftshift1 is
	port (inp : in std_logic_vector (15 downto 0);
			outp : out std_logic_vector (15 downto 0));
end entity leftshift1;

architecture beh of leftshift1 is
	begin
		outp(15 downto 1) <= inp(14 downto 0);
		outp(0) <= '0';
end beh;
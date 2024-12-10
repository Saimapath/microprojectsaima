library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity stall_counter is
	port (--initial: in std_logic_vector(15 downto 0);
	opcode:in std_logic_vector(3 downto 0);
	stallc:in std_logic_vector(2 downto 0);
			next_stallc_in: out std_logic_vector(2 downto 0));
end entity stall_counter;

architecture beh of stall_counter is
	constant lm:std_logic_vector(3 downto 0):="0110";
	constant sm:std_logic_vector(3 downto 0):="0111";
	
	begin
	--storage<=initial;
	--storage(15 downto 0)<= initial(15 downto 0);
		edit_process: process(opcode,stallc)
		begin
		
			 case opcode is
          when lm|sm =>
						case stallc is
								when "111" =>
								next_stallc_in <="110";
								when "110" =>
								next_stallc_in <="101";
								when "101" =>
								next_stallc_in <="100";
								when "100" =>
								next_stallc_in <="011";
								when "011" =>
								next_stallc_in <="010";
								when "010" =>
								next_stallc_in <="001";
								when "001" =>
								next_stallc_in <="000";
								when "000" =>
								next_stallc_in <="111";

								when others =>
								next_stallc_in <="111";
						end case;           
          when others =>
								next_stallc_in <="111";
        end case;
		end process;
end architecture beh;
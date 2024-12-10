library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity disabler is 
  port (
    opcode3: in std_logic_vector(3 downto 0);
   
disable_instr_3: in std_logic;

disable_instr_2: in std_logic;
    disable_instr_1: in std_logic;
	 z_in: in std_logic;
 c_in_inp: in std_logic;	
 disable_next_3_instr: out std_logic

  );
end entity disabler;

architecture Behavioral of disabler is


constant adi:std_logic_vector(3 downto 0):="0000";
constant add:std_logic_vector(3 downto 0):="0001";
	constant nandi:std_logic_vector(3 downto 0):="0010";
	constant lli:std_logic_vector(3 downto 0):="0011";
	constant load:std_logic_vector(3 downto 0):="0100";
	constant store:std_logic_vector(3 downto 0):="0101";
	constant lm:std_logic_vector(3 downto 0):="0110";
	constant sm:std_logic_vector(3 downto 0):="0111";
	constant beq:std_logic_vector(3 downto 0):="1000";
	constant blessthan:std_logic_vector(3 downto 0):="1001";
	constant ble:std_logic_vector(3 downto 0):="1010";
	constant jal:std_logic_vector(3 downto 0):="1100";
	constant jlr:std_logic_vector(3 downto 0):="1101";
	constant jri:std_logic_vector(3 downto 0):="1111";
 
begin
  process(  opcode3,c_in_inp,disable_instr_2,disable_instr_1,z_in,disable_instr_3)
  
begin

if disable_instr_3='1' then
disable_next_3_instr<='0';
  
else 

  case opcode3 is
	when add|adi|nandi|store|lli|load => -- nand
	disable_next_3_instr<='0';

	

	when beq  => -- Addition
		if (z_in='1' )then
		disable_next_3_instr<='1';

		else
		disable_next_3_instr<='0';

			
		end if;
	when blessthan => -- Addition
		if (c_in_inp='1')then
		disable_next_3_instr<='1';

		else
		disable_next_3_instr<='0';

			
		end if;
	when ble => -- Addition
		if (z_in='1' or c_in_inp='1')then
		disable_next_3_instr<='1';

		else
		disable_next_3_instr<='0';

				
		end if;
									
	when jal|jri|jlr => -- Addition
	disable_next_3_instr<='1';
 									
	when others => 
	disable_next_3_instr<='0';

		
	end case;
end if;

	 
  end process;
 
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity RF_Writer is 
  port (
opcode5: in std_logic_vector(3 downto 0); 
disable_ult_5: in std_logic;
should_i_write: in std_logic;
rf_4_lm: in std_logic;	
RF_Write: out std_logic

  );
end entity RF_Writer;

architecture Behavioral of RF_Writer is


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
  process(  opcode5,disable_ult_5,should_i_write,rf_4_lm)
  
begin

if disable_ult_5='1'  then
					RF_Write<='0';	

else
	  case opcode5 is
	   when add|nandi => -- Addition
				RF_Write<='1' and should_i_write;

		when adi |lli|load|jal|jlr	=>
					RF_Write<='1' and should_i_write ;	
		when lm	=>
		RF_write<=rf_4_lm;
	   when store|sm|beq|blessthan|ble|jri => -- nand
             RF_Write<='0';	
      when others => 
				RF_Write<='0';	
    end case;
end if;
	 
  end process;
 
end Behavioral;

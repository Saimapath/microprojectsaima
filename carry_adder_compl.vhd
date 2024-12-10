library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity carry_adder_compl is 
  port (
    ALU_B: in std_logic_vector(15 downto 0);
	 carry_in: in std_logic;

    complememt_kar_du: in std_logic;
	 cy_add_kar_du: in std_logic;

    ALU_C: out std_logic_vector(15 downto 0);
    C_O: out std_logic
  );
end entity carry_adder_compl;

architecture Behavioral of carry_adder_compl is
  signal carry : std_logic_vector(16 downto 0) := (others=>'0');
  signal cy : std_logic_vector(15 downto 0) := (others=>'0');

begin
  process(complememt_kar_du, ALU_B, cy_add_kar_du,cy)
  variable doosra_input  : std_logic_vector(15 downto 0) := (others=>'0');

  begin
    case complememt_kar_du is
	   when '0' => -- Addition
	 doosra_input:=ALU_B;
	   when '1' => -- nand
	 doosra_input:=not ALU_B;
      when others => 
	 doosra_input:=ALU_B;
    end case;

      case cy_add_kar_du is
	   when '1' => -- Addition
 carry <= ('0' & cy) + ('0' & doosra_input);
	   when '0' => -- nand
 carry <=  ('0' & doosra_input);
      when others => 
 carry <=  ('0' & doosra_input);
    end case;
	 
  end process;
  cy<="000000000000000" & carry_in;
  ALU_C <= carry(15 downto 0); -- ALU out
  C_O <= carry(16); -- Carryout
end Behavioral;

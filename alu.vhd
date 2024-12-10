library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity alu is 
  port (
    ALU_A, ALU_B: in std_logic_vector(15 downto 0);
    ALU_SELECT: in std_logic_vector(1 downto 0);
	-- cond_compl: in std_logic_vector(2 downto 0);
    ALU_C: out std_logic_vector(15 downto 0);
    Z_O, C_O: out std_logic
  );
end entity alu;

architecture Behavioral of alu is
  signal carry : std_logic_vector(16 downto 0) := (others=>'0');
  
begin
  process(ALU_A, ALU_B, ALU_SELECT)
  variable A30  : std_logic_vector(3 downto 0) := (others=>'0');
  variable B30  : std_logic_vector(3 downto 0) := (others=>'0');
  variable A70  : std_logic_vector(8 downto 0) := (others=>'0');
  variable B70  : std_logic_vector(7 downto 0) := (others=>'0');
  variable A157 : std_logic_vector(7 downto 0) := (others=>'0');
  variable B157 : std_logic_vector(6 downto 0) := (others=>'0');
  begin
    case ALU_SELECT is
	   when "00" => -- Addition
 carry <= ('0' & ALU_A) + ('0' & ALU_B);
	 
	   when "11" => -- nand
               carry <= ('0' & ALU_A) nand ('0' & ALU_B);

      when "10" => -- subtraction
		 carry <= ('0' & ALU_A) - ('0' & ALU_B);

       when "01" => --lli--000000(nine bit imm)
		 A70  := ALU_A(8 downto 0);
        B157 := ALU_B(15 downto 9);
        carry <= '0' & B157 & A70;
      
        
      when others => carry <= ('0' & ALU_A) + ('0' & ALU_B);
    end case;
  end process;

  ALU_C <= carry(15 downto 0); -- ALU out
  C_O <= carry(16); -- Carryout
  Z_O <= not(carry(0) or carry(1) or carry(2) or carry(3) or carry(4) or carry(5) or carry(6) or carry(7) or carry(8) or carry(9) or carry(10) or carry(11) or carry(12) or carry(13) or carry(14) or carry(15));
end Behavioral;

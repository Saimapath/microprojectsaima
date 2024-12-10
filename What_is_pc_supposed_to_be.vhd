library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity What_is_pc_supposed_to_be is 
  port (
    reset: in std_logic;
      disable_instr_3: in std_logic;
		r0_me_likha_alu3: in std_logic;
		r0_me_likha_load4: in std_logic;
		
    opcode3: in std_logic_vector(3 downto 0);
    z_in: in std_logic;
    c_in_inp: in std_logic;	  
alu_out_addr: in std_logic_vector(15 downto 0);
pc_plus_2: in std_logic_vector(15 downto 0);
d2_data:in std_logic_vector(15 downto 0);
alu_out:in std_logic_vector(15 downto 0);
dm_out:in std_logic_vector(15 downto 0);

What_is_pc_supposed_to_be: out std_logic_vector(15 downto 0)

  );
end entity What_is_pc_supposed_to_be;

architecture Behavioral of What_is_pc_supposed_to_be is
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
  signal carry : std_logic_vector(16 downto 0) := (others=>'0');
  signal cy : std_logic_vector(15 downto 0) := (others=>'0');


begin
  process( reset, disable_instr_3,opcode3, z_in, c_in_inp,alu_out_addr,pc_plus_2,d2_data,r0_me_likha_alu3,alu_out,dm_out,r0_me_likha_load4)
  
begin
   if reset='1' then
			What_is_pc_supposed_to_be<="0000000000000000";
	else 
				if disable_instr_3='1' then
				What_is_pc_supposed_to_be<=pc_plus_2;
				
				elsif r0_me_likha_alu3='1' then
				What_is_pc_supposed_to_be<=alu_out;
				
				elsif r0_me_likha_load4='1' then
				What_is_pc_supposed_to_be<=dm_out;


				
				else 
	
									case opcode3 is
								when add|adi|nandi|store|lli|load => -- nand
										if (z_in='1' )then
											What_is_pc_supposed_to_be<=alu_out_addr;
											else	
											What_is_pc_supposed_to_be<=pc_plus_2;
											end if;
											What_is_pc_supposed_to_be<=pc_plus_2;

								when beq  => -- Addition
											if (z_in='1' )then
											What_is_pc_supposed_to_be<=alu_out_addr;
											else	
											What_is_pc_supposed_to_be<=pc_plus_2;
											end if;
								when blessthan => -- Addition
												if (c_in_inp='1')then
												 What_is_pc_supposed_to_be<=alu_out_addr;
												else
											    What_is_pc_supposed_to_be<=pc_plus_2;
												end if;
								when ble => -- Addition
										if (z_in='1' or c_in_inp='1')then
											   What_is_pc_supposed_to_be<=alu_out_addr;
												else
												What_is_pc_supposed_to_be<=pc_plus_2;
												end if;
								
								when jal|jri => -- Addition
									 What_is_pc_supposed_to_be<=alu_out_addr;

								when jlr => -- nand
									 What_is_pc_supposed_to_be<=d2_data;
									 
								when others => 
									 What_is_pc_supposed_to_be<=pc_plus_2;

							 end case;
				end if;			 
			    
	end if;
	
	 
  end process;
 
end Behavioral;

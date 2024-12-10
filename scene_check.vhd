library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity carry_zero_scene_checker is 
  port (opcode2: in std_logic_vector(3 downto 0);
   addr_mode2: in std_logic_vector(1 downto 0);
	c_in_inp: in std_logic;
	z_in: in std_logic;
		c_out1: in std_logic;
      z_out1: in std_logic;
		c_out: in std_logic;
      z_out: in std_logic;
		c_flag: in std_logic;
      z_flag: in std_logic;
		 carry_zero_scene: in std_logic;
		aage: in std_logic;
      should_i_write: in std_logic;
    
carry_zero_scene_check: out std_logic

  );
end entity carry_zero_scene_checker;

architecture Behavioral of carry_zero_scene_checker is
constant add:std_logic_vector(3 downto 0):="0001";
	constant nandi:std_logic_vector(3 downto 0):="0010";


begin
  process(opcode2,addr_mode2,c_out1,z_out1,c_out,z_out,c_flag,z_flag,carry_zero_scene,aage,should_i_write)
  
begin
  if(opcode2=add or opcode2=nandi)then--opcode
		  if(addr_mode2="10") then--
		  
		  
		  carry_zero_scene_check <= (carry_zero_scene and c_in_inp)
		  or
                             ( aage and (not carry_zero_scene) and c_out1) or
                           (should_i_write and (not aage) and (not carry_zero_scene) and c_out) or
									
                              ((not should_i_write) and (not aage)  and (not carry_zero_scene)and c_flag);

		
						
			elsif(addr_mode2="01") then
			  carry_zero_scene_check <= (carry_zero_scene and z_in) or
                              ( aage and (not carry_zero_scene) and z_out1) or
                              (should_i_write and (not aage) and (not carry_zero_scene) and z_out) or
										
                              ((not should_i_write) and (not aage)  and (not carry_zero_scene)and z_flag);

		
	
				
			else--dont care
	      carry_zero_scene_check<='1';
	      end if;	
	else--dont care
	carry_zero_scene_check<='1';
	end if;
	

	 
  end process;
 
end Behavioral;

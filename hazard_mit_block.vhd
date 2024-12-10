library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

entity hazard_mitigation_block is 
  port (
    alu_hazard_imm1_2: in std_logic;
      carry_zero_scene: in std_logic;
    alu_hazard_2imm1_2: in std_logic;
	 alu_hazard_3imm1_2: in std_logic;
should_i_write: in std_logic;
load_hazard_imm1_2: in std_logic;
    load_hazard_2imm1_2: in std_logic;
	 load_hazard_3imm1_2: in std_logic;
will_it_write4: in std_logic;
will_it_write5: in std_logic;
    aage: in std_logic;	  
	result: in std_logic_vector(15 downto 0);
alu_out: in std_logic_vector(15 downto 0);
alu_data: in std_logic_vector(15 downto 0);
dm_out:in std_logic_vector(15 downto 0);
d1:in std_logic_vector(15 downto 0);
d1_inp: out std_logic_vector(15 downto 0)

  );
end entity hazard_mitigation_block;

architecture Behavioral of hazard_mitigation_block is



begin
  process(  alu_hazard_imm1_2,should_i_write,alu_hazard_3imm1_2, carry_zero_scene, alu_hazard_2imm1_2,load_hazard_3imm1_2,load_hazard_2imm1_2,load_hazard_imm1_2,aage,alu_out,alu_data,dm_out,result,d1,will_it_write4)
  
begin
   --d1 inp
	 if(alu_hazard_imm1_2='1' and carry_zero_scene='1') then--
		d1_inp<=	alu_out;
	 elsif(alu_hazard_2imm1_2='1' and aage='1') then--
	  d1_inp<=alu_data;	
	  
	  elsif(alu_hazard_3imm1_2='1' and should_i_write='1') then--
	 d1_inp<=result;	
	   elsif( load_hazard_3imm1_2='1' and will_it_write5='1') then--
	 d1_inp<=result;	
	  elsif((load_hazard_2imm1_2='1' or load_hazard_imm1_2='1') and will_it_write4='1') then--
	  d1_inp<=dm_out; 
	  else
		d1_inp<=d1;
	  end if;
	 --------------d2 inp

	 
  end process;
 
end Behavioral;

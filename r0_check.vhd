library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity r0_me1_likha_kya is 
  port (
    opcode_which: in std_logic_vector(3 downto 0);
   
 reg_a_which: in std_logic_vector(2 downto 0);
	 reg_b_which: in std_logic_vector(2 downto 0);
	 	 reg_c_which: in std_logic_vector(2 downto 0);
stallc_which: in std_logic_vector(2 downto 0);
	  disable_instr_which:in std_logic;	  
	 r0_me_likha_alu: out std_logic;
	 r0_me_likha_load: out std_logic

  );
end entity r0_me1_likha_kya;

architecture Behavioral of r0_me1_likha_kya is
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
  process(reg_a_which,reg_b_which,reg_c_which,opcode_which,disable_instr_which,stallc_which)
  
    variable dest  : std_logic_vector(2 downto 0) := (others=>'0');

begin
  
				
					
  	 case opcode_which is
	   when add|nandi => -- Addition
					dest:=reg_c_which;
		 when lm => -- blt,ble
					dest:=stallc_which;
	   when adi => -- blt,ble
					dest:=reg_b_which;
		
		when lli|jal|jlr|load=> -- blt,ble
					dest:=reg_a_which;		
      when others => 
					dest:=reg_a_which;
    end case;
	 
	 
	
		if(dest="000" ) then--
				if(opcode_which=add or opcode_which=adi or opcode_which=nandi or opcode_which=lli or opcode_which=jal or opcode_which=jlr ) then-- is ble
		               r0_me_likha_alu<='1' and (not disable_instr_which) ;	
		               r0_me_likha_load<='0' ;	

				elsif opcode_which=load or opcode_which=lm then
		               r0_me_likha_load<='1' and (not disable_instr_which) ;	
							r0_me_likha_alu<='0' ;	

				else
							r0_me_likha_alu<='0' ;	
		               r0_me_likha_load<='0' ;	
				end if;
	
	     else
							
							r0_me_likha_alu<='0' ;	
		               r0_me_likha_load<='0' ;
	end if;
	
	 
	
  end process;
 
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity hazard_detection_block is 
  port (opcode1: in std_logic_vector(3 downto 0);
    opcode_which: in std_logic_vector(3 downto 0);
    reg_a1: in std_logic_vector(2 downto 0);
	 reg_b1: in std_logic_vector(2 downto 0);
	 stallc1: in std_logic_vector(2 downto 0);
 reg_a_which: in std_logic_vector(2 downto 0);
	 reg_b_which: in std_logic_vector(2 downto 0);
	 	 reg_c_which: in std_logic_vector(2 downto 0);
stallc_which: in std_logic_vector(2 downto 0);
	  disable_instr_which:in std_logic;	  

    alu_hazard_source1: out std_logic;
    alu_hazard_source2: out std_logic;
    load_hazard_source1: out std_logic;
    load_hazard_source2: out std_logic
	

  );
end entity hazard_detection_block;

architecture Behavioral of hazard_detection_block is
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
  process(reg_a1,reg_b1,reg_a_which,reg_b_which,reg_c_which,opcode1,opcode_which,disable_instr_which,stallc_which,stallc1)
  
    variable source_1,source_2,dest,dest2  : std_logic_vector(2 downto 0) := (others=>'0');

begin

	if opcode1=sm then
	source_2:=stallc1;
	else
	source_2:=reg_b1;
	end if;	
	
	
  	source_1:=reg_a1;
	
	if opcode1=sm then
	source_2:=stallc1;
	else
	source_2:=reg_b1;
	end if;				
					
  	 case opcode_which is
	   when add|nandi => -- Addition
					dest:=reg_c_which;
	   when adi => -- blt,ble
					dest:=reg_b_which;
		 when lm => -- blt,ble
					dest:=stallc_which;
		when lli|jal|jlr|load=> -- blt,ble
					dest:=reg_a_which;		
      when others => 
					dest:=reg_a_which;
    end case;
	 
	 
	 
	 
 	if(source_1=dest ) then--
	  case opcode1 is
	   when add|nandi|adi|store|beq|blessthan|ble|jri|sm|lm => -- Addition
		if stallc1="111"then
						if(opcode_which=add or opcode_which=adi or opcode_which=nandi or opcode_which=lli or opcode_which=jal or opcode_which=jlr ) then-- is ble
									alu_hazard_source1<='1' and (not disable_instr_which) ;	
									load_hazard_source1<='0';		

						elsif opcode_which=load  then
									load_hazard_source1<= (not disable_instr_which) ;		
									alu_hazard_source1<='0';
									
							elsif opcode_which=lm  then
									load_hazard_source1<= (not disable_instr_which) and (stallc_which(0) xor stallc_which(1));		
									alu_hazard_source1<='0';
			
						
						else
									load_hazard_source1<='0';		

									alu_hazard_source1<='0';
						end if;
			else
			load_hazard_source1<='0';		
			alu_hazard_source1<='0';
			end if;
		
      when others =>
							load_hazard_source1<='0';		

		               alu_hazard_source1<='0';
    end case;
	else
							load_hazard_source1<='0';		

		               alu_hazard_source1<='0';
	end if;

	
	if(source_2=dest ) then--
	  case opcode1 is
	   when add|nandi|store|load|beq|blessthan|ble|jlr|sm=> -- Addition
				if(opcode_which=add or opcode_which=adi or opcode_which=nandi or opcode_which=lli or opcode_which=jal or opcode_which=jlr ) then-- is ble
		               alu_hazard_source2<='1' and (not disable_instr_which) ;	
							load_hazard_source2<='0';		

				elsif opcode_which=load or opcode_which=lm then
							load_hazard_source2<='1' and (not disable_instr_which) ;	
		               alu_hazard_source2<='0';							
				else
							load_hazard_source2<='0';		
		               alu_hazard_source2<='0';
				end if;
		
      when others => 
							load_hazard_source2<='0';		
		               alu_hazard_source2<='0';
    end case;
	else
							load_hazard_source2<='0';		
		               alu_hazard_source2<='0';
	end if;
	
		
	 
	
  end process;
 
end Behavioral;

library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;


entity risc_memory_data is 
		port(
				clk, m_wr, m_rd: in std_logic; 
				mem_addr, mem_in: in std_logic_vector(15 downto 0);
				mem_out: out std_logic_vector(15 downto 0)
			 ); 
end entity; 

architecture  storage  of risc_memory_data is 
		type mem_vector is array(1600 downto 0) of std_logic_vector(7 downto 0);
		signal memory : mem_vector :=
		(0=>"00000000", 
		 1=>"00000001", 
		 2=>"00000000",
		 3=>"00000010", 
		 4=>"00000000",
		5=>"00000011",
		6=>"00000000",
		7=>"00000100", 
		8=>"00000000",
		9=>"00000101",
		10=>"00000000",
		11=>"00000110", 
		12=>"00000000",
		13=>"00000001",
	14=>"00000000",
	15=>"01010100",
	16=>"00000000", 
		17=>"01011110", 
		36=>"00000000", 
		37=>"00000000", 
		38=>"00110000", 
		39=>"00010000", 
		40=>"01000000", 
		41=>"01010000", 
		42=>"01100000", 
		
		
		34=>"11110000", 
		
			others => "00011100");  		 
begin

	
  mem_process : process (clk, m_rd,m_wr,mem_in, mem_addr,memory) is
  begin
  
		if m_rd = '1' then
				mem_out <= memory(to_integer(unsigned(mem_addr)))&memory(to_integer(unsigned(mem_addr))+1);
		else 
mem_out<="0000000000000000";
		end if;
    if (clk='1' and clk'event) then
      if m_wr = '1' then
        memory(to_integer(unsigned(mem_addr))) <= mem_in(15 downto 8);  -- Write
        memory(to_integer(unsigned(mem_addr))+1) <= mem_in(7 downto 0);  -- Write

      end if;
    end if;
  end  process;
end  architecture;


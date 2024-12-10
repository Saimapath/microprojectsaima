library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity RegisterFile is
	port (A1: in std_logic_vector(2 downto 0);
			A2: in std_logic_vector(2 downto 0);
			A3: in std_logic_vector(2 downto 0);
			PC_inp: in std_logic_vector(15 downto 0);
			D1: out std_logic_vector(15 downto 0);
			D2: out std_logic_vector(15 downto 0);
			D3: in std_logic_vector(15 downto 0);
			PC_read: out std_logic_vector(15 downto 0);
			clock: in std_logic;
			Enable: in std_logic;
						pc_write:in std_logic;
		reg0: out std_logic_vector(15 downto 0);
			reg1: out std_logic_vector(15 downto 0);
			reg2: out std_logic_vector(15 downto 0);
			reg3: out std_logic_vector(15 downto 0);
			reg4: out std_logic_vector(15 downto 0);
			reg5: out std_logic_vector(15 downto 0);
			reg6: out std_logic_vector(15 downto 0);
			reg7: out std_logic_vector(15 downto 0)
	

		);
end entity RegisterFile;

architecture beh of RegisterFile is
	type reg_vec is array(7 downto 0) of std_logic_vector(15 downto 0);
		signal RegFile : reg_vec :=
	  (0=>"0000000000000000", 
	   1=>"0000000000000000", 
		2=>"0000000000000000", 
		3=>"0000000000000000", 
		4=>"0000000000000000", 
		5=>"0000000000000000",
		6=>"0000000000000000", 
		7=>"0000000000000000" 
		);  
 
  begin
mem_process : process (clock, Enable, A1,A2,A3,D3,RegFile) is
  begin
  
--		if m_rd = '1' then
	--			mem_out <= memory(to_integer(unsigned(mem_addr)));
		--end if;
		D1 <= RegFile(to_integer(unsigned(A1)));
		D2 <= RegFile(to_integer(unsigned(A2)));
		PC_read<= RegFile(0);
		
    if rising_edge(clock) then
--		D1 <= RegFile(to_integer(unsigned(A1)));
	--	D2 <= RegFile(to_integer(unsigned(A2)));
	
		if pc_write = '1' then
			RegFile(0)<=PC_inp;	
		end if;
		
		if Enable = '1' then
        RegFile(to_integer(unsigned(A3))) <= D3;  
      end if;
    end if;
  end  process;

  reg0<=RegFile(0);
  reg1<=RegFile(1);
  reg2<=RegFile(2);
  reg3<=RegFile(3);
  reg4<=RegFile(4);
  reg5<=RegFile(5);
  reg6<=RegFile(6);
  reg7<=RegFile(7);
	
	 
end beh;
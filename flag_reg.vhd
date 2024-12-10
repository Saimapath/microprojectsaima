library ieee;
use ieee.std_logic_1164.all;


entity flag_reg is 
	port (c_in, z_in :std_logic;
			c_en, z_en, clk :in std_logic;
			c_out, z_out: out std_logic
		);
end entity flag_reg;

architecture beh of flag_reg is
	signal z_storage,c_storage: std_logic:='0';
	begin
		c_out<=c_storage;
		z_out<=z_storage;
		f_process: process(clk,z_storage,c_storage)
		begin
		   if(clk='1' and clk'event) then
			    if( z_en='1' ) then
			   z_storage<=z_in;
			    end if;	
			   if( c_en='1' ) then
			   c_storage<=c_in;
			   end if;
		 else
		     z_storage<=z_storage;
			  c_storage<=c_storage;
			  end if;
		end process;
end architecture beh;
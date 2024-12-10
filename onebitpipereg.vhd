library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library Work;
entity eight_bit_pipe_reg is
	port (--initial: in std_logic_vector(15 downto 0);
	input1:in std_logic;
		input2:in std_logic;

		input3:in std_logic;
	input4:in std_logic;
	input5:in std_logic;
	input6:in std_logic;
	input7:in std_logic;
	input8:in std_logic;

			Enable, clock: in std_logic;
			output1: out std_logic;
			output2: out std_logic;
			output3: out std_logic;
			output4: out std_logic;
			output5: out std_logic;
			output6: out std_logic;
			output7: out std_logic;
			output8: out std_logic
			);
end entity eight_bit_pipe_reg;

architecture beh of eight_bit_pipe_reg is
	signal storage1,storage2,storage3,storage4,storage5,storage6,storage7,storage8: std_logic:='0';
	begin
	--storage<=initial;
	--storage(15 downto 0)<= initial(15 downto 0);
		output1<= storage1;
		output2<= storage2;
		output3<= storage3;
		output4<= storage4;
		output5<= storage5;
		output6<= storage6;
		output7<= storage7;
		output8<= storage8;
		
		edit_process: process(clock,storage1,storage2,storage3,storage4,storage5,storage6,storage7,storage8	,Enable	)
		begin
			if(clock='1' and clock'event and Enable='1') then
				storage1<=input1;
				storage2<=input2;
				storage3<=input3;
				storage4<=input4;
				storage5<=input5;
				storage6<=input6;
				storage7<=input7;
				storage8<=input8;

				
			else
				storage8<=storage8;
				storage7<=storage7;
				storage6<=storage6;
				storage5<=storage5;
				storage4<=storage4;
				storage3<=storage3;
				storage2<=storage2;
				storage1<=storage1;
				
			end if;
		end process;
end architecture beh;
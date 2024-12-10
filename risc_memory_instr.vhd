library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;


entity risc_memory_instr is 
		port(
				clk, m_wr, m_rd: in std_logic; 
				mem_addr, mem_in: in std_logic_vector(15 downto 0);
				mem_out: out std_logic_vector(15 downto 0)
			 ); 
end entity; 

architecture  storage  of risc_memory_instr is 
constant add:std_logic_vector(3 downto 0):="0001";
	constant adi:std_logic_vector(3 downto 0):="0000";
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
	constant r0,ada,ndu:std_logic_vector(2 downto 0):="000";
	constant r1,adz,ndz:std_logic_vector(2 downto 0):="001";
	constant r2,adc,ndc:std_logic_vector(2 downto 0):="010";
	constant r3,awc:std_logic_vector(2 downto 0):="011";
	constant r4,aca,ncu:std_logic_vector(2 downto 0):="100";
	constant r5,acz,ncz:std_logic_vector(2 downto 0):="101";
	constant r6,acc,ncc:std_logic_vector(2 downto 0):="110";
	constant r7,acw:std_logic_vector(2	downto 0):="111";
	
		type mem_vector is array(150 downto 0) of std_logic_vector(7 downto 0);
		signal memory : mem_vector :=
		(
		--loads tegister r0 to r6 with values 0 to 6 repectively
		
    0 => load & "0011",--lw r1,r7,0
    1 => "11000000",--r1=1
	 
    2 => load & "0101",----lw r2,r7,2
	 3 => "11000010",--r2=2
	 --" & "
    4 => load & "0111",--lw r3,r7,3
	 5 => "11000100",--r3=3
    
	 6 => load & "1001",--lw r4,r7,4
    7 => "11000110",--r4=4
    
	 8 => load & "1011",--lw r5,r7,5
	 9 => "11001000",--r5=5
	 
	 10 => load & "1101", --lw r6,r7,6
    11=> "11001010",--r6=6
        --r0 test

	 12=> add & "010" & "1",--ada r7,r2,r5
    13=> "01" & r7 & "000",--r7=r2+r5
	 
	 ---till here rx=x
--000101
--101101
--111010
14=>add & r7 & "1",
15=>"01" & r1 & ada,

16=>add & r6 & "0",
17=>"01" & r2 & ada,

18=>add & r2 & "0",
19=>"01" & r3 & aca,

20=>nandi & r2 & "0",
21=>"11" & r4 & ncc,

22=>nandi & r2 & "0",
23=>"10" & r5 & ncu,


24=>nandi & r5 & "1",

25=>"01" & r5 & ndc,


26=>add & r5 & "1",

27=>"01" & r6 & acz,


28=>add & r5 & "1",

29=>"10" & r3 & acc,


30=>add & r6 & "1",

31=>"01" & r4 & acz,


32=>add & r3 & "0",

33=>"01" & r2 & awc,


34=>add & r3 & "1",

35=>"00" & r4 & acz,


36=>add & r5 & "1",

37=>"10" & r3 & adc,


38=>add & r1 & "1",

39=>"11" & r3 & aca,


40=>add & r6 & "1",

41=>"01" & r4 & adz,


42=>add & r4 & "1",

43=>"00" & r7 & acw,


44=>nandi & r5 & "1",

45=>"01" & r5 & ndz,


46=>nandi & r5 & "1",

47=>"00" & r6 & ncz,


48=>load & r2 & "1",

49=>"01" & "000001",

50=>add & r3 & "0",

51=>"10" & r1 & aca,


52=>adi & r1 & "1",

53=>"11" & "000010",

54=>load & r3 & "1",

55=>"11" & "001000",

56=>store & r7 & "0",

57=>"11" & "000000",

58=>load & r4 & "1",

59=>"11" & "001000",

60=>lli & r4 & "0",
61=>"00000000",

62=>beq & r3 & "1",
63=>"00" & "000100",

64=>ble & r5 & "0",
65=>"11" & "000100",

66=>lli & r2 & "0",
67=>"00" & "000010",

68=>lm & r2 & "0",
69=>"11" & "101110",

70=>add & r2 & "0",
71=>"00" & r3 & ada,

72=>add & r2 & "0",
73=>"01" & r3 & ada,




74=>blessthan & r5 & "0",
75=>"11" & "000001",

76=>beq & r3 & "0",
77=>"11" & "000001",

78=>ble & r3 & "1",
79=>"01" & "000001",

80=>ble & r5 & "1",
81=>"01" & "000001",

82=>jal & r5 &"0",
83=>"00000011",

84=>lli & r3 & "0",
85=>"01001010",

86=>jlr & r1 & "0",
87=>"11" & "000000",

88=>jlr & r0 & "0",
89=>"11" & "000000",

90=>jri & r0 & "0",
91=>"00000010",

92=>load & r3 & "1",
93=>"01" & "100101",

94=>lm & r2 & "0",
95=>"11100110",

96=>add & r2 & "0",
97=>"01" & r3 & ada,

98=>sm & r3 & "0",
99=>"11111111",

100=>lm & r3 & "0",
101=>"11111110",

102=>lli & r3 & "0",
103=>"00000000",

104=>load & r4 & "0",
105=>"11" & "000000",

106=>add & r3 & "0",
107=>"01" & r2 & adz,
	
	 

			others => "11100000");  		 
begin

	
  mem_process : process (clk, m_rd, mem_addr,memory) is
  begin
  
		if m_rd = '1' then
mem_out <= memory(to_integer(unsigned(mem_addr))) & memory(to_integer(unsigned(mem_addr)) + 1);
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


--r0 wali corner case
--what if ra in jal jlr jri is r0????????????? 0_o --priority given to r0
--
-- load produces zero flag i mem stage. thatll cause a problem with adz and ndz immediately after
--try editing aage for this-

--lm me last 3 writeback stages can produce hazards--edit hazard detection
--immediate hazard doesnt  matter because even if it writes its gonna branch and flush 3? 4? instructions
--can detect and mitigate the next two dependancies

--sm  source hazards source 2 it has to read reg b 

--branch k liye alu--ehhh not a good idea
--use alu in chooser
--make two selects for alu
--check lli
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;
--I AM GONNA ASSUME THAT LM AND SM DON'T UPDATE THE FLAGS T_T
entity main_dataflow is 
	port(
	clk: in std_logic;
	 reset: in std_logic;
	out0: out std_logic_vector(15 downto 0);
			out1: out std_logic_vector(15 downto 0);
			out2: out std_logic_vector(15 downto 0);
			out3: out std_logic_vector(15 downto 0);
			out4: out std_logic_vector(15 downto 0);
			out5: out std_logic_vector(15 downto 0);
			out6: out std_logic_vector(15 downto 0);
			out7: out std_logic_vector(15 downto 0);
			c_flag: out std_logic;
			z_flag: out std_logic
			);
end entity;

architecture ultimate of main_dataflow is
	
	
	component pipe_reg is
port (--initial: in std_logic_vector(15 downto 0);
	input:in std_logic_vector(15 downto 0);
			Enable, clock: in std_logic;
			output: out std_logic_vector(15 downto 0));
end component pipe_reg;

	component stallc_pipe is
port (--initial: in std_logic_vector(15 downto 0);
	input:in std_logic_vector(2 downto 0);
			disable, clock: in std_logic;
			output: out std_logic_vector(2 downto 0));
end component stallc_pipe;

component stall_counter is
	port (--initial: in std_logic_vector(15 downto 0);
	opcode:in std_logic_vector(3 downto 0);
	stallc:in std_logic_vector(2 downto 0);
	
			next_stallc_in: out std_logic_vector(2 downto 0));
end component stall_counter;


component mux_16x1 is
    Port ( opcode  : in  STD_LOGIC_VECTOR (3 downto 0);
           dadi, dadd, dnandi, dlli, dload, dstore, dlm, dsm, dbeq, dblessthan, dble, djal, djlr, djri,default : in  STD_LOGIC_VECTOR (15 downto 0);

           y   : out STD_LOGIC_VECTOR (15 downto 0)

          );
end component mux_16x1;

component carry_adder_compl is 
 port (
    ALU_B: in std_logic_vector(15 downto 0);
	 carry_in: in std_logic;

    complememt_kar_du: in std_logic;
		cy_add_kar_du: in std_logic;

    ALU_C: out std_logic_vector(15 downto 0);
    C_O: out std_logic
  );
end component carry_adder_compl;

component leftshift1 is
	port (inp : in std_logic_vector (15 downto 0);
			outp : out std_logic_vector (15 downto 0));
end component leftshift1;

component f_reg is
port (c_in, z_in :std_logic;
			c_en, z_en, clk :in std_logic;
			c_out, z_out: out std_logic
		);
end component f_reg;

component hazard_detection_block is 
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
end component hazard_detection_block;

component r0_me1_likha_kya is 
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
end component r0_me1_likha_kya;


component RegisterFile is
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
end component RegisterFile;

component sign_extend is
port (input: in std_logic_vector(5 downto 0);
			output: out std_logic_vector(15 downto 0));
end component sign_extend;

component sign_extend_9 is
port (input: in std_logic_vector(8 downto 0);
			output: out std_logic_vector(15 downto 0));
end component sign_extend_9;

component risc_memory_instr is
port(
				clk, m_wr, m_rd: in std_logic; 
				mem_addr, mem_in: in std_logic_vector(15 downto 0);
				mem_out: out std_logic_vector(15 downto 0)
			 ); 
end component risc_memory_instr;

component risc_memory_data is
port(
				clk, m_wr, m_rd: in std_logic; 
				mem_addr, mem_in: in std_logic_vector(15 downto 0);
				mem_out: out std_logic_vector(15 downto 0)
			 ); 
end component risc_memory_data;

component eight_bit_pipe_reg is
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
end component eight_bit_pipe_reg;

component Instruction_reg_pipe is
	port (input:in std_logic_vector(15 downto 0);
			w_enable, clk: in std_logic;
			IR_80: out std_logic_vector(8 downto 0);
			IR_50: out std_logic_vector(5 downto 0);
			IR_1512: out std_logic_vector(3 downto 0);
			IR_119, IR_86, IR_53: out std_logic_vector(2 downto 0);
			IR_2 : out std_logic;
			IR_01:out std_logic_vector(1 downto 0);
			IR_out: out std_logic_vector(15 downto 0));
end component Instruction_reg_pipe;

component flag_reg is
port (c_in, z_in :std_logic;
			c_en, z_en, clk :in std_logic;
			c_out, z_out: out std_logic
		);
end component flag_reg;
-- IR: component Instruction_reg_pipe
 --port map(input, enable, clk, IR_80, IR_50,  IR_1512, IR_119, IR_86, IR_53, IR_2,IR_01,);
  

component alu is
port (
    ALU_A, ALU_B: in std_logic_vector(15 downto 0);
    ALU_SELECT: in std_logic_vector(1 downto 0);
    ALU_C: out std_logic_vector(15 downto 0);
    Z_O, C_O: out std_logic
  );
end component alu;

component hazard_mitigation_block is 
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
end component hazard_mitigation_block;



component disabler is 
  port (
    opcode3: in std_logic_vector(3 downto 0);
   
disable_instr_3: in std_logic;

disable_instr_2: in std_logic;
    disable_instr_1: in std_logic;
	 z_in: in std_logic;
 c_in_inp: in std_logic;	
  disable_next_3_instr: out std_logic


 

  );
end component disabler;

component What_is_pc_supposed_to_be is 
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
end component What_is_pc_supposed_to_be;

component RF_Writer is 
  port (
opcode5: in std_logic_vector(3 downto 0); 
disable_ult_5: in std_logic;
should_i_write: in std_logic;
rf_4_lm: in std_logic;	
RF_Write: out std_logic

  );
end component RF_Writer;


--opcode signals for ease
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


	
	--16 bit
		signal check,d1, d2,m_in, m_out,pc_plus_2,What_is_pc_supposed_to_bee,pc_inp,pc,iMemo_addr, pc1,pc2,pc3,pc4,pc5,im_out,Imem_ka_data: std_logic_vector(15 downto 0):="0000000000000000";

	signal regb_mod,d2_dataa,se9_out,se6_out,alu_input2,alu_input1,d1_inp,d2_inp,d1_data,d2_data,im_in: std_logic_vector(15 downto 0):="0000000000000000";
	signal result,act_result: std_logic_vector(15 downto 0):="0000000000000000";
	signal next_lmi_inp,zero_or_next_lmi_inp,branch_ka_addr, alu2_b,alu_out_addr,doubse9_out,doubse6_out,dm_data, dm_in, dm_out,alu_data,alu_out,lmi,whyy: std_logic_vector(15 downto 0):="0000000000000000";
signal poora_ir2,poora_ir1,poora_ir3,poora_ir4,poora_ir5: std_logic_vector(15 downto 0):="0000000000000000";
	--four
	signal opcode1,opcode2,opcode3,opcode4,opcode5:std_logic_vector(3 downto 0):=(others=>'0');
	
--three
	signal  a1, a2,reg_b2_or_whatever_sm_wants,dest_load,dest2,dest,source_2,source_1,lm_dest_5,reg_a1_or_pc,reg_a1,reg_b1,reg_c1,reg_a2,reg_b2,reg_c2,reg_a3,reg_b3,reg_c3,reg_a4,reg_b4,reg_c4,reg_a5,reg_b5,reg_c5, a3: std_logic_vector(2 downto 0):=(others=>'0');
	signal stallc5_in,stallc4_in,stallc3_in,stallc2_in,stallc1_in,stallc1,stallc2,stallc3,stallc4,stallc5: std_logic_vector(2 downto 0):=(others=>'1');

	--two
	signal 	alu_ctrl,addr_mode1,addr_mode2,addr_mode3,addr_mode4,addr_mode5: std_logic_vector(1 downto 0):="00";
	--nine bit
	signal nine_bit_imm1,nine_bit_imm2,nine_bit_imm3,nine_bit_imm4,nine_bit_imm5: std_logic_vector(8 downto 0):="000000000";
	--six
	signal six_bit_imm1,six_bit_imm2,six_bit_imm3,six_bit_imm4,six_bit_imm5 : std_logic_vector(5 downto 0):="000000";
	--one
	signal c_in_inp,z_in,c_out1, z_out1,z_in_1, c_in_1,
	stall1,
	alu_hazard_imm1_4,alu_hazard_imm2_4,alu_hazard_2imm1_4,alu_hazard_2imm2_4,alu_hazard_3imm1_4,alu_hazard_3imm2_4,
	load_hazard_imm1_4,load_hazard_imm2_4,load_hazard_2imm1_4,load_hazard_2imm2_4,load_hazard_3imm1_4,load_hazard_3imm2_4,
	alu_hazard_imm1_3,alu_hazard_imm2_3,alu_hazard_2imm1_3,alu_hazard_2imm2_3,alu_hazard_3imm1_3,alu_hazard_3imm2_3,
	load_hazard_imm1_3,load_hazard_imm2_3,load_hazard_2imm1_3,load_hazard_2imm2_3,load_hazard_3imm1_3,load_hazard_3imm2_3,
	alu_hazard_imm1_2,alu_hazard_imm2_2,alu_hazard_2imm1_2,alu_hazard_2imm2_2,alu_hazard_3imm1_2,alu_hazard_3imm2_2,
	load_hazard_imm1_2,load_hazard_imm2_2,load_hazard_2imm1_2,load_hazard_2imm2_2,load_hazard_3imm1_2,load_hazard_3imm2_2,
	alu_hazard_imm1_1,alu_hazard_imm2_1,alu_hazard_2imm1_1,alu_hazard_2imm2_1,alu_hazard_3imm1_1,alu_hazard_3imm2_1,
	load_hazard_imm1_1,load_hazard_imm2_1,load_hazard_2imm1_1,load_hazard_2imm2_1,load_hazard_3imm1_1,load_hazard_3imm2_1,
	alu_hazard_imm1  ,alu_hazard_imm2  ,alu_hazard_2imm1  ,alu_hazard_2imm2  ,alu_hazard_3imm1 ,alu_hazard_3imm2,
	load_hazard_imm1  ,load_hazard_imm2  ,load_hazard_2imm1  ,load_hazard_2imm2  ,load_hazard_3imm1, load_hazard_3imm2,
	stalled,stalled_1,stalled_2,stalled_3,stalled_4,stalled_5,
	r0_me_likha_alu1,r0_me_likha_load1,r0_me_likha_alu2,r0_me_likha_load2,r0_me_likha_alu3,r0_me_likha_load3,r0_me_likha_alu4,r0_me_likha_load4,r0_me_likha_alu5,r0_me_likha_load5,
	mem_read,dMem_Write,c_in,c_en_4,z_en_4, c_en, z_en, c_out, z_out,carry1,c_out_data,complement_kar_du,	cy_add_kar_du,iMem_Write, iMem_Read,RF_Write,comp1,comp2,comp3,comp4,comp5: std_logic:='0';
		signal r0_en,disable_instr,disable_instr_2_inp,disable_instr_3_inp,disable_instr_4_inp,disable_instr_1,disable_instr_2,disable_instr_3,disable_instr_4,disable_instr_5,c_4_regb,c_flagg, z_flagg,disable_next_3_instr,disable_ult_1,disable_ult_2,disable_ult_3,disable_ult_4,disable_ult_5,need_to_check,need_to_check_again,zero_scene_check,carry_scene_check,carry_zero_scene_check,carry_zero_scene,should_i_write,aage_inp,aage,will_it_write2,will_it_write3: std_logic:='0';
		signal will_it_write1,will_it_write4,will_it_write5,rf_4_lm,R0_Write,pc1_en,ir_wr,RD_EX_D1_read,z_out1_eh,useless_1,useless_2_1,useless2_1,blah,blahh,hazen1,hazen2,hazen3,hazen4,hazen5,PC_write,IR_wr1,IR_wr3,IR_wr4: std_logic:='1';

	constant two: std_logic_vector(15 downto 0):="0000000000000010";
	constant why: std_logic_vector(15 downto 0):="0000000000000000";

		--useless
	signal	that_r0_thing,disable_instr_11,disable_instr_22,disable_instr_33,useless11,useless16,useless17,useless18,useless19,useless20,useless12,useless13, useless5,useless6,useless7,useless8,useless9,useless21,useless22,useless10,useless,useless1,useless2,useless3,useless4: std_logic:='1'; 
		
	begin
----pipeline reg--------------
  pc_update: component pipe_reg
 port map(pc_inp,PC_write,clk,pc);
--fetch end
--decode start

 IFetch_ID: component Instruction_reg_pipe
 port map(Imem_ka_data, ir_wr, clk,nine_bit_imm1, six_bit_imm1, opcode1,reg_a1, reg_b1, reg_c1, comp1, addr_mode1, poora_ir1);
 
   lm_stall_1: component stallc_pipe
 port map(stallc1_in,disable_ult_1,clk,stallc1);
 
  stall_counter1: component stall_counter
 port map(opcode1,stallc1,stallc1_in);
 
 
  pc_1: component pipe_reg
 port map(pc,pc1_en,clk,pc1);
 
 ro_written_1:component r0_me1_likha_kya  
  port map( opcode1,reg_a1,reg_b1,reg_c1,stallc1,disable_instr_1,r0_me_likha_alu1, r0_me_likha_load1 );

  
alu_hazard_signal_1: component eight_bit_pipe_reg
 port map(alu_hazard_imm1  ,alu_hazard_imm2  ,alu_hazard_2imm1  ,alu_hazard_2imm2  ,alu_hazard_3imm1  ,alu_hazard_3imm2,
			'0',disable_instr,hazen1,clk,
			 alu_hazard_imm1_1,alu_hazard_imm2_1,alu_hazard_2imm1_1,alu_hazard_2imm2_1,alu_hazard_3imm1_1,alu_hazard_3imm2_1,
 stalled,disable_instr_11
 );
 
	load_hazard_signal_1: component eight_bit_pipe_reg
 port map(load_hazard_imm1  ,load_hazard_imm2  ,load_hazard_2imm1  ,load_hazard_2imm2  ,load_hazard_3imm1  ,load_hazard_3imm2,
			'0',disable_instr,hazen1,clk,
			 load_hazard_imm1_1,load_hazard_imm2_1,load_hazard_2imm1_1,load_hazard_2imm2_1,load_hazard_3imm1_1,load_hazard_3imm2_1,
 useless,disable_instr_1
 );
 --decode end 
 --read start
 ID_RD: component Instruction_reg_pipe
 port map(poora_ir1, '1', clk,nine_bit_imm2, six_bit_imm2, opcode2,reg_a2, reg_b2, reg_c2, comp2, addr_mode2, poora_ir2);
 
 alu_hazard_signal_2: component eight_bit_pipe_reg
 port map(alu_hazard_imm1  ,alu_hazard_imm2  ,alu_hazard_2imm1  ,alu_hazard_2imm2  ,alu_hazard_3imm1  ,alu_hazard_3imm2  ,
 stalled_1,disable_instr_2_inp,hazen2,clk,
			 alu_hazard_imm1_2,alu_hazard_imm2_2,alu_hazard_2imm1_2,alu_hazard_2imm2_2,alu_hazard_3imm1_2,alu_hazard_3imm2_2,
 stalled_2,disable_instr_22
);

load_hazard_signal_2: component eight_bit_pipe_reg
 port map(load_hazard_imm1  ,load_hazard_imm2  ,load_hazard_2imm1  ,load_hazard_2imm2  ,load_hazard_3imm1  ,load_hazard_3imm2,
 '0',disable_instr_2_inp,hazen2,clk,
			 load_hazard_imm1_2,load_hazard_imm2_2,load_hazard_2imm1_2,load_hazard_2imm2_2,load_hazard_3imm1_2,load_hazard_3imm2_2,
 useless2,disable_instr_2
);


   lm_stall_2: component stallc_pipe
 port map(stallc2_in,disable_ult_2,clk,stallc2);
 
   stall_counter2: component stall_counter
 port map(opcode2,stallc2,stallc2_in);
 


 pc_2: component pipe_reg
 port map(pc1,'1',clk,pc2);
 
 
 
ro_written_2: component flag_reg
port map(r0_me_likha_alu1, r0_me_likha_load1, r0_en, r0_en, clk, r0_me_likha_alu2, r0_me_likha_load2);

 
 

 --read end
 --execute start
 
  RD_EX_D1: component pipe_reg
 port map(d1_inp,RD_EX_D1_read,clk,d1_data);
 --enable for this one
 RD_EX_D1_read<=stallc3_in(2) and stallc3_in(1) and stallc3_in(0);
 
 RD_EX_D2: component pipe_reg
 port map(d2_inp,'1',clk,d2_data);
 
 
 RD_EX: component Instruction_reg_pipe
 port map(poora_ir2, '1', clk,nine_bit_imm3, six_bit_imm3, opcode3,reg_a3, reg_b3, reg_c3, comp3, addr_mode3, poora_ir3);
  
  alu_ka_output: component pipe_reg
 port map(alu_out,'1',clk,alu_data);
 
  pc_3: component pipe_reg
 port map(pc2,'1',clk,pc3);
 
  next_lmi: component pipe_reg
 port map(zero_or_next_lmi_inp,will_it_write3,clk,lmi);
  
   lm_stall_3: component stallc_pipe
 port map(stallc3_in,disable_ult_3,clk,stallc3);
 
   stall_counter3: component stall_counter
 port map(opcode3,stallc3,stallc3_in);
 
 
ro_written_3: component flag_reg
port map(r0_me_likha_alu2, r0_me_likha_load2, r0_en, r0_en, clk, r0_me_likha_alu3, r0_me_likha_load3);

 
 
 
 
 alu_hazard_signal_3: component eight_bit_pipe_reg
 port map(alu_hazard_imm1_2,alu_hazard_imm2_2,alu_hazard_2imm1_2,alu_hazard_2imm2_2,alu_hazard_3imm1_2,alu_hazard_3imm2_2,
 stalled_2,disable_instr_3_inp,hazen3,clk,
 			 alu_hazard_imm1_3,alu_hazard_imm2_3,alu_hazard_2imm1_3,alu_hazard_2imm2_3,alu_hazard_3imm1_3,alu_hazard_3imm2_3,
 stalled_3,disable_instr_33
);

 load_hazard_signal_3: component eight_bit_pipe_reg
 port map(load_hazard_imm1_2,load_hazard_imm2_2,load_hazard_2imm1_2,load_hazard_2imm2_2,load_hazard_3imm1_2,load_hazard_3imm2_2,
 carry_zero_scene_check,disable_instr_3_inp,hazen3,clk,
			 load_hazard_imm1_3,load_hazard_imm2_3,load_hazard_2imm1_3,load_hazard_2imm2_3,load_hazard_3imm1_3,load_hazard_3imm2_3,
 carry_zero_scene,disable_instr_3
);
  --execute end
 --mem access start

 
 EX_MEM: component Instruction_reg_pipe
 port map(poora_ir3, '1', clk,nine_bit_imm4, six_bit_imm4, opcode4,reg_a4, reg_b4, reg_c4, comp4, addr_mode4, poora_ir4);

  load_pen_signals4: component eight_bit_pipe_reg
 port map(load_hazard_imm1_3,load_hazard_imm2_3,load_hazard_2imm1_3,load_hazard_2imm2_3,load_hazard_3imm1_3,load_hazard_3imm2_3,
 aage_inp,disable_instr_4_inp,hazen4,clk,
			 load_hazard_imm1_4,load_hazard_imm2_4,load_hazard_2imm1_4,load_hazard_2imm2_4,load_hazard_3imm1_4,load_hazard_3imm2_4,
 aage,disable_instr_4
);

stallbit4_and_that_r0en_thing: component flag_reg
port map(stalled_3, that_r0_thing, '1', '1', clk, stalled_4, r0_en);


flag1: component flag_reg
port map(c_in_inp, z_in, '1', '1', clk, c_out1, z_out1_eh);

 pc_4: component pipe_reg
 port map(pc3,'1',clk,pc4);

  dm_in_pipe: component pipe_reg
 port map(alu_out_addr,'1',clk,dm_in);
 
 
 
   lm_stall_4: component stallc_pipe
 port map(stallc4_in,disable_ult_4,clk,stallc4);
 
   stall_counter4: component stall_counter
 port map(opcode4,stallc4,stallc4_in);
 
 
ro_written_4: component flag_reg
port map(r0_me_likha_alu3, r0_me_likha_load3, r0_en, r0_en, clk, r0_me_likha_alu4, r0_me_likha_load4);

  

  
 
 --mem access end
 -- write back start
 
 
 MEM_WB: component Instruction_reg_pipe
 port map(poora_ir4, '1', clk,nine_bit_imm5, six_bit_imm5, opcode5,reg_a5, reg_b5, reg_c5, comp5, addr_mode5, poora_ir5);
  
  
flag: component flag_reg
port map(c_out1, z_out1, c_en_4, z_en_4, clk, c_out, z_out);
 
  
  signals5: component eight_bit_pipe_reg
 port map(stalled_4,load_hazard_imm2_4,load_hazard_2imm1_4,load_hazard_2imm2_4,load_hazard_3imm1_4,load_hazard_3imm2_4,
 aage,disable_instr_4,hazen5,clk,
 stalled_5,useless16,useless17,useless18,useless19,useless20
 ,should_i_write,disable_instr_5
);
  
   pc_5: component pipe_reg
 port map(pc4,'1',clk,pc5);
 
 
   lm_stall_5: component stallc_pipe
 port map(stallc5_in,disable_ult_5,clk,stallc5);
 
   stall_counter5: component stall_counter
 port map(opcode5,stallc5,stallc5_in);
 

  
  
  result_to_be_written: component pipe_reg
 port map(act_result,'1',clk,result);
 
 --write back end
 --------------------------------------------------------
  disable_ult_1<=disable_instr_1  or stalled_1; 

 disable_ult_2<=disable_instr_2  or stalled_2; 
disable_ult_3<=disable_instr_3  or stalled_3; 
disable_ult_4<=disable_instr_4  or stalled_4; 
disable_ult_5<=disable_instr_5  or stalled_5; 

c_flag<=c_flagg;
z_flag<=z_flagg;
R0_Write<=not 	disable_ult_5;

 --*************************************************
 --*******************************************************
 ------------other components----------------------------------------------
actual_flag: component flag_reg
port map(c_out, z_out, c_en, z_en, clk, c_flagg, z_flagg);

 reg_file: component RegisterFile
  port map(reg_a2, a2, a3,pc5, d1, d2, result,whyy, clk, RF_Write,R0_Write,out0,out1,out2,out3,out4,out5,out6,out7);
  
  imem: component risc_memory_instr
  port map(clk, '0', '1', iMemo_addr, im_in, im_out);
  
   dmem: component risc_memory_data
  port map(clk, dMem_Write, mem_read, alu_data, dm_in, dm_out);
  
dMem_Write<=(not (disable_instr_4  or stalled_4))
and 			(
					(not opcode4(3) and  opcode4(2) and not opcode4(1) and opcode4(0)) -- add
				or
					(not opcode4(3) and  opcode4(2) and  opcode4(1) and opcode4(0) and will_it_write4) -- add
				);

mem_read<=(not (disable_instr_4  or stalled_4))
and 			(	
					(not opcode4(3)) and  opcode4(2) and (not opcode4(0))-- add
				);
				
  chooser: component carry_adder_compl
  port map(d2_data,c_4_regb,complement_kar_du,	cy_add_kar_du,regb_mod,carry1);
  
 c_4_regb <= (aage and c_out1) or
                              ( should_i_write and (not aage) and c_out) or
                              ((not should_i_write) and (not aage) and c_flagg);

  
  multiplyby2: component leftshift1
			port map(se6_out, doubse6_out);
			
  multiply9by2: component leftshift1
			port map(se9_out, doubse9_out);
  
  
 se6: component sign_extend
   port map(six_bit_imm3, se6_out);
	
se9: component sign_extend_9
   port map(nine_bit_imm3, se9_out);  
	
alu_main: component alu
			port map(alu_input1, alu_input2, 	alu_ctrl, alu_out, z_in, c_in);
alu_for_address: component alu
			port map(branch_ka_addr, alu2_b, "00", alu_out_addr, z_in_1, c_in_1);
alu_for_twos: component alu
			port map(two, lmi, "00", next_lmi_inp, useless12, useless11);

			
alu_for_pc: component alu
			port map(pc,two,"00",pc_plus_2,blah,blahh);
			
 --               adi, add, nandi, lli, load, store, lm,   sm,    beq, blessthan, ble, jal, jlr, jri : in  STD_LOGIC_VECTOR (3 downto 0);
actual_data: component mux_16x1
port map (opcode4,alu_data,alu_data,alu_data,alu_data,dm_out,alu_data,dm_out,alu_data,alu_data,alu_data,alu_data,pc3,pc3,alu_data,alu_data,act_result);

branch_ka_addr_1st: component mux_16x1
port map (opcode3,pc3,pc3,  pc3,   pc3 ,pc3 ,d1_data,pc3,d2_data,pc3,        pc3         ,pc3         ,pc3,          d2_data,    d1_data,pc3 ,   branch_ka_addr);
 

alu2_b_wot: component mux_16x1
port map (opcode3,why,why,  why,   why ,why ,why    ,why,why    ,doubse6_out,doubse6_out,doubse6_out  ,doubse9_out, why,     doubse9_out,doubse6_out, alu2_b);


	--                 adi,    add,  nandi,    lli,   load,  store,     lm,     sm,    beq, blessthan,    ble,jal, jlr, jri : in  STD_LOGIC_VECTOR (3 downto 0);
firstinputofalumain: component mux_16x1
port map (opcode3,d1_data,d1_data,d1_data,se9_out,se6_out,se6_out,d1_data,d1_data,d1_data,   d1_data,d1_data,pc3, pc3,d1_data,d1_data,alu_input1);
 
 secondinpofalumain: component mux_16x1
port map(opcode3,se6_out,regb_mod,regb_mod,  why ,regb_mod,regb_mod,lmi  ,lmi    ,regb_mod, regb_mod,regb_mod,two,two,regb_mod,regb_mod ,alu_input2);
 --change for lli and beq and stuff
	

iamtiredofthinkingofnames: component RF_Writer
  port map(opcode5,disable_ult_5,should_i_write,will_it_write5,RF_Write);  
  
need_to_check<=(not opcode2(3)) and (not opcode2(2)) and (opcode2(1) xor opcode2(0)) and (addr_mode2(1) xor addr_mode2(0));
need_to_check_again<=(not opcode3(3)) and (not opcode3(2)) and (opcode3(1) xor opcode3(0)) and (not addr_mode3(0)) and addr_mode3(0)
and (not opcode4(3)) and ( opcode4(2)) and (not opcode4(1)) and  (not opcode4(0));
zero_scene_check<=  (not need_to_check) or
						  (   ( (not addr_mode2(1)) and addr_mode2(0)) and 
								(	(carry_zero_scene and z_in) or
									( aage and (not carry_zero_scene) and z_out1) or
									(should_i_write and (not aage) and (not carry_zero_scene) and z_out) or		
									((not should_i_write) and (not aage)  and (not carry_zero_scene)and z_flagg)
								)
						   )	;
carry_scene_check<=  (not need_to_check) or
							(
								( (not addr_mode2(0)) and addr_mode2(1)) and 
								(	(carry_zero_scene and c_in_inp) or
									( aage and (not carry_zero_scene) and c_out1) or
									(should_i_write and (not aage) and (not carry_zero_scene) and c_out) or		
									((not should_i_write) and (not aage)  and (not carry_zero_scene)and c_flagg)
								) 
						   );
carry_zero_scene_check <= (carry_scene_check or zero_scene_check); 
aage_inp<=((not need_to_check_again) and carry_zero_scene) or (need_to_check_again and((z_out1 and (not disable_ult_4)) or z_out));

  -- Opcode2 is add or nandi, addr_mode2 is 01
  

	

detect_hazard_imm: component hazard_detection_block 
  port map(opcode1,opcode2,reg_a1,reg_b1,stallc1,reg_a2,reg_b2,reg_c2,stallc2,disable_ult_2,alu_hazard_imm1,alu_hazard_imm2,load_hazard_imm1,load_hazard_imm2);
 
 detect_hazard_next_imm: component hazard_detection_block 
  port map(opcode1,opcode3,reg_a1,reg_b1,stallc1,reg_a3,reg_b3,reg_c3,stallc3,disable_ult_3,alu_hazard_2imm1,alu_hazard_2imm2,load_hazard_2imm1,load_hazard_2imm2);
 
 detect_hazard_sec_next_imm: component hazard_detection_block 
  port map(opcode1,opcode4,reg_a1,reg_b1,stallc1,reg_a4,reg_b4,reg_c4,stallc4,disable_ult_4,alu_hazard_3imm1,alu_hazard_3imm2,load_hazard_3imm1,load_hazard_3imm2);
 

 d1_input_chooser:component hazard_mitigation_block
  port map(
    alu_hazard_imm1_2, carry_zero_scene, alu_hazard_2imm1_2,alu_hazard_3imm1_2,should_i_write,load_hazard_imm1_2,load_hazard_2imm1_2,load_hazard_3imm1_2,will_it_write4,will_it_write5,aage,result,alu_out,alu_data,dm_out,d1,d1_inp );

	 d2_input_chooser:component hazard_mitigation_block
   port map(
    alu_hazard_imm2_2, carry_zero_scene, alu_hazard_2imm2_2,alu_hazard_3imm2_2,should_i_write,load_hazard_imm2_2,load_hazard_2imm2_2,load_hazard_3imm2_2,will_it_write4,will_it_write5,aage,result,alu_out,alu_data,dm_out,d2,d2_inp );

  What_is_pc_supposed_to_beee:component What_is_pc_supposed_to_be 
  port map (reset, disable_ult_3,	r0_me_likha_alu4,r0_me_likha_load4,opcode3,z_in, c_in_inp,alu_out_addr,pc_plus_2,d2_data,alu_data,dm_out,What_is_pc_supposed_to_bee);

  disable_instrs:component disabler 
  port map( opcode3,disable_instr_3,disable_instr_2,disable_instr_1, z_in, c_in_inp,disable_next_3_instr );
 
 
			disable_instr<=disable_next_3_instr or (r0_me_likha_alu4 and aage and not disable_ult_4) or (r0_me_likha_load4 and will_it_write4 and not disable_ult_4);
			
			disable_instr_4_inp<=disable_instr_3  or  (r0_me_likha_alu4 and aage and not disable_ult_4) or (r0_me_likha_load4 and will_it_write4 and not disable_ult_4);
			disable_instr_3_inp<=disable_instr_2 or disable_next_3_instr or (r0_me_likha_alu4 and aage and not disable_ult_4) or (r0_me_likha_load4 and will_it_write4 and not disable_ult_4);
			disable_instr_2_inp<=disable_instr_1 or disable_next_3_instr or (r0_me_likha_alu4 and aage and not disable_ult_4) or (r0_me_likha_load4 and will_it_write4 and not disable_ult_4);		



 c_en <= (not disable_ult_5) and 
					(  
							(not opcode5(3) and not opcode5(2) and (not opcode5(1))) -- add
							 and RF_Write
						 
					);
					
	  z_en <= (not disable_ult_5) and 
					(  (
							(not opcode5(3) and not opcode5(2) and (opcode5(1) nand opcode5(0))) -- add
							 and RF_Write
						) or
						(
							(not opcode5(3) and  opcode5(2) and not opcode5(1) and not opcode5(0)) -- add
						)	
					);
 c_en_4 <= (not disable_ult_4) and 
					(  (
							(not opcode4(3) and not opcode4(2) and (not opcode4(1)) ) -- add
							 and aage
						) 
					);
	  z_en_4 <= (not disable_ult_4) and 
					(  (
							(not opcode4(3) and not opcode4(2) and (opcode4(1) nand opcode4(0))) -- add
							 and aage
						) or
						(
							(not opcode4(3) and  opcode4(2) and not opcode4(1) and not opcode4(0)) -- add
						)					
					);
 

z_out1 <= not(act_result(0) or act_result(1) or act_result(2) or act_result(3) or act_result(4) or act_result(5) or act_result(6) or act_result(7) or act_result(8) or act_result(9) or act_result(10) or act_result(11) or act_result(12) or act_result(13) or act_result(14) or act_result(15));
c_in_inp<=c_In or carry1;
stalled_1<=(load_hazard_imm1 or load_hazard_imm2) 
and 		(   (stallc2(0) and stallc2(1) and stallc2(2))
				or
				 ((stallc2(0) xor stallc2(1)) and not stallc2(2))
			);


hazen1<=not stalled_1;	

PC_write<=
	(not (stalled_1 and not disable_instr_1) )
and
	(	((not opcode1(3)) and  opcode1(2) and opcode1(1) and (not stallc1(2)) and (not stallc1(1)) and (not stallc1(0)) ) 
	or (not (not opcode1(3) and  opcode1(2) and opcode1(1) ) )
	);

--PC_write<= not stalled_1;
ir_wr<=PC_write;
pc1_en<=PC_write;

will_it_write1<=((((not opcode1(3)) and  opcode1(2) and  opcode1(1))and nine_bit_imm1(to_integer(unsigned(stallc1)))) ) or (not((not opcode1(3)) and  opcode1(2) and  opcode1(1)));
will_it_write2<=((((not opcode2(3)) and  opcode2(2) and  opcode2(1))and nine_bit_imm2(to_integer(unsigned(stallc2)))) );
will_it_write3<=((((not opcode3(3)) and  opcode3(2) and  opcode3(1))and nine_bit_imm3(to_integer(unsigned(stallc3)))) ) ;
will_it_write4<=((((not opcode4(3)) and  opcode4(2) and  opcode4(1))and nine_bit_imm4(to_integer(unsigned(stallc4)))) ) or (not((not opcode4(3)) and  opcode4(2) and  opcode4(1)));
will_it_write5<=((((not opcode5(3)) and  opcode5(2) and  opcode5(1))and nine_bit_imm5(to_integer(unsigned(stallc5)))) ) or (not((not opcode5(3)) and  opcode5(2) and  opcode5(1)));




cy_add_kar_du<= (not opcode3(3)) and (not opcode3(2)) and (not opcode3(1)) and (opcode3(0)) and addr_mode3(1) and addr_mode3(0);

    complement_kar_du <= (comp3 and
                           ( (not opcode3(3) and not opcode3(2) and not opcode3(1) and opcode3(0)) or  -- add
                             (not opcode3(3) and not opcode3(2) and opcode3(1) and not opcode3(0)) 
									 ) 
								 );
								--	 or  -- nandi
                        -- ('1' and
                         --   (opcode3(3) and not opcode3(2) and ( (not opcode3(1) and not opcode3(0)) or  -- beq
								--													  (not opcode3(1) and opcode3(0)) or  -- blessthan
									--												  (opcode3(1) and not opcode3(0)) 
								--													 ) 
								--	 )
								-- );
									 

--mem_read<=(not disable_instr_4) and not(opcode4(0) or  (not opcode4(2)) or opcode4(3) )						

cpu_process : process (clk) is
  variable PC_write_var,zenable,cenable,stall1 ,stall8 : std_logic:='0';

begin



----reg_b1_or_whatever_the_fuck_sm_wants---
if(opcode2=sm) then

    reg_b2_or_whatever_sm_wants<=stallc2;	
    else
    reg_b2_or_whatever_sm_wants<=reg_b2;
    end if;
	 
if(stallc2="111")  then

zero_or_next_lmi_inp<=why;
    else
zero_or_next_lmi_inp<=next_lmi_inp;
    end if;
	
	--control***************************************
  --alu ctrl-------------------
  case opcode3 is
	   when add|adi |load|store|lm|sm => -- Addition
		alu_ctrl		<="00";
	   when nandi => -- nand
		alu_ctrl<="11";
		when beq|blessthan |ble => -- nand
		alu_ctrl<="10";
		when lli => -- nand
		alu_ctrl<="01";


      when others => 
		alu_ctrl		<="00";
    end case;
	 
  	--for a3 (kahan likhna hai?)
	  case opcode5 is
	   when lli|load |jal|jlr => -- Addition
a3<=reg_a5;
	   when adi => -- nand
a3<=reg_b5;
		when add|nandi => -- nand
a3<=reg_c5;
	when lm => -- nand
			 
a3<=stallc5;
      when others => 
a3<=reg_a5;
    end case;
	 
	 

 


	 case opcode2 is
	   when add|nandi => -- Addition
					dest<=reg_c2;
	   when adi => -- blt,ble
					dest<=reg_b2;
		when lli|jal|jlr|load=> -- blt,ble
					dest<=reg_a2;		

      when others => 
					dest<=reg_a2;
    end case;
	 
	  case opcode3 is
	   when add|nandi => -- Addition
					dest2<=reg_c2;
	   when adi => -- blt,ble
					dest2<=reg_b2;
		when lli|jal|jlr=> -- blt,ble
					dest2<=reg_a2;	
      when others => 
					dest2<=reg_a2;
    end case;
	 


	
 end  process;
 
  --*8888888888888888888888888888888888888888
  ---------------------instruction fetch-------------------0988888888888888888888
  --*879999999999999967
  iMemo_addr<=pc;
  pc_inp<=What_is_pc_supposed_to_bee;
  
  
   --***********************************************************
  ---------------------instruction decode-------------------
  --***********************************************************
   Imem_ka_data<=im_out;
	
   --***********************************************************
  ---------------------register read-------------------
  --***********************************************************
  a2<=reg_b2_or_whatever_sm_wants;
  

   --***********************************************************
  ---------------------execute-------------------
  --***********************************************************


   --***********************************************************
  ---------------------memory access-------------------
  --***********************************************************
  
   --***********************************************************
  ---------------------write back-------------------
  --***********************************************************
end architecture;
--check hazard detection
--use that mux
--check unsafe signals
--PC = R0--done
--Updating carry and zero flag and all registers in the writeback stage--done
--Computing zero flag for the load instruction according to the data --done
--Pipeline Flush Mechanism
--Pipeline Stall Mechanism
--Data forwarding--done
--LM SM instructions implementation without any unnecessary stalls
--possible corner cases
--what if r0 me result likh diya
--add reset in reg file

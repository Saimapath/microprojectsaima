library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_16x1 is
    Port ( opcode  : in  STD_LOGIC_VECTOR (3 downto 0);
           dadi, dadd, dnandi, dlli, dload, dstore, dlm, dsm, dbeq, dblessthan, dble, djal, djlr, djri,default : in  STD_LOGIC_VECTOR (15 downto 0);

           -- Data inputs
           -- Select input
           -- Output
           y   : out STD_LOGIC_VECTOR (15 downto 0)

          );
end mux_16x1;

architecture Behavioral of mux_16x1 is
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
begin

    process (dadi, dadd, dnandi, dlli, dload, dstore, dlm, dsm, dbeq, dblessthan, dble, djal, djlr, djri,default, opcode)
    begin
        case opcode is
            when adi =>
                y <= dadi;
            when add =>
                y <= dadd;
            when nandi=>
                y <= dnandi;
            when lli =>
                y <= dlli;
            when load =>
                y <= dload;
            when store =>
                y <= dstore;
            when lm =>
                y <= dlm;
            when sm=>
                y <= dsm;
            when beq=>
                y <= dbeq;
            when blessthan=>
                y <= dblessthan;
            when ble =>
                y <= dble;
            when jal =>
                y <= djal;
            when jlr =>
                y <= djlr;
            when jri =>
                y <= djri;
            when others =>
                y <= default;
        end case;
    end process;
end Behavioral;

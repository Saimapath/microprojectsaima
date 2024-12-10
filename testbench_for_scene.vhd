library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench_for_scene is
end testbench_for_scene;

architecture behavior of testbench_for_scene is

    -- Component declaration for the Unit Under Test (UUT)
    component carry_zero_scene_checker
    port (
        opcode2: in std_logic_vector(3 downto 0);
        addr_mode2: in std_logic_vector(1 downto 0);
        c_in_inp: in std_logic;
        z_in: in std_logic;
        c_out1: in std_logic;
        z_out1: in std_logic;
        c_out: in std_logic;
        z_out: in std_logic;
        c_flag: in std_logic;
        z_flag: in std_logic;
        carry_zero_scene: in std_logic;
        aage: in std_logic;
        should_i_write: in std_logic;
        carry_zero_scene_check: out std_logic
    );
    end component;

    -- Signal declarations to connect to the UUT
    signal opcode2 : std_logic_vector(3 downto 0);
    signal addr_mode2 : std_logic_vector(1 downto 0);
    signal c_in_inp : std_logic;
    signal z_in : std_logic;
    signal c_out1 : std_logic;
    signal z_out1 : std_logic;
    signal c_out : std_logic;
    signal z_out : std_logic;
    signal c_flag : std_logic;
    signal z_flag : std_logic;
    signal carry_zero_scene : std_logic;
    signal aage : std_logic;
    signal should_i_write : std_logic;
    signal carry_zero_scene_check : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    dut: carry_zero_scene_checker
    port map (
        opcode2 => opcode2,
        addr_mode2 => addr_mode2,
        c_in_inp => c_in_inp,
        z_in => z_in,
        c_out1 => c_out1,
        z_out1 => z_out1,
        c_out => c_out,
        z_out => z_out,
        c_flag => c_flag,
        z_flag => z_flag,
        carry_zero_scene => carry_zero_scene,
        aage => aage,
        should_i_write => should_i_write,
        carry_zero_scene_check => carry_zero_scene_check
    );

    -- Test process
    stimulus: process
    begin
        -- Initialize all signals to default values
        opcode2 <= (others => '0');
        addr_mode2 <= (others => '0');
        c_in_inp <= '0';
        z_in <= '0';
        c_out1 <= '0';
        z_out1 <= '0';
        c_out <= '0';
        z_out <= '0';
        c_flag <= '0';
        z_flag <= '0';
        carry_zero_scene <= '0';
        aage <= '0';
        should_i_write <= '0';
        wait for 10 ns;

        -- Test Case 1: opcode2 = add, addr_mode2 = "10", carry_zero_scene = 1, c_in_inp = 1
        opcode2 <= "0001"; -- add
        addr_mode2 <= "10";
        carry_zero_scene <= '1';
        c_in_inp <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 1 failed: carry_zero_scene_check is not 1 when carry_zero_scene=1 and c_in_inp=1"
        severity error;

        -- Reset signals
        carry_zero_scene <= '0';
        c_in_inp <= '0';
        wait for 10 ns;

        -- Test Case 2: opcode2 = add, addr_mode2 = "10", carry_zero_scene = 0, aage = 1, c_out1 = 1
        carry_zero_scene <= '0';
        aage <= '1';
        c_out1 <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 2 failed: carry_zero_scene_check is not 1 when carry_zero_scene=0, aage=1, c_out1=1"
        severity error;

        -- Reset signals
        aage <= '0';
        c_out1 <= '0';
        wait for 10 ns;

        -- Test Case 3: opcode2 = add, addr_mode2 = "10", carry_zero_scene = 0, should_i_write = 1, c_out = 1
        carry_zero_scene <= '0';
        should_i_write <= '1';
        c_out <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 3 failed: carry_zero_scene_check is not 1 when carry_zero_scene=0, should_i_write=1, c_out=1"
        severity error;

        -- Reset signals
        should_i_write <= '0';
        c_out <= '0';
        wait for 10 ns;

        -- Test Case 4: opcode2 = add, addr_mode2 = "10", carry_zero_scene = 0, c_flag = 1
        carry_zero_scene <= '0';
        c_flag <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 4 failed: carry_zero_scene_check is not 1 when carry_zero_scene=0, c_flag=1"
        severity error;

        -- Reset signals
        c_flag <= '0';
        wait for 10 ns;

        -- Test Case 5: opcode2 = add, addr_mode2 = "01", carry_zero_scene = 1, z_in = 1
        addr_mode2 <= "01";
        carry_zero_scene <= '1';
        z_in <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 5 failed: carry_zero_scene_check is not 1 when carry_zero_scene=1, z_in=1"
        severity error;

        -- Reset signals
        carry_zero_scene <= '0';
        z_in <= '0';
        wait for 10 ns;

        -- Test Case 6: opcode2 = add, addr_mode2 = "01", carry_zero_scene = 0, aage = 1, z_out1 = 1
        carry_zero_scene <= '0';
        aage <= '1';
        z_out1 <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 6 failed: carry_zero_scene_check is not 1 when carry_zero_scene=0, aage=1, z_out1=1"
        severity error;

        -- Reset signals
        aage <= '0';
        z_out1 <= '0';
        wait for 10 ns;

        -- Test Case 7: opcode2 = add, addr_mode2 = "01", carry_zero_scene = 0, should_i_write = 1, z_out = 1
        carry_zero_scene <= '0';
        should_i_write <= '1';
        z_out <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 7 failed: carry_zero_scene_check is not 1 when carry_zero_scene=0, should_i_write=1, z_out=1"
        severity error;

        -- Reset signals
        should_i_write <= '0';
        z_out <= '0';
        wait for 10 ns;

        -- Test Case 8: opcode2 = add, addr_mode2 = "01", carry_zero_scene = 0, z_flag = 1
        carry_zero_scene <= '0';
        z_flag <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 8 failed: carry_zero_scene_check is not 1 when carry_zero_scene=0, z_flag=1"
        severity error;

        -- Reset signals
        z_flag <= '0';
        wait for 10 ns;

        -- Test Case 9: opcode2 = nandi, addr_mode2 = "10", carry_zero_scene = 1, c_in_inp = 1
        opcode2 <= "0010"; -- nandi
        addr_mode2 <= "10";
        carry_zero_scene <= '1';
        c_in_inp <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 9 failed: carry_zero_scene_check is not 1 when opcode2=nandi, carry_zero_scene=1, c_in_inp=1"
        severity error;

        -- Reset signals
        carry_zero_scene <= '0';
        c_in_inp <= '0';
        wait for 10 ns;

        -- Test Case 10: opcode2 = nandi, addr_mode2 = "01", carry_zero_scene = 1, z_in = 1
        addr_mode2 <= "01";
        carry_zero_scene <= '1';
        z_in <= '1';
        wait for 10 ns;
        assert (carry_zero_scene_check = '1')
        report "Test Case 10 failed: carry_zero_scene_check is not 1 when opcode2=nandi, carry_zero_scene=1, z_in=1"
        severity error;
		  
		  
        -- Finish simulation
        wait;
    end process;

end behavior;


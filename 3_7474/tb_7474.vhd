----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity tb_7474 is
end entity;
----------------------------------------------------------------------------------
architecture test of tb_7474 is
    component waituntil_7474 is
        port (
            CLK: in std_logic;
            CLR1_L, CLR2_L: in std_logic;
            PRE1_L, PRE2_L: in std_logic;
            D1, D2: in std_logic;
            Q1, Q2, Q1_L, Q2_L: out std_logic
            );
    end component;

    signal CLK_tb: std_logic := '0';
    signal CLR1_L_tb, CLR2_L_tb: std_logic := '1';
    signal PRE1_L_tb, PRE2_L_tb: std_logic := '1';
    signal D1_tb, D2_tb: std_logic := '0';
    signal Q1_tb, Q2_tb, Q1_L_tb, Q2_L_tb: std_logic;
    signal expected: std_logic_vector(1 downto 0);
    constant period: time := 10 ns;
    constant delta: time := 2 ns;
begin
    dut: waituntil_7474
        port map (
            CLK_tb,
            CLR1_L_tb, CLR2_L_tb,
            PRE1_L_tb, PRE2_L_tb,
            D1_tb, D2_tb,
            Q1_tb, Q2_tb, Q1_L_tb, Q2_L_tb
        );
        
    -- generate CLK and D stimuli
    CLK_tb <= not CLK_tb after period/2;
    D1_tb <= not D1_tb after period;
    D2_tb <= not D2_tb after period;
    
    -- generate CLR and PRE stimuli
    clear_preset: process
    begin
        wait for 1 ns; -- force output to 1 to start testing
        PRE1_L_tb <= '0';
        PRE2_L_tb <= '0';
        wait for 1 ns;
        PRE1_L_tb <= '1';
        PRE2_L_tb <= '1';
        
        -- wait for final D input, then change CLR and PRE before next period
        --starts to continue testing
        wait until rising_edge(D1_tb);
        wait for 3*period/4;
        CLR1_L_tb <= '0';
        CLR2_L_tb <= '0';
        wait until rising_edge(D1_tb);
        wait for 3*period/4;
        PRE1_L_tb <= '0';
        PRE2_L_tb <= '0';
        wait until rising_edge(D1_tb);
        wait for 3*period/4;
        CLR1_L_tb <= '1';
        CLR2_L_tb <= '1';
        wait until rising_edge(D1_tb);
        wait for 3*period/4;
    end process;
    
    -- generate expected values
    gen_expected: process
    begin
        wait for period/2;
        expected <= "01"; -- CLR = PRE = inactive, first input
        wait for period;
        expected <= "10"; -- CLR = PRE = inactive, second input
        wait for period;
        expected <= "01"; -- CLR = active
        wait for 2*period;
        expected <= "11"; -- CLR = PRE = active
        wait for 2*period;
        expected <= "10"; -- PRE = active
        wait for 2*period;
        expected <= "01"; -- CLR = PRE = inactive
        -- in theory the last value shouldn't be needed, but modelsim simulates
        --up to 85 ns for some reason
    end process;
    
    check: process
    begin
        -- 8*period = 85ns ????
        if(now < 8*period) then
            -- check values after every rising_edge(CLK_tb)
            wait until rising_edge(CLK_tb);
            wait for delta;
            assert(expected = (Q1_tb & Q1_L_tb))
                report "Mismatch in output of DFF1 at t=" & time'image(now) &
                        " Q1 = " & to_string(Q1_tb) &
                        " Q1_L = " & to_string(Q1_L_tb) &
                        " expected = " & to_string(expected)
                    severity failure;
            assert(expected = (Q2_tb & Q2_L_tb))
                report "Mismatch in output of DFF2 at t=" & time'image(now) &
                        " Q2 = " & to_string(Q2_tb) &
                        " Q2_L = " & to_string(Q2_L_tb) &
                        " expected = " & to_string(expected)
                    severity failure;
        else
            assert false
                report "No errors found!"
                severity note;
            wait for delta;
        end if;
    end process;
end architecture;
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;
----------------------------------------------------------------------------------
entity tb_74181 is
end entity;
----------------------------------------------------------------------------------
architecture test of tb_74181 is
    component alu_74181 is
        port (
            A_L, B_L: in std_logic_vector(3 downto 0);
            S: in std_logic_vector(3 downto 0);
            M, C_ripple_in: in std_logic;
            F_L: out std_logic_vector(3 downto 0);
            A_equal_B, C_ripple_out, P_L, G_L: out std_logic
            );
    end component;
    
    FILE f: TEXT OPEN READ_MODE IS "expected.txt";
    signal A_L_tb, B_L_tb, S_tb: std_logic_vector(3 downto 0) := (others => '0');
    signal A_L_usig, B_L_usig, S_usig: unsigned(3 downto 0) := (others => '0');
    signal M_tb, C_ripple_in_tb: std_logic := '0';
    signal F_L_tb: std_logic_vector(3 downto 0) := (others => '0');
    signal A_equal_B_tb, C_ripple_out_tb, P_L_tb, G_L_tb: std_logic := '0';
    signal check_F: std_logic_vector(3 downto 0);
    signal check_AB, check_P, check_G, check_C: std_logic;
    constant period: time := 10 ns;
    constant delta: time := 2 ns;
begin
    dut: alu_74181
        port map (A_L_tb, B_L_tb, S_tb,
            M_tb, C_ripple_in_tb,
            F_L_tb,
            A_equal_B_tb, C_ripple_out_tb, P_L_tb, G_L_tb);
            
    stimuli: process
    begin
        for i in 0 to 1 loop
            for j in 0 to 1 loop
                for k in 0 to 15 loop
                    for l in 0 to 15 loop
                        for m in 0 to 15 loop
                            wait for period;
                            B_L_usig <= (B_L_usig + 1);
                        end loop;
                        A_L_usig <= (A_L_usig + 1);
                    end loop;
                    S_usig <= (S_usig + 1);
                end loop;
                C_ripple_in_tb <= not C_ripple_in_tb;
            end loop;
            M_tb <= not M_tb;
        end loop;
    end process;
    S_tb <= std_logic_vector(S_usig);
    A_L_tb <= std_logic_vector(A_L_usig);
    B_L_tb <= std_logic_vector(B_L_usig);
    
    check: process
        variable l: line;
        variable valid: boolean;
        variable expected_file: bit_vector(7 downto 0);
        variable expected: std_logic_vector(7 downto 0);
    begin
        while not endfile (f) loop
            readline(f, l);
            read(l, expected_file, valid);
            assert(valid)
                report "Improper value from file"
                severity failure;
            expected := to_stdlogicvector(expected_file);
            check_F <= expected(7 downto 4);
            check_AB <= expected(3);
            check_P <= expected(2);
            check_G <= expected(1);
            check_C <= expected(0);
            wait for delta;
            assert false
                report "value of expected at t=" & time'image(now) &
                    ": " & to_string(expected)
                severity note;
            assert(F_L_tb = check_F)
                report "Mismatch of F_L_tb at t=" & time'image(now) &
                    " F_L_tb = " & to_string(F_L_tb) &
                    " expected = " & to_string(check_F)
                severity failure;
            assert(A_equal_B_tb = check_AB)
                report "Mismatch of A_equal_b_tb at t=" & time'image(now) &
                    " A_equal_B_tb = " & to_string(A_equal_B_tb) &
                    " expected = " & to_string(check_AB)
                severity failure;
            assert(P_L_tb = check_P)
                report "Mismatch of P_L_tb at t=" & time'image(now) &
                    " P_L_tb = " & to_string(P_L_tb) &
                    " expected = " & to_string(check_P)
                severity failure;
            assert(G_L_tb = check_G)
                report "Mismatch of G_L_tb at t=" & time'image(now) &
                    " G_L_tb = " & to_string(G_L_tb) &
                    " expected = " & to_string(check_G)
                severity failure;
            assert(C_ripple_out_tb = check_C)
                report "Mismatch of C_ripple_out_tb at t=" & time'image(now) &
                    " C_ripple_out_tb = " & to_string(C_ripple_out_tb) &
                    " expected = " & to_string(check_C)
                severity failure;
            wait on B_L_usig;
        end loop;
        assert false
            report "No errors!"
            severity note;
        wait;
    end process;
end architecture;

----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity logic_7474 is
    port(
        CLK: in std_logic;
        CLR1_L, CLR2_L: in std_logic;
        PRE1_L, PRE2_L: in std_logic;
        D1, D2: in std_logic;
        Q1, Q2, Q1_L, Q2_L: out std_logic
    );
end entity;
----------------------------------------------------------------------------------
architecture rts of logic_7474 is
    -- for feedback of output signals
    signal Q1_internal, Q2_internal: std_logic;
    signal Q1L_internal, Q2L_internal: std_logic;
    -- internal signals in the logic circuit
    signal int_1, int_2, int_3, int_4: std_logic_vector(2 downto 1);
begin
    Q1 <= Q1_internal;
    Q2 <= Q2_internal;
    Q1_L <= Q1L_internal;
    Q2_L <= Q2L_internal;
    
    -- DFF1
    int_1(1) <= not (PRE1_L and int_2(1) and int_4(1));
    int_2(1) <= not (CLR1_L and int_1(1) and CLK);
    int_3(1) <= not (int_2(1) and CLK and int_4(1));
    int_4(1) <= not (int_3(1) and CLR1_L and D1);
    Q1_internal <= not (PRE1_L and int_2(1) and Q1L_internal);
    Q1L_internal <= not (Q1_internal and CLR1_L and int_3(1));
    
    -- DFF2
    int_1(2) <= not (PRE2_L and int_2(2) and int_4(2));
    int_2(2) <= not (CLR2_L and int_1(2) and CLK);
    int_3(2) <= not (int_2(2) and CLK and int_4(2));
    int_4(2) <= not (int_3(2) and CLR2_L and D2);
    Q2_internal <= not (PRE2_L and int_2(2) and Q2L_internal);
    Q2L_internal <= not (Q2_internal and CLR2_L and int_3(2));
end architecture;
----------------------------------------------------------------------------------

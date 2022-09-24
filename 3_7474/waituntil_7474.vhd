----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity waituntil_7474 is
    port (
        CLK: in std_logic;
        CLR1_L, CLR2_L: in std_logic;
        PRE1_L, PRE2_L: in std_logic;
        D1, D2: in std_logic;
        Q1, Q2, Q1_L, Q2_L: out std_logic
        );
end entity;
----------------------------------------------------------------------------------
architecture rts of waituntil_7474 is
begin
    -- how to model the nonstable characteristic of the 7474 when both PRE and
    --CLR are active?
    DFF1: process
    begin
        wait until rising_edge(CLK) or CLR1_L = '0' or PRE1_L = '0';
        if (PRE1_L = '0' and CLR1_L = '0') then
            Q1 <= '1';
            Q1_L <= '1';
        elsif (PRE1_L = '0' and CLR1_L ='1') then
            Q1 <= '1';
            Q1_L <= '0';
        elsif (PRE1_L = '1' and CLR1_L ='0') then
            Q1 <= '0';
            Q1_L <= '1';
        else
            Q1 <= D1;
            Q1_L <= not D1;
        end if;
    end process;
    
    DFF2: process
    begin
        wait until rising_edge(CLK) or CLR2_L = '0' or PRE2_L = '0';
        if (PRE2_L = '0' and CLR2_L = '0') then
            Q2 <= '1';
            Q2_L <= '1';
        elsif (PRE2_L = '0' and CLR2_L ='1') then
            Q2 <= '1';
            Q2_L <= '0';
        elsif (PRE2_L = '1' and CLR2_L ='0') then
            Q2 <= '0';
            Q2_L <= '1';
        else
            Q2 <= D2;
            Q2_L <= not D2;
        end if;
    end process;
end architecture;
----------------------------------------------------------------------------------

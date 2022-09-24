----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity forloop_74595 is
    port (
        SRCLK, RCLK: in std_logic;
        SRCLR_L, OE_L: in std_logic;
        SER: in std_logic;
        QA, QB, QC, QD, QE, QF, QG, QH: out std_logic;
        QH_prime: out std_logic
        );
end entity;
----------------------------------------------------------------------------------
architecture rts of forloop_74595 is
    signal reg1: std_logic_vector(7 downto 0);
    signal reg2: std_logic_vector(7 downto 0);
    signal Q: std_logic_vector(7 downto 0);
begin
    -- circuit output
    QA <= Q(7); QB <= Q(6); QC <= Q(5); QD <= Q(4); QE <= Q(3); QF <= Q(2); 
    QG <= Q(1); QH <= Q(0);
    QH_prime <= reg1(0);
    
    -- determine Q
    Q <= reg2 when OE_L = '0' else
         "ZZZZZZZZ";

    -- determine reg1
    first_register: process(SRCLK, SRCLR_L)
    begin
        if(SRCLR_L = '0') then
            reg1 <= (others => '0');
        elsif rising_edge(SRCLK) then
            reg1(7) <= SER;
            for i in 6 downto 0 loop
                reg1(i) <= reg1(i+1);
            end loop;
        end if;
    end process;
    
    -- determine reg2
    second_register: process
    begin
        wait until rising_edge(RCLK);
        for i in 7 downto 0 loop
            reg2(i) <= reg1(i);
        end loop;
    end process;
end architecture;
----------------------------------------------------------------------------------

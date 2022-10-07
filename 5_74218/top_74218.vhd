----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity int_74218 is
    port (
        A: in std_logic_vector(4 downto 0);
        S1_L, S2_L: in std_logic;
        READ_WRITE: in std_logic; -- read = 1, write = 0
        D: in std_logic_vector(7 downto 0);
        Q: out std_logic_vector(7 downto 0)
        ); -- 74218 is asynchronous, there's no clock
end entity;
----------------------------------------------------------------------------------
architecture rtl of top_74218 is
    type cell_type is array (0 to 31) of std_logic_vector(7 downto 0);
    signal read_en: std_logic; -- output is high impedance if read_en = '0'
    signal write_en: std_logic;
    signal cell: cell_type := (others => (others => 'Z'));
begin
    read_en <= not (S1_L or S2_L or READ_WRITE);
    write_en <= not (S1_L or S2_L or not READ_WRITE);
    Q <= cell(to_integer(unsigned(A))) when read_en = '1' else (others => 'Z');
    cell(to_integer(unsigned(A))) <= D when write_en = '1' 
        else cell(to_integer(unsigned(A)));
end architecture;
----------------------------------------------------------------------------------

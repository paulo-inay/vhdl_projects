----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------------------------------------------------------------
entity whenelse_74138 is
	port (
		G1, G2A_L, G2B_L: in std_logic;
		A, B, C: in std_logic;
		Y: out std_logic_vector(7 downto 0));
end entity;
----------------------------------------------------------------------------------
architecture rts of whenelse_74138 is
	signal enable: std_logic;
	signal in_cat: std_logic_vector(2 downto 0);
begin
	enable <= '1' when (G1 and not G2A_L and not G2B_L) = '1' else
				 '0';
	
	in_cat <= C & B & A;
	Y <= "11111110" when enable = '1' and in_cat = "000" else
		  "11111101" when enable = '1' and in_cat = "001" else
		  "11111011" when enable = '1' and in_cat = "010" else
		  "11110111" when enable = '1' and in_cat = "011" else
		  "11101111" when enable = '1' and in_cat = "100" else
		  "11011111" when enable = '1' and in_cat = "101" else
		  "10111111" when enable = '1' and in_cat = "110" else
		  "01111111" when enable = '1' and in_cat = "111" else
		  "11111111";
end architecture;
----------------------------------------------------------------------------------

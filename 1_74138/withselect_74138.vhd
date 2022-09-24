----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------------------------------------------------------------
entity withselect_74138 is
	port (
		G1, G2A_L, G2B_L: in std_logic;
		A, B, C: in std_logic;
		Y: out std_logic_vector(7 downto 0));
end entity;
----------------------------------------------------------------------------------
architecture rts of withselect_74138 is
	signal en_cat: std_logic_vector(2 downto 0);
	signal in_cat: std_logic_vector(3 downto 0);
	signal enable: std_logic;
begin
	en_cat <= G1 & G2A_L & G2B_L;
	with en_cat select
		enable <= 	'1' when "100",
						'0' when others;
					
	in_cat <= enable & C & B & A;
	with in_cat select
		Y	<= 	"11111110" when "1000",
					"11111101" when "1001",
					"11111011" when "1010",
					"11110111" when "1011",
					"11101111" when "1100",
					"11011111" when "1101",
					"10111111" when "1110",
					"01111111" when "1111",
					"11111111" when others;
end architecture;
----------------------------------------------------------------------------------

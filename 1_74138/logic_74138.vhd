library IEEE;
use IEEE.std_logic_1164.all;

entity logic_74138 is
	port (
		G1, G2A_L, G2B_L: in std_logic;
		A, B, C: in std_logic;
		Y: out std_logic_vector(7 downto 0));
end entity;

architecture rts of logic_74138 is
	signal enable: std_logic;
begin
	enable <= (G1 and not G2A_L and not G2B_L);
	Y(0) <= not(not A and not B and not C and enable);
	Y(1) <= not(A and not B and not C and enable);
	Y(2) <= not(not A and B and not C and enable);
	Y(3) <= not(A and B and not C and enable);
	Y(4) <= not(not A and not B and C and enable);
	Y(5) <= not(A and not B and C and enable);
	Y(6) <= not(not A and B and C and enable);
	Y(7) <= not(A and B and C and enable);
end architecture;
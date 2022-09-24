----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity if_74138 is
	port (
		G1, G2A_L, G2B_L: in std_logic;
		A, B, C: in std_logic;
		Y: out std_logic_vector(7 downto 0));
end entity;
----------------------------------------------------------------------------------
architecture rts of if_74138 is
	signal enable: std_logic;
begin
	process(G1, G2A_L, G2B_L)
	begin
		if (G1 = '1' and G2A_L = '0' and G2B_L = '0') then
			enable <= '1';
		else
			enable <= '0';
		end if;
	end process;
	
	process(A, B, C, enable)
		variable in_cat: std_logic_vector(2 downto 0);
	begin
		if enable = '0' then
			Y <= (others => '1');
		else
			in_cat := C & B & A;
			if in_cat = "000" then
				Y <= (0 => '0', others => '1');
			elsif in_cat = "001" then
				Y <= (1 => '0', others => '1');
			elsif in_cat = "010" then
				Y <= (2 => '0', others => '1');
			elsif in_cat = "011" then
				Y <= (3 => '0', others => '1');
			elsif in_cat = "100" then
				Y <= (4 => '0', others => '1');
			elsif in_cat = "101" then
				Y <= (5 => '0', others => '1');
			elsif in_cat = "110" then
				Y <= (6 => '0', others => '1');
			elsif in_cat = "111" then
				Y <= (7 => '0', others => '1');
			else
				Y <= (others => '1');
			end if;
		end if;
	end process;
end architecture;
----------------------------------------------------------------------------------

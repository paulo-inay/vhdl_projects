----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
----------------------------------------------------------------------------------
entity case_74138 is
	port (
		G1, G2A_L, G2B_L: in std_logic;
		A, B, C: in std_logic;
		Y: out std_logic_vector(7 downto 0));
end entity;
----------------------------------------------------------------------------------
architecture rts of case_74138 is
	signal enable: std_logic;
begin
	process(G1, G2A_L, G2B_L)
		variable en_cat: std_logic_vector(2 downto 0);
	begin
		en_cat := G1 & G2A_L & G2B_L;
		case en_cat is
			when "100" => enable <= '1';
			when others => enable <= '0';
		end case;
	end process;
	
	process(A, B, C, enable)
		variable in_cat: std_logic_vector(3 downto 0);
	begin
		in_cat := enable & C & B & A;
		case in_cat is
			when "1000" => Y <= "11111110";
			when "1001" => Y <= "11111101";
			when "1010" => Y <= "11111011";
			when "1011" => Y <= "11110111";
			when "1100" => Y <= "11101111";
			when "1101" => Y <= "11011111";
			when "1110" => Y <= "10111111";
			when "1111" => Y <= "01111111";
			when others => Y <= "11111111";
		end case;
	end process;
end architecture;
----------------------------------------------------------------------------------

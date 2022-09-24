----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity top_74138 is
	port (
		G1, G2A_L, G2B_L: in std_logic;
		A, B, C: in std_logic;
		Y_logic, Y_if, Y_case, Y_whenelse,
			Y_withselect: out std_logic_vector(7 downto 0));
end entity;
----------------------------------------------------------------------------------
architecture rts of top_74138 is
	component logic_74138 is
		port (
			G1, G2A_L, G2B_L: in std_logic;
			A, B, C: in std_logic;
			Y: out std_logic_vector(7 downto 0));
	end component;

	component if_74138 is
		port (
			G1, G2A_L, G2B_L: in std_logic;
			A, B, C: in std_logic;
			Y: out std_logic_vector(7 downto 0));
	end component;
	
	component case_74138 is
		port (
			G1, G2A_L, G2B_L: in std_logic;
			A, B, C: in std_logic;
			Y: out std_logic_vector(7 downto 0));
	end component;
	
	component whenelse_74138 is
		port (
			G1, G2A_L, G2B_L: in std_logic;
			A, B, C: in std_logic;
			Y: out std_logic_vector(7 downto 0));
	end component;
	
	component withselect_74138 is
		port (
			G1, G2A_L, G2B_L: in std_logic;
			A, B, C: in std_logic;
			Y: out std_logic_vector(7 downto 0));
	end component;
begin

	comp_logic: logic_74138
		port map (G1 => G1, G2A_L => G2A_L, G2B_L => G2B_L,
			A => A, B => B, C => C,
			Y => Y_logic);
			
	comp_if: if_74138
		port map (G1 => G1, G2A_L => G2A_L, G2B_L => G2B_L,
			A => A, B => B, C => C,
			Y => Y_if);
			
	comp_case: case_74138
		port map (G1 => G1, G2A_L => G2A_L, G2B_L => G2B_L,
			A => A, B => B, C => C,
			Y => Y_case);
	
	comp_whenelse: whenelse_74138
		port map (G1 => G1, G2A_L => G2A_L, G2B_L => G2B_L,
			A => A, B => B, C => C,
			Y => Y_whenelse);
			
	comp_withselect: withselect_74138
		port map (G1 => G1, G2A_L => G2A_L, G2B_L => G2B_L,
			A => A, B => B, C => C,
			Y => Y_withselect);
end architecture;
----------------------------------------------------------------------------------

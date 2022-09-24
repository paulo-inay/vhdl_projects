----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity alu_74181 is
	port (
		A_L, B_L: in std_logic_vector(3 downto 0);
		S: in std_logic_vector(3 downto 0);
		M, C_ripple_in: in std_logic;
		F_L: out std_logic_vector(3 downto 0);
		A_equal_B, C_ripple_out, P_L, G_L: out std_logic
		);
end entity;
----------------------------------------------------------------------------------
architecture rts of alu_74181 is
    -- active-high values of the inputs
	signal A_H, B_H: std_logic_vector(3 downto 0);
	-- signal responsible for selecting a boolean function in both arith and logic
	--modes
	signal fun_sel: std_logic_vector(3 downto 0);
	-- receives the output F, for use in determining other outputs
    signal F_result: std_logic_vector(3 downto 0);
    -- carry signals
	signal P_internal, G_internal: std_logic_vector(3 downto 0); 
	signal C_ripple: std_logic_vector(3 downto 0);
	-- receives the output of the selected boolean function applied to A and B
	signal logic_result: std_logic_vector(3 downto 0);
	-- signed signals for arithmetic
	signal A_sig, logic_sig: signed(3 downto 0);
	signal C_sig: signed(1 downto 0);
begin
	A_H <= not A_L;
	B_H <= not B_L;
	
	-- in order to imitate the output of the 74181 component
	--the logic function selected in the case  where M = '0'
	--must be changed
	-- note that the arithmetic output of the 74181 is A + F(A,B)
	--where F is some boolean function of A and B
	fun_sel <= 	S when M = '1' else
					S(3 downto 2) & not S(1 downto 0);
	
	-- determining logic result
	with fun_sel select
		logic_result <=	not A_H 				when "0000",
								A_H nand B_H 		when "0001",
								not A_H or B_H 	when "0010",
								"1111"				when "0011",
								A_H nor B_H 		when "0100",
								not B_H				when "0101",
								A_H xnor B_H		when "0110",
								A_H and not B_H	when "0111",
								not A_H and B_H	when "1000",
								A_H xor B_H			when "1001",
								B_H					when "1010",
								A_H or B_H			when "1011",
								"0000"				when "1100",
								A_H and not B_H	when "1101",
								A_H and B_H			when "1110",
								A_H					when others;
	
	-- prepare signals for the circuit responsible for arithmetic
	A_sig <= signed(A_H);
	logic_sig <= signed(logic_result);
	C_sig <= "01" when C_ripple_in = '1' else
				"00";
	
	process(A_sig, logic_sig, logic_result, M, C_sig)
	begin
		if M = '1' then -- logic mode
			F_result <= not logic_result;
		else -- arithmetic mode
			F_result <= not std_logic_vector(A_sig + logic_sig + C_sig);
		end if;
	end process;
	F_L <= F_result;
	A_equal_B <= F_result(3) and F_result(2) 
		and F_result(1) and F_result(0);
	
	-- determining carry outputs
	P_internal <= A_H or B_H;
	G_internal <= A_H and B_H;
	
	P_L <= not (P_internal(3) and P_internal(2)
		and P_internal(1) and P_internal(0));
	G_L <= not (G_internal(3)
		or (G_internal(2) and P_internal(3))
		or (G_internal(1) and P_internal(3) and P_internal(2))
		or (G_internal(0) and P_internal(3) and P_internal(2)
			and P_internal(1)));
			
	C_ripple(0) <= C_ripple_in;
	genCarry: for i in 1 to 3 generate
		C_ripple(i) <= G_internal(i-1) or (P_internal(i-1) and C_ripple(i-1));
	end generate;
	C_ripple_out <= C_ripple(3);
	
end architecture;
----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity tb_74138 is
end entity;
----------------------------------------------------------------------------------
architecture test of tb_74138 is
	component top_74138 is
		port (
			G1, G2A_L, G2B_L: in std_logic;
			A, B, C: in std_logic;
			Y_logic, Y_if, Y_case, Y_whenelse,
                Y_withselect: out std_logic_vector(7 downto 0));
	end component;
	
	signal G1_tb, G2A_L_tb, G2B_L_tb: std_logic := '0';
	signal A_tb, B_tb, C_tb: std_logic := '0';
	signal Y_logic_tb, Y_if_tb, Y_case_tb, Y_whenelse_tb,
        Y_withselect_tb: std_logic_vector(7 downto 0) := (others => '1');
    signal expected: std_logic_vector(7 downto 0) := (others => '1');
	constant period: time := 10 ns;
	constant delta: time := 2 ns;
begin
	dut: top_74138
		port map (G1 => G1_tb, G2A_L => G2A_L_tb, G2B_L => G2B_L_tb,
			A => A_tb, B => B_tb, C => C_tb,
			Y_logic => Y_logic_tb,
			Y_if => Y_if_tb,
			Y_case => Y_case_tb,
			Y_whenelse => Y_whenelse_tb,
			Y_withselect => Y_withselect_tb);
			
	-- generating stimuli
	G1_tb <= not G1_tb after 32*period;
	G2A_L_tb <= not G2A_L_tb after 16*period;
	G2B_L_tb <= not G2B_L_tb after 8*period;
	C_tb <= not C_tb after 4*period;
	B_tb <= not B_tb after 2*period;
	A_tb <= not A_tb after period;
	
	-- generating expected values
	-- the expected value is 1 always except when G1 G2A_L G2B_L = "100",
	--this value happens after 32*period
	-- the delta is needed to take into account propagation times in modelsim
	expected <=    "11111110" after 32*period+delta,
                   "11111101" after 33*period+delta,
                   "11111011" after 34*period+delta,
                   "11110111" after 35*period+delta,
                   "11101111" after 36*period+delta,
                   "11011111" after 37*period+delta,
                   "10111111" after 38*period+delta,
                   "01111111" after 39*period+delta,
                   "11111111" after 40*period+delta;
                   
    -- checking the result
    process
    begin
        wait for delta;
        -- if now > 64*period, all the values were tested and there's nothing left to do
        if(now < 64*period) then
            assert(Y_logic_tb = expected)
                report "Mismatch of logic_74138 at t=" & time'image(now) &
                    " Y_logic = " & to_string(Y_logic_tb) &
                    " expected = " & to_string(expected)
                severity failure;
            assert(Y_if_tb = expected)
                report "Mismatch of if_74138 at t=" & time'image(now) &
                    " Y_if = " & to_string(Y_if_tb) &
                    " expected = " & to_string(expected)
                severity failure;
            assert(Y_case_tb = expected)
                report "Mismatch of case_74138 at t=" & time'image(now) &
                    " Y_case = " & to_string(Y_case_tb) &
                    " expected = " & to_string(expected)
                severity failure;
            assert(Y_whenelse_tb = expected)
                report "Mismatch of whenelse_74138 at t=" & time'image(now) &
                    " Y_whenelse = " & to_string(Y_whenelse_tb) &
                    " expected = " & to_string(expected)
                severity failure;
            assert(Y_withselect_tb = expected)
                report "Mismatch of withselect_74138 at t=" & time'image(now) &
                    " Y_withselect = " & to_string(Y_withselect_tb) &
                    " expected = " & to_string(expected)
                severity failure;
        else
            assert false
                report "No error found, t=" & time'image(now)
                severity note;
        end if;
    end process;
end architecture;
----------------------------------------------------------------------------------

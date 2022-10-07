----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
----------------------------------------------------------------------------------
entity top_74232 is
    port (
        LDCK, UNCK: in std_logic;
        RST_L, OE: in std_logic;
        D: in std_logic_vector(3 downto 0);
        FULL_L, EMPTY_L: out std_logic;
        Q: out std_logic_vector(3 downto 0)
    );
end entity;
----------------------------------------------------------------------------------
architecture rtl of top_74232 is
    function count_15(signal cnt: in integer) return integer is
        variable cnt_ret: integer;
    begin
        if(cnt < 15) then
            cnt_ret := cnt + 1;
        else
            cnt_ret := 0;
        end if;
        return cnt_ret;
    end function;

    type cell_type is array (0 to 15) of std_logic_vector(3 downto 0);
    signal cell: cell_type;
    type fifo_state is (Empty, Full, NormalOp);
    signal state_ld, state_un: fifo_state;
    signal ptr_load, ptr_unload: integer := 0;
begin

    clk_load: process(RST_L, LDCK)
    begin
        if RST_L = '0' then
            state_ld <= Empty;
            ptr_load <= 0;
        elsif(rising_edge(LDCK)) then
            case state_ld is
                when Empty =>
                    ptr_load <= count_15(ptr_load);
                    state_ld <= NormalOp;
                when NormalOp =>
                    if count_15(ptr_load) = ptr_unload then
                        state_ld <= Full;
                    else
                        ptr_load <= count_15(ptr_load);
                        state_ld <= NormalOp;
                    end if;
                when Full =>
                    state_ld <= Full;
            end case;
        end if;
    end process;
    
    clk_unload: process(RST_L, UNCK)
    begin
        if RST_L = '0' then
            ptr_unload <= 0;
        elsif(rising_edge(UNCK)) then
            case state_un is
                when Empty =>
                    state_un <= Empty;
                when NormalOp =>
                    if count_15(ptr_unload) = ptr_load then
                        state_un <= Empty;
                    else
                        ptr_unload <= count_15(ptr_unload);
                        state_un <= NormalOp;
                    end if;
                when Full =>
                    ptr_unload <= count_15(ptr_unload);
                    state_un <= NormalOp;
            end case;
        end if;
    end process;
    
    load: process(state_ld, ptr_load, D)
    begin
        case state_ld is
            when Full =>
                FULL_L <= '0';
            when others =>
                cell(ptr_load) <= D;
                FULL_L <= '1';
        end case;
    end process;
    
    unload: process(state_un, cell, ptr_unload, OE)
    begin
        if(OE = '1') then
            Q <= (others => 'Z');
        else
            Q <= cell(ptr_unload); -- memory is read in all cases
        end if;
        
        case state_un is
            when Empty =>
                EMPTY_L <= '0';
            when others =>
                EMPTY_L <= '1';
        end case;
    end process;
end architecture;
----------------------------------------------------------------------------------

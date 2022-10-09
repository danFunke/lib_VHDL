library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity funit_tb is
end funit_tb;

architecture tb of funit_tb is
    -- Declare internal components
    component funit
        port(
            x       : in STD_LOGIC_VECTOR (15 downto 0);
            y       : in STD_LOGIC_VECTOR (15 downto 0);
            fcode   : in STD_LOGIC_VECTOR (3 downto 0);
            z       : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Test signals
    signal clk_tb   : STD_LOGIC;    -- for clock
    signal x_tb     : STD_LOGIC_VECTOR (15 downto 0);
    signal y_tb     : STD_LOGIC_VECTOR (15 downto 0);
    signal z_tb     : STD_LOGIC_VECTOR (15 downto 0);
    signal fcode_tb : STD_LOGIC_VECTOR (3 downto 0);

    -- Constants
    constant period : time := 10 ns;    -- 50 MHz clock

    begin
        UUT : funit
            port map (
                x => x_tb,
                y => y_tb,
                fcode => fcode_tb,
                z => z_tb
            );
            
        -- Standard clock process
        clock : process
            begin
                clk_tb <= '0';
                wait for (period / 2);
                clk_tb <= '1';
                wait for (period / 2);
            end process;
            
        test : process
            begin
                x_tb <= X"0004";
                y_tb <= X"001F";

                -- Add y to x
                fcode_tb <= X"0";
                wait for (period * 2);

                -- Subtract y from x
                fcode_tb <= X"1";
                wait for (period * 2);

                -- Decrement x
                fcode_tb <= X"2";
                wait for (period * 2);

                -- Increment x
                fcode_tb <= X"3";
                wait for (period * 2);

                -- NOT x
                fcode_tb <= X"4";
                wait for (period * 2);

                -- x AND y
                fcode_tb <= X"5";
                wait for (period * 2);

                -- x OR y
                fcode_tb <= X"6";
                wait for (period * 2);

                -- x XOR y
                fcode_tb <= X"7";
                wait for (period * 2);

                -- Logic shift left x
                fcode_tb <= X"8";
                wait for (period * 2);

                -- Logic shift right x
                fcode_tb <= X"9";
                wait for (period * 2);

                -- Arithmetic shift right x
                fcode_tb <= X"A";
                wait for (period * 2);

                -- 2's Complement of x
                fcode_tb <= X"B";
                wait for (period * 2);

                -- x Squared
                fcode_tb <= X"C";
                wait for (period * 2);

                -- FALSE
                fcode_tb <= X"D";
                wait for (period * 2);

                -- TRUE
                fcode_tb <= X"E";
                wait for (period * 2);

                -- Pass through y
                fcode_tb <= X"F";
                wait for (period * 2);

                wait;
            end process;


end tb;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity TEMPLATE_tb is
end TEMPLATE_tb;

architecture tb of TEMPLATE_tb is
    -- Declare internal components
    component COMP_1
        generic (N : integer);
        port(
            X : in STD_LOGIC;
            Y : out STD_LOGIC;
        );
    end component;

    -- Test signals
    signal clk_tb   : STD_LOGIC;    -- for clock
    signal clr_tb   : STD_LOGIC;    -- for reset
    signal X_tb   : STD_LOGIC;      -- for COMP_1
    signal Y_tb   : STD_LOGIC;      -- for COMP_1

    -- Constants
    constant period : time := 20 ns;    -- for clock

    begin
        UUT : COMP_1
            generic map (N => 8)
            port map (
                x => X_tb,
                y => Y_tb,
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
                clr_tb <= '1';
                wait for period;
                clr_tb <= '0';
                wait;
            end process;


end tb;

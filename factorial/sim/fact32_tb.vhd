library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fact32_tb is
end fact32_tb;

architecture tb of fact32_tb is
    component fact32
        port (
            num     : in STD_LOGIC_VECTOR (3 downto 0);
            clk     : in STD_LOGIC;
            clr     : in STD_LOGIC;
            go      : in STD_LOGIC;
            fact    : out STD_LOGIC_VECTOR (31 downto 0);
            ovfl    : out STD_LOGIC
        );
    end component;

    --Internal signals
    signal num_tb   : STD_LOGIC_VECTOR (3 downto 0);
    signal clk_tb   : STD_LOGIC;
    signal clr_tb   : STD_LOGIC;
    signal go_tb    : STD_LOGIC;
    signal fact_tb  : STD_LOGIC_VECTOR (31 downto 0);
    signal ovfl_tb  : STD_LOGIC;

    -- Constants
    constant period : TIME := 10ns; -- 100MHz clock

    begin
        UUT : fact32
            port map (
                num => num_tb,
                clk => clk_tb,
                clr => clr_tb,
                go => go_tb,
                fact => fact_tb,
                ovfl => ovfl_tb
            );

        clock : process
            begin
                clk_tb <= '0';
                wait for (period / 2);
                clk_tb <= '1';
                wait for (period / 2);
        end process; -- clock

        test : process
            begin
                clr_tb <= '1';
                wait for (period);
                clr_tb <= '0';

                -- Input valid num, hit go
                num_tb <= X"6";
                go_tb <= '1';

                wait;
        end process; -- test

end tb;
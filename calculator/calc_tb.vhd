library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity calc_tb is
end calc_tb;

architecture tb of calc_tb is
    -- Declare internal components
    component calc_top
        port(
            sw      : in STD_LOGIC_VECTOR (15 downto 0);
            mclk    : in STD_LOGIC;
            btn     : in STD_LOGIC_VECTOR (1 downto 0);
            an      : out STD_LOGIC_VECTOR (7 downto 0);
            a_to_g  : out STD_LOGIC_VECTOR (6 downto 0);
            dp      : out STD_LOGIC
        );
    end component;

    -- Test signals
    signal clk_tb   : STD_LOGIC;    -- for clock
    signal clr_tb   : STD_LOGIC;    -- for reset
    signal sw_tb    : STD_LOGIC_VECTOR (15 downto 0);
    signal btn_tb   : STD_LOGIC_VECTOR (1 downto 0);
    signal an_tb    : STD_LOGIC_VECTOR (7 downto 0);
    signal ag_tb    : STD_LOGIC_VECTOR (6 downto 0);
    signal dp_tb    : STD_LOGIC;

    -- Constants
    constant period : time := 10 ns;    -- 50 MHz clock

    begin
        UUT : calc_top
            port map (
                sw      => sw_tb,
                mclk    => clk_tb,
                btn     => btn_tb,
                an      => an_tb,
                a_to_g  => ag_tb,
                dp      => dp_tb
            );
            
        -- Standard clock process
        clock : process
            begin
                clk_tb <= '0';
                wait for (period / 2);
                clk_tb <= '1';
                wait for (period / 2);
            end process;

        clock_pulse : process
            begin
                btn_tb(0) <= '1';
                wait for (period * 10);
                btn_tb(0) <= '0';
                wait for (period * 10);
            end process;
            
        test : process
            begin
                btn_tb(1) <= '1';
                sw_tb <= X"4263";
                wait for period;
                btn_tb(1) <= '0';
                wait for (period * 750000 * 2);
                sw_tb <= X"1234";
                wait;
            end process;


end tb;

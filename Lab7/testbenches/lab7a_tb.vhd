library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lab7a_tb is
end lab7a_tb;

architecture behavior of lab7a_tb is
    component lab7a_top
        port (
            mclk    : in STD_LOGIC;
            btn     : in STD_LOGIC_VECTOR (3 downto 0);
            sw      : in STD_LOGIC_VECTOR (7 downto 0);
            ld      : out STD_LOGIC_VECTOR (7 downto 0);
            an      : out STD_LOGIC_VECTOR (7 downto 0);
            a_to_g  : out STD_LOGIC_VECTOR (6 downto 0);
            dp      : out STD_LOGIC
        );
    end component;

    -- Test signals
    signal clk_tb   : STD_LOGIC;
    signal sw_tb    : STD_LOGIC_VECTOR (7 downto 0);
    signal btn_tb   : STD_LOGIC_VECTOR (3 downto 0);
    signal ld_tb    : STD_LOGIC_VECTOR (7 downto 0);
    signal an_tb    : STD_LOGIC_VECTOR (7 downto 0);
    signal AtoG_tb  : STD_LOGIC_VECTOR (6 downto 0);
    signal dp_tb    : STD_LOGIC;

    -- Constants
    constant period : time := 10ns; -- 100 MHz clock

    begin
        -- Unit Under Test
        UUT : lab7a_top
            port map(
                mclk    => clk_tb,
                btn     => btn_tb,
                sw      => sw_tb,
                ld      => ld_tb,
                an      => an_tb,
                a_to_g  => AtoG_tb,
                dp      => dp_tb
            );

        clock : process
            begin
                clk_tb <= '0';
                wait for (period / 2);
                clk_tb <= '1';
                wait for (period / 2);
        end process;

        btn0p : process
            begin
                -- Time 0 ns
                btn_tb(0) <= '0';
                wait for (period * 20);

                -- Time 200 ns
                btn_tb(0) <= '1';
                wait for (period * 10);

                -- Time 300 ns
                btn_tb(0) <= '0';
                wait for (period * 40);

                -- Time 700 ns
                btn_tb(0) <= '1';
                wait for (period * 10);

                -- Time 800 ns
                btn_tb(0) <= '0';
                wait for (period * 40);

                -- Time 1200 ns
                btn_tb(0) <= '1';
                wait for (period * 10);

                -- Time 1300 ns
                btn_tb(0) <= '0';
                wait for (period * 40);

                -- Time 1700 ns
                btn_tb(0) <= '1';
                wait for (period * 10);

                -- Time 1800 ns
                btn_tb(0) <= '0';
                wait for (period * 40);

                -- Time 2200 ns
                btn_tb(0) <= '1';
                wait for (period * 10);

                -- Time 2300 ns
                btn_tb(0) <= '0';
                wait for (period * 40);

                -- Time 2700 ns
                btn_tb(0) <= '1';
                wait for (period * 10);

                -- Time 2800 ns
                btn_tb(0) <= '0';
                wait for (period * 40);

                -- Time 3200 ns
                btn_tb(0) <= '1';
                wait for (period * 10);

                -- Time 3300 ns
                btn_tb(0) <= '0';
                wait;

        end process btn0p;

        test : process
            begin
                -- Time 0 ns
                btn_tb(3) <= '1';
                sw_tb <= X"12";
                wait for (period / 2);

                -- Time 5 ns
                btn_tb(3) <= '0';
                wait for (period / 2);

                -- Time 10 ns
                wait for (period * 49);

                -- Time 500 ns
                sw_tb <= X"34";
                wait for (period * 50);

                -- Time 1000 ns
                sw_tb <= X"56";
                wait for (period * 50);

                -- Time 1500 ns
                sw_tb <= X"78";
                wait;
        end process test;

end behavior;

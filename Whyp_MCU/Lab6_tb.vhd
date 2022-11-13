library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab6_tb is
end Lab6_tb;

architecture tb of Lab6_tb is
    component Lab6
        port (
            sw      : in STD_LOGIC_VECTOR (7 downto 0);
            btn     : in STD_LOGIC_VECTOR (3 downto 0);
            mclk    : in STD_LOGIC;
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
    signal a_to_g_tb : STD_LOGIC_VECTOR (6 downto 0);
    signal dp_tb    : STD_LOGIC;

    -- Constants
    constant period : time := 10ns;    -- 100 MHz clock

    begin
        -- Unit Under Test
        UUT : Lab6
            port map (
                sw => sw_tb,
                btn => btn_tb,
                mclk => clk_tb,
                ld => ld_tb,
                an => an_tb,
                a_to_g => a_to_g_tb,
                dp => dp_tb
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
                -- Time 0 ns
                btn_tb(3) <= '1';
                sw_tb <= X"3B";
                btn_tb(0) <= '0';
                wait for (period / 2);
                
                -- Time 5 ns
                btn_tb(3)<= '0';
                wait for (period / 2);
                
                -- Time 10 ns
                wait for (period * 19);
                
                -- Time 200 ns
                btn_tb(0) <= '1';
                wait for (period * 20);
                
                -- Time 400 ns
                btn_tb(0) <= '0';
                wait for (period * 20);
                
                -- Time 600 ns
                btn_tb(0) <= '1';
                wait for (period * 20);
                
                -- Time 800 ns
                btn_tb(0) <= '0';
                
                
                wait;
        end process;

end tb;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataStack_tb is
end DataStack_tb;

architecture behavior of DataStack_tb is
    component DataStack
        port (
            Tin     : in STD_LOGIC_VECTOR (15 downto 0);
            tload   : in STD_LOGIC;
            y1      : in STD_LOGIC_VECTOR (15 downto 0);
            nsel    : in STD_LOGIC_VECTOR (1 downto 0);
            nload   : in STD_LOGIC;
            ssel    : in STD_LOGIC;
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            dpush   : in STD_LOGIC;
            dpop    : in STD_LOGIC;
            T       : out STD_LOGIC_VECTOR (15 downto 0);
            N       : out STD_LOGIC_VECTOR (15 downto 0);
            N2      : out STD_LOGIC_VECTOR (15 downto 0);
            full    : out STD_LOGIC;
            empty   : out STD_LOGIC
        );
    end component;

    -- Test signals
    signal clk_tb   : STD_LOGIC;
    signal clr_tb   : STD_LOGIC;
    signal count    : STD_LOGIC_VECTOR (15 downto 0);

    signal tload_tb     : STD_LOGIC;
    signal y1_tb        : STD_LOGIC_VECTOR (15 downto 0);
    signal nsel         : STD_LOGIC_VECTOR (2 downto 1);
    signal nload_tb     : STD_LOGIC;
    signal ssel_tb      : STD_LOGIC;
    signal dpush_tb     : STD_LOGIC;
    signal dpop_tb      : STD_LOGIC;
    signal T_tb         : STD_LOGIC_VECTOR (15 downto 0);
    signal N_tb         : STD_LOGIC_VECTOR (15 downto 0);
    signal N2_tb        : STD_LOGIC_VECTOR (15 downto 0);
    signal full_tb      : STD_LOGIC;
    signal empty_tb     : STD_LOGIC;


    -- Constants
    constant period : time := 10ns; -- 100 MHz clock

    begin
        -- Unit Under Test
        UUT : DataStack
            port map(
                Tin     => count,
                tload   => tload_tb,
                y1      => y1_tb,
                nsel    => nsel,
                nload   => nload_tb,
                ssel    => ssel_tb,
                clr     => clr_tb,
                clk     => clk_tb,
                dpush   => dpush_tb,
                dpop    => dpop_tb,
                T       => T_tb,
                N       => N_tb,
                N2      => N2_tb,
                full    => full_tb,
                empty   => empty_tb
            );

        clock : process
            begin
                clk_tb <= '0';
                wait for (period / 2);
                clk_tb <= '1';
                wait for (period / 2);
        end process;

        counter : process (clk_tb, clr_tb)
            begin
                if (clr_tb = '1') then
                    count <= X"0000";
                elsif (clk_tb'event and clk_tb = '1') then
                    count <= count + 1;
                end if;
        end process;

        test : process
            begin
                -- Time 0 ns
                clr_tb <= '1';
                tload_tb <= '1';
                y1_tb <= X"FFFF";
                nsel <= "00";
                nload_tb <= '1';
                ssel_tb <= '0';
                dpush_tb <= '1';
                dpop_tb <= '0';
                wait for (period / 2);

                -- Time 5 ns
                clr_tb <= '0';

                wait for (period * 35);
                dpush_tb <= '0';
                dpop_tb <= '1';

                wait;
        end process;
end behavior;

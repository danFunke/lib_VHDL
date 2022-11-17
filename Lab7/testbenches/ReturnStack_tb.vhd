library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ReturnStack_tb is
end ReturnStack_tb;

architecture behavior of ReturnStack_tb is
    component ReturnStack
        port (
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            Rin     : in STD_LOGIC_VECTOR (15 downto 0);
            rsel    : in STD_LOGIC;
            rload   : in STD_LOGIC;
            rdec    : in STD_LOGIC;
            rpush   : in STD_LOGIC;
            rpop    : in STD_LOGIC;
            R       : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Test signals
    signal clk_tb   : STD_LOGIC;
    signal clr_tb   : STD_LOGIC;
    signal count    : STD_LOGIC_VECTOR (15 downto 0);

    signal rsel_tb      : STD_LOGIC;
    signal rload_tb     : STD_LOGIC;
    signal rdec_tb      : STD_LOGIC;
    signal rpush_tb     : STD_LOGIC;
    signal rpop_tb      : STD_LOGIC;
    signal Rout_tb      : STD_LOGIC_VECTOR (15 downto 0);

    -- Constants
    constant period : time := 10ns; -- 100 MHz clock

    begin
        -- Unit Under Test
        UUT : ReturnStack
            port map(
                clr     => clr_tb,
                clk     => clk_tb,
                Rin     => count,
                rsel    => rsel_tb,
                rload   => rload_tb,
                rdec    => rdec_tb,
                rpush   => rpush_tb,
                rpop    => rpop_tb,
                R       => Rout_tb
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
                rload_tb <= '1';
                rsel_tb <= '0';
                rpush_tb <= '1';
                rpop_tb <= '0';
                wait for (period / 2);

                -- Time 5 ns
                clr_tb <= '0';
                wait for (period * 35);

                -- Time 355 ns
                rpush_tb <= '0';
                rpop_tb <= '1';
                rsel_tb <= '1';

                wait;
        end process;
end behavior;

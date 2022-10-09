library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_div is
    port (
        mclk    : in STD_LOGIC;
        clr     : in STD_LOGIC;
        clk190  : out STD_LOGIC
    );
end clock_div;

architecture behavior of clock_div is
    signal q : STD_LOGIC_VECTOR (23 downto 0);

    begin
        process (mclk, clr)
            begin
                if (clr = '1') then
                    q <= X"000000";
                elsif (mclk'event and mclk = '1') then
                    q <= q + 1;
                end if;
        end process;

        clk190 <= q(17);

end behavior;
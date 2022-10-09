library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_pulse is
    port (
        inp     : in STD_LOGIC;
        cclk    : in STD_LOGIC;
        clr     : in STD_LOGIC;
        outp    : out STD_LOGIC
    );
end clock_pulse;

architecture behavior of clock_pulse is
    signal delay_1 : STD_LOGIC;
    signal delay_2 : STD_LOGIC;
    signal delay_3 : STD_LOGIC;

    begin
        process (cclk, clr)
            begin
                if (clr = '1') then
                    delay_1 <= '0';
                    delay_2 <= '0';
                    delay_3 <= '0';
                elsif cclk'event and cclk = '1' then
                    delay_1 <= inp;
                    delay_2 <= delay_1;
                    delay_3 <= delay_2;
                end if;
        end process;

        outp <= delay_1 and delay_2 and not delay_3;

end behavior;
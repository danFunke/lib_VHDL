library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    port (
        d       : in STD_LOGIC_VECTOR (15 downto 0);
        clr     : in STD_LOGIC;
        clk     : in STD_LOGIC;
        inc     : in STD_LOGIC;
        pload   : in STD_LOGIC;
        q       : out STD_LOGIC_VECTOR (15 downto 0)
    );
end PC;

architecture behavior of PC is
    -- Declare internal signals
    signal COUNT : STD_LOGIC_VECTOR (15 downto 0);

    begin
        process (clk, clr)
            begin
                if (clr = '1') then
                    COUNT <= "0000000000000000";
                elsif (clk'event) and (clk = '1') then
                    if (pload = '0') then
                        if (inc = '1') then
                            COUNT <= COUNT + 1;
                        end if;
                    else
                        count <= d;
                    end if;
                end if;
        end process;

        -- Assign output
        q <= COUNT;

end behavior;
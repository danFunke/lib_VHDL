library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DecReg is
    generic (N : integer := 8);
    port (
        d       : in STD_LOGIC_VECTOR (N-1 downto 0);
        load    : in STD_LOGIC;
        clr     : in STD_LOGIC;
        clk     : in STD_LOGIC;
        dec     : in STD_LOGIC;
        q       : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end DecReg;

architecture behavior of DecReg is
    -- Declare internal signals
    signal current_val  : STD_LOGIC_VECTOR (15 downto 0);

    begin
        process (clk, clr, load)
            begin
                if (clr = '1') then
                    current_val <= (others => '0');
                elsif (clk'event) and (clk = '1') then
                    if (load = '0') then
                        if (dec = '1') then
                            current_val <= current_val - 1;
                        end if;
                    else
                        current_val <= d;
                    end if;
                end if;
        end process;

        -- Assign output
        q <= current_val;

end behavior;
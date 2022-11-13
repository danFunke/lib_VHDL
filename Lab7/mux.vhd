library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux is
    generic (N : integer := 8);
    port (
        x   : in STD_LOGIC_VECTOR (N-1 downto 0);
        y   : in STD_LOGIC_VECTOR (N-1 downto 0);
        sel : in STD_LOGIC;
        z   : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end mux;

architecture behavior of mux is
    begin
        process (x, y, sel)
            begin
                if (sel = '0') then
                    z <= x;
                else
                    z <= y;
                end if;
            end process;
    end behavior;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multiplier is
    generic (N : integer := 8);
    port (
        x   : in STD_LOGIC_VECTOR (N - 1 downto 0);
        y   : in STD_LOGIC_VECTOR (N - 1 downto 0);
        z   : in STD_LOGIC_VECTOR ((N * 2) - 1 downto 0);
    );
end multiplier;

architecture behavior of multiplier is
    begin
        process (x, y)
            begin
                z <= x * y;
        end process;
end behavior;
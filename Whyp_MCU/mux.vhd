library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux is
    generic (N : integer := 8);
    port (
        a   : in STD_LOGIC_VECTOR (N-1 downto 0);
        b   : in STD_LOGIC_VECTOR (N-1 downto 0);
        c   : in STD_LOGIC_VECTOR (N-1 downto 0);
        d   : in STD_LOGIC_VECTOR (N-1 downto 0);
        sel : in STD_LOGIC_VECTOR (1 downto 0);
        z   : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end mux;

architecture behavior of mux is
    begin
        process (a, b, c, d, sel)
            begin
                if (sel = "00") then
                    z <= a;
                elsif (sel = "01") then
                    z <= b;
                elsif (sel = "10") then
                    z <= c;
                else
                    z <= d;
                end if;
            end process;
    end behavior;
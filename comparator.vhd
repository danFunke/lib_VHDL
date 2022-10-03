library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity comparator is
    generic(N : integer := 8);
    port(
        x   : in STD_LOGIC_VECTOR (N-1 downto 0);
        y   : in STD_LOGIC_VECTOR (N-1 downto 0);
        lt  : out STD_LOGIC;
        gt  : out STD_LOGIC;
        eq  : out STD_LOGIC
    );
end comparator;

architecture behavior of comparator is
    begin
        process (x, y)
            begin
                lt <= '0';
                gt <= '0';
                eq <= '0';
                if (x < y) then
                    lt <= '1';
                elsif (x > y) then
                    gt <= '1';
                elsif (x = y) then
                    eq <= '1';
                end if;
        end process;
    end behavior;
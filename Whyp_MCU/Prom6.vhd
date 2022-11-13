library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.opcodes.all;

entity Prom6 is
    port (
        addr    : in STD_LOGIC_VECTOR (15 downto 0);
        M       : out STD_LOGIC_VECTOR (15 downto 0)
    );
end Prom6;

architecture behavior of Prom6 is
    -- Define internal signals, types and constants
    subtype tword is std_logic_vector(15 downto 0);
    type rom_array is array (NATURAL range <>) of tword;
    constant rom: rom_array := (
        JB0HI, X"0000",	-- X"00" wait for BTN0 up
        JB0LO, X"0002",	-- X"02" wait for BTN0
        SFETCH,		    -- X"04" push switches
        digstore,		-- X"05" display
        JB0HI, X"0006",	-- X"06" wait for BTN0 up
        JB0LO, X"0008",	-- X"08" wait for BTN0
        twotimes,		-- X"0A" 2*
        DUP,			-- X"0B" DUP
        twotimes,		-- X"0C" 2*
        twotimes,		-- X"0D" 2*
        plus,			-- X"0E" +
        digstore,		-- X"0F" display
        JMP, X"0000",	-- X"10" GOTO 0
        X"0000"		    -- X"12"
    );

    begin
        process (addr)
            variable j: integer;
            begin
                j := conv_integer(addr);
                M <= rom(j);
        end process;

end behavior;

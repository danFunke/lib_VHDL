library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.opcodes.all;

entity prom7a is
    port (
        addr    : in STD_LOGIC_VECTOR (15 downto 0);
        M       : out STD_LOGIC_VECTOR (15 downto 0)
    );
end prom7a;

architecture behavior of prom7a is
    -- Define internal signals, types and constants
    type rom_array is array (NATURAL range <>)  of STD_LOGIC_VECTOR (15 downto 0);
    constant rom: rom_array := (
        JMP, 		--0
        X"0002", 		--1
        JB0HI, 		--2
        X"0002", 		--3
        JB0LO, 		--4
        X"0004", 		--5
        sfetch, 		--6
        dup, 		--7
        digstore, 		--8
        JB0HI, 		--9
        X"0009", 		--a
        JB0LO, 		--b
        X"000b", 		--c
        sfetch, 		--d
        dup, 		--e
        digstore, 		--f
        over, 		--10
        over, 		--11
        JB0HI, 		--12
        X"0012", 		--13
        JB0LO, 		--14
        X"0014", 		--15
        plus, 		--16
        dup, 		--17
        digstore, 		--18
        mrot, 		--19
        JB0HI, 		--1a
        X"001a", 		--1b
        JB0LO, 		--1c
        X"001c", 		--1d
        minus, 		--1e
        dup, 		--1f
        digstore, 		--20
        JB0HI, 		--21
        X"0021", 		--22
        JB0LO, 		--23
        X"0023", 		--24
        andd, 		--25
        digstore, 		--26
        JMP, 		--27
        X"0002", 		--28
        X"0000" 		--29
        );

    begin
        process (addr)
            variable j: integer;
            begin
                j := conv_integer(addr);
                M <= rom(j);
        end process;

end behavior;

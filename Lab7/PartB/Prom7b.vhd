library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.opcodes.all;

entity prom7b is
    port (
        addr    : in STD_LOGIC_VECTOR (15 downto 0);
        M       : out STD_LOGIC_VECTOR (15 downto 0)
    );
end prom7b;

architecture behavior of prom7b is
    -- Define internal signals, types and constants
type rom_array is array (NATURAL range <>)  of STD_LOGIC_VECTOR (15 downto 0);
constant rom: rom_array := (
	JMP, 		--0
	X"0030", 		--1
	lit, 		--2
	X"0000", 		--3
	mpp, 		--4
	mpp, 		--5
	mpp, 		--6
	mpp, 		--7
	mpp, 		--8
	mpp, 		--9
	mpp, 		--a
	mpp, 		--b
	mpp, 		--c
	mpp, 		--d
	mpp, 		--e
	mpp, 		--f
	mpp, 		--10
	mpp, 		--11
	mpp, 		--12
	mpp, 		--13
	rot_drop, 		--14
	RET, 		--15
	CALL, 		--16
	X"0002", 		--17
	drop, 		--18
	RET, 		--19
	lit, 		--1a
	X"0001", 		--1b
	lit, 		--1c
	X"0002", 		--1d
	rot, 		--1e
	over, 		--1f
	over, 		--20
	lte, 		--21
	JZ, 		--22
	X"002d", 		--23
	mrot, 		--24
	tuck, 		--25
	CALL, 		--26
	X"0016", 		--27
	swap, 		--28
	plus1, 		--29
	rot, 		--2a
	JMP, 		--2b
	X"001f", 		--2c
	drop, 		--2d
	drop, 		--2e
	RET, 		--2f
	JB0HI, 		--30
	X"0030", 		--31
	JB0LO, 		--32
	X"0032", 		--33
	sfetch, 		--34
	dup, 		--35
	digstore, 		--36
	JB0HI, 		--37
	X"0037", 		--38
	JB0LO, 		--39
	X"0039", 		--3a
	CALL, 		--3b
	X"001a", 		--3c
	digstore, 		--3d
	JMP, 		--3e
	X"0030", 		--3f
	X"0000" 		--40
	);

    begin
        process (addr)
            variable j: integer;
            begin
                j := conv_integer(addr);
                M <= rom(j);
        end process;

end behavior;

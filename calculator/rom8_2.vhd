library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rom8_2 is
    port (
        addr    : in STD_LOGIC_VECTOR (2 downto 0);
        M       : out STD_LOGIC_VECTOR (7 downto 0)
    );
end rom8_2;

architecture rom8_2 of rom8_2 is
    constant data0 : STD_LOGIC_VECTOR (7 downto 0) := "01110000";
    constant data1 : STD_LOGIC_VECTOR (7 downto 0) := "01110000";
    constant data2 : STD_LOGIC_VECTOR (7 downto 0) := "01000001";
    constant data3 : STD_LOGIC_VECTOR (7 downto 0) := "00100000";
    constant data4 : STD_LOGIC_VECTOR (7 downto 0) := "01001010";
    constant data5 : STD_LOGIC_VECTOR (7 downto 0) := "01001010";
    constant data6 : STD_LOGIC_VECTOR (7 downto 0) := "01000000";
    constant data7 : STD_LOGIC_VECTOR (7 downto 0) := "01000000";

    type rom_array is array (NATURAL range <>) of STD_LOGIC_VECTOR (7 downto 0);

    constant rom : rom_array := (
        data0, data1, data2, data3,
        data4, data5, data6, data7);

    begin
        process(addr)
            variable j: integer;
            begin
                j := conv_integer(addr);
                M <= rom(j);
        end process;
end rom8_2;
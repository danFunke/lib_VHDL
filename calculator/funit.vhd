library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity funit is
    port (
        x       : in STD_LOGIC_VECTOR (15 downto 0);
        y       : in STD_LOGIC_VECTOR (15 downto 0);
        fcode   : in STD_LOGIC_VECTOR (3 downto 0);
        z       : out STD_LOGIC_VECTOR (15 downto 0)
    );
end funit;

architecture behavior of funit is
    signal temp16 : STD_LOGIC_VECTOR (15 downto 0) := X"0001";

    begin
        process (x, y, fcode)
            variable N: integer;
            begin
                case fcode is
                    -- Add y to x
                    when X"0" =>
                        z <= x + y;
                        
                    -- Subtract y from x
                    when X"1" =>
                        z <= x - y;

                    -- Decrement x
                    when X"2" =>
                        z <= x - 1;

                    -- Increment x
                    when X"3" =>
                        z <= x + 1;

                    -- NOT x
                    when X"4" =>
                        z <= not x;

                    -- x AND y
                    when X"5" =>
                        z <= x and y;

                    -- x OR y
                    when X"6" =>
                        z <= x or y;

                    -- x XOR y
                    when X"7" =>
                        z <= x xor y;

                    -- Logic shift left x
                    when X"8" =>
                        z <= x(14 downto 0) & '0';

                    -- Logic shift right x
                    when X"9" =>
                        z <= '0' & x(15 downto 1);

                    -- Arithmetic shift right x
                    when X"A" =>
                        if (x(15) = '1') then
                            z <= '1' & x(15 downto 1);
                        else 
                            z <= '0' & x(15 downto 1);
                        end if;

                    -- 2's Complement of x
                    when X"B" =>
                        z <= NOT x + 1;

                    -- 2^x
                    when X"C" =>
                        N := conv_integer(x);
                        if (N < 16) then                          
                            z(15 downto N + 1) <= (others => '0');
                            z(N) <= '1';
                            z(N - 1 downto 0) <= (others => '0');
                        else
                            z <= X"0000";
                        end if;

                    -- FALSE
                    when X"D" =>
                        z <= X"0000";

                    -- TRUE
                    when X"E" =>
                        z <= X"FFFF";

                    -- Pass through Y
                    when X"F" =>
                        z <= y;
                        
                    when others =>
                        z <= X"0000";   
                end case;
        end process;
end behavior;
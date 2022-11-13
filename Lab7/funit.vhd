library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity funit is
    port (
        x       : in STD_LOGIC_VECTOR (15 downto 0);
        y       : in STD_LOGIC_VECTOR (15 downto 0);
        fcode   : in STD_LOGIC_VECTOR (5 downto 0);
        z       : out STD_LOGIC_VECTOR (15 downto 0)
    );
end funit;

architecture behavior of funit is
    begin
        process (x, y, fcode)
            variable N: integer;
            begin
                case fcode is
                    -- plus
                    when "010000"=>
                        z <= x + y;
                        
                    -- minus
                    when "010001" =>
                        z <= x - y;

                    -- plus1
                    when "010010" =>
                        z <= x + 1;

                    -- minus1
                    when "010011" =>
                        z <= x - 1;

                    -- invert
                    when "010100" =>
                        z <= not x;

                    -- andd
                    when "010101" =>
                        z <= x and y;

                    -- orr
                    when "010110" =>
                        z <= x or y;
                    
                    -- xorr
                    when "010111" =>
                        z <= x xor y;

                    -- twotimes
                    when "011000" =>
                        z <= x(14 downto 0) & '0';
                    
                    -- u2slash
                    when "011001" =>
                        z <= '0' & x(15 downto 1);

                    -- twoslash
                    when "011010" =>
                        z <= x(15) & x(15 downto 1);
                    
                    -- rshift
                    when "011011" =>
                        z <= '0' & x(15 downto 1);

                    -- lshift
                    when "011100" =>
                        z <= x(14 downto 0) & '0';

                    -- ones
                    when "100000" =>
                        z <= X"FFFF";

                    -- zeros
                    when "100001" =>
                        z <= X"0000";

                    -- zeroequal
                    when "100010" =>
                        if (x = X"0000") then
                            z <= X"FFFF";
                        else
                            z <= X"0000";
                        end if;

                    -- zeroless
                    when "100011" =>
                        if (x(15) = '1') then
                            z <= X"FFFF";
                        else
                            z <= X"0000";
                        end if;

                    -- ugt
                    when "100100" =>
                        if (x > y) then
                            z <= X"FFFF";
                        else
                            z <= X"0000";
                        end if;
    

                    -- ult
                    when "100101" =>
                        if (x < y) then
                            z <= X"FFFF";
                        else
                            z <= X"0000";
                        end if;

                    -- eq
                    when "100110" =>
                        if (x = y) then
                            z <= X"FFFF";
                        else
                            z <= X"0000";
                        end if;

                    -- ugte
                    when "100111" =>
                        if (x >= y) then
                            z <= X"FFFF";
                        else
                            z <= X"0000";
                        end if;


                    -- ulte
                    when "101000" =>
                        if (x <= y) then
                            z <= X"FFFF";
                        else
                            z <= X"0000";
                        end if;

                    -- neq
                    when "101001" =>
                        if (x /= y)  then
                            z <= X"FFFF";
                        else
                            z <= X"0000";
                        end if;

                    -- gt
                    when "101010" =>
                        if (x(15) = '0') and (y(15) = '1') then
                            z <= X"FFFF";
                        elsif (x(15) = '1') and (y(15) = '0') then
                            z <= X"0000";
                        elsif (x(15) = '1') and (y(15) = '1') then
                            if (x(14 downto 0) < y(14 downto 0)) then
                                z <= X"FFFF";
                            else
                                z <= X"0000";
                            end if;
                        else
                            if (x > y) then
                                z <= X"FFFF";
                            else
                                z <= X"0000";
                            end if;
                        end if;

                    -- lt
                    when "101011" =>
                        if (x(15) = '0') and (y(15) = '1') then
                            z <= X"0000";
                        elsif (x(15) = '1') and (y(15) = '0') then
                            z <= X"FFFF";
                        elsif (x(15) = '1') and (y(15) = '1') then
                            if (x(14 downto 0) < y(14 downto 0)) then
                                z <= X"0000";
                            else
                                z <= X"FFFF";
                            end if;
                        else
                            if (x < y) then
                                z <= X"FFFF";
                            else
                                z <= X"0000";
                            end if;
                        end if;

                    -- gte
                    when "101100" =>
                        if (x(15) = '0') and (y(15) = '1') then
                            z <= X"FFFF";
                        elsif (x(15) = '1') and (y(15) = '0') then
                            z <= X"0000";
                        elsif (x(15) = '1') and (y(15) = '1') then
                            if (x(14 downto 0) <= y(14 downto 0)) then
                                z <= X"FFFF";
                            else
                                z <= X"0000";
                            end if;
                        else
                            if (x >= y) then
                                z <= X"FFFF";
                            else
                                z <= X"0000";
                            end if;
                        end if;

                    -- lte
                    when "101101" =>
                        if (x(15) = '0') and (y(15) = '1') then
                            z <= X"0000";
                        elsif (x(15) = '1') and (y(15) = '0') then
                            z <= X"FFFF";
                        elsif (x(15) = '1') and (y(15) = '1') then
                            if (x(14 downto 0) >= y(14 downto 0))  then
                                z <= X"FFFF";
                            else
                                z <= X"0000";
                            end if;
                        else
                            if (x <= y) then
                                z <= X"FFFF";
                            else
                                z <= X"0000";
                            end if;
                        end if;

                    -- Default
                    when others =>
                        z <= X"0000";

                end case;
        end process;
end behavior;
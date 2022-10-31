library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity funit is
    port (
        x       : in STD_LOGIC_VECTOR (7 downto 0);
        y       : in STD_LOGIC_VECTOR (7 downto 0);
        fcode   : in STD_LOGIC_VECTOR (5 downto 0);
        z       : out STD_LOGIC_VECTOR (7 downto 0)
    );
end funit;

architecture behavior of funit is
    begin
        process (x, y, fcode)
            variable N: integer;
            begin
                case fcode is
                    -- plus
                    when X"0010" =>
                        z <= x + y;
                        
                    -- minus
                    when X"0011" =>
                        z <= x - y;

                    -- plus1
                    when X"0012" =>
                        z <= x + 1;

                    -- minus1
                    when X"0013" =>
                        z <= x - 1;

                    -- invert
                    when X"0014" =>
                        z <= not x;

                    -- andd
                    when X"0015" =>
                        z <= x and y;

                    -- orr
                    when X"0016" =>
                        z <= x or y;
                    
                    -- xorr
                    when X"0017" =>
                        z <= x xor y;

                    -- twotimes
                    when X"0018" =>
                        z <= x(6 downto 0) & '0';
                    
                    -- u2slash
                        z <= '0' & x(7 downto 1);

                    -- twoslash
                    when X"001A" =>
                        z <= x(7) & x(7 downto 1);
                    
                    -- rshift
                    when X"001B" =>
                        z <= '0' & x(7 downto 1);

                    -- lshift
                    when X"001C" =>
                        z <= x(6 downto 0) & '0';

                    -- ones
                    when X"0020" =>
                        z <= X"FF";

                    -- zeros
                    when X"0021" =>
                        z <= X"00";

                    -- zeroequal
                    when X"0022" =>
                        if (x = X"00") then
                            z <= X"FF";
                        else
                            z <= X"00";
                        end if;

                    -- zeroless
                    when X"0023" =>
                        if (x(7) == 1) then
                            z <= X"FF";
                        else
                            z <= X"00";
                        end if;

                    -- ugt
                    when X"0024" =>
                        if (x > y) then
                            z <= X"FF";
                        else
                            z <= X"00";
                        end if;
    

                    -- ult
                    when X"0025" =>
                        if (x < y) then
                            z <= X"FF";
                        else
                            z <= X"00";
                        end if;

                    -- eq
                    when X"0026" =>
                        if (x = y) then
                            z <= X"FF";
                        else
                            z <= X"00";
                        end if;

                    -- ugte
                    when X"0027" =>
                        if (x >= y) then
                            z <= X"FF";
                        else
                            z <= X"00";
                        end if;


                    -- ulte
                    when X"0028" =>
                        if (x <= y) then
                            z <= X"FF";
                        else
                            z <= X"00";
                        end if;

                    -- neq
                    when X"0029" =>
                        if (x /= y)  then
                            z <= X"FF";
                        else
                            z <= X"00";
                        end if;

                    -- gt
                    when X"002A" =>
                        if (x(7) = '0') and (y(7) = '1') then
                            z <= X"FF";
                        elsif (x(7) = '1') and (y(7) = '0') then
                            z <= X"00";
                        elsif (x(7) = '1') and (y(7) = '1') then
                            if (x(6 downto 0) < y(6 downto 0)) then
                                z <= X"FF";
                            else
                                z <= X"00";
                            end if;
                        else
                            if (x > y) then
                                z <= X"FF";
                            else
                                z <= X"00";
                            end if;
                        end if;

                    -- lt
                    when X"002B" =>
                        if (x(7) = '0') and (y(7) = '1') then
                            z <= X"00";
                        elsif (x(7) = '1') and (y(7) = '0') then
                            z <= X"FF";
                        elsif (x(7) = '1') and (y(7) = '1') then
                            if (x(6 downto 0) < y(6 downto 0)) then
                                z <= X"00";
                            else
                                z <= X"FF";
                            end if;
                        else
                            if (x < y) then
                                z <= X"FF";
                            else
                                z <= X"00";
                            end if;
                        end if;

                    -- gte
                    when X"002C" =>
                        if (x(7) = '0') and (y(7) = '1') then
                            z <= X"FF";
                        elsif (x(7) = '1') and (y(7) = '0') then
                            z <= X"00";
                        elsif (x(7) = '1') and (y(7) = '1') then
                            if (x(6 downto 0) <= y(6 downto 0)) then
                                z <= X"FF";
                            else
                                z <= X"00";
                            end if;
                        else
                            if (x >= y) then
                                z <= X"FF";
                            else
                                z <= X"00";
                            end if;
                        end if;

                    -- lte
                    when X"002D" =>
                        if (x(7) = '0') and (y(7) = '1') then
                            z <= X"00";
                        elsif (x(7) = '1') and (y(7) = '0') then
                            z <= X"FF";
                        elsif (x(7) = '1') and (y(7) = '1') then
                            if (x(6 downto 0) >= y(6 downto 0))  then
                                z <= X"FF";
                            else
                                z <= X"00";
                            end if;
                        else
                            if (x <= y) then
                                z <= X"FF";
                            else
                                z <= X"00";
                            end if;
                        end if;

                    -- Default
                    when others =>
                        z <= X"0000";

                end case;
        end process;
end behavior;
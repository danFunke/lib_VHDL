library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Funit2 is
    port (
        a       : in STD_LOGIC_VECTOR (15 downto 0);
        b       : in STD_LOGIC_VECTOR (15 downto 0);
        c       : in STD_LOGIC_VECTOR (15 downto 0);
        fcode   : in STD_LOGIC_VECTOR (5 downto 0);
        y       : out STD_LOGIC_VECTOR (15 downto 0);
        y1      : out STD_LOGIC_VECTOR (15 downto 0)
    );
end Funit2;

architecture behavior of Funit2 is
    begin
        alu16 : process (a, b, c, fcode)
            -- Declare variables
            variable true   : STD_LOGIC_VECTOR (15 downto 0);
            variable false  : STD_LOGIC_VECTOR (15 downto 0);
            variable avs    : SIGNED (15 downto 0); 
            variable bvs    : SIGNED (15 downto 0);
            variable AVector: STD_LOGIC_VECTOR (16 downto 0);
            variable BVector: STD_LOGIC_VECTOR (16 downto 0);
            variable CVector: STD_LOGIC_VECTOR (16 downto 0);
            variable yVector: STD_LOGIC_VECTOR (16 downto 0);
            variable y1_tmp : STD_LOGIC_VECTOR (15 downto 0);

            begin
                -- true is all ones; false is all zeros
                for i in 0 to 15 loop
                    true(i) := '1';
                    false(i) := '0';
                    avs(i) := a(i);
                    bvs(i) := b(i);
                end loop;

                -- Variables for mul/div
                AVector := '0' & a;
                BVector := '0' & b;
                CVector := '0' & c;
                y1_tmp  := false;
                yVector := '0' & false;
                y1      <= false;

                case fcode is
                    -- plus
                    when "010000" =>
                        y <= b + a;

                    -- minus
                    when "010001" =>
                        y <= b-a;

                    -- plus1
                    when "010010" =>
                        y <= a + 1;

                    -- minus1
                    when "010011" =>
                        y <= a - 1;

                    -- invert
                    when "010100" =>
                        y <= not a;

                    -- andd
                    when "010101" =>
                        y <= a AND b;

                    -- orr
                    when "010110" =>
                        y <= a OR b;

                    -- xorr
                    when "010111" =>
                        y <= a XOR b;

                    -- twotimes
                    when "011000" =>
                        y <= a(14 downto 0) & '0';

                    -- u2slash
                    when "011001" =>
                        y <= '0' & a(15 downto 1);

                    -- twoslash
                    when "011010" => -- 2/
                        y <= a(15) & a(15 downto 1);

                    -- rshift
                    when "011011" =>
                        y <= SHR(b,a);

                    -- lshift
                    when "011100" =>
                        y <= SHL(b,a);

                    -- mpp
                    when "011101" =>
                        if (b(0) = '1') then
                            yVector := AVector + CVector;
                        else
                            yVector := AVector;
                        end if;

                        y   <= yVector(16 downto 1);
                        y1  <= yVector(0) & b(15 downto 1);

                    -- shldc
                    when "011110" =>
                        yVector := a & b(15);
                        y1_tmp  := b(14 downto 0) & '0';

                        if (yVector > CVector) then
                            yVector     := yVector - CVector;
                            y1_tmp(0)   := '1';
                        end if;

                        y   <= yVector(15 downto 0);
                        y1  <= y1_tmp;
                    
                    -- true
                    when "100000" =>
                        y <= true;

                    -- false
                    when "100001" =>
                        y <= false;

                    -- zeroequal
                    when "100010" =>
                        if (a = false) then
                            y <= true;
                        else
                            y <= false;
                        end if;

                    -- zeroless
                    when "100011" => -- 0<
                        if (a(3) = '1') then
                            y <= true;
                        else
                            y <= false;
                        end if;
                    
                    -- ugt
                    when "100100" =>
                        if (b > a) then
                            y <= true;
                        else
                            y <= false;
                        end if;

                    -- ult
                    when "100101" =>
                        if (b < a) then
                            y <= true;
                        else
                            y <= false;
                        end if;

                    -- eq
                    when "100110" =>
                        if (b = a) then
                            y <= true;
                        else
                            y <= false;
                        end if;

                    -- ugte
                    when "100111" =>
                        if (b >= a) then
                            y <= true;
                        else
                            y <= false;
                        end if;

                    -- ulte
                    when "101000" =>
                        if (b <= a) then
                            y <= true;
                        else
                            y <= false;
                        end if;
                    
                    -- neq
                    when "101001" =>
                        if (b /= a) then
                            y <= true;
                        else
                            y <= false;
                        end if;
                    
                    -- gt
                    when "101010" =>
                        if (bvs > avs) then
                            y <= true;
                        else
                            y <= false;
                        end if;

                    -- lt
                    when "101011" =>
                        if (bvs < avs) then
                            y <= true;
                        else
                            y <= false;
                        end if;

                    -- gte
                    when "101100" =>
                        if (bvs >= avs) then
                            y <= true;
                        else
                            y <= false;
                        end if;
                    
                    -- lte
                    when "101101" =>
                        if (bvs <= avs) then
                            y <= true;
                        else
                            y <= false;
                        end if;
                    
                    -- default
                    when others =>
                        y <= false;

                end case;

        end process;

end behavior;
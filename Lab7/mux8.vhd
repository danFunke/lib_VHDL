library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity mux8 is
    generic (N : integer := 8);
    port (
        in0 : in STD_LOGIC_VECTOR (N-1 downto 0);
        in1 : in STD_LOGIC_VECTOR (N-1 downto 0);
        in2 : in STD_LOGIC_VECTOR (N-1 downto 0);
        in3 : in STD_LOGIC_VECTOR (N-1 downto 0);
        in4 : in STD_LOGIC_VECTOR (N-1 downto 0);
        in5 : in STD_LOGIC_VECTOR (N-1 downto 0);
        in6 : in STD_LOGIC_VECTOR (N-1 downto 0);
        in7 : in STD_LOGIC_VECTOR (N-1 downto 0);
        sel : in STD_LOGIC_VECTOR (2 downto 0);
        z   : out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end mux8;

architecture behavior of mux8 is
    begin
        process (in0, in1, in2, in3, in4, in5, in6, in7, sel)
            begin
                case sel is
                    when "000" =>
                        z <= in0;
                    when "001" =>
                        z <= in1;
                    when "010" =>
                        z <= in2;
                    when "011" =>
                        z <= in3;
                    when "100" =>
                        z <= in4;
                    when "101" =>
                        z <= in5;
                    when "110" =>
                        z <= in6;
                    when "111" =>
                        z <= in7;
                    when others =>
                        z <= X"0000";
                end case;
            end process;
    end behavior;
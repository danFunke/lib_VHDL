library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_bsprite is
    port (
        vidon       : in STD_LOGIC;
        hc          : in STD_LOGIC_VECTOR (9 downto 0);
        vc          : in STD_LOGIC_VECTOR (9 downto 0);
        M1          : in STD_LOGIC_VECTOR (7 downto 0);
        M2          : in STD_LOGIC_VECTOR (7 downto 0);
        sw          : in STD_LOGIC_VECTOR (7 downto 0);
        rom_addr15a : out STD_LOGIC_VECTOR (14 downto 0);
        rom_addr15b : out STD_LOGIC_VECTOR (14 downto 0);
        red         : out STD_LOGIC_VECTOR (2 downto 0);
        green       : out STD_LOGIC_VECTOR (2 downto 0);
        blue        : out STD_LOGIC_VECTOR (1 downto 0)
    );
end vga_bsprite;

architecture behavior of vga_bsprite is
    -- Define constants
    constant hbp    : STD_LOGIC_VECTOR (9 downto 0) := "0010010000";
    constant vbp    : STD_LOGIC_VECTOR (9 downto 0) := "0000011111";
    constant w      : integer := 140;
    constant h      : integer := 140;

    -- Declare signals
    signal xpix_a         : STD_LOGIC_VECTOR (9 downto 0);
    signal ypix_a         : STD_LOGIC_VECTOR (9 downto 0);
    signal xpix_b         : STD_LOGIC_VECTOR (9 downto 0);
    signal ypix_b         : STD_LOGIC_VECTOR (9 downto 0);
    signal C1           : STD_LOGIC_VECTOR (9 downto 0);
    signal C2           : STD_LOGIC_VECTOR (9 downto 0);
    signal R1           : STD_LOGIC_VECTOR (9 downto 0);
    signal R2           : STD_LOGIC_VECTOR (9 downto 0);
    signal spriteon1    : STD_LOGIC;
    signal spriteon2    : STD_LOGIC;

    begin
        -- Statically set C1 and C2 (horizontal position)
        C1 <= "0010000001";
        C2 <= "0110000001";

        -- Set R1 and R2 (vertical position) using switches
        R1 <= '0' & sw(3 downto 0) & "00001";
        R2 <= '0' & sw(7 downto 4) & "00001";
        
        -- Picture 1 coordinates
        xpix_a <= hc - hbp - C1;
        ypix_a <= vc - vbp - R1;

        -- Picture 2 coordinates
        xpix_b <= hc - hbp - C2;
        ypix_b <= vc - vbp - R2;

        -- Enable sprite video out when within the sprite region
        spriteon1 <= '1'    when (  ((hc >= C1 + hbp) and (hc < C1 + hbp + w)) and
                                    ((vc >= R1 + vbp) and (vc < R1 + vbp + h)) )
                            else '0';

        spriteon2 <= '1'    when (  ((hc >= C2 + hbp) and (hc < C2 + hbp + w)) and
                                    ((vc >= R2 + vbp) and (vc < R2 + vbp + h)) )
                            else '0';

        process (xpix_a, ypix_a)
            variable rom_addr1 : STD_LOGIC_VECTOR (16 downto 0);
            variable rom_addr2 : STD_LOGIC_VECTOR (16 downto 0);
            begin
                -- y * (128 + 8 + 4) = y *140
                rom_addr1 := (ypix_a & "0000000") + ("0000" & ypix_a & "000") + ("00000" & ypix_a & "00");
        
                -- y * 240 + x
                rom_addr2 := rom_addr1 + ("0000000" & xpix_a);

                rom_addr15a <= rom_addr2(14 downto 0);
        end process;

        process (xpix_b, ypix_b)
            variable rom_addr3 : STD_LOGIC_VECTOR (16 downto 0);
            variable rom_addr4 : STD_LOGIC_VECTOR (16 downto 0);
            begin
                -- y * (128 + 8 + 4) = y *140
                rom_addr3 := (ypix_b & "0000000") + ("0000" & ypix_b & "000") + ("00000" & ypix_b & "00");
        
                -- y * 240 + x
                rom_addr4 := rom_addr3 + ("0000000" & xpix_b);

                rom_addr15b <= rom_addr4(14 downto 0);
        end process;

        process (spriteon1, spriteon2, vidon, M1, M2)
            variable j: integer;
            begin
                red <= "000";
                green <= "000";
                blue <= "00";
                if (spriteon1 = '1' and vidon = '1') then
                    red <= M1(7 downto 5);
                    green <= M1(4 downto 2);
                    blue <= M1(1 downto 0);
                elsif (spriteon2 = '1' and vidon = '1') then
                    red <= M2(7 downto 5);
                    green <= M2(4 downto 2);
                    blue <= M2(1 downto 0);
                elsif (spriteon1 = '0' and spriteon2 = '0' and vidon = '1') then
                    -- Red
                    if (vc - vbp < 80) then
                        red <= "110";
                        green <= "000";
                        blue <= "00";

                    -- Orange
                    elsif (vc - vbp < 160) then
                        red <= "111";
                        green <= "011";
                        blue <= "00";
                    
                    -- Yellow
                    elsif (vc - vbp < 240) then
                        red <= "111";
                        green <= "111";
                        blue <= "00";

                    -- Green
                    elsif (vc - vbp < 320) then
                        red <= "000";
                        green <= "100";
                        blue <= "00";
                    
                    -- Blue
                    elsif (vc - vbp < 400) then
                        red <= "000";
                        green <= "000";
                        blue <= "11";

                    -- Purple
                    elsif (vc - vbp < 480) then
                        red <= "100";
                        green <= "000";
                        blue <= "11";
                    end if;
                end if;
        end process;
end behavior;
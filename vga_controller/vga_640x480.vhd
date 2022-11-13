library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga_640x480 is
    port (
        clk     : in STD_LOGIC;
        clr     : in STD_LOGIC;
        hsync   : out STD_LOGIC;
        vsync   : out STD_LOGIC;
        hc      : out STD_LOGIC_VECTOR (9 downto 0);
        vc      : out STD_LOGIC_VECTOR (9 downto 0);
        vidon   : out STD_LOGIC
    );
end vga_640x480;

architecture behavior of vga_640x480 is
    -- Declare constants
    constant hpixels    : STD_LOGIC_VECTOR (9 downto 0) := "1100100000"; -- Number of pixels in a horizontal line = 800
    constant vlines     : STD_LOGIC_VECTOR (9 downto 0) := "1000001001"; -- Number of horizontal lines in the display = 521
    constant hbp        : STD_LOGIC_VECTOR (9 downto 0) := "0010010000"; -- Horizontal back porch = 144 (126 + 16)
    constant hfp        : STD_LOGIC_VECTOR (9 downto 0) := "1100010000"; -- Horizontal front porch = 784 (128 + 16 + 640)
    constant vbp        : STD_LOGIC_VECTOR (9 downto 0) := "0000011111"; -- Vertical back porch = 31 (2 + 29)
    constant vfp        : STD_LOGIC_VECTOR (9 downto 0) := "0111111111"; -- Vertical front porch = 511 (2 + 29 + 480)
    
    -- Declare signals
    signal hcs      : STD_LOGIC_VECTOR (9 downto 0); -- Horizontal counter
    signal vcs      : STD_LOGIC_VECTOR (9 downto 0); -- Vertical counter
    signal vsenable : STD_LOGIC;

    begin
        hsync_counter : process (clk, clr)
            begin
                if (clr = '1') then
                    hcs <="0000000000";
                elsif (clk'event and clk = '1') then
                    if (hcs = hpixels - 1) then
                        -- Reset the counter
                        hcs <= "0000000000";

                        -- Enable the vertical counter
                        vsenable <= '1';
                    else
                        -- Increment horizontal counter
                        hcs <= hcs + 1;

                        -- Leave the vsenable off
                        vsenable <= '0';
                    end if;
                end if;
        end process;

        -- Horizontal Sync Pulse is low when hcs < 128
        hsync <= '0' when hcs < 128 else '1';

        vsync_counter : process (clk, clr)
            begin
                if (clr = '1') then
                    vcs <= "0000000000";
                elsif (clk'event and clk = '1' and vsenable = '1') then
                    if (vcs = vlines - 1) then
                        -- Reset the counter
                        vcs <= "0000000000";
                    else
                        -- Increment the counter
                        vcs <= vcs + 1;
                    end if;
                end if;
        end process;

        --Vertical Sync Pulse is low when vc is 0 or 1
        vsync <= '0' when vcs < 2 else '1';

        -- Enable video out when within the porches
         vidon <= '1' when ((hcs < hfp) and (hcs >= hbp) and 
                            (vcs < vfp) and (vcs >= vbp)
                    ) else '0';

        -- Output horizontal and vertical counters
        hc <= hcs;
        vc <= vcs;

end behavior;
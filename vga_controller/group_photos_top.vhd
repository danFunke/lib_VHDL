library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity group_photos_top is
    port (
        mclk    : in STD_LOGIC;
        btn     : in STD_LOGIC_VECTOR (3 downto 0);
        sw      : in STD_LOGIC_VECTOR (7 downto 0);
        hsync   : out STD_LOGIC;
        vsync   : out STD_LOGIC;
        red     : out STD_LOGIC_VECTOR (2 downto 0);
        green   : out STD_LOGIC_VECTOR (2 downto 0);
        blue    : out STD_LOGIC_VECTOR (1 downto 0)
    );
end group_photos_top;

architecture behavior of group_photos_top is
    -- Declare internal components
    component clock_div is
        port (
            mclk    : in STD_LOGIC;
            clr     : in STD_LOGIC;
            clk25  : out STD_LOGIC
        );
    end component;

    component vga_640x480 is
        port (
            clk     : in STD_LOGIC;
            clr     : in STD_LOGIC;
            hsync   : out STD_LOGIC;
            vsync   : out STD_LOGIC;
            hc      : out STD_LOGIC_VECTOR (9 downto 0);
            vc      : out STD_LOGIC_VECTOR (9 downto 0);
            vidon   : out STD_LOGIC
        );
    end component;

    component vga_bsprite is
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
    end component;

    component sesame_140x140 is
        port (
            addra : in STD_LOGIC_VECTOR (14 downto 0);
            clka  : in STD_LOGIC;
            douta   : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component dan_britt_140x140 is
        port (
            addra : in STD_LOGIC_VECTOR (14 downto 0);
            clka  : in STD_LOGIC;
            douta   : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Declare internal signals
    signal clr      : STD_LOGIC;
    signal clk25    : STD_LOGIC;
    signal vidon    : STD_LOGIC;
    signal hc       : STD_LOGIC_VECTOR (9 downto 0);
    signal vc       : STD_LOGIC_VECTOR (9 downto 0);
    signal M1       : STD_LOGIC_VECTOR (7 downto 0);
    signal M2       : STD_LOGIC_VECTOR (7 downto 0);
    signal rom_addr15a  : STD_LOGIC_VECTOR (14 downto 0);
    signal rom_addr15b  : STD_LOGIC_VECTOR (14 downto 0);

    begin
        clr <= btn(3);

        U1 : clock_div
            port map(
                mclk => mclk,
                clr => clr, 
                clk25 =>clk25
            );

        U2 : vga_640x480
            port map (
                clk => clk25,
                clr => clr,
                hsync => hsync,
                vsync => vsync,
                hc => hc,
                vc => vc,
                vidon => vidon
            );

        U3 : vga_bsprite
            port map (
                vidon => vidon,
                hc => hc,
                vc => vc,
                M1 => M1,
                M2 => M2,
                sw => sw,
                rom_addr15a => rom_addr15a,
                rom_addr15b => rom_addr15b,
                red => red,
                green => green,
                blue => blue
            );

        U4 : sesame_140x140
            port map (
                addra => rom_addr15a,
                clka => clk25,
                douta => M1
            );
        
        U5 : dan_britt_140x140
            port map (
                addra => rom_addr15b,
                clka => clk25,
                douta => M2
            );
end behavior;


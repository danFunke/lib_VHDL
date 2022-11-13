library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Lab6_components.all;

entity Lab6 is
    port (
        sw      : in STD_LOGIC_VECTOR (7 downto 0);
        btn     : in STD_LOGIC_VECTOR (3 downto 0);
        mclk    : in STD_LOGIC;
        ld      : out STD_LOGIC_VECTOR (7 downto 0);
        an      : out STD_LOGIC_VECTOR (7 downto 0);
        a_to_g  : out STD_LOGIC_VECTOR (6 downto 0);
        dp      : out STD_LOGIC
    );
end Lab6;

architecture behavior of Lab6 is
    -- Declare internal signals
    signal M        : STD_LOGIC_VECTOR (15 downto 0);
    signal P        : STD_LOGIC_VECTOR (15 downto 0);
    signal pload    : STD_LOGIC;
    signal pinc     : STD_LOGIC;
    signal clk25    : STD_LOGIC;
    signal clk190   : STD_LOGIC;
    signal iload    : STD_LOGIC;
    signal icode    : STD_LOGIC_VECTOR (15 downto 0);
    signal digload  : STD_LOGIC;
    signal tload    : STD_LOGIC;
    signal nload    : STD_LOGIC;
    signal btn0     : STD_LOGIC;
    signal fcode    : STD_LOGIC_VECTOR (5 downto 0);
    signal msel     : STD_LOGIC_VECTOR (1 downto 0);
    signal y        : STD_LOGIC_VECTOR (7 downto 0);
    signal N        : STD_LOGIC_VECTOR (7 downto 0);
    signal tin      : STD_LOGIC_VECTOR (7 downto 0);
    signal T        : STD_LOGIC_VECTOR (7 downto 0);
    signal xin      : STD_LOGIC_vECTOR (7 downto 0);

    begin
        -- Tie LED output to input switch state
        ld <= sw;

        -- Port map internal components
        Program_Counter : PC
            port map (
                d       => M,
                clr     => btn(3),
                clk     => clk25,
                inc     => pinc,
                pload   => pload,
                q       => P
            );
            
        Program_Memory : Prom6
            port map (
                addr    => P,
                M       => M
            );

        iReg : reg
            generic map (N => 16)
            port map (
                d       => M,
                load    => iload,
                clk     => clk25,
                clr     => btn(3),
                q       => icode
            );

        ctrl : Pcontrol
            port map (
                icode => icode,
                M       => M,
                clr     => btn(3),
                clk     => clk25,
                BTN0    => btn(0),
                fcode   => fcode,
                msel    => msel,
                pinc    => pinc,
                pload   => pload,
                tload   => tload,
                nload   => nload,
                digload => digload,
                iload   => iload
            );

        clkdiv : clock_div
            port map(
                mclk    => mclk,
                clr     => btn(3),
                clk190  => clk190,
                clk25   => clk25
            );

        mux4 : mux
            generic map (N => 8)
            port map(
                a   => N,
                b   => y,
                c   => sw(7 downto 0),
                d   => M(7 downto 0),
                sel => msel,
                z   => tin
            );

        treg : reg
            generic map (N => 8)
            port map (
                d       => tin,
                load    => tload,
                clk     => clk25,
                clr     => btn(3),
                q       => T
            );

        nreg : reg
            generic map (N => 8)
            port map (
                d       => T,
                load    => nload,
                clk     => clk25,
                clr     => btn(3),
                q       => N
            );

        digreg : reg
            generic map (N => 8)
            port map (
                d       => T,
                load    => digload,
                clk     => clk25,
                clr     => btn(3),
                q       => xin
            );
        
        funit1 : funit
            port map (
                x       => T,
                y       => N,
                fcode   => fcode,
                z       => y
            );
        
        disp : x7segb8
            port map (
                x       => X"000000" & xin,
                clk     => clk190,
                clr     => btn(3),
                a_to_g  => a_to_g,
                an      => an,
                dp      => dp
            );

end behavior;
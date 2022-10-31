library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab6 is
    port (
        sw      : in STD_LOGIC_VECTOR (7 downto 0);
        btn     : in STD_LOGIC_VECTOR (3 downto 0);
        mclk    : in STD_LOGIC;
        ld      : out STD_LOGIC_VECTOR (7 downto 0);
        an      : out STD_LOGIC_VECTOR (3 downto 0);
        a_to_g  : out STD_LOGIC_VECTOR (6 downto 0);
        dp      : out STD_LOGIC
    );
end Lab6;

architecture behavior of Lab6 is
    -- Declare internal components
    component PC is
        port (
            d       : in STD_LOGIC_VECTOR (15 downto 0);
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            inc     : in STD_LOGIC;
            pload   : in STD_LOGIC;
            q       : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    component reg is
        generic (N : integer := 8);
        port (
            d       : in STD_LOGIC_VECTOR (N-1 downto 0);
            load    : in STD_LOGIC;
            clk     : in STD_LOGIC;
            clr     : in STD_LOGIC;
            q       : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    component Prom7 is
        port (
            addr: in STD_LOGIC_VECTOR (15 downto 0);
            M: out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    component Pcontrol is
        port (
            icode   : in STD_LOGIC_VECTOR (15 downto 0);
            M       : in STD_LOGIC_VECTOR (15 downto 0);
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            BTN0    : in STD_LOGIC;
            fcode   : out STD_LOGIC_VECTOR (5 downto 0);
            msel    : out STD_LOGIC_VECTOR (1 downto 0);
            pinc    : out STD_LOGIC;
            pload   : out STD_LOGIC;
            tload   : out STD_LOGIC;
            nload   : out STD_LOGIC;
            digload : out STD_LOGIC;
            iload   : out STD_LOGIC
        );
    end component;

    component clock_div is
        port (
            mclk    : in STD_LOGIC;
            clr     : in STD_LOGIC;
            clk190  : out STD_LOGIC;
            clk25   : out STD_LOGIC
        );
    end component;
    
    component clock_pulse is
        port (
            inp     : in STD_LOGIC;
            cclk    : in STD_LOGIC;
            clr     : in STD_LOGIC;
            outp    : out STD_LOGIC
        );
    end component;

    component x7segb8 is
        port (
            x : in STD_LOGIC_VECTOR(31 downto 0);
            clk : in STD_LOGIC;
            clr : in STD_LOGIC;
            a_to_g : out STD_LOGIC_VECTOR(6 downto 0);
            an : out STD_LOGIC_VECTOR(7 downto 0);
            dp : out STD_LOGIC
        );
    end component;

    component mux is
        generic (N : integer := 8);
        port (
            a   : in STD_LOGIC_VECTOR (N-1 downto 0);
            b   : in STD_LOGIC_VECTOR (N-1 downto 0);
            c   : in STD_LOGIC_VECTOR (N-1 downto 0);
            d   : in STD_LOGIC_VECTOR (N-1 downto 0);
            sel : in STD_LOGIC_VECTOR (1 downto 0);
            z   : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    component funit is
        port (
            x       : in STD_LOGIC_VECTOR (7 downto 0);
            y       : in STD_LOGIC_VECTOR (7 downto 0);
            fcode   : in STD_LOGIC_VECTOR (5 downto 0);
            z       : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    -- Declare internal signals
    signal M        : STD_LOGIC_VECTOR (15 downto 0);
    signal P        : STD_LOGIC_VECTOR (15 downto 0):
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

        Program_Mem : Prom7
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
                BTN0    => btn0,
                fcode   => fcode,
                msel    => msel,
                pinc    => pinc,
                pload   => pload,
                tload   => tload,
                nload   => nload,
                digload => digload,
                iload   => iload
            );

        debounce : clock_pulse
            port map (
                inp     => btn(0),
                cclk    => clk190,
                clr     => btn(3),
                outp    => btn0
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
                c   => sw(7:0),
                d   => M,
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
                x       => N,
                y       => T,
                fcode   => fcode,
                z       => y
            );
        
        disp : x7seg
            port map (
                x       => X"000000" & xin,
                clk     => clk190,
                clr     => btn(3),
                a_to_g  => a_to_g,
                an      => an,
                dp      => dp
            );

end behavior;
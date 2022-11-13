library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WC16B is
    port (
        M       : in STD_LOGIC_VECTOR (15 downto 0);
        S       : in STD_LOGIC_VECTOR (7 downto 0);
        BTN0    : in STD_LOGIC;
        clr     : in STD_LOGIC;
        clk     : in STD_LOGIC;
        P       : out STD_LOGIC_VECTOR (15 downto 0);
        digload : out STD_LOGIC;
        T       : out STD_LOGIC_VECTOR (15 downto 0)
    );
end WC16B;

architecture behavior of WC16B is
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

    component mux8 is
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
    end component;

    component WC16B_control is
        port (
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            icode   : in STD_LOGIC_VECTOR (15 downto 0);
            BTN0    : in STD_LOGIC;
            T       : in STD_LOGIC_VECTOR (15 downto 0);
            M       : in STD_LOGIC_VECTOR (15 downto 0);
            fcode   : out STD_LOGIC_VECTOR (5 downto 0);        
            pinc    : out STD_LOGIC;
            pload   : out STD_LOGIC;
            tload   : out STD_LOGIC;
            nload   : out STD_LOGIC;
            digload : out STD_LOGIC;
            iload   : out STD_LOGIC;
            dpush   : out STD_LOGIC;
            dpop    : out STD_LOGIC;
            psel    : out STD_LOGIC;
            ssel    : out STD_LOGIC;
            nsel    : out STD_LOGIC_VECTOR (1 downto 0);
            tsel    : out STD_LOGIC_VECTOR (2 downto 0)
        );
    end component;

    component DataStack is
        port (
            Tin     : in STD_LOGIC_VECTOR (15 downto 0);
            tload   : in STD_LOGIC;
            y1      : in STD_LOGIC_VECTOR (15 downto 0);
            nsel    : in STD_LOGIC_VECTOR (1 downto 0);
            nload   : in STD_LOGIC;
            ssel    : in STD_LOGIC;
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            dpush   : in STD_LOGIC;
            dpop    : in STD_LOGIC;
            T       : out STD_LOGIC_VECTOR (15 downto 0);
            N       : out STD_LOGIC_VECTOR (15 downto 0);
            N2      : out STD_LOGIC_VECTOR (15 downto 0);
            full    : out STD_LOGIC;
            empty   : out STD_LOGIC
        );
    end component;

    component funit is
        port (
            x       : in STD_LOGIC_VECTOR (15 downto 0);
            y       : in STD_LOGIC_VECTOR (15 downto 0);
            fcode   : in STD_LOGIC_VECTOR (5 downto 0);
            z       : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Declare internal signals
    signal pload    : STD_LOGIC;
    signal pinc     : STD_LOGIC;
    signal irload   : STD_LOGIC;
    signal icode    : STD_LOGIC_VECTOR (15 downto 0);
    signal tsel     : STD_LOGIC_VECTOR (2 downto 0);
    signal tload    : STD_LOGIC;
    signal nload    : STD_LOGIC;
    signal nsel     : STD_LOGIC_VECTOR (1 downto 0);
    signal ssel     : STD_LOGIC;
    signal dpush    : STD_LOGIC;
    signal dpop     : STD_LOGIC;
    signal fcode    : STD_LOGIC_VECTOR (5 downto 0);
    signal y        : STD_LOGIC_VECTOR (15 downto 0);
    signal y1       : STD_LOGIC_VECTOR (15 downto 0);
    signal Ts       : STD_LOGIC_VECTOR (15 downto 0);
    signal N        : STD_LOGIC_VECTOR (15 downto 0);
    signal N2       : STD_LOGIC_VECTOR (15 downto 0);
    signal psel     : STD_LOGIC;
    signal R        : STD_LOGIC_VECTOR (15 downto 0);
    signal E1       : STD_LOGIC_VECTOR (15 downto 0);
    signal E2       : STD_LOGIC_VECTOR (15 downto 0);
    signal Tin      : STD_LOGIC_VECTOR (15 downto 0);
    signal full     : STD_LOGIC;
    signal empty    : STD_LOGIC;

    begin
        -- Port map internal components
        PCount  : PC
            port map (
                d       => M,
                clr     => clr,
                clk     => clk,
                inc     => pinc,
                pload   => pload,
                q       => P
            );

        IReg    : reg
            generic map (N => 16)
            port map(
                d       => M,
                load    => irload,
                clk     => clk,
                clr     => clr,
                q       => icode
            );

        Ctrl    : WC16B_control
            port map (
                clr     => clr,
                clk     => clk, 
                icode   => icode,
                BTN0    => BTN0,
                T       => Ts,
                M       => M,
                fcode   => fcode,      
                pinc    => pinc,
                pload   => pload,
                tload   => tload,
                nload   => nload,
                digload => digload,
                iload   => irload,
                dpush   => dpush,
                dpop    => dpop,
                psel    => psel,
                ssel    => ssel,
                nsel    => nsel,
                tsel    => tsel
            );

        Tmux    : mux8
            generic map (N => 16)
            port map (
                in0 => y,
                in1 => M,
                in2 => X"00" & S,
                in3 => R,
                in4 => E1,
                in5 => E2,
                in6 => N2,
                in7 => N,
                sel => tsel,
                z   => Tin
            );
        
        DStack  : DataStack
            port map (
                Tin     => Tin,
                tload   => tload,
                y1      => y1,
                nsel    => nsel,
                nload   => nload,
                ssel    => ssel,
                clr     => clr,
                clk     => clk,
                dpush   => dpush,
                dpop    => dpop,
                T       => Ts,
                N       => N,
                N2      => N2,
                full    => full,
                empty   => empty
            );

        Funit1  : funit
            port map (
                x       => Ts,
                y       => n,
                fcode   => fcode,
                z       => y
            );

        -- Assign output
        T <= Ts;
        
end behavior;
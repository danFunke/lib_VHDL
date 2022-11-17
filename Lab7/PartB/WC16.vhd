library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity WC16 is
    port (
        clk     : in STD_LOGIC;
        clr     : in STD_LOGIC;
        M       : in STD_LOGIC_VECTOR (15 downto 0);
        S       : in STD_LOGIC_VECTOR (7 downto 0);
        B       : in STD_LOGIC_VECTOR (3 downto 0);
        E1      : in STD_LOGIC_VECTOR (15 downto 0);
        E2      : in STD_LOGIC_VECTOR (15 downto 0);
        P       : out STD_LOGIC_VECTOR (15 downto 0);
        digload : out STD_LOGIC;
        T       : out STD_LOGIC_VECTOR (15 downto 0);
        N       : out STD_LOGIC_VECTOR (15 downto 0)
    );
end WC16;

architecture behavior of WC16 is
    -- Declare Internal Components
    component mux is
        generic (N : integer := 8);
        port (
            x   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            y   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            sel : in STD_LOGIC;
            z   : out STD_LOGIC_VECTOR (N - 1 downto 0)
        );
    end component;

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

    component WC16_control is
        port (
            -- Inputs
            clk     : in STD_LOGIC;
            clr     : in STD_LOGIC;
            icode   : in STD_LOGIC_VECTOR (15 downto 0);
            B       : in STD_LOGIC_VECTOR (3 downto 0);
            T       : in STD_LOGIC_VECTOR (15 downto 0);
            M       : in STD_LOGIC_VECTOR (15 downto 0);
            R       : in STD_LOGIC_VECTOR (15 downto 0);

            -- Outputs
            fcode   : out STD_LOGIC_VECTOR (5 downto 0);
            pinc    : out STD_LOGIC;
            tload   : out STD_LOGIC;
            nload   : out STD_LOGIC;
            pload   : out STD_LOGIC;
            iload   : out STD_LOGIC;
            digload : out STD_LOGIC;
            ldload  : out STD_LOGIC;
            dpush   : out STD_LOGIC;
            dpop    : out STD_LOGIC;
            psel    : out STD_LOGIC;
            ssel    : out STD_LOGIC;
            rload   : out STD_LOGIC;
            rpush   : out STD_LOGIC;
            rpop    : out STD_LOGIC;
            rinsel  : out STD_LOGIC;
            rsel    : out STD_LOGIC;
            rdec    : out STD_LOGIC;
            nsel    : out STD_LOGIC_VECTOR(1 downto 0);
            tsel    : out STD_LOGIC_VECTOR(2 downto 0)
        );
    end component;

    component ReturnStack is
        port (
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            Rin     : in STD_LOGIC_VECTOR (15 downto 0);
            rsel    : in STD_LOGIC;
            rload   : in STD_LOGIC;
            rdec    : in STD_LOGIC;
            rpush   : in STD_LOGIC;
            rpop    : in STD_LOGIC;
            R       : out STD_LOGIC_VECTOR (15 downto 0)
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

    component funit2 is
        port (
            a       : in STD_LOGIC_VECTOR (15 downto 0);
            b       : in STD_LOGIC_VECTOR (15 downto 0);
            c       : in STD_LOGIC_VECTOR (15 downto 0);
            fcode   : in STD_LOGIC_VECTOR (5 downto 0);
            y       : out STD_LOGIC_VECTOR (15 downto 0);
            y1      : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Declare internal signals
    signal R        : STD_LOGIC_VECTOR (15 downto 0);
    signal psel     : STD_LOGIC;
    signal Pin      : STD_LOGIC_VECTOR (15 downto 0);
    signal P1       : STD_LOGIC_VECTOR (15 downto 0);
    signal Tout       : STD_LOGIC_VECTOR (15 downto 0);
    signal rinsel   : STD_LOGIC;
    signal Rin      : STD_LOGIC_VECTOR (15 downto 0);
    signal pinc     : STD_LOGIC;
    signal pload    : STD_LOGIC;
    signal Pout     : STD_LOGIC_VECTOR (15 downto 0);
    signal iload    : STD_LOGIC;
    signal icode    : STD_LOGIC_VECTOR (15 downto 0);
    signal fcode    : STD_LOGIC_VECTOR (5 downto 0);
    signal tload    : STD_LOGIC;
    signal nload    : STD_LOGIC;
    signal nsel     : STD_LOGIC_VECTOR (1 downto 0);
    signal ssel     : STD_LOGIC;
    signal dpush    : STD_LOGIC;
    signal dpop     : STD_LOGIC;
    signal rpush    : STD_LOGIC;
    signal rpop     : STD_LOGIC;
    signal rsel     : STD_LOGIC;
    signal rdec     : STD_LOGIC;
    signal rload    : STD_LOGIC;
    signal tsel     : STD_LOGIC_VECTOR (2 downto 0);
    signal y        : STD_LOGIC_VECTOR (15 downto 0);
    signal y1       : STD_LOGIC_VECTOR (15 downto 0);
    signal Nout     : STD_LOGIC_VECTOR (15 downto 0);
    signal N2       : STD_LOGIC_VECTOR (15 downto 0);
    signal Tin      : STD_LOGIC_VECTOR (15 downto 0);

    begin
        -- Port map internal components
        Pmux    : mux
            generic map (N => 16)
            port map (
                x   => M,
                y   => R,
                sel => psel,
                z   => pin
            );
        
        PCount  : PC
            port map (
                d       => Pin,
                clr     => clr,
                clk     => clk,
                inc     => pinc,
                pload   => pload,
                q       => Pout
            );

        IR      : reg
            generic map (N => 16)    
            port map (
                d       => M,
                load    => iload,
                clk     => clk,
                clr     => clr,
                q       => icode
            );

        ctrl    : WC16_control
            port map (
                clk     => clk,
                clr     => clr,
                icode   => icode,
                B       => B,
                T       => Tout,
                M       => M,
                R       => R,
                fcode   => fcode,
                pinc    => pinc,
                tload   => tload,
                nload   => nload,
                pload   => pload,
                iload   => iload,
                digload => digload,
                ldload  => open,
                dpush   => dpush,
                dpop    => dpop,
                psel    => psel,
                ssel    => ssel,
                rload   => rload,
                rpush   => rpush,
                rpop    => rpop,
                rinsel  => rinsel,
                rsel    => rsel,
                rdec    => rdec,
                nsel    => nsel,
                tsel    => tsel
            );
        
        Rmux    : mux
            generic map (N => 16)
            port map (
                x   => P1,
                y   => Tout,
                sel => rinsel,
                z   => Rin
            );

        RStack  : ReturnStack
            port map (
                clr     => clr,
                clk     => clk,
                Rin     => Rin,
                rsel    => rsel,
                rload   => rload,
                rdec    => rdec,
                rpush   => rpush,
                rpop    => rpop,
                R       => R
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
                in7 => Nout,
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
                T       => Tout,
                N       => Nout,
                N2      => N2,
                full    => open,
                empty   => open
            );

        Alu     : Funit2
            port map (
                a       => Tout,
                b       => Nout,
                c       => N2,
                fcode   => fcode,
                y       => y,
                y1      => y1
            );
            
        -- Assign outputs
        T <= Tout;
        N <= Nout;
        P <= Pout;
        P1 <= Pout + 1;

end behavior;
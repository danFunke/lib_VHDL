library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataStack is
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
end DataStack;

architecture behavior of DataStack is
    -- Delcare internal components
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

    component mux is
        generic (N : integer := 8);
        port (
            x   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            y   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            sel : in STD_LOGIC;
            z   : out STD_LOGIC_VECTOR (N - 1 downto 0)
        );
    end component;

    component mux3 is
        generic (N : integer := 8);
        port (
            a   : in STD_LOGIC_VECTOR (N-1 downto 0);
            b   : in STD_LOGIC_VECTOR (N-1 downto 0);
            c   : in STD_LOGIC_VECTOR (N-1 downto 0);
            sel : in STD_LOGIC_VECTOR (1 downto 0);
            z   : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    component stack32x16 is
        port (
            d       : in STD_LOGIC_VECTOR (15 downto 0);
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            push    : in STD_LOGIC;
            pop     : in STD_LOGIC;
            q       : out STD_LOGIC_VECTOR (15 downto 0);
            full    : out STD_LOGIC;
            empty   : out STD_LOGIC 
        );
    end component;

    -- Declare internal signals
    signal T1   : STD_LOGIC_VECTOR (15 downto 0);
    signal Nin  : STD_LOGIC_VECTOR (15 downto 0);
    signal N1   : STD_LOGIC_VECTOR (15 downto 0);
    signal N2a  : STD_LOGIC_VECTOR (15 downto 0);
    signal d    : STD_LOGIC_VECTOR (15 downto 0);

    begin
        -- Port map internal components
        Treg : reg
            generic map (N => 16)
            port map (
                d       => Tin,
                load    => tload,
                clk     => clk,
                clr     => clr,
                q       => T1
            );

        Nmux : mux3
            generic map (N => 16)
            port map (
                a   => T1,
                b   => N2a,
                c   => y1,
                sel => nsel,
                z   => Nin
            );

        Nreg : reg
            generic map (N => 16)
            port map (
                d       => Nin,
                load    => nload,
                clk     => clk,
                clr     => clr,
                q       => N1
            );

        Smux : mux
            generic map (N => 16)
            port map (
                x   => N1,
                y   => T1,
                sel => ssel,
                z   => d
            );

        stack : stack32x16
            port map (
                d       => d,
                clr     => clr,
                clk     => clk,
                push    => dpush,
                pop     => dpop,
                q       => N2a,
                full    => full,
                empty   => empty
            );

        -- Assign outputs
        T <= T1;
        N <= N1;
        N2 <= N2a;

end behavior;
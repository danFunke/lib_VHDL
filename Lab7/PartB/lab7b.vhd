library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lab7b is
    port (
        mclk    : in STD_LOGIC;
        btn     : in STD_LOGIC_VECTOR (3 downto 0);
        sw      : in STD_LOGIC_VECTOR (7 downto 0);
        ld      : out STD_LOGIC_VECTOR (7 downto 0);
        an      : out STD_LOGIC_VECTOR (7 downto 0);
        a_to_g  : out STD_LOGIC_VECTOR (6 downto 0);
        dp      : out STD_LOGIC  
    );
end lab7b;

architecture behavior of lab7b is
    -- Declare internal components
    component Prom7b is
        port (
            addr: in STD_LOGIC_VECTOR (15 downto 0);
            M: out STD_LOGIC_VECTOR (15 downto 0)
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

    component WC16 is
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
    end component;

    -- Declare internal signals
    signal M        : STD_LOGIC_VECTOR (15 downto 0);
    signal P        : STD_LOGIC_VECTOR (15 downto 0);
    signal btn20    : STD_LOGIC_VECTOR (3 downto 0);
    signal btn0     : STD_LOGIC;
    signal clk190   : STD_LOGIC;
    signal clk25    : STD_LOGIC;
    signal digload  : STD_LOGIC;
    signal T        : STD_LOGIC_VECTOR (15 downto 0);
    signal xin      : STD_LOGIC_VECTOR (15 downto 0);
    signal E1       : STD_LOGIC_VECTOR (15 downto 0);
    signal E2       : STD_LOGIC_VECTOR (15 downto 0);
    

    begin
        -- Tie LED output to input switch state
        ld <= sw;
        
        -- Assign default values to E1 and E2
        E1 <= X"0000";
        E2 <= X"0000";

        -- Port map internal components
        Prom    : Prom7b
            port map (
                addr    => P,
                M       => M
            );
        
        Core    : WC16
            port map (
                clk     => mclk,
                clr     => btn(3),
                M       => M, 
                S       => sw,
                B       => btn,
                E1      => E1,
                E2      => E2,
                P       => P,
                digload => digload,
                T       => T,
                N       => open
            );

        CDiv    : clock_div
            port map (
                mclk    => mclk,
                clr     => btn(3),
                clk190  => clk190,
                clk25   => clk25
            );
        
        CPulse  : clock_pulse
            port map (
                inp     => btn(0),
                cclk    => mclk,
                clr     => btn(3),
                outp    => btn0
            );
        
        DigReg  : reg
            generic map (N => 16)
            port map (
                d       => T,
                load    => digload,
                clk     => mclk,
                clr     => btn(3),
                q       => xin
            );

        Disp    : x7segb8
            port map(
                x       => X"0000" & xin,
                clk     => mclk,
                clr     => btn(3),
                a_to_g  => a_to_g,
                an      => an,
                dp      => dp
            );



end behavior;
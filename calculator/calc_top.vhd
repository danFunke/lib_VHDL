library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity calc_top is
    port (
        sw      : in STD_LOGIC_VECTOR (15 downto 0);
        mclk    : in STD_LOGIC;
        btn     : in STD_LOGIC_VECTOR (1 downto 0);
        an      : out STD_LOGIC_VECTOR (7 downto 0);
        a_to_g  : out STD_LOGIC_VECTOR (6 downto 0);
        dp      : out STD_LOGIC
    );
end calc_top;

architecture behavior of calc_top is
    -- Declare internal components
    component mux is
        generic (N : integer := 8);
        port (
            x   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            y   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            sel : in STD_LOGIC;
            z   : out STD_LOGIC_VECTOR (N - 1 downto 0)
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

    component funit is
        port (
            x       : in STD_LOGIC_VECTOR (15 downto 0);
            y       : in STD_LOGIC_VECTOR (15 downto 0);
            fcode   : in STD_LOGIC_VECTOR (3 downto 0);
            z       : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    component counter is
        generic (N : integer := 8);
        port (
            clr : in STD_LOGIC;
            clk : in STD_LOGIC;
            q   : out STD_LOGIC_VECTOR(N - 1 downto 0)
        );
    end component;

    component rom8 is
        port (
            addr    : in STD_LOGIC_VECTOR (2 downto 0);
            M       : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;

    component clock_div is
        port (
            mclk    : in STD_LOGIC;
            clr     : in STD_LOGIC;
            clk190  : out STD_LOGIC
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

    -- Declare internal signals
    signal addr : STD_LOGIC_VECTOR (2 downto 0);
    signal clkp : STD_LOGIC;
    signal tin  : STD_LOGIC_VECTOR (15 downto 0);
    signal M    : STD_LOGIC_VECTOR (7 downto 0);
    signal clk190   : STD_LOGIC;
    signal t        : STD_LOGIC_VECTOR (15 downto 0);
    signal n        : STD_LOGIC_VECTOR (15 downto 0);
    signal zl       : STD_LOGIC_VECTOR (15 downto 0);
    
    begin
        -- Port Map internal components
        Imux : mux
            generic map (N => 16)
            port map (
                x => zl(15 downto 0),
                y => sw(15 downto 0),
                sel => M(4),
                z => tin(15 downto 0)
            );

        Treg : reg
            generic map (N => 16)
            port map (
                d       => tin(15 downto 0),
                load    => M(6),
                clk     => clkp,
                clr     => btn(1),
                q       => t(15 downto 0)
            );

        Nreg : reg
            generic map (N => 16)
            port map (
                d       => t(15 downto 0),
                load    => M(5),
                clk     => clkp,
                clr     => btn(1),
                q       => n(15 downto 0)
            );

        alu : funit
            port map (
                x       => t(15 downto 0),
                y       => n(15 downto 0),
                fcode   => M(3 downto 0),
                z       => zl(15 downto 0)
            );

        pc : counter
            generic map (N => 3)
            port map (
                clr => btn(1),
                clk => clkp,
                q   => addr
            );

        pm : rom8
            port map (
                addr    => addr,
                M       => M
            );
        
        clkdiv : clock_div
            port map (
                mclk    => mclk,
                clr     => btn(1),
                clk190  => clk190
            );

        clkpls  : clock_pulse
            port map (
                inp => btn(0),
                cclk    => clk190,
                clr     => btn(1),
                outp    => clkp
            );

        display : x7segb8
            port map(
                x       => X"0000" & t,
                clk     => mclk,
                clr     => btn(1),
                a_to_g  => a_to_g,
                an      => an,
                dp      => dp
            );

end behavior;
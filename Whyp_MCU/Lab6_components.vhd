library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package Lab6_components is
    
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
        generic (N : integer := 16);
        port (
            d       : in STD_LOGIC_VECTOR (N-1 downto 0);
            load    : in STD_LOGIC;
            clk     : in STD_LOGIC;
            clr     : in STD_LOGIC;
            q       : out STD_LOGIC_VECTOR (N-1 downto 0)
        );
    end component;

    component Prom6 is
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
        generic (N : integer := 16);
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
            x       : in STD_LOGIC_VECTOR (15 downto 0);
            y       : in STD_LOGIC_VECTOR (15 downto 0);
            fcode   : in STD_LOGIC_VECTOR (5 downto 0);
            z       : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;
    
end package;
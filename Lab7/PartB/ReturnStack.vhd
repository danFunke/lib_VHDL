library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ReturnStack is
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
end ReturnStack;

architecture behavior of ReturnStack is
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

    component DecReg is
        generic (N : integer := 8);
        port (
            d       : in STD_LOGIC_VECTOR (N-1 downto 0);
            load    : in STD_LOGIC;
            clr     : in STD_LOGIC;
            clk     : in STD_LOGIC;
            dec     : in STD_LOGIC;
            q       : out STD_LOGIC_VECTOR (N-1 downto 0)
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
    signal R1       : STD_LOGIC_VECTOR (15 downto 0);
    signal r_in     : STD_LOGIC_VECTOR (15 downto 0);
    signal Rs       : STD_LOGIC_VECTOR (15 downto 0);

    begin
        -- Port map internal components
        Rmux    : mux
            generic map (N => 16)
            port map (
                x   => Rin,
                y   => R1,
                sel => rsel,
                z   => r_in
            );

        Rreg    : DecReg
            generic map (N => 16)
            port map (
                d       => r_in,
                load    => rload,
                clk     => clk,
                clr     => clr,
                dec     => rdec,
                q       => Rs
            );

        Rstack  : stack32x16
            port map (
                d       => Rs,
                clr     => clr,
                clk     => clk,
                push    => rpush,
                pop     => rpop,
                full    => open,
                empty   => open,
                q       => R1
            );

        -- Assign output
        R <= Rs;

end behavior;
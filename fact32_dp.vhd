library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fact32_dp is
    port (
        num         : in STD_LOGIC_VECTOR (3 downto 0);
        clk         : in STD_LOGIC;
        clr         : in STD_LOGIC;
        multSel     : in STD_LOGIC;
        multLd      : in STD_LOGIC;
        outputSel   : in STD_LOGIC;
        outputLd    : in STD_LOGIC;
        numEqZero   : out STD_LOGIC;
        oflow       : out STD_LOGIC;
        cntLtNum    : out STD_LOGIC;
        cntGtZero   : out STD_LOGIC;
        fact        : out STD_LOGIC_VECTOR (31 downto 0)
    );
end fact32_dp;

architecture behavior of fact32_dp is
    -- Declare internal components
    component comparator
        generic (N : integer := 8);
        port (
            x   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            y   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            lt  : out STD_LOGIC;
            gt  : out STD_LOGIC;
            eq  : out STD_LOGIC
        );
    end component;

    component multiplexer
        generic (N : integer := 8);
        port (
            x   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            y   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            sel : in STD_LOGIC;
            z   : out STD_LOGIC_VECTOR (N - 1 downto 0)
        );
    end component;

    component reg
        generic (N : integer := 8);
        port (
            d       : in STD_LOGIC_VECTOR (N - 1 downto 0);
            load    : in STD_LOGIC;
            clk     : in STD_LOGIC;
            clr     : in STD_LOGIC;
            q       : out STD_LOGIC_VECTOR (N - 1 downto 0);
        );
    end component;

    component counter
        generic (N : integer := 8);
        port (
            clr : in STD_LOGIC;
            clk : in STD_LOGIC;
            q   : out STD_LOGIC_VECTOR (N - 1 downto 0)
        );
    end component;

    component multiplier
        generic (N : integer := 8);
        port (
            x : in STD_LOGIC_VECTOR (N - 1 downto 0);
            y : in STD_LOGIC_VECTOR (N - 1 downto 0);
            z : in STD_LOGIC_VECTOR ((N * 2) - 1 downto 0)
        );
    end component;

    -- Define internal signals
    signal cnt      : STD_LOGIC_VECTOR (3 downto 0);
    signal tempMult : STD_LOGIC_VECTOR (31 downto 0);
    signal mult     : STD_LOGIC_VECTOR (31 downto 0);
    signal tempFact : STD_LOGIC_VECTOR (63 downto 0);
    signal tempOutput   : STD_LOGIC_VECTOR (31 downto 0);

    -- Define contants
    constant zero_4b : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    constant twlv_4b : STD_LOGIC_VECTOR (3 downto 0) := X"C";
    constant one_32b : STD_LOGIC_VECTOR (31 downto 0) := X"00000001";

    begin
        oflowComp : comparator
            generic map (N => 4)
            port map (
                x   => num,
                y   => twlv_4b,
                gt  => oflow
            );
        
        numEqZeroComp : comparator
            generic map (N => 4)
            port map (
                x   => num,
                y   => zero_4b,
                eq  => numEqZero
            );
        
        cntLtNumComp : comparator
            generic map (N => 4)
            port map (
                x   => cnt,
                y   => num,
                lt  => cntLtNum
            );

        cntGtZero : comparator
            generic map (N => 4)
            port map (
                x   => cnt,
                y   => zero_4b,
                gt  => cntGtZero
            );

        counter : counter
            generic map (N => 4)
            port map (
                clr => clr,
                clk => clk,
                q   => cnt 
            );

        multMux : multiplexer
            generic map (N => 32)
            port map (
                x => one_32b,
                y => tempFact(31 downto 0),
                s => multSel,
                z => tempMult
            );

        outputMux : multiplexer
            generic map (N => 32)
            port map (
                x => one_32b,
                y => tempFact(31 downto 0),
                s => outputSel,
                z => tempOutput
            );
        
        multReg : reg
            generic map (N => 32)
            port map (
                d    => tempMult,
                load => multLd,
                clk  => clk,
                clr  => clr,
                q    => mult
            );

        outputReg : reg
            generic map (N => 32)
            port map (
                d    => tempOutput,
                load => outputLd,
                clk  => clk,
                clr  => clr,
                q    => fact
            );

        multiply : multiplier
            generic map (N => 32)
            port map (
                x => mult,
                y => X"0000000" & cnt,
                z => tempFact
            );     

end behavior;
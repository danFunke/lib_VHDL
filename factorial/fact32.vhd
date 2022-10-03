library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fact32 is
    port (
        num     : in STD_LOGIC_VECTOR (3 downto 0);
        clk     : in STD_LOGIC;
        clr     : in STD_LOGIC;
        go      : in STD_LOGIC;
        fact    : out STD_LOGIC_VECTOR (31 downto 0);
        ovfl    : out STD_LOGIC
    );
end fact32;

architecture behavior of fact32 is
    component fact32_dp
        port (
            num         : in STD_LOGIC_VECTOR (3 downto 0);
            clk         : in STD_LOGIC;
            clr         : in STD_LOGIC;
            multSel     : in STD_LOGIC;
            multLd      : in STD_LOGIC;
            outputSel   : in STD_LOGIC;
            outputLd    : in STD_LOGIC;
            hold        : in STD_LOGIC;
            numEqZero   : out STD_LOGIC;
            oflow       : out STD_LOGIC;
            cntLtNum    : out STD_LOGIC;
            cntGtOne    : out STD_LOGIC;
            fact        : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    component fact32_ctrl
        port (
            go          : in STD_LOGIC;
            clk         : in STD_LOGIC;
            clr         : in STD_LOGIC;
            numEqZero   : in STD_LOGIC;
            oflow       : in STD_LOGIC;
            cntLtNum    : in STD_LOGIC;
            cntGtOne    : in STD_LOGIC;
            multSel     : out STD_LOGIC;
            multLd      : out STD_LOGIC;
            outputSel   : out STD_LOGIC;
            outputLd    : out STD_LOGIC;
            hold        : out STD_LOGIC
        );
    end component;

    -- Internal signals
    signal multSel : STD_LOGIC;
    signal multLd : STD_LOGIC;
    signal outputSel : STD_LOGIC;
    signal outputLd : STD_LOGIC;
    signal numEqZero : STD_LOGIC;
    signal oflow : STD_LOGIC;
    signal cntLtNum : STD_LOGIC;
    signal cntGtOne : STD_LOGIC;
    signal hold     : STD_LOGIC;

    begin
        datapath : fact32_dp
            port map(
                num         => num,
                clk         => clk,
                clr         => clr,
                multSel     => multSel,
                multLd      => multLd,
                outputSel   => outputSel,
                outputLd    => outputLd,
                hold        => hold,
                numEqZero   => numEqZero,
                oflow       => oflow,
                cntLtNum    => cntLtNum,
                cntGtOne    => cntGtOne,
                fact        => fact
            );

        controller : fact32_ctrl
            port map(
                go          => go,
                clk         => clk,
                clr         => clr,
                numEqZero   => numEqZero,
                oflow       => oflow,
                cntLtNum    => cntLtNum,
                cntGtOne    => cntGtOne,
                multSel     => multSel,
                multLd      => multLd,
                outputSel   => outputSel,
                outputLd    => outputLd,
                hold        => hold
            );

        process (oflow)
            begin
                ovfl <= oflow;
        end process;
            

end behavior;
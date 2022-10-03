--Lab 3; Part 1.1
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fact32_dp_tb is
end fact32_dp_tb;

architecture tb of fact32_dp_tb is
    component fact32_dp
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
            cntGtOne    : out STD_LOGIC;
            fact        : out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;

    -- Internal test signals
    signal num_tb       : STD_LOGIC_VECTOR (3 downto 0);
    signal clk_tb       : STD_LOGIC;
    signal clr_tb       : STD_LOGIC;
    signal multSel_tb   : STD_LOGIC;
    signal multLd_tb    : STD_LOGIC;
    signal outputSel_tb : STD_LOGIC;
    signal outputLd_tb  : STD_LOGIC;

    -- Define constants
    constant period : TIME := 10ns; -- 100 MHz clock

    begin
        UUT : fact32_dp
            port map (
                num => num_tb,
                clk => clk_tb,
                clr => clr_tb,
                multSel => multSel_tb,
                multLd => multLd_tb,
                outputSel => outputSel_tb,
                outputLd => outputLd_tb
            );

        clock : process
            begin
                clk_tb <= '0';
                wait for (period / 2);
                clk_tb <= '1';
                wait for (period / 2);
        end process;

        test : process
            begin
                -- OUT: numEqZero = 1, oflow = 0, cntLtNum = 0, cntGtOne = 0/1, fact = 1
                -- IN : multSel = X, multLd = X, outputSel = 1, outputLd = 1
                num_tb <= X"0";
                clr_tb <= '1';
                wait for (period);
                outputSel_tb <= '0';
                outputLd_tb <= '1';
                clr_tb <= '0';
                wait for (period * 4);

                -- numEqZero = 0, oflow = 0, cntLtNum = 0/1, cntGtOne = 0/1
                num_tb <= X"1";
                clr_tb <= '1';
                wait for (period);
                clr_tb <= '0';
                wait for (period * 4);
                
                -- numEqZero = 0, oflow = 1, cntLtNum = 1, cntGtOne = 0/1
                num_tb <= X"D";
                clr_tb <= '1';
                wait for (period); 
                clr_tb <= '0';
                wait for (period * 4);
                
                -- numEqZero = 0, oflow = 0, cntLtNum = 0, cntGtOne = 0/1
                num_tb <= X"C";
                clr_tb <= '1';
                wait for (period);
                clr_tb <= '0';
                wait for (period * 4);
                

                
                wait;
            end process;

end tb;
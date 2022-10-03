library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fact32_ctrl is
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
end fact32_ctrl;

architecture behavior of fact32_ctrl is
    type state_type is (s0, s1, s2, s3, s4, s5);
    signal state : state_type;

    begin
        process (go, clk, clr, numEqZero, oflow, cntLtNum, cntGtOne)
            begin

                if clr = '1' then
                    state       <= s0;
                    multSel     <= '0';
                    multLd      <= '0';
                    outputSel   <= '0';
                    outputLd    <= '0';
                    hold        <= '1';
                elsif clk'event and clk = '1' then
                    case state is
                        -- State 0 / Start
                        when s0 =>
                            if go = '1' then
                                state <= s1;
                            else
                                state <= s0;
                            end if;

                        -- State 1
                        when s1 =>
                            if oflow = '1' then
                                state <= s1;
                            else
                                state <= s2;
                                hold <= '0';
                            end if;

                        -- State 2
                        when s2 =>
                            multSel <= '0';
                            multLd <= '1';
                            if (cntGtOne = '1') and (numEqZero = '0') then
                                state <= s3;
                            elsif (numEqZero = '1') then
                                state <= s4;
                            end if;

                        -- State 3
                        when s3 =>
                            if (cntLtNum = '1') then
                                multSel     <= '1';
                                multLd      <= '1';
                                outputSel   <= '1';
                                outputLd    <= '1';
                            else
                                state <= s4;
                            end if;

                        -- State 4
                        when s4 =>
                            outputSel   <= '0';
                            outputLd    <= '1';
                            state       <= s5;
                        
                        -- State 5 / Stop
                        when s5 =>
                            multSel     <= '0';
                            multLd      <= '0';
                            outputSel   <= '0';
                            outputLd    <= '0';
                            hold        <= '1';

                        -- Default case
                        when others =>
                            state <= s0;
                    end case;

                end if;

        end process;
end behavior;
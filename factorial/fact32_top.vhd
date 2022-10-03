-- Lab 3; Part 2
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fact32_top is
    port (
        sw      : in STD_LOGIC_VECTOR (3 downto 0);
        btn     : in STD_LOGIC_VECTOR (3 downto 2);
        mclk    : in STD_LOGIC;
        a_to_g  : out STD_LOGIC_VECTOR (6 downto 0);
        an      : out STD_LOGIC_VECTOR (7 downto 0);
        dp      : out STD_LOGIC;
        ld      : out STD_LOGIC_VECTOR (3 downto 0)
    );
end fact32_top;

architecture behavior of fact32_top is
    component fact32
        port (
            num     : in STD_LOGIC_VECTOR (3 downto 0);
            clk     : in STD_LOGIC;
            clr     : in STD_LOGIC;
            go      : in STD_LOGIC;
            fact    : out STD_LOGIC_VECTOR (31 downto 0);
            ovfl    : out STD_LOGIC
        );
    end component;

    component x7segb8
        port (
            x       : in STD_LOGIC_VECTOR (31 downto 0);
            clk     : in STD_LOGIC;
            clr     : in STD_LOGIC;
            a_to_g  : out STD_LOGIC_VECTOR (6 downto 0);
            an      : out STD_LOGIC_VECTOR (7 downto 0);
            dp      : out STD_LOGIC
        );
    end component;

    signal fact : STD_LOGIC_VECTOR (31 downto 0);

    begin
        factorial : fact32
            port map (
                num => sw(3 downto 0),
                clk => mclk,
                clr => btn(3),
                go  => btn(2),
                fact => fact,
                ovfl => ld(0)
            );

        ssd : x7segb8
            port map (
                x => fact,
                clk => mclk,
                clr => btn(3),
                a_to_g => a_to_g,
                an => an,
                dp => dp
            );

end behavior;
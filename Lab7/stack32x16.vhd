library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity stack32x16 is
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
end stack32x16;

architecture behavior of stack32x16 is 
    -- Declare internal components
    component stack_ctrl is
        port (         
        clr     : in STD_LOGIC;
        clk     : in STD_LOGIC;
        push    : in STD_LOGIC;
        pop     : in STD_LOGIC;
        we      : out STD_LOGIC;
        amsel   : out STD_LOGIC;    
        wr_addr : out STD_LOGIC_VECTOR(4 downto 0); 
        rd_addr : out STD_LOGIC_VECTOR(4 downto 0);
        full    : out STD_LOGIC;
        empty   : out STD_LOGIC
    );
    end component;

    component mux is
        generic (N : integer := 5);
        port (
            x   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            y   : in STD_LOGIC_VECTOR (N - 1 downto 0);
            sel : in STD_LOGIC;
            z   : out STD_LOGIC_VECTOR (N - 1 downto 0)
        );
    end component;

    component dpram32x16 is
        port (
            a       : in STD_LOGIC_VECTOR (4 downto 0);
            d       : in STD_LOGIC_VECTOR (15 downto 0);
            dpra    : in STD_LOGIC_VECTOR (4 downto 0);
            clk     : in STD_LOGIC;
            we      : in STD_LOGIC;
            spo     : out STD_LOGIC_VECTOR (15 downto 0);
            dpo     : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

    -- Declare internal signals
    signal we : STD_LOGIC;
    signal amsel    : STD_LOGIC;
    signal wr_addr  : STD_LOGIC_VECTOR (4 downto 0);
    signal rd_addr  : STD_LOGIC_VECTOR (4 downto 0);
    signal wr2_addr : STD_LOGIC_VECTOR (4 downto 0);

    begin
        -- Port map internal components
        stack_ctrl32 : stack_ctrl
            port map (
                clr     => clr,
                clk     => clk,
                push    => push,
                pop     => pop,
                we      => we,
                amsel   => amsel,
                wr_addr => wr_addr,
                rd_addr => rd_addr,
                full    => full,
                empty   => empty
            );

        adSel : mux
            generic map (N => 5)
            port map (
                x   => wr_addr,
                y   => rd_addr,
                sel => amsel,
                z   => wr2_addr
            );

        ram : dpram32x16
            port map (
                a       => wr2_addr,
                d       => d,
                dpra    => rd_addr,
                clk     => clk,
                we      => we,
                spo     => open,
                dpo     => q
            );

end behavior;
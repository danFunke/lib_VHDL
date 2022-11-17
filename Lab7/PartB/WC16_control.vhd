library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use WORK.OPCODES.ALL;

entity WC16_control is
    port (
        -- Inputs
        clk     : in STD_LOGIC;
        clr     : in STD_LOGIC;
        icode   : in STD_LOGIC_VECTOR (15 downto 0);
        B       : in STD_LOGIC_VECTOR (3 downto 0);
        T       : in STD_LOGIC_VECTOR (15 downto 0);
        M       : in STD_LOGIC_VECTOR (15 downto 0);
        R       : in STD_LOGIC_VECTOR (15 downto 0);

        -- Outputs
        fcode   : out STD_LOGIC_VECTOR (5 downto 0);
        pinc    : out STD_LOGIC;
        tload   : out STD_LOGIC;
        nload   : out STD_LOGIC;
        pload   : out STD_LOGIC;
        iload   : out STD_LOGIC;
        digload : out STD_LOGIC;
        ldload  : out STD_LOGIC;
        dpush   : out STD_LOGIC;
        dpop    : out STD_LOGIC;
        psel    : out STD_LOGIC;
        ssel    : out STD_LOGIC;
        rload   : out STD_LOGIC;
        rpush   : out STD_LOGIC;
        rpop    : out STD_LOGIC;
        rinsel  : out STD_LOGIC;
        rsel    : out STD_LOGIC;
        rdec    : out STD_LOGIC;
        nsel    : out STD_LOGIC_VECTOR(1 downto 0);
        tsel    : out STD_LOGIC_VECTOR(2 downto 0)
    );
end WC16_control;

architecture behavior of WC16_control is
    -- Define internal types and signals
    type state_type is (fetch, exec, exec_fetch);
    signal current_state    : state_type; 
    signal next_state       : state_type;

    begin
        synch : process (clk, clr)
            begin
                if (clr = '1') then
                    current_state <= fetch;
                elsif ((clk'event) and (clk = '1')) then
                    current_state <= next_state;
                end if;
        end process synch;

        C1: process(current_state, M, icode)
            begin 
                case current_state is
                    -- Fetch instruction   
                    when fetch =>				
                        if (M(8) = '1') then  		
                            next_state <= exec;		  	
                        else					
                            next_state <= exec_fetch;	 	
                        end if;

                    -- Execute instruction and fetch the next one
                    when exec_fetch =>			
                        if (M(8) = '1') then  		
                            next_state <= exec;		  	
                        else					
                            next_state <= exec_fetch;		
                        end if;

                    -- Execute instruction without fetching a new one
                    when exec =>				
                        next_state <= fetch;

                end case;
        end process C1;

        C2: process(icode, current_state, T, R, B)
            -- Declare variables
            variable z  : STD_LOGIC;
            variable r1 : STD_LOGIC;
            
            begin
                -- z <= '0' if T = all zeros
                z := '0';
                for i in 15 downto 0 loop
                    z := z or T(i);
                end loop;

                -- r1 <= '1' if R-1 is all zeros
                r1 := '0';
                for i in 15 downto 1 loop
                    r1 := r1 or R(i);
                end loop;
                r1 := (not r1) and R(0);

                -- Initialize outputs
                fcode   <= "000000"; 
                tsel    <= "000"; 
                pload   <= '0'; 
                tload   <= '0';
                nload   <= '0'; 
                digload <= '0'; 
                pinc    <= '1'; 
                iload   <= '0';
                nsel    <= "00"; 
                ssel    <= '0'; 
                rinsel  <= '0'; 
                rsel    <= '0';
                rload   <= '0'; 
                rdec    <= '0'; 
                rpush   <= '0'; 
                rpop    <='0';
                dpush   <= '0'; 
                dpop    <= '0'; 
                psel    <= '0'; 
                ldload  <= '0';

                if ((current_state = fetch) or (current_state = exec_fetch))  then
                    iload <= '1'; -- fetch next instruction 
                end if;

                if ((current_state = exec) or (current_state = exec_fetch)) then
                    case icode is
                        -- Data Stack instructions
                        when nop =>
                            null;    

                        when dup =>
                            nload <= '1';
                            dpush <= '1';

                        when swap =>
                            tload   <= '1';
                            nload   <= '1';
                            tsel    <= "111";

                        when drop =>
                            tload   <= '1';
                            nload   <= '1';
                            tsel    <= "111";
                            nsel    <= "01";
                            dpop    <= '1';

                        when over =>
                            tload   <= '1';
                            nload   <= '1';
                            tsel    <= "111";
                            dpush   <= '1';

                        when rot =>
                            tload   <= '1';
                            nload   <= '1';
                            tsel    <= "110";
                            dpush   <= '1';
                            dpop    <= '1';

                        when mrot =>
                            tload   <= '1';
                            nload   <= '1';
                            tsel    <= "111";
                            nsel    <= "01";
                            ssel    <= '1';
                            dpush   <= '1';
                            dpop    <= '1';

                        when nip =>
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';

                        when tuck =>
                            ssel    <= '1';
                            dpush   <= '1';

                        when rot_drop =>
                            dpop <= '1';

                        when rot_drop_swap =>
                            tload   <= '1';
                            nload   <= '1';
                            tsel    <= "111";
                            dpop    <= '1';
                        
                        -- FUnit instructions
                        when plus =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when minus =>
                            tload   <= '1';
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when plus1 =>
                            tload   <= '1'; 
                            fcode   <= icode(5 downto 0);

                        when minus1 =>
                            tload   <= '1';
                            fcode   <= icode(5 downto 0); 

                        when invert =>
                            tload   <= '1'; 
                            fcode   <= icode(5 downto 0);

                        when andd =>
                            tload   <= '1';
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when orr =>
                            tload <= '1'; 
                            nload <= '1';
                            nsel <= "01";
                            dpop <= '1';
                            fcode <= icode(5 downto 0);

                        when xorr =>
                            tload <= '1'; 
                            nload <= '1';
                            nsel <= "01";
                            dpop <= '1';
                            fcode <= icode(5 downto 0);

                        when twotimes =>
                            tload   <= '1';
                            fcode   <= icode(5 downto 0);

                        when u2slash =>
                            tload <= '1';
                            fcode <= icode(5 downto 0);

                        when twoslash =>
                            tload <= '1';
                            fcode <= icode(5 downto 0);

                        when rshift =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when lshift =>
                            tload   <= '1'; nload <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when mpp =>
                            tload   <= '1'; 
                            nload   <= '1'; 
                            nsel    <= "10";
                            fcode   <= icode(5 downto 0);

                        when shldc =>
                            tload   <= '1'; 
                            nload   <= '1'; 
                            nsel    <= "10";
                            fcode   <= icode(5 downto 0);
                            
                        when ones =>
                            tload   <= '1'; 
                            nload   <= '1'; 
                            dpush   <= '1';
                            fcode   <= icode(5 downto 0);

                        when zeros =>
                            tload   <= '1'; 
                            nload   <= '1'; 
                            dpush   <= '1';
                            fcode   <= icode(5 downto 0);

                        when zeroequal =>
                            tload   <= '1';
                            fcode   <= icode(5 downto 0);

                        when zeroless =>
                            tload   <= '1';
                            fcode   <= icode(5 downto 0);

                        when ult =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when ugt =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when eq =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when ugte =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when ulte =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when neq =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);
                           
                        when gt =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when lt =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when gte =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);

                        when lte =>
                            tload   <= '1'; 
                            nload   <= '1';
                            nsel    <= "01";
                            dpop    <= '1';
                            fcode   <= icode(5 downto 0);    

                        -- Return Stack, Memory Access, and I/O Instructions
                        when tor =>
                            tload   <= '1'; 
                            nload   <= '1';
                            tsel    <= "111"; 
                            nsel    <= "01";
                            dpop    <= '1';
                            rload   <= '1'; 
                            rpush   <= '1';
                            rinsel  <= '1';

                        when rfrom =>
                            tload   <= '1'; 
                            nload   <= '1';
                            tsel    <= "011";
                            dpush   <= '1';
                            rsel    <= '1'; 
                            rload   <= '1'; 
                            rpop    <= '1';

                        when rfetch =>
                            tload   <= '1'; 
                            nload   <= '1';
                            tsel    <= "011";
                            dpush   <= '1';

                        when rfromdrop =>
                            rsel    <= '1';
                            rload   <= '1'; 
                            rpop    <= '1';

                        when Sfetch =>
                            tload   <= '1'; 
                            nload   <= '1';
                            tsel    <= "010";
                            dpush   <= '1';

                        when digstore =>
                            digload <= '1';
                            tload   <= '1'; 
                            nload   <= '1';
                            tsel    <= "111"; 
                            nsel    <= "01";
                            dpop    <= '1';

                        when ldstore =>
                            ldload  <= '1';
                            tload   <= '1'; 
                            nload   <= '1';
                            tsel    <= "111"; 
                            nsel    <= "01";
                            dpop    <= '1';
                            
                        -- Literal, Transfer, and Branching instructions
                        when lit =>
                            tload   <= '1'; 
                            nload   <= '1';
                            tsel    <= "001";
                            dpush   <= '1';

                        when jmp =>
                            pload   <= '1'; 
                            psel    <= '0';
                            pinc    <= '0';

                        when jz =>
                            pload <= not z; 
                            psel    <= '0';
                            pinc    <= z;
                            tload   <= '1'; 
                            nload   <= '1';
                            tsel    <= "111"; 
                            nsel    <= "01";
                            dpop    <= '1';

                        when drjne =>
                            rdec    <= not r1;
                            pload   <= not r1; 
                            psel    <= '0';
                            pinc    <= r1; 
                            rsel    <= r1;
                            rload   <= r1; 
                            rpop    <= r1;

                        when call =>
                            pload <= '1';
                            rload <= '1';
                            rpush <= '1';

                        when ret =>
                            psel    <= '1'; 
                            pload   <= '1'; 
                            rsel    <= '1';
                            rload   <= '1'; 
                            rpop    <= '1';

                        when jb0LO =>
                            pload   <= not B(0); 
                            psel    <= '0'; 
                            pinc    <= B(0);

                        when jb1LO =>
                            pload   <= not B(1); 
                            psel    <= '0'; 
                            pinc    <= B(1);

                        when jb2LO =>
                            pload   <= not B(2); 
                            psel    <= '0'; 
                            pinc    <= B(2);

                        when jb3LO =>
                            pload   <= not B(3); 
                            psel    <= '0'; 
                            pinc    <= B(3);

                        when jb0HI =>
                            pload   <= B(0); 
                            psel    <= '0';
                            pinc    <= not B(0);

                        when jb1HI =>
                            pload   <= B(1);
                            psel    <= '0'; 
                            pinc    <= not B(1);

                        when jb2HI =>
                            pload   <= B(2); 
                            psel    <= '0'; 
                            pinc    <= not B(2);

                        when jb3HI =>
                            pload   <= B(3); 
                            psel    <= '0'; 
                            pinc    <= not B(3);

                        when others =>
                            null;

                    end case;
                end if;
            end process C2;

end behavior;
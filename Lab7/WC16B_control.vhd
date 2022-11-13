library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.OPCODES.ALL;

entity WC16B_control is
    port (
        clr     : in STD_LOGIC;
        clk     : in STD_LOGIC;
        icode   : in STD_LOGIC_VECTOR (15 downto 0);
        BTN0    : in STD_LOGIC;
        T       : in STD_LOGIC_VECTOR (15 downto 0);
        M       : in STD_LOGIC_VECTOR (15 downto 0);
        fcode   : out STD_LOGIC_VECTOR (5 downto 0);        
        pinc    : out STD_LOGIC;
        pload   : out STD_LOGIC;
        tload   : out STD_LOGIC;
        nload   : out STD_LOGIC;
        digload : out STD_LOGIC;
        iload   : out STD_LOGIC;
        dpush   : out STD_LOGIC;
        dpop    : out STD_LOGIC;
        psel    : out STD_LOGIC;
        ssel    : out STD_LOGIC;
        nsel    : out STD_LOGIC_VECTOR (1 downto 0);
        tsel    : out STD_LOGIC_VECTOR (2 downto 0)
    );
end WC16B_control;

architecture behavior of WC16B_control is
    -- Define internal types and signals
    type state_type is (fetch, exec, exec_fetch);
    signal current_state, next_state : state_type;

    begin
        synch : process (clk, clr)
            begin
                if (clr = '1') then
                    current_state <= fetch;
                elsif ((clk'event) and (clk = '1')) then
                    current_state <= next_state;
                end if;
        end process synch;

        C1: process(current_state, M)
            begin  
                case current_state is
                    -- Fetch instruction   
                    when fetch =>				
                        if M(8) = '1' then  		
                            next_state <= exec;		  	
                        else					
                            next_state <= exec_fetch;	 	
                        end if;
                    -- Execute instruction and fetch the next one
                    when exec_fetch =>			
                        if M(8) = '1' then  		
                            next_state <= exec;		  	
                        else					
                            next_state <= exec_fetch;		
                        end if;
                    -- Execute instruction without fetching a new one
                    when exec =>				
                        next_state <= fetch;			
                end case;
        end process C1;

        C2: process(icode, current_state, BTN0)
            begin
                fcode <= "000000";
                nsel <= "00"; 
                pload <= '0'; 
                tload <= '0';
                nload <= '0'; 
                digload <= '0'; 
                pinc <= '1'; 
                iload <= '0';

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
                dpush   <= '0';
                dpop    <= '0';
                psel    <= '0';
                if (current_state = fetch) or (current_state = exec_fetch)  then
                    iload <= '1'; -- fetch next instruction 
                end if;

                if (current_state = exec) or (current_state = exec_fetch) then
                    case icode is
                        -- Stack instructions
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

                        -- I/O Instructions
                        when sfetch =>
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

                        when jb0LO =>
                            pload   <= not BTN0;
                            psel    <= '0'; 
                            pinc    <= BTN0;

                        when jb0HI =>
                            pload   <= BTN0;
                            psel    <= '0';
                            pinc    <= not BTN0;

                        when others =>
                            null;

                    end case;
                end if;
            end process C2;

end behavior;
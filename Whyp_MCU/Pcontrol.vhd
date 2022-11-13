library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.OPCODES.ALL;

entity Pcontrol is
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
end Pcontrol;

architecture behavior of Pcontrol is
    -- Define internal types and signals
    type state_type is (fetch, exec, exec_fetch);
    signal current_state, next_state : state_type;

    begin
        synch : process (clk, clr)
            begin
                if (clr = '1') then
                    current_state <= fetch;
                elsif (clk'event) and (clk = '1') then
                    current_state <= next_state;
                end if;
        end process synch;

        C1: process(current_state, M)
            begin  
                case current_state is    
                    when fetch =>				
                        if M(8) = '1' then  		
                            next_state <= exec;		  	
                        else					
                            next_state <= exec_fetch;	 	
                        end if;      
                    when exec_fetch =>			
                        if M(8) = '1' then  		
                            next_state <= exec;		  	
                        else					
                            next_state <= exec_fetch;		
                        end if;
                    when exec =>				
                    next_state <= fetch;			
                end case;
        end process C1;

        C2: process(icode, current_state, BTN0)
            begin
                fcode <= "000000"; msel <= "00"; pload <= '0'; tload <= '0';
                nload <= '0'; digload <= '0'; pinc <= '1'; iload <= '0';

                if (current_state = fetch) or (current_state = exec_fetch)  then
                    iload <= '1'; -- fetch next instruction 
                end if;

                if (current_state = exec) or (current_state = exec_fetch) then
                    case icode is
                        when nop =>
                            null;                                            
                        when dup =>
                            nload <= '1';	  	  	                                                                      
                        when plus =>
                            tload <= '1'; fcode <= icode(5 downto 0);
                            msel <= "01";
                        when plus1 =>
                            tload <= '1'; fcode <= icode(5 downto 0);
                            msel <= "01";  
                        when invert =>
                            tload <= '1'; fcode <= icode(5 downto 0);
                            msel <= "01";
                        when twotimes =>
                            tload <= '1'; fcode <= icode(5 downto 0);
                            msel <= "01";
                        when sfetch =>
                            tload <= '1'; msel <= "10";
                        when digstore =>
                            digload <= '1';        
                        when jmp =>
                            pload <= '1'; pinc <= '0';
                        when jb0LO =>
                            pload   <= not BTN0; 
                            pinc    <= BTN0; 
                        when jb0HI =>
                            pload   <= BTN0; 
                            pinc    <= not BTN0;   
                        when others => null;	  
                    end case;
                end if;
            end process C2;

end behavior;
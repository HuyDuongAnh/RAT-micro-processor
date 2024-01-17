library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port (A,B : in std_logic_vector(7 downto 0);
          result : out std_logic_vector(7 downto 0);
          C, Z : out std_logic;
          cin : in std_logic;
          Sel : in std_logic_vector(3 downto 0));
end ALU;

architecture Behavioral of ALU is

signal Z_s,C_s : std_logic := '0';

begin
       
proc1 : process(Sel, A, B, cin, C_s, Z_s)
variable v_res : std_logic_vector(8 downto 0); 
variable v_c : std_logic;

begin
    C_s <= cin;
    Z_s <= '0';
    --v_res := "000000000";
    case Sel is 
       when "0000" => v_res := (('0' & A) + ('0' & B) + '0'); -- ADD
             result <= v_res(7 downto 0);
             C_s <= v_res(8);
            
             if (v_res(7 downto 0) = x"00") then
                Z_s <= '1';
             else
                Z_s <= '0';
             end if;
                  
       when "0001" => v_res := (('0' & A) + ('0' & B) + cin); -- ADDC
             result <= v_res(7 downto 0);
             C_s <= v_res(8);
                   
             if (v_res(7 downto 0) = x"00") then
                Z_s <= '1';
             else
                Z_s <= '0';
             end if;
            
       when "0010" => v_res := (('0' & A) + ('0' & not(B)) + '1'); -- SUB
             result <= v_res(7 downto 0);
             C_s <= not(v_res(8));
                        
             if (v_res(7 downto 0) = x"00") then
                Z_s <= '1';
             else
                Z_s <= '0';
             end if;
            
       when "0011" => v_res := (('0' & A) + ('0' & not(B)) + '1' - Cin); -- SUBC
             result <= v_res(7 downto 0);
             C_s <= not(v_res(8));
                                    
             if (v_res(7 downto 0) = x"00") then
                Z_s <= '1';
             else
                Z_s <= '0';
             end if;
            
       when "0100" => v_res := (('0' & A) + ('0' & not(B)) + '1'); -- CMP
             result <= v_res(7 downto 0);
             C_s <= not(v_res(8));
                               
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if;
             
       when "0101" => v_res := ('0' & (A AND B)); --AND
             result <= v_res(7 downto 0);
             C_s <= '0';
             
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if;
             
       when "0110" => v_res := ('0' & (A OR B)); --OR
             result <= v_res(7 downto 0);
             C_s <= '0';
                                
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if;      
             
       when "0111" => v_res := ('0' & (A XOR B)); --XOR
             result <= v_res(7 downto 0);
             C_s <= '0';
                                                   
             if (v_res(7 downto 0) = x"00") then
                  Z_s <= '1';
             else
                  Z_s <= '0';
             end if;
              
       when "1000" => v_res := ('0' & (A AND B)); -- TEST
             result <= v_res(7 downto 0);
             C_s <= '0';
                          
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if;
             
       when "1001" => v_res := ('0' & A); --LSL
             v_c := C_s;
             result(0) <= v_c;
             result(7 downto 1) <= v_res(6 downto 0);
             C_s <= v_res(7);
             
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if;
             
       when "1010" => v_res := ('0' & A); --LSR      
             v_c := C_s;
             result(7) <= v_c;
             result(6 downto 0) <= v_res(7 downto 1);
             C_s <= v_res(7);
                          
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if;
       
       when "1011" => v_res := ('0' & A); --ROL        
             v_c := C_s;
             result(0) <= v_res(7);
             result(7 downto 1) <= v_res(6 downto 0);
             C_s <= not(v_res(0));
                                                    
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if; 
                                
       when "1100" => v_res := ('0' & A); --ROR         
             v_c := C_s;
             result(7) <= v_res(0);
             result(6 downto 0) <= v_res(7 downto 1);
             C_S <= v_res(0);
                                       
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if;      
       
       when "1101" => v_res := ('0' & A); --ASR         
             v_c := C_s;
             result(7) <= v_res(7);
             result(6 downto 0) <= v_res(7 downto 1);
             C_s <= v_res(0);
                                                    
             if (v_res(7 downto 0) = x"00") then
                 Z_s <= '1';
             else
                 Z_s <= '0';
             end if;    
                     
       when "1110" => v_res := ('0' & A); --MOV          
             result(7 downto 0) <= v_res(7 downto 0);
                                      
       when others => result <= "00000000"; --NULL
end case;
end process proc1; 
C <= C_s;
Z <= Z_s;

end Behavioral;

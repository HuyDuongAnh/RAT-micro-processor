----------------------------------------------------------------------------------
-- Engineer: Huy Duong
-- Create Date: 01/28/2018 04:40:56 PM
-- Module Name: ALU - Behavioral
-- Description: 15 instructions ALU with 4 bit select taks in two 8 bit 
--              inputs, and outputs one 8-bit result, a Zero flag and a Carry flag
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
 port (  A,B : in std_logic_vector(7 downto 0);
         Cin : in std_logic;
         SEL : in std_logic_vector(3 downto 0);
         Z,C : out std_logic;
         RESULT : out std_logic_vector(7 downto 0));
end ALU;

architecture my_ALU of ALU is
begin
     process(A,B,Cin,SEL)
        variable v_res : std_logic_vector(8 downto 0) := "000000000";
        variable temp_res : std_logic_vector(8 downto 0) := "000000000";
        variable temp_c : std_logic;
     begin
         temp_c := '0';
         Z <= '0'; C <= '0';
         v_res := "000000000";
        
         case SEL is
             when "0000" =>                                  --ADD
                v_res := ('0' & A) + ('0' & B);
                C <= v_res(8);
             when "0001" =>                                  --ADDC                           
                v_res := ('0' & A) + ('0' & B) + Cin;
                C <= v_res(8);
             when "0010" =>                                  --SUB
                v_res := ('0' & A) - ('0' & B);
                if(A(7) = B(7)) then
                    C <= '1';
                end if;
             when "0011" =>                                  --SUBC
                v_res := ('0' & A) - ('0' & B) -Cin;
                if(A(7) = B(7)) then
                    C <= '1';
                end if;
             when "0100" =>                                  --CMP
                v_res := ('1' & A) - ('1' & B);
                --v_res := temp_res;
                C <= v_res(8);                            --check last bit to form value for C
                --if (v_res(7 downto 0) = X"00") then
                   --Z <= '1';
                --end if;                
             when "0101" =>
                v_res := '0' & (A AND B);
             when "0110" =>
                v_res := '0' & (A OR B);
             when "0111" =>
                v_res := '0' & (A XOR B);
             when "1000" =>                                  --TEST
                v_res := '0' & (A AND B);
--                if (temp_res(7 downto 0) = X"00") then
--                   Z <= '1';
--                end if; 
             when "1010" =>                                  --LSR & BSR
--                case B is
--                  when "00000000" =>
                      temp_res := A(0) & Cin & A(7 downto 1);
                      temp_c := A(0);
--                  when "00000001" => temp_res := '0' & A(6 downto 0) & "0";
--                  when "00000010" => temp_res := '0' & A(5 downto 0) & "00";
--                  when "00000011" => temp_res := '0' & A(4 downto 0) & "000";
--                  when "00000100" => temp_res := '0' & A(3 downto 0) & "0000";
--                  when "00000101" => temp_res := '0' & A(2 downto 0) & "00000";
--                  when "00000110" => temp_res := '0' & A(1 downto 0) & "000000";
--                  when "00000111" => temp_res := '0' & A(0) & "0000000";
--                  when "00001000" => temp_res := "000000000" ;
--                  when others => 
--                      temp_res := '0' & A;
--                      temp_c := '1';
--                  end case;
                  v_res := temp_res;
                  C <= temp_c;                                                    
             when "1001" =>                                  --LSL & BSL
--                case B is
--                 when "00000000" =>
                     temp_res := A(7 downto 0) & Cin;
                     temp_c := A(7);
--                 when "00000001" => temp_res := "00" & A(7 downto 1);
--                 when "00000010" => temp_res := "000" & A(7 downto 2);
--                 when "00000011" => temp_res := "0000" & A(7 downto 3);
--                 when "00000100" => temp_res := "00000" & A(7 downto 4);
--                 when "00000101" => temp_res := "000000" & A(7 downto 5);
--                 when "00000110" => temp_res := "0000000" & A(7 downto 6);
--                 when "00000111" => temp_res := "00000000" & A(7);
--                 when "00001000" => temp_res := "000000000" ;
--                 when others => 
--                     temp_res := '0' & A;
--                     temp_c := '1';
--                 end case;
                 v_res := temp_res;
                 C <= temp_c;                  
             when "1011" =>                                  --ROL
                C <= A(7);
                v_res := '0' & A(6 downto 0) & A(7);
             when "1100" =>                                  --ROR
                C <= A(0);
                v_res := '0' & A(0) & A(7 downto 1);
             when "1101" =>                                  --ASR
                C <= A(0);
                v_res := '0' & A(7)& A(7) & A(6 downto 1);
             when "1110" =>                                  --MOV
                v_res := '0' & B;
             when others =>
                v_res := "000000000";   
         end case;
         if (v_res(7 downto 0) = X"00") then                --Set Z-Flag when v_res is zero
            Z <= '1';
         end if;       
         RESULT <= v_res(7 downto 0);
        
     end process;
end my_ALU; 

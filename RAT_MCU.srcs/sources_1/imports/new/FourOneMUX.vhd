----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/26/2018 01:33:55 PM
-- Design Name: 
-- Module Name: FourONeMUX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FourOneMUX is
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_INTRR : in STD_LOGIC_VECTOR (9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           D_IN : out STD_LOGIC_VECTOR (9 downto 0));
end FourOneMUX;

architecture Behavioral of FourONeMUX is
    signal s_D : std_logic_vector (9 downto 0) := "0000000000";
begin
    MUX : process(PC_MUX_SEL, FROM_IMMED, FROM_STACK, FROM_INTRR)
    begin
        if(PC_MUX_SEL = "00") then --Branch and Call instructions
            s_D <= FROM_IMMED;
        elsif(PC_MUX_SEL = "01") then
            s_D <= FROM_STACK;   --Return instructions from subroutine or interrupt
        elsif(PC_MUX_SEL = "10") then
            s_D <= FROM_INTRR; --intertup vector 0x3FF
        else
            s_D <= "0000000000";
        end if;
    end process;
    D_IN <= s_D;
end Behavioral;

----------------------------------------------------------------------------------
-- Engineer: Huy Duong
-- Create Date: 02/06/2018 03:31:28 PM
-- Module Name: MuxFourOne_8Bit - Behavioral
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

entity MuxFourOne_8Bit is
    Port ( IN_0 : in STD_LOGIC_VECTOR (7 downto 0);
           IN_1 : in STD_LOGIC_VECTOR (7 downto 0);
           IN_2 : in STD_LOGIC_VECTOR (7 downto 0);
           IN_3 : in STD_LOGIC_VECTOR (7 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (1 downto 0));
end MuxFourOne_8Bit;

architecture Behavioral of MuxFourOne_8Bit is
    --signal s_out : std_logic_vector (7 downto 0);
begin
    MUX : process(SEL, IN_0, IN_1, IN_2, IN_3)
    begin
        if(SEL = "00") then --Branch and Call instructions
            OUTPUT <= IN_0;
        elsif(SEL = "01") then
            OUTPUT <= IN_1;   --Return instructions from subroutine or interrupt
        elsif(SEL = "10") then
            OUTPUT <= IN_2; --interupt vector 0x3FF
        else
            OUTPUT <= IN_3;
        end if;
    end process;
    --OUTPUT <= s_out;
end Behavioral;

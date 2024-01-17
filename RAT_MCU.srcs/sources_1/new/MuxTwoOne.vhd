----------------------------------------------------------------------------------
-- Engineer: Huy Duong
-- Create Date: 02/06/2018 03:48:03 PM
-- Module Name: MUXTwoOne - Behavioral
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

entity MuxTwoOne_8Bit is
    Port ( IN_0 : in STD_LOGIC_VECTOR (7 downto 0);
           IN_1 : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
end MuxTwoOne_8Bit;

architecture Behavioral of MuxTwoOne_8Bit is

begin
    MUX : process(SEL, IN_0, IN_1)
    begin
        if(SEL = '0') then
            OUTPUT <= IN_0; --interupt vector 0x3FF
        else
            OUTPUT <= IN_1;
        end if;
    end process;
end Behavioral;

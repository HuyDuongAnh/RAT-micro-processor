----------------------------------------------------------------------------------
-- Engineer: Huy Duong
-- Create Date: 02/17/2018 04:47:52 PM
-- Module Name: SHAD_FF - Behavioral
-- Description: Shadow Flag Flip Flop
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

entity SHAD_FF is
    Port ( LD : in STD_LOGIC;
           INPUT : in STD_LOGIC;
           OUTPUT : out STD_LOGIC;
           CLK : in STD_LOGIC);
end SHAD_FF;

architecture Behavioral of SHAD_FF is
begin
    FF: process(CLK, LD, INPUT)
    begin
        if(rising_edge(CLK)) then
            if(LD = '1') then
                OUTPUT <= INPUT;
            end if;
        end if;
    end process;
end Behavioral;

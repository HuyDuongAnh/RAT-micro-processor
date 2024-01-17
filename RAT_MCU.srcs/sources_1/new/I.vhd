----------------------------------------------------------------------------------
-- Engineer: Huy Duong & Brandon Replogle
-- Create Date: 02/07/2018 03:29:12 PM
-- Module Name: I - Behavioral
-- Description: Set and clear INT value in Control Unit
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

entity I is
    Port ( I_SET : in STD_LOGIC;
           I_CLR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           OUTPUT : out STD_LOGIC);
end I;

architecture Behavioral of I is
    signal s_D : std_logic := '0';
begin
    process(I_SET, CLK, I_CLR)
    begin
        if(rising_edge(CLK)) then
            if(I_SET = '1') then
                s_D <= '1';
            elsif(I_CLR = '1') then
                s_D <= '0';
            end if;
        end if;
    end process;
    OUTPUT <= s_D;
end Behavioral;

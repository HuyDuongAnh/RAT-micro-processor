----------------------------------------------------------------------------------
-- Engineer: Huy Duong & Brandon Replogle
-- Create Date: 02/11/2018 05:01:59 PM
-- Description: Stack Pointer Module in MCU
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SP is
    Port ( RST : in STD_LOGIC;
           LD : in STD_LOGIC;
           INCR : in STD_LOGIC;
           DECR : in STD_LOGIC;
           DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end SP;

architecture Behavioral of SP is
    signal s_data_out : std_logic_vector ( 7 downto 0) := "00000000";
    signal temp : std_logic_vector ( 7 downto 0) := "00000000";
begin
    SP: process (RST, LD, INCR, DECR, CLK)
    begin
        if(rising_edge (CLK)) then
            if(RST = '1') then
                s_data_out <= "00000000";
            elsif (LD = '1') then
                s_data_out <= DATA_IN;
            elsif (INCR = '1') then
                s_data_out <= std_logic_vector(unsigned(s_data_out) + "00000001");
            elsif (DECR = '1') then
                s_data_out <= std_logic_vector(unsigned(s_data_out) - "00000001");
            end if;
        end if;
    end process;
    DATA_OUT <= s_data_out;
end Behavioral;

----------------------------------------------------------------------------------
-- Engineers: Keefe Johnson and James Kim 
-- Create Date: 01/26/2018 01:56:11 PM
-- Description: Program counter for the RAT MCU
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PC is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           FROM_INTRR : in STD_LOGIC_VECTOR (9 downto 0) := "1111111111"; -- 0x3FF
           FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0) );
end PC;

architecture Behavioral of PC is

    signal D_IN : STD_LOGIC_VECTOR (9 downto 0);
    signal s_PC_COUNT : UNSIGNED (9 downto 0);
    
begin

    -- mux
    D_IN <= FROM_IMMED when PC_MUX_SEL = "00" else
            FROM_STACK when PC_MUX_SEL = "01" else
            FROM_INTRR when PC_MUX_SEL = "10" else  -- 0x3FF
            (others => '-');

    -- program counter
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '1' then
                s_PC_COUNT <= (others => '0');
            elsif PC_LD = '1' then
                s_PC_COUNT <= unsigned(D_IN);
            elsif PC_INC = '1' then
                s_PC_COUNT <= s_PC_COUNT + 1;
            end if;
        end if;
    end process;
    PC_COUNT <= std_logic_vector(s_PC_COUNT);

end Behavioral;

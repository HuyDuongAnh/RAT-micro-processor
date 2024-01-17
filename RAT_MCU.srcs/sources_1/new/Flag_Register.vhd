------------------------------------------------------------------------------
-- Company: RAT Technologies
-- Engineer: James Ratner (Template) & Huy Duong & Brandon Replogle
-- 
-- Create Date:    13:55:34 04/06/2014 
-- Design Name: 
-- Module Name:    Mux - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Full featured D Flip-flop intended for use as flag register. 
--
-- Dependencies: 
--
-- Revision: 3.0
-- Revision 0.01 - File Created
-- Additional Comments: 
--
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FlagReg is
    Port ( C : in STD_LOGIC; --flag input
           Z : in STD_LOGIC; --load Q with the D value
           FLG_C_SET : in STD_LOGIC; --set the flag to '1'
           FLG_C_CLR : in STD_LOGIC; --clear the flag to '0'
           FLG_C_LD : in STD_LOGIC;
           FLG_Z_LD : in STD_LOGIC;
           FLG_LD_SEL : in STD_LOGIC;
           FLG_SHAD_LD : in STD_LOGIC;
           CLK  : in  STD_LOGIC; --system clock
           C_OUT : out  STD_LOGIC;
           Z_OUT : out STD_LOGIC); --flag output
end FlagReg;

architecture Behavioral of FlagReg is
    component FlagFF is
        Port ( INPUT    : in  STD_LOGIC; --flag input
               LD   : in  STD_LOGIC; --load Q with the D value
               SET  : in  STD_LOGIC; --set the flag to '1'
               CLR  : in  STD_LOGIC; --clear the flag to '0'
               CLK  : in  STD_LOGIC; --system clock
               Q    : out  STD_LOGIC); --flag output
    end component FlagFF;
    component MuxTwoOne_1Bit is
        Port ( IN_0 : in STD_LOGIC;
               IN_1 : in STD_LOGIC;
               SEL : in STD_LOGIC;
               OUTPUT : out STD_LOGIC);
    end component MuxTwoOne_1Bit;
    signal z_output, c_output, z_shad, c_shad : STD_LOGIC := '0';
    signal z_in, c_in : STD_LOGIC := '0';
begin
    CFlag :  FlagFF
    port map ( INPUT => c_in,
               LD => FLG_C_LD, --load Q with the D value
               SET => FLG_C_SET, --set the flag to '1'
               CLR => FLG_C_CLR,  --clear the flag to '0'
               CLK => CLK, --system clock
               Q  => c_output); --flag output
    ZFlag :  FlagFF
    port map (  INPUT => z_in,
                LD => FLG_Z_LD, --load Q with the D value
                SET => '0', --set the flag to '1'
                CLR => '0',  --clear the flag to '0'
                CLK => CLK, --system clock
                Q  => z_output); --flag output
    SHAD_Z :  FlagFF
    port map (  INPUT => z_output,
                LD => FLG_SHAD_LD, --load Q with the D value
                SET => '0', --set the flag to '1'
                CLR => '0',  --clear the flag to '0'
                CLK => CLK, --system clock
                Q  =>  z_shad);--z_in); --flag output
    SHAD_C :  FlagFF
    port map (  INPUT => c_output,
                LD => FLG_SHAD_LD, --load Q with the D value
                SET => '0', --set the flag to '1'
                CLR => '0',  --clear the flag to '0'
                CLK => CLK, --system clock
                Q  =>  c_shad);--z_in); --flag output
    MUX_Z: MuxTwoOne_1Bit 
    port map ( IN_0 => Z,
               IN_1 => z_shad,
               SEL => FLG_LD_SEL,
               OUTPUT => z_in);
    MUX_C: MuxTwoOne_1Bit 
    port map ( IN_0 => C,
              IN_1 => c_shad,
              SEL => FLG_LD_SEL,
              OUTPUT => c_in);            
    Z_OUT <= z_output;
    C_OUT <= c_output;
end Behavioral;
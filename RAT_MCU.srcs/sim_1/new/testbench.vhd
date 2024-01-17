----------------------------------------------------------------------------------
-- Engineer: Stolen from Jordan Jones & Brandon Nghe
--           Modified by James Ratner
-- 
-- Create Date: 10/19/2016 03:04:18 AM
-- Design Name: testbench
-- Module Name: testbench - Behavioral
-- Project Name: Exp 7
-- Target Devices: 
-- Tool Versions: 
-- Description: Experiment 7 testbench 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 1.00 - File Created (11-20-2016)
-- Revision 1.01 - Finished Modifications for Basys3 (10-29-2017)
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is

	component RAT_wrapper is
		Port ( LEDS     : out   STD_LOGIC_VECTOR(7 downto 0);
			   --SEGMENTS : out   STD_LOGIC_VECTOR(7 downto 0); 
			   --DISP_EN  : out   STD_LOGIC_VECTOR(3 downto 0); 
			   SWITCHES : in    STD_LOGIC_VECTOR(7 downto 0);
			   --BUTTONS  : in    STD_LOGIC_VECTOR(3 downto 0); 
			   RST    : in    STD_LOGIC;
			   CLK      : in    STD_LOGIC);
	end component;


	signal s_LEDS     : STD_LOGIC_VECTOR(7 downto 0):= (others => '0'); 
	--signal s_SEGMENTS : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); 
	--signal s_DISP_EN  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); 
	signal s_SWITCHES : STD_LOGIC_VECTOR(7 downto 0) := (others => '0'); 
	--signal s_BUTTONS  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); 
	signal s_RESET    : STD_LOGIC := '0';
	signal s_CLK      : STD_LOGIC := '0';

begin

   -- instantiate device under test (DUT) ---------
   testMCU : RAT_wrapper PORT Map(
      LEDS     => s_LEDS,
      --SEGMENTS => s_segments,
	  --DISP_EN  => s_DISP_EN,
      SWITCHES => s_SWITCHES,
	  --BUTTONS  => s_BUTTONS,
      RST    => s_RESET,
      CLK      => s_CLK);
      
   -- generate clock signal -----------------------
   clk_process :process
   begin
      s_CLK <= '1';
      wait for 5ns;
      s_CLK <= '0';
      wait for 5ns;
   end process clk_process;
    
   -- generate stimulus for DUT --------------------	
   stim_process :process
   begin
      s_RESET <= '1';
      wait for 10 ns;
      s_RESET <= '0';
      s_SWITCHES <= X"70";
      wait;
   end process stim_process;

end Behavioral;
----------------------------------------------------------------------------------
-- Engineer: Bridget Benson
-- Create Date: 09/21/2015 09:02:18 AM
-- Description: Template file for test benches
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--make the entity name of your simulation file the same name as the file you  wish to simulate
--with the word Sim at the end of it.  The entity is empty because a simulation file does not 
--connect to anything on the board.
entity simulation is
--  Port ( );
end simulation;

architecture Behavioral of simulation is

    -- Component Declaration for the Unit Under Test (UUT) (the module you are testing)
    component RAT_MCU is
        Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
               RESET    : in  STD_LOGIC;
               CLK      : in  STD_LOGIC;
               INT      : in  STD_LOGIC;
               OUT_PORT : out  STD_LOGIC_VECTOR (7 downto 0);
               PORT_ID  : out  STD_LOGIC_VECTOR (7 downto 0);
               IO_STRB  : out  STD_LOGIC);
    end component RAT_MCU;

    --Signal declarions - can be the same names as the ports
    signal IN_PORT  : STD_LOGIC_VECTOR (7 downto 0);
    signal RESET    : STD_LOGIC;
    signal CLK      : STD_LOGIC;
    signal INT      : STD_LOGIC;
    signal OUT_PORT : STD_LOGIC_VECTOR (7 downto 0);
    signal PORT_ID  : STD_LOGIC_VECTOR (7 downto 0);
    signal IO_STRB  : STD_LOGIC;
	--For designs with a CLK, uncomment the following
	--signal CLK : std_logic := '0';
	
	--For designs with a CLK uncomment the following
	--constant CLK_period: time := 10 ns;
	
    begin
    
		-- Map the UUT's ports to the signals
        uut: RAT_MCU 
        PORT MAP ( IN_PORT  => IN_PORT,
                   RESET    => RESET,
                   CLK      => CLK,
                   INT      => INT,
                   OUT_PORT => OUT_PORT,
                   PORT_ID  => PORT_ID,
                   IO_STRB  => IO_STRB);

		--For designs with a CLK uncomment the following
		--CLK_process : process
		--begin
		--	CLK <= '0';
		--	wait for CLK_period/2;
		--	CLK <= '1'; 
		--	wait for CLK_period/2;
		--end process;
		
		
        stim_proc: process
        begin
            -- now assign values to the input signals
			-- you should include at least 8 test cases for all labs that 
			-- are representative of different inputs for your circuit
			-- if you can do an exhaustive test (like those that have only 8
			-- or 16 possible input combinations) - do an exhaustive test
            
            wait for 10 ns;
            A <= '0';
            B <= '0';
            C <= '0';
            D <= '1';
            wait for 10 ns;
            A <= '0';
            B <= '0';
            C <= '1';
            D <= '0';
            wait for 10 ns;
            A <= '0';
            B <= '0';
            C <= '1';
            D <= '1';
            
            wait;
        end process;
end Behavioral;
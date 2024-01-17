----------------------------------------------------------------------------------
-- Engineers: David Turien, Edson Ribeiro Junior, and Keefe Johnson
-- Credits: RAT Technologies (a subdivision of Cal Poly CENG)
-- Create Date: 02/05/2018 03:31:58 PM
-- Description: An interface between the Basys3 board and the RAT MCU
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAT_wrapper is
    Port ( LEDS     : out STD_LOGIC_VECTOR (15 downto 0);
           SWITCHES : in  STD_LOGIC_VECTOR (15 downto 0);
           SEGMENTS : out STD_LOGIC_VECTOR (7 downto 0);
           DISP_EN  : out STD_LOGIC_VECTOR (3 downto 0);
           BUTTONS  : in  STD_LOGIC_VECTOR (2 downto 0);
           RESET    : in  STD_LOGIC;
           INT      : in  STD_LOGIC;
           CLK      : in  STD_LOGIC );
end RAT_wrapper;

architecture Behavioral of RAT_wrapper is

    -- input port IDs ------------------------------------------------------------
    constant c_SWITCHES_LO_ID : STD_LOGIC_VECTOR (7 downto 0) := X"20";
    constant c_SWITCHES_HI_ID : STD_LOGIC_VECTOR (7 downto 0) := X"21";
    constant c_BUTTONS_ID     : STD_LOGIC_VECTOR (7 downto 0) := X"24";

    -- output port IDs -----------------------------------------------------------
    constant c_LEDS_LO_ID  : STD_LOGIC_VECTOR (7 downto 0) := X"40";
    constant c_LEDS_HI_ID  : STD_LOGIC_VECTOR (7 downto 0) := X"41";
    constant c_SSEG_ID     : STD_LOGIC_VECTOR (7 downto 0) := X"81";

    component RAT_MCU
        Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
               RESET    : in  STD_LOGIC;
               CLK      : in  STD_LOGIC;
               INT      : in  STD_LOGIC;
               OUT_PORT : out STD_LOGIC_VECTOR (7 downto 0);
               PORT_ID  : out STD_LOGIC_VECTOR (7 downto 0);
               IO_STRB  : out STD_LOGIC );
    end component;

    component db_1shot_fsm
        Port ( A    : in  STD_LOGIC;
               CLK  : in  STD_LOGIC;
               A_DB : out STD_LOGIC );
    end component;

    component sseg_dec_uni
        Port ( COUNT1   : in  STD_LOGIC_VECTOR (13 downto 0);
               COUNT2   : in  STD_LOGIC_VECTOR (7 downto 0);
               SEL      : in  STD_LOGIC_VECTOR (1 downto 0);
               dp_oe    : in  STD_LOGIC;
               dp       : in  STD_LOGIC_VECTOR (1 downto 0);
               CLK      : in  STD_LOGIC;
               SIGN     : in  STD_LOGIC;
               VALID    : in  STD_LOGIC;
               DISP_EN  : out STD_LOGIC_VECTOR (3 downto 0);
               SEGMENTS : out STD_LOGIC_VECTOR (7 downto 0) );
    end component;

    signal s_MCU_IN_PORT  : STD_LOGIC_VECTOR (7 downto 0);
    signal s_MCU_OUT_PORT : STD_LOGIC_VECTOR (7 downto 0);
    signal s_MCU_PORT_ID  : STD_LOGIC_VECTOR (7 downto 0);
    signal s_MCU_IO_STRB  : STD_LOGIC;
    signal s_MCU_CLK      : STD_LOGIC := '0';
    signal s_MCU_INT      : STD_LOGIC;

    signal s_DB_RESET     : STD_LOGIC;
    signal s_DB_INT       : STD_LOGIC;

    -- registers for outputs -----------------------------------------------------
    signal r_LEDS_LO  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal r_LEDS_HI  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal r_SSEG     : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

    signal r_SSEG_ext : STD_LOGIC_VECTOR (13 downto 0); 

begin

    -- clock divider -------------------------------------------------------------
    clkdiv: process(CLK, s_MCU_CLK)
    begin
        if rising_edge(CLK) then
            s_MCU_CLK <= not s_MCU_CLK;
        end if;
    end process;

    c_MCU: RAT_MCU
    port map ( IN_PORT  => s_MCU_IN_PORT,
               OUT_PORT => s_MCU_OUT_PORT,
               PORT_ID  => s_MCU_PORT_ID,
               RESET    => s_DB_RESET,
               IO_STRB  => s_MCU_IO_STRB,
               INT      => s_DB_INT,
               CLK      => s_MCU_CLK );

    c_DB_RESET: db_1shot_fsm
    port map ( A    => RESET,
               CLK  => s_MCU_CLK,
               A_DB => s_DB_RESET );

    c_DB_INT: db_1shot_fsm
    port map ( A    => INT,
               CLK  => s_MCU_CLK,
               A_DB => s_DB_INT );

    r_SSEG_ext <= "000000" & r_SSEG;
    c_SSEG: sseg_dec_uni
    port map ( COUNT1   => r_SSEG_ext,
               COUNT2   => (others => '0'),
               SEL      => "00",
               dp_oe    => '0',
               dp       => "00",
               CLK      => CLK,
               SIGN     => '0',
               VALID    => '1',
               DISP_EN  => DISP_EN,
               SEGMENTS => SEGMENTS);

    -- mux for selecting which input to read -------------------------------------
    inputs: process(s_MCU_PORT_ID, SWITCHES, BUTTONS)
    begin
        case s_MCU_PORT_ID is
        when c_SWITCHES_LO_ID =>
            s_MCU_IN_PORT <= SWITCHES(7 downto 0);
        when c_SWITCHES_HI_ID =>
            s_MCU_IN_PORT <= SWITCHES(15 downto 8);
        when c_BUTTONS_ID =>
            s_MCU_IN_PORT <= "00000" & BUTTONS;
        when others =>
            s_MCU_IN_PORT <= X"00";
        end case;
    end process;

    -- output registers ----------------------------------------------------------
    outputs: process(CLK, s_MCU_IO_STRB, s_MCU_PORT_ID, s_MCU_OUT_PORT)
    begin
        if rising_edge(CLK) then
            if s_MCU_IO_STRB = '1' then

                -- mux for selecting which output to write -----------------------
                case s_MCU_PORT_ID is
                when c_LEDS_LO_ID =>
                    r_LEDS_LO <= s_MCU_OUT_PORT;
                when c_LEDS_HI_ID =>
                    r_LEDS_HI <= s_MCU_OUT_PORT;
                when c_SSEG_ID =>
                    r_SSEG <= s_MCU_OUT_PORT;
                when others =>
                end case;

            end if;
        end if;
    end process;

    LEDS(7 downto 0) <= r_LEDS_LO; 
    LEDS(15 downto 8) <= r_LEDS_HI; 

end Behavioral;
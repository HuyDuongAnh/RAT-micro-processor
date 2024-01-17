----------------------------------------------------------------------------------
-- Company: Ratner Engineering
-- Engineer: James Ratner & Huy Duong
-- 
-- Create Date:    20:59:29 02/04/2013 
-- Design Name: 
-- Module Name:    RAT_MCU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Starter MCU file for RAT MCU. 
--
-- Dependencies: 
--
-- Revision: 3.00
-- Revision: 4.00 (08-24-2016): removed support for multibus
-- Revision: 4.01 (11-01-2016): removed PC_TRI reference
-- Revision: 4.02 (11-15-2016): added SCR_DATA_SEL 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAT_MCU is
    Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
           RESET    : in  STD_LOGIC;
           CLK      : in  STD_LOGIC;
           INT      : in  STD_LOGIC;
           OUT_PORT : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID  : out  STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB  : out  STD_LOGIC);
end RAT_MCU;



architecture Behavioral of RAT_MCU is
    component prog_rom  
      port (     ADDRESS : in std_logic_vector(9 downto 0); 
             INSTRUCTION : out std_logic_vector(17 downto 0); 
                     CLK : in std_logic);  
    end component;
    
    component ALU
       Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
              B : in  STD_LOGIC_VECTOR (7 downto 0);
              Cin : in  STD_LOGIC;
              SEL : in  STD_LOGIC_VECTOR(3 downto 0);
              C : out  STD_LOGIC;
              Z : out  STD_LOGIC;
              RESULT : out  STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component CONTROL_UNIT 
       Port ( CLK           : in   STD_LOGIC;
              C             : in   STD_LOGIC;
              Z             : in   STD_LOGIC;
              INT           : in   STD_LOGIC;
              RESET         : in   STD_LOGIC; 
              OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
              OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
              
              PC_LD         : out  STD_LOGIC;
              PC_INC        : out  STD_LOGIC;
              PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);		  
    
              SP_LD         : out  STD_LOGIC;
              SP_INCR       : out  STD_LOGIC;
              SP_DECR       : out  STD_LOGIC;
    
              RF_WR         : out  STD_LOGIC;
              RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);
    
              ALU_OPY_SEL   : out  STD_LOGIC;
              ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);
    
              SCR_WR        : out  STD_LOGIC;
              SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);
              SCR_DATA_SEL  : out  STD_LOGIC; 
    
              FLG_C_LD      : out  STD_LOGIC;
              FLG_C_SET     : out  STD_LOGIC;
              FLG_C_CLR     : out  STD_LOGIC;
              FLG_SHAD_LD   : out  STD_LOGIC;
              FLG_LD_SEL    : out  STD_LOGIC;
              FLG_Z_LD      : out  STD_LOGIC;
              
              I_SET    : out  STD_LOGIC;
              I_CLR    : out  STD_LOGIC;
    
              RST           : out  STD_LOGIC;
              IO_STRB       : out  STD_LOGIC);
    end component;
    
    component RegisterFile 
       Port ( D_IN   : in     STD_LOGIC_VECTOR (7 downto 0);
              DX_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
              DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
              ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
              ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
              WR     : in     STD_LOGIC;
              CLK    : in     STD_LOGIC);
    end component;
    
    component PC 
      port ( RST,CLK,PC_LD,PC_INC : in std_logic; 
             FROM_IMMED : in std_logic_vector (9 downto 0); 
             FROM_STACK : in std_logic_vector (9 downto 0); 
             FROM_INTRR : in std_logic_vector (9 downto 0); 
             PC_MUX_SEL : in std_logic_vector (1 downto 0); 
             PC_COUNT   : out std_logic_vector (9 downto 0)); 
    end component; 
    
    component MuxFourOne_8Bit is
        Port ( IN_0 : in STD_LOGIC_VECTOR (7 downto 0);
               IN_1 : in STD_LOGIC_VECTOR (7 downto 0);
               IN_2 : in STD_LOGIC_VECTOR (7 downto 0);
               IN_3 : in STD_LOGIC_VECTOR (7 downto 0);
               OUTPUT : out STD_LOGIC_VECTOR (7 downto 0);
               SEL : in STD_LOGIC_VECTOR (1 downto 0));
    end component MuxFourOne_8Bit;
    
    component MuxTwoOne_8Bit is
        Port ( IN_0 : in STD_LOGIC_VECTOR (7 downto 0);
               IN_1 : in STD_LOGIC_VECTOR (7 downto 0);
               SEL : in STD_LOGIC;
               OUTPUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component MuxTwoOne_8Bit;
        
    component FlagReg is
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
    end component FlagReg;
    
    component Scratch_RAM is
        Port ( DATA_IN  : in  STD_LOGIC_VECTOR (9 downto 0);
               DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0); 
               ADDR     : in  STD_LOGIC_VECTOR (7 downto 0);
               WE       : in  STD_LOGIC; 
               CLK      : in  STD_LOGIC);
    end component Scratch_RAM;
    
    component SP is
        Port ( RST : in STD_LOGIC;
               LD : in STD_LOGIC;
               INCR : in STD_LOGIC;
               DECR : in STD_LOGIC;
               DATA_IN : in STD_LOGIC_VECTOR (7 downto 0);
               CLK : in STD_LOGIC;
               DATA_OUT : out STD_LOGIC_VECTOR (7 downto 0));
    end component SP;
    
    component MuxTwoOne_10Bit is
        Port ( IN_0 : in STD_LOGIC_VECTOR (9 downto 0);
               IN_1 : in STD_LOGIC_VECTOR (9 downto 0);
               SEL : in STD_LOGIC;
               OUTPUT : out STD_LOGIC_VECTOR (9 downto 0));
    end component MuxTwoOne_10Bit;
    
    component I is
        Port ( I_SET : in STD_LOGIC;
               I_CLR : in STD_LOGIC;
               CLK : in STD_LOGIC;
               OUTPUT : out STD_LOGIC);
    end component I;
 
    -- intermediate signals ----------------------------------
    signal s_pc_ld : std_logic := '0'; 
    signal s_pc_inc : std_logic := '0'; 
    signal s_rst : std_logic := '0'; 
    signal s_pc_mux_sel : std_logic_vector(1 downto 0) := "00"; 
    signal s_pc_count : std_logic_vector(9 downto 0) := (others => '0');   
    signal s_inst_reg : std_logic_vector(17 downto 0) := (others => '0'); 
    
    
    
    -- helpful aliases ------------------------------------------------------------------
    alias s_ir_immed_bits : std_logic_vector(9 downto 0) is s_inst_reg(12 downto 3); 
    
    --intermediate signals
    ----------------Control Unit--------------------
    signal C_FLAG: std_logic := '0';
    signal Z_FLAG: std_logic := '0';
    signal INT_CU : std_logic := '0';
    
    signal I_SET: std_logic := '0';
    signal I_CLR: std_logic := '0';
    
    signal PC_LD: std_logic := '0';
    signal PC_INC: std_logic := '0';
    signal PC_MUX_SEL: std_logic_vector( 1 downto 0) := "00";
    
    signal ALU_OPY_SEL: std_logic := '0';
    signal ALU_SEL: std_logic_vector (3 downto 0) := "0000";
    
    signal RF_WR: std_logic := '0';
    signal RF_WR_SEL: std_logic_vector (1 downto 0) := "00";
    
    signal SP_LD: std_logic := '0';
    signal SP_INCR: std_logic := '0';
    signal SP_DECR: std_logic := '0';
    
    signal SCR_WR: std_logic := '0';
    signal SCR_ADDR_SEL: std_logic_vector (1 downto 0) := "00";
    signal SCR_DATA_SEL: std_logic := '0';
    
    signal FLG_C_SET: std_logic := '0'; 
    signal FLG_C_CLR: std_logic := '0'; 
    signal FLG_C_LD: std_logic := '0'; 
    signal FLG_Z_LD: std_logic := '0'; 
    signal FLG_LD_SEL: std_logic := '0'; 
    signal FLG_SHAD_LD: std_logic := '0'; 
    
    signal RST: std_logic := '0';
    ----------------REG_FILE-----------------------------------
    signal D_IN: std_logic_vector ( 7 downto 0) := "00000000";
    signal ADRX: std_logic_vector ( 4 downto 0) := "00000";
    signal ADRY: std_logic_vector ( 4 downto 0) := "00000";
    signal DX_OUT: std_logic_vector ( 7 downto 0) := "00000000";
    signal DY_OUT: std_logic_vector ( 7 downto 0) := "00000000";
    ------------------------------------------------------------
    ----------------ALU-----------------------------------------
    signal ALU_C, ALU_Z : std_logic := '0';
    signal B_IN, ALU_RES : std_logic_vector ( 7 downto 0) := "00000000";
    ------------------------------------------------------------
    ---------------------SP-------------------------------------
    signal B: std_logic_vector ( 7 downto 0) := "00000000";
    ------------------------------------------------------------
    ---------------------SCR------------------------------------
    signal Bm1 : std_logic_vector ( 7 downto 0) := "00000000";
    signal R_ADDR : std_logic_vector ( 7 downto 0) := "00000000";
    signal R_DATA_IN : std_logic_vector ( 9 downto 0) := "0000000000";
    signal R_DATA_OUT : std_logic_vector ( 9 downto 0) := "0000000000";
    signal R_DX_OUT : std_logic_vector ( 9 downto 0) := "0000000000";
    ------------------------------------------------------------
    ----------------------I-------------------------------------
    signal s_OUT : std_logic := '0';
    ------------------------------------------------------------
    begin
    my_prog_rom: prog_rom  
    port map(     ADDRESS => s_pc_count, 
             INSTRUCTION => s_inst_reg, 
                     CLK => CLK); 
    
    my_alu: ALU
    port map ( A => DX_OUT,       
              B => B_IN,       
              Cin => C_FLAG,     
              SEL => ALU_SEL,     
              C => ALU_C,       
              Z => ALU_Z,       
              RESULT => ALU_RES); 
    
     FLAGS: FlagReg
          port map (C => ALU_C, --flag input
                    Z => ALU_Z, --load Q with the D value
                    FLG_C_SET => FLG_C_SET, --set the flag to '1'
                    FLG_C_CLR => FLG_C_CLR, --clear the flag to '0'
                    FLG_C_LD => FLG_C_LD,
                    FLG_Z_LD => FLG_Z_LD,
                    FLG_LD_SEL => FLG_LD_SEL,
                    FLG_SHAD_LD => FLG_SHAD_LD,
                    CLK  => CLK, --system clock
                    C_OUT => C_FLAG,
                    Z_OUT => Z_FLAG); --flag output
    
    INT_CU <= INT AND s_OUT;                
    my_cu: CONTROL_UNIT 
    port map ( CLK           => CLK, 
              C             => C_FLAG, 
              Z             => Z_FLAG, 
              INT           => INT_CU, 
              RESET         => RESET, 
              OPCODE_HI_5   => s_inst_reg ( 17 downto 13), 
              OPCODE_LO_2   => s_inst_reg ( 1 downto 0), 
              
              PC_LD         => s_pc_ld, 
              PC_INC        => s_pc_inc,  
              PC_MUX_SEL    => s_pc_mux_sel, 
    
              SP_LD         => SP_LD, 
              SP_INCR       => SP_INCR, 
              SP_DECR       => SP_DECR, 
    
              RF_WR         => RF_WR, 
              RF_WR_SEL     => RF_WR_SEL, 
    
              ALU_OPY_SEL   => ALU_OPY_SEL, 
              ALU_SEL       => ALU_SEL,
              
              SCR_WR        => SCR_WR, 
              SCR_ADDR_SEL  => SCR_ADDR_SEL,              
              SCR_DATA_SEL  => SCR_DATA_SEL,
              
              FLG_C_LD      => FLG_C_LD, 
              FLG_C_SET     => FLG_C_SET, 
              FLG_C_CLR     => FLG_C_CLR, 
              FLG_SHAD_LD   => FLG_SHAD_LD, 
              FLG_LD_SEL    => FLG_LD_SEL, 
              FLG_Z_LD      => FLG_Z_LD, 
              I_SET    => I_SET, 
              I_CLR    => I_CLR,  
    
              RST           => RST,
              IO_STRB       => IO_STRB);
              
    
    my_regfile: RegisterFile 
    port map ( D_IN   => D_IN,   
              DX_OUT => DX_OUT,   
              DY_OUT => DY_OUT,   
              ADRX   => s_inst_reg ( 12 downto 8),   
              ADRY   => s_inst_reg ( 7 downto 3),     
              WR     => RF_WR,   
              CLK    => CLK); 
    
    
    my_PC: PC 
    port map ( RST        => RST,
              CLK        => CLK,
              PC_LD      => s_pc_ld,
              PC_INC     => s_pc_inc,
              FROM_IMMED => s_inst_reg (12 downto 3),
              FROM_STACK => R_DATA_OUT,
              FROM_INTRR => "1111111111",
              PC_MUX_SEL => s_pc_mux_sel,
              PC_COUNT   => s_pc_count); 
              
    REG_MUX: MuxFourOne_8Bit
    port map (   IN_0 => ALU_RES,
                 IN_1 => R_DATA_OUT(7 downto 0),
                 IN_2 => B,
                 IN_3 => IN_PORT,
                 OUTPUT => D_IN,
                 SEL => RF_WR_SEL);
                 
    ALU_MUX: MuxTwoONe_8Bit
    port map ( IN_0 => DY_OUT,
               IN_1 => s_inst_reg(7 downto 0),
               SEL => ALU_OPY_SEL,
               OUTPUT => B_IN);
               
               
    StackPointer: SP 
    port map (RST => RST,
              LD => SP_LD,
              INCR => SP_INCR,
              DECR => SP_DECR,
              DATA_IN => DX_OUT,
              CLK => CLK,
              DATA_OUT => B);

    Bm1 <= std_logic_vector(unsigned(B) - "00000001");           
    SCR_MUX1: MuxFourOne_8Bit
    port map (     IN_0 => DY_OUT,
                   IN_1 => s_inst_reg(7 downto 0),
                   IN_2 => B,
                   IN_3 => Bm1,
                   OUTPUT => R_ADDR,
                   SEL => SCR_ADDR_SEL);
    
    R_DX_OUT <= "00" & DX_OUT;
                   
    SCR_MUX2: MuxTwoOne_10Bit 
    port map (IN_0 => R_DX_OUT,
              IN_1 => s_pc_count,
              SEL => SCR_DATA_SEL,
              OUTPUT => R_DATA_IN);

    SCR: Scratch_RAM
    port map (   DATA_IN  => R_DATA_IN,
                 DATA_OUT => R_DATA_OUT,
                 ADDR     => R_ADDR,
                 WE       => SCR_WR, 
                 CLK      => CLK);
                 
    Interrupt: I 
    port map ( I_SET => I_SET,
               I_CLR => I_CLR,
               CLK => CLK,
               OUTPUT => s_OUT);
     

    OUT_PORT <= DX_OUT;
    PORT_ID <= s_inst_reg(7 downto 0);
end Behavioral;
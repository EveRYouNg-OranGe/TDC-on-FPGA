--------------------------------------------------------------
 --  Copyright (c) 2011-2022 Anlogic, Inc.
 --  All Right Reserved.
--------------------------------------------------------------
 -- Log	:	This file is generated by Anlogic IP Generator.
 -- File	:	D:/Learn/_EE/GraduationDesign/Project/8_The_Real_Start/4_TDC_master/tdc_core/pll/pll.vhd
 -- Date	:	2024 03 12
 -- TD version	:	5.6.59063
--------------------------------------------------------------

-------------------------------------------------------------------------------
--	Input frequency:             24.000MHz
--	Clock multiplication factor: 50
--	Clock division factor:       1
--	Clock information:
--		Clock name	| Frequency 	| Phase shift
--		C0        	| 200.000000MHZ	| 0  DEG     
--		C1        	| 92.307692 MHZ	| 0  DEG     
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.std_logic_arith.ALL;
LIBRARY eagle_macro;
USE eagle_macro.EAGLE_COMPONENTS.ALL;

ENTITY pll IS
  PORT (
    refclk : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    extlock : OUT STD_LOGIC;
    clk0_out : OUT STD_LOGIC;
    clk1_out : OUT STD_LOGIC 
  );
END pll;

ARCHITECTURE rtl OF pll IS
  SIGNAL clkc_wire :  STD_LOGIC_VECTOR (4 DOWNTO 0);
BEGIN
  pll_inst : EG_PHY_PLL
  GENERIC MAP (
    DPHASE_SOURCE => "DISABLE",
    DYNCFG => "DISABLE",
    FIN => "24.000",
    FEEDBK_MODE => "NOCOMP",
    FEEDBK_PATH => "VCO_PHASE_0",
    STDBY_ENABLE => "DISABLE",
    PLLRST_ENA => "ENABLE",
    SYNC_ENABLE => "DISABLE",
    DERIVE_PLL_CLOCKS => "DISABLE",
    GEN_BASIC_CLOCK => "DISABLE",
    GMC_GAIN => 2,
    ICP_CURRENT => 9,
    KVCO => 2,
    LPF_CAPACITOR => 1,
    LPF_RESISTOR => 8,
    REFCLK_DIV => 1,
    FBCLK_DIV => 50,
    CLKC0_ENABLE => "ENABLE",
    CLKC0_DIV => 6,
    CLKC0_CPHASE => 5,
    CLKC0_FPHASE => 0,
    CLKC1_ENABLE => "ENABLE",
    CLKC1_DIV => 13,
    CLKC1_CPHASE => 12,
    CLKC1_FPHASE => 0 
  )
  PORT MAP (
    refclk => refclk,
    reset => reset,
    stdby => '0',
    extlock => extlock,
    load_reg => '0',
    psclk => '0',
    psdown => '0',
    psstep => '0',
    psclksel => b"000",
    dclk => '0',
    dcs => '0',
    dwe => '0',
    di => b"00000000",
    daddr => b"000000",
    fbclk => '0',
    clkc => clkc_wire 
  );

  clk1_out <= clkc_wire(1);
  clk0_out <= clkc_wire(0);

END rtl;

-------------------------------------------------------------------------------
-- Title      : Virtex-5 Ethernet MAC Wrapper Top Level
-- Project    : Virtex-5 Embedded Tri-Mode Ethernet MAC Wrapper
-- File       : v5_emac_v1_8_block.vhd
-- Version    : 1.8
-------------------------------------------------------------------------------
--
-- (c) Copyright 2004-2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-------------------------------------------------------------------------------
-- Description:  This is the EMAC block level VHDL design for the Virtex-5 
--               Embedded Ethernet MAC Example Design.  It is intended that
--               this example design can be quickly adapted and downloaded onto
--               an FPGA to provide a real hardware test environment.
--
--               The block level:
--
--               * instantiates all clock management logic required (BUFGs, 
--                 DCMs) to operate the EMAC and its example design;
--
--               * instantiates appropriate PHY interface modules (GMII, MII,
--                 RGMII, SGMII or 1000BASE-X) as required based on the user
--                 configuration.
--
--
--               Please refer to the Datasheet, Getting Started Guide, and
--               the Virtex-5 Embedded Tri-Mode Ethernet MAC User Gude for
--               further information.
-------------------------------------------------------------------------------


library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;



-------------------------------------------------------------------------------
-- The entity declaration for the top level design.
-------------------------------------------------------------------------------
entity v5_emac_v1_8_block is
   port(
      -- EMAC0 Clocking
      -- TX Client Clock output from EMAC0
      TX_CLIENT_CLK_OUT_0             : out std_logic;
      -- RX Client Clock output from EMAC0
      RX_CLIENT_CLK_OUT_0             : out std_logic;
      -- TX PHY Clock output from EMAC0
      TX_PHY_CLK_OUT_0                : out std_logic;
      -- EMAC0 TX Client Clock input from BUFG
      TX_CLIENT_CLK_0                 : in  std_logic;
      -- EMAC0 RX Client Clock input from BUFG
      RX_CLIENT_CLK_0                 : in  std_logic;
      -- EMAC0 TX PHY Clock input from BUFG
      TX_PHY_CLK_0                    : in  std_logic;
      -- Speed indicator for EMAC0
      -- Used in clocking circuitry in example_design file.
      EMAC0SPEEDIS10100               : out std_logic;

      -- Client Receiver Interface - EMAC0
      EMAC0CLIENTRXD                  : out std_logic_vector(7 downto 0);
      EMAC0CLIENTRXDVLD               : out std_logic;
      EMAC0CLIENTRXGOODFRAME          : out std_logic;
      EMAC0CLIENTRXBADFRAME           : out std_logic;
      EMAC0CLIENTRXFRAMEDROP          : out std_logic;
      EMAC0CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD           : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC0
      CLIENTEMAC0TXD                  : in  std_logic_vector(7 downto 0);
      CLIENTEMAC0TXDVLD               : in  std_logic;
      EMAC0CLIENTTXACK                : out std_logic;
      CLIENTEMAC0TXFIRSTBYTE          : in  std_logic;
      CLIENTEMAC0TXUNDERRUN           : in  std_logic;
      EMAC0CLIENTTXCOLLISION          : out std_logic;
      EMAC0CLIENTTXRETRANSMIT         : out std_logic;
      CLIENTEMAC0TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC0CLIENTTXSTATS              : out std_logic;
      EMAC0CLIENTTXSTATSVLD           : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ             : in  std_logic;
      CLIENTEMAC0PAUSEVAL             : in  std_logic_vector(15 downto 0);

 
      -- Clock Signals - EMAC0
      GTX_CLK_0                       : in  std_logic;
      -- GMII Interface - EMAC0
      GMII_TXD_0                      : out std_logic_vector(7 downto 0);
      GMII_TX_EN_0                    : out std_logic;
      GMII_TX_ER_0                    : out std_logic;
      GMII_TX_CLK_0                   : out std_logic;
      GMII_RXD_0                      : in  std_logic_vector(7 downto 0);
      GMII_RX_DV_0                    : in  std_logic;
      GMII_RX_ER_0                    : in  std_logic;
      GMII_RX_CLK_0                   : in  std_logic;

      MII_TX_CLK_0                    : in  std_logic;
      GMII_COL_0                      : in  std_logic;
      GMII_CRS_0                      : in  std_logic;

        
        
      -- Asynchronous Reset
      RESET                           : in  std_logic
   );
end v5_emac_v1_8_block;


architecture TOP_LEVEL of v5_emac_v1_8_block is

-------------------------------------------------------------------------------
-- Component Declarations for lower hierarchial level entities
-------------------------------------------------------------------------------
  -- Component Declaration for the main EMAC wrapper
  component v5_emac_v1_8 is
    port(
      -- Client Receiver Interface - EMAC0
      EMAC0CLIENTRXCLIENTCLKOUT       : out std_logic;
      CLIENTEMAC0RXCLIENTCLKIN        : in  std_logic;
      EMAC0CLIENTRXD                  : out std_logic_vector(7 downto 0);
      EMAC0CLIENTRXDVLD               : out std_logic;
      EMAC0CLIENTRXDVLDMSW            : out std_logic;
      EMAC0CLIENTRXGOODFRAME          : out std_logic;
      EMAC0CLIENTRXBADFRAME           : out std_logic;
      EMAC0CLIENTRXFRAMEDROP          : out std_logic;
      EMAC0CLIENTRXSTATS              : out std_logic_vector(6 downto 0);
      EMAC0CLIENTRXSTATSVLD           : out std_logic;
      EMAC0CLIENTRXSTATSBYTEVLD       : out std_logic;

      -- Client Transmitter Interface - EMAC0
      EMAC0CLIENTTXCLIENTCLKOUT       : out std_logic;
      CLIENTEMAC0TXCLIENTCLKIN        : in  std_logic;
      CLIENTEMAC0TXD                  : in  std_logic_vector(7 downto 0);
      CLIENTEMAC0TXDVLD               : in  std_logic;
      CLIENTEMAC0TXDVLDMSW            : in  std_logic;
      EMAC0CLIENTTXACK                : out std_logic;
      CLIENTEMAC0TXFIRSTBYTE          : in  std_logic;
      CLIENTEMAC0TXUNDERRUN           : in  std_logic;
      EMAC0CLIENTTXCOLLISION          : out std_logic;
      EMAC0CLIENTTXRETRANSMIT         : out std_logic;
      CLIENTEMAC0TXIFGDELAY           : in  std_logic_vector(7 downto 0);
      EMAC0CLIENTTXSTATS              : out std_logic;
      EMAC0CLIENTTXSTATSVLD           : out std_logic;
      EMAC0CLIENTTXSTATSBYTEVLD       : out std_logic;

      -- MAC Control Interface - EMAC0
      CLIENTEMAC0PAUSEREQ             : in  std_logic;
      CLIENTEMAC0PAUSEVAL             : in  std_logic_vector(15 downto 0);

      -- Clock Signals - EMAC0
      GTX_CLK_0                       : in  std_logic;
      PHYEMAC0TXGMIIMIICLKIN          : in  std_logic;
      EMAC0PHYTXGMIIMIICLKOUT         : out std_logic;

      -- GMII Interface - EMAC0
      GMII_TXD_0                      : out std_logic_vector(7 downto 0);
      GMII_TX_EN_0                    : out std_logic;
      GMII_TX_ER_0                    : out std_logic;
      GMII_RXD_0                      : in  std_logic_vector(7 downto 0);
      GMII_RX_DV_0                    : in  std_logic;
      GMII_RX_ER_0                    : in  std_logic;
      GMII_RX_CLK_0                   : in  std_logic;

      
      MII_TX_CLK_0                    : in  std_logic;
      GMII_COL_0                      : in  std_logic;
      GMII_CRS_0                      : in  std_logic;

      EMAC0SPEEDIS10100               : out std_logic;


      DCM_LOCKED_0                    : in  std_logic;

      -- Asynchronous Reset
      RESET                           : in  std_logic
    );
  end component;


 
  -- Component Declaration for the GMII Physcial Interface 
  component gmii_if
    port(
      RESET                           : in  std_logic;
      -- GMII Interface
      GMII_TXD                        : out std_logic_vector(7 downto 0);
      GMII_TX_EN                      : out std_logic;
      GMII_TX_ER                      : out std_logic;
      GMII_TX_CLK                     : out std_logic;
      GMII_RXD                        : in  std_logic_vector(7 downto 0);
      GMII_RX_DV                      : in  std_logic;
      GMII_RX_ER                      : in  std_logic;
      -- MAC Interface
      TXD_FROM_MAC                    : in  std_logic_vector(7 downto 0);
      TX_EN_FROM_MAC                  : in  std_logic;
      TX_ER_FROM_MAC                  : in  std_logic;
      TX_CLK                          : in  std_logic;
      RXD_TO_MAC                      : out std_logic_vector(7 downto 0);
      RX_DV_TO_MAC                    : out std_logic;
      RX_ER_TO_MAC                    : out std_logic;
      RX_CLK                          : in  std_logic);
  end component;

  -- Component declaration for the FCS block
  component emac0_fcs_blk_mii is
   port(
      -- Global signals
      reset               : in  std_logic;
      -- PHY-side input signals
      tx_phy_clk          : in  std_logic;
      txd_from_mac        : in  std_logic_vector(7 downto 0);
      tx_en_from_mac      : in  std_logic;
      tx_er_from_mac      : in  std_logic;
      -- Client-side signals
      tx_client_clk       : in  std_logic;
      tx_stats_byte_valid : in  std_logic;
      tx_collision        : in  std_logic;
      speed_is_10_100     : in  std_logic;
      -- PHY outputs
      txd                 : out std_logic_vector(7 downto 0);
      tx_en               : out std_logic;
      tx_er               : out std_logic
    );
  end component;


-------------------------------------------------------------------------------
-- Signal Declarations
-------------------------------------------------------------------------------

    --  Power and ground signals
    signal gnd_i                          : std_logic;
    signal vcc_i                          : std_logic;

    -- Asynchronous reset signals
    signal reset_ibuf_i                   : std_logic;
    signal reset_i                        : std_logic;

    -- EMAC0 Client Clocking Signals
    signal rx_client_clk_out_0_i          : std_logic;
    signal rx_client_clk_in_0_i           : std_logic;
    signal tx_client_clk_out_0_i          : std_logic;
    signal tx_client_clk_in_0_i           : std_logic;
    -- EMAC0 Physical Interface Clocking Signals
    signal tx_gmii_mii_clk_out_0_i        : std_logic;
    signal tx_gmii_mii_clk_in_0_i         : std_logic;
    -- EMAC0 Physical Interface Signals
    signal gmii_tx_en_0_i                 : std_logic;
    signal gmii_tx_er_0_i                 : std_logic;
    signal gmii_txd_0_i                   : std_logic_vector(7 downto 0);
    signal gmii_tx_en_fa_0_i              : std_logic;
    signal gmii_tx_er_fa_0_i              : std_logic;
    signal gmii_txd_fa_0_i                : std_logic_vector(7 downto 0);
    signal mii_tx_clk_0_i                 : std_logic;    
    signal gmii_rx_clk_0_i                : std_logic;
    signal gmii_rx_dv_0_r                 : std_logic;
    signal gmii_rx_er_0_r                 : std_logic;
    signal gmii_rxd_0_r                   : std_logic_vector(7 downto 0);




    -- 125MHz reference clock for EMAC0
    signal gtx_clk_ibufg_0_i              : std_logic;

    -- Speed output from EMAC0 for physical interface clocking
    signal speed_vector_0_i               : std_logic_vector(1 downto 0);
    signal speed_vector_0_int             : std_logic;

    -- EMAC0 FCS block signals
    signal tx_stats_byte_valid_0_i        : std_logic;
    signal tx_collision_0_i               : std_logic;


-------------------------------------------------------------------------------
-- Attribute Declarations 
-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
-- Main Body of Code
-------------------------------------------------------------------------------

begin

    gnd_i     <= '0';
    vcc_i     <= '1';

    ---------------------------------------------------------------------------
    -- Main Reset Circuitry
    ---------------------------------------------------------------------------
    reset_ibuf_i <= RESET;

    reset_i <= reset_ibuf_i;

    ---------------------------------------------------------------------------
    -- GMII circuitry for the Physical Interface of EMAC0
    ---------------------------------------------------------------------------

    gmii0 : gmii_if port map (
        RESET                         => reset_i,
        GMII_TXD                      => GMII_TXD_0,
        GMII_TX_EN                    => GMII_TX_EN_0,
        GMII_TX_ER                    => GMII_TX_ER_0,
        GMII_TX_CLK                   => GMII_TX_CLK_0,
        GMII_RXD                      => GMII_RXD_0,
        GMII_RX_DV                    => GMII_RX_DV_0,
        GMII_RX_ER                    => GMII_RX_ER_0,
        TXD_FROM_MAC                  => gmii_txd_0_i,
        TX_EN_FROM_MAC                => gmii_tx_en_0_i,
        TX_ER_FROM_MAC                => gmii_tx_er_0_i,
        TX_CLK                        => tx_gmii_mii_clk_in_0_i,
        RXD_TO_MAC                    => gmii_rxd_0_r,
        RX_DV_TO_MAC                  => gmii_rx_dv_0_r,
        RX_ER_TO_MAC                  => gmii_rx_er_0_r,
        RX_CLK                        => gmii_rx_clk_0_i);

    -- Instantiate the FCS block to correct possible duplicate
    -- transmission of the final FCS byte
    emac0_fcs_blk_inst : emac0_fcs_blk_mii port map (
        reset               => reset_i,
        tx_phy_clk          => tx_gmii_mii_clk_in_0_i,
        txd_from_mac        => gmii_txd_fa_0_i,
        tx_en_from_mac      => gmii_tx_en_fa_0_i,
        tx_er_from_mac      => gmii_tx_er_fa_0_i,
        tx_client_clk       => tx_client_clk_in_0_i,
        tx_stats_byte_valid => tx_stats_byte_valid_0_i,
        tx_collision        => tx_collision_0_i,
        speed_is_10_100     => speed_vector_0_int,
        txd                 => gmii_txd_0_i,
        tx_en               => gmii_tx_en_0_i,
        tx_er               => gmii_tx_er_0_i
    );

    EMAC0CLIENTTXCOLLISION    <= tx_collision_0_i;
    EMAC0CLIENTTXSTATSBYTEVLD <= tx_stats_byte_valid_0_i;

 
    --------------------------------------------------------------------------
    -- GTX_CLK Clock Management - 125 MHz clock frequency supplied by the user
    -- (Connected to PHYEMAC#GTXCLK of the EMAC primitive)
    --------------------------------------------------------------------------
    gtx_clk_ibufg_0_i <= GTX_CLK_0;



    ------------------------------------------------------------------------
    -- GMII PHY side transmit clock for EMAC0
    ------------------------------------------------------------------------
    tx_gmii_mii_clk_in_0_i <= TX_PHY_CLK_0;
 
    
    ------------------------------------------------------------------------
    -- GMII PHY side Receiver Clock for EMAC0
    ------------------------------------------------------------------------
    gmii_rx_clk_0_i <= GMII_RX_CLK_0;    

    ------------------------------------------------------------------------
    -- GMII client side transmit clock for EMAC0
    ------------------------------------------------------------------------
    tx_client_clk_in_0_i <= TX_CLIENT_CLK_0;

    ------------------------------------------------------------------------
    -- GMII client side receive clock for EMAC0
    ------------------------------------------------------------------------
    rx_client_clk_in_0_i <= RX_CLIENT_CLK_0;

    ------------------------------------------------------------------------
    -- MII Transmitter Clock for EMAC0
    ------------------------------------------------------------------------
    mii_tx_clk_0_i <= MII_TX_CLK_0;




    ------------------------------------------------------------------------
    -- Connect previously derived client clocks to example design output ports
    ------------------------------------------------------------------------
    -- EMAC0 Clocking
    -- TX Client Clock output from EMAC0
    TX_CLIENT_CLK_OUT_0       <= tx_client_clk_out_0_i;
    -- RX Client Clock output from EMAC0
    RX_CLIENT_CLK_OUT_0       <= rx_client_clk_out_0_i;
    -- TX PHY Clock output from EMAC0
    TX_PHY_CLK_OUT_0          <= tx_gmii_mii_clk_out_0_i;


 

    --------------------------------------------------------------------------
    -- Instantiate the EMAC Wrapper (v5_emac_v1_8.vhd)
    --------------------------------------------------------------------------
    v5_emac_wrapper_inst : v5_emac_v1_8
    port map (
        -- Client Receiver Interface - EMAC0
        EMAC0CLIENTRXCLIENTCLKOUT       => rx_client_clk_out_0_i,
        CLIENTEMAC0RXCLIENTCLKIN        => rx_client_clk_in_0_i, 
        EMAC0CLIENTRXD                  => EMAC0CLIENTRXD,
        EMAC0CLIENTRXDVLD               => EMAC0CLIENTRXDVLD,
        EMAC0CLIENTRXDVLDMSW            => open,
        EMAC0CLIENTRXGOODFRAME          => EMAC0CLIENTRXGOODFRAME,
        EMAC0CLIENTRXBADFRAME           => EMAC0CLIENTRXBADFRAME,
        EMAC0CLIENTRXFRAMEDROP          => EMAC0CLIENTRXFRAMEDROP,
        EMAC0CLIENTRXSTATS              => EMAC0CLIENTRXSTATS,
        EMAC0CLIENTRXSTATSVLD           => EMAC0CLIENTRXSTATSVLD,
        EMAC0CLIENTRXSTATSBYTEVLD       => EMAC0CLIENTRXSTATSBYTEVLD,

        -- Client Transmitter Interface - EMAC0
        EMAC0CLIENTTXCLIENTCLKOUT       => tx_client_clk_out_0_i,
        CLIENTEMAC0TXCLIENTCLKIN        => tx_client_clk_in_0_i,
        CLIENTEMAC0TXD                  => CLIENTEMAC0TXD,
        CLIENTEMAC0TXDVLD               => CLIENTEMAC0TXDVLD,
        CLIENTEMAC0TXDVLDMSW            => gnd_i,
        EMAC0CLIENTTXACK                => EMAC0CLIENTTXACK,
        CLIENTEMAC0TXFIRSTBYTE          => CLIENTEMAC0TXFIRSTBYTE,
        CLIENTEMAC0TXUNDERRUN           => CLIENTEMAC0TXUNDERRUN,
        EMAC0CLIENTTXCOLLISION          => tx_collision_0_i,
        EMAC0CLIENTTXRETRANSMIT         => EMAC0CLIENTTXRETRANSMIT,
        CLIENTEMAC0TXIFGDELAY           => CLIENTEMAC0TXIFGDELAY,
        EMAC0CLIENTTXSTATS              => EMAC0CLIENTTXSTATS,
        EMAC0CLIENTTXSTATSVLD           => EMAC0CLIENTTXSTATSVLD,
        EMAC0CLIENTTXSTATSBYTEVLD       => tx_stats_byte_valid_0_i,

        -- MAC Control Interface - EMAC0
        CLIENTEMAC0PAUSEREQ             => CLIENTEMAC0PAUSEREQ,
        CLIENTEMAC0PAUSEVAL             => CLIENTEMAC0PAUSEVAL,

        -- Clock Signals - EMAC0
        GTX_CLK_0                       => gtx_clk_ibufg_0_i,

        EMAC0PHYTXGMIIMIICLKOUT         => tx_gmii_mii_clk_out_0_i,
        PHYEMAC0TXGMIIMIICLKIN          => tx_gmii_mii_clk_in_0_i,

        -- GMII Interface - EMAC0
        GMII_TXD_0                      => gmii_txd_fa_0_i,
        GMII_TX_EN_0                    => gmii_tx_en_fa_0_i,
        GMII_TX_ER_0                    => gmii_tx_er_fa_0_i,
        GMII_RXD_0                      => gmii_rxd_0_r,
        GMII_RX_DV_0                    => gmii_rx_dv_0_r,
        GMII_RX_ER_0                    => gmii_rx_er_0_r,
        GMII_RX_CLK_0                   => gmii_rx_clk_0_i,

        MII_TX_CLK_0                    => mii_tx_clk_0_i,
        GMII_COL_0                      => GMII_COL_0,
        GMII_CRS_0                      => GMII_CRS_0,

        EMAC0SPEEDIS10100               => speed_vector_0_int,


        DCM_LOCKED_0                    => vcc_i,

        -- Asynchronous Reset
        RESET                           => reset_i
        );

  
 

    -- Speed indicator for EMAC0
    -- Used in clocking circuitry in example_design file.
    EMAC0SPEEDIS10100 <= speed_vector_0_int;

 
end TOP_LEVEL;

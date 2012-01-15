##############################################################################
## Filename:          /home/bashton/tmp/drivers/eth_mac_v1_00_a/data/eth_mac_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Sat Oct  8 12:48:37 2011 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "eth_mac" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}

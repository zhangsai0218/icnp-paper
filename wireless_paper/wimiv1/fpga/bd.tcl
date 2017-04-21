
################################################################
# This is a generated script based on design: trd03_base
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source trd03_base_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcku040-ffva1156-2-e
   set_property BOARD_PART xilinx.com:kcu105:part0:1.1 [current_project]
}


# CHANGE DESIGN NAME HERE
set design_name wimi

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: reset_top1
proc create_hier_cell_reset_top1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_reset_top1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir O -from 0 -to 0 interconnect_areset
  create_bd_pin -dir O -from 0 -to 0 -type rst interconnect_aresetn
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn
  create_bd_pin -dir I -type clk slowest_sync_clk

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]
  set_property -dict [ list \
CONFIG.C_AUX_RESET_HIGH {0} \
 ] $proc_sys_reset_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
CONFIG.C_OPERATION {not} \
CONFIG.C_SIZE {1} \
 ] $util_vector_logic_0

  # Create port connections
  connect_bd_net -net M01_ARESETN_1 [get_bd_pins interconnect_aresetn] [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net pcie_dma_wrapper_0_user_clk [get_bd_pins slowest_sync_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
  connect_bd_net -net pcie_dma_wrapper_0_user_lnk_up1 [get_bd_pins ext_reset_in] [get_bd_pins proc_sys_reset_0/ext_reset_in]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net user_linkup_n [get_bd_pins interconnect_areset] [get_bd_pins util_vector_logic_0/Res]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: JESD
proc create_hier_cell_JESD { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_JESD() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O common0_qpll0_lock_out
  create_bd_pin -dir O common0_qpll1_lock_out
  create_bd_pin -dir I -type clk qpll0_refclk
  create_bd_pin -dir I -type clk qpll1_refclk
  create_bd_pin -dir O rx_aresetn
  create_bd_pin -dir I rx_core_clk
  create_bd_pin -dir I -from 0 -to 0 rx_reset
  create_bd_pin -dir O rx_reset_done
  create_bd_pin -dir O rx_sync
  create_bd_pin -dir I -from 0 -to 0 rx_sys_reset
  create_bd_pin -dir I rx_sysref
  create_bd_pin -dir O -from 127 -to 0 rx_tdata
  create_bd_pin -dir O rx_tvalid
  create_bd_pin -dir I -from 3 -to 0 rxn_in
  create_bd_pin -dir I -from 3 -to 0 rxp_in
  create_bd_pin -dir I -type clk s_axi_aclk
  create_bd_pin -dir O tx_aresetn
  create_bd_pin -dir I tx_core_clk
  create_bd_pin -dir I -from 0 -to 0 tx_reset
  create_bd_pin -dir O tx_reset_done
  create_bd_pin -dir I tx_sync
  create_bd_pin -dir I -from 0 -to 0 tx_sys_reset
  create_bd_pin -dir I tx_sysref
  create_bd_pin -dir I -from 127 -to 0 tx_tdata
  create_bd_pin -dir O tx_tready
  create_bd_pin -dir O -from 3 -to 0 txn_out
  create_bd_pin -dir O -from 3 -to 0 txp_out

  # Create instance: jesd204_ADC, and set properties
  set jesd204_ADC [ create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 jesd204_ADC ]
  set_property -dict [ list \
CONFIG.AXICLK_FREQ {100} \
CONFIG.C_DEFAULT_F {1} \
CONFIG.C_DEFAULT_SCR {1} \
CONFIG.C_DEFAULT_SYSREF_ALWAYS {1} \
CONFIG.C_LANES {4} \
CONFIG.C_NODE_IS_TRANSMIT {0} \
CONFIG.SupportLevel {0} \
 ] $jesd204_ADC

  # Create instance: jesd204_DAC, and set properties
  set jesd204_DAC [ create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204:7.0 jesd204_DAC ]
  set_property -dict [ list \
CONFIG.AXICLK_FREQ {100} \
CONFIG.C_DEFAULT_F {1} \
CONFIG.C_DEFAULT_SCR {1} \
CONFIG.C_DEFAULT_SYSREF_ALWAYS {0} \
CONFIG.C_LANES {4} \
CONFIG.C_NODE_IS_TRANSMIT {1} \
CONFIG.GT_Line_Rate {10} \
CONFIG.GT_REFCLK_FREQ {250} \
CONFIG.SupportLevel {0} \
 ] $jesd204_DAC

  # Create instance: jesd204_phy_0, and set properties
  set jesd204_phy_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jesd204_phy:3.1 jesd204_phy_0 ]
  set_property -dict [ list \
CONFIG.C_LANES {4} \
CONFIG.C_PLL_SELECTION {1} \
CONFIG.DRPCLK_FREQ {100} \
CONFIG.GT_Line_Rate {10} \
CONFIG.GT_Location {X0Y16} \
CONFIG.GT_REFCLK_FREQ {250} \
CONFIG.RX_GT_Line_Rate {10} \
CONFIG.RX_GT_REFCLK_FREQ {250} \
CONFIG.RX_PLL_SELECTION {2} \
 ] $jesd204_phy_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net jesd204_DAC_gt0_tx [get_bd_intf_pins jesd204_DAC/gt0_tx] [get_bd_intf_pins jesd204_phy_0/gt0_tx]
  connect_bd_intf_net -intf_net jesd204_DAC_gt1_tx [get_bd_intf_pins jesd204_DAC/gt1_tx] [get_bd_intf_pins jesd204_phy_0/gt1_tx]
  connect_bd_intf_net -intf_net jesd204_DAC_gt2_tx [get_bd_intf_pins jesd204_DAC/gt2_tx] [get_bd_intf_pins jesd204_phy_0/gt2_tx]
  connect_bd_intf_net -intf_net jesd204_DAC_gt3_tx [get_bd_intf_pins jesd204_DAC/gt3_tx] [get_bd_intf_pins jesd204_phy_0/gt3_tx]
  connect_bd_intf_net -intf_net jesd204_phy_0_gt0_rx [get_bd_intf_pins jesd204_ADC/gt0_rx] [get_bd_intf_pins jesd204_phy_0/gt0_rx]
  connect_bd_intf_net -intf_net jesd204_phy_0_gt1_rx [get_bd_intf_pins jesd204_ADC/gt1_rx] [get_bd_intf_pins jesd204_phy_0/gt1_rx]
  connect_bd_intf_net -intf_net jesd204_phy_0_gt2_rx [get_bd_intf_pins jesd204_ADC/gt2_rx] [get_bd_intf_pins jesd204_phy_0/gt2_rx]
  connect_bd_intf_net -intf_net jesd204_phy_0_gt3_rx [get_bd_intf_pins jesd204_ADC/gt3_rx] [get_bd_intf_pins jesd204_phy_0/gt3_rx]

  # Create port connections
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins s_axi_aclk] [get_bd_pins jesd204_ADC/s_axi_aclk] [get_bd_pins jesd204_DAC/s_axi_aclk] [get_bd_pins jesd204_phy_0/drpclk]
  connect_bd_net -net hw_sgl_prepare_0_axi_stream_s2c_tdata [get_bd_pins tx_tdata] [get_bd_pins jesd204_DAC/tx_tdata]
  connect_bd_net -net jesd204_ADC_rx_aresetn [get_bd_pins rx_aresetn] [get_bd_pins jesd204_ADC/rx_aresetn]
  connect_bd_net -net jesd204_ADC_rx_reset_gt [get_bd_pins jesd204_ADC/rx_reset_gt] [get_bd_pins jesd204_phy_0/rx_reset_gt]
  connect_bd_net -net jesd204_ADC_rx_sync [get_bd_pins rx_sync] [get_bd_pins jesd204_ADC/rx_sync]
  connect_bd_net -net jesd204_ADC_rx_tdata [get_bd_pins rx_tdata] [get_bd_pins jesd204_ADC/rx_tdata]
  connect_bd_net -net jesd204_ADC_rx_tvalid [get_bd_pins rx_tvalid] [get_bd_pins jesd204_ADC/rx_tvalid]
  connect_bd_net -net jesd204_ADC_rxencommaalign_out [get_bd_pins jesd204_ADC/rxencommaalign_out] [get_bd_pins jesd204_phy_0/rxencommaalign]
  connect_bd_net -net jesd204_DAC_gt_prbssel_out [get_bd_pins jesd204_DAC/gt_prbssel_out] [get_bd_pins jesd204_phy_0/gt_prbssel]
  connect_bd_net -net jesd204_DAC_tx_aresetn [get_bd_pins tx_aresetn] [get_bd_pins jesd204_DAC/tx_aresetn]
  connect_bd_net -net jesd204_DAC_tx_reset_gt [get_bd_pins jesd204_DAC/tx_reset_gt] [get_bd_pins jesd204_phy_0/tx_reset_gt]
  connect_bd_net -net jesd204_DAC_tx_tready [get_bd_pins tx_tready] [get_bd_pins jesd204_DAC/tx_tready]
  connect_bd_net -net jesd204_phy_0_common0_qpll0_lock_out [get_bd_pins common0_qpll0_lock_out] [get_bd_pins jesd204_phy_0/common0_qpll0_lock_out]
  connect_bd_net -net jesd204_phy_0_common0_qpll1_lock_out [get_bd_pins common0_qpll1_lock_out] [get_bd_pins jesd204_phy_0/common0_qpll1_lock_out]
  connect_bd_net -net jesd204_phy_0_rx_reset_done [get_bd_pins rx_reset_done] [get_bd_pins jesd204_ADC/rx_reset_done] [get_bd_pins jesd204_phy_0/rx_reset_done]
  connect_bd_net -net jesd204_phy_0_rxoutclk [get_bd_pins rx_core_clk] [get_bd_pins jesd204_ADC/rx_core_clk] [get_bd_pins jesd204_phy_0/rx_core_clk]
  connect_bd_net -net jesd204_phy_0_tx_reset_done [get_bd_pins tx_reset_done] [get_bd_pins jesd204_DAC/tx_reset_done] [get_bd_pins jesd204_phy_0/tx_reset_done]
  connect_bd_net -net jesd204_phy_0_txn_out [get_bd_pins txn_out] [get_bd_pins jesd204_phy_0/txn_out]
  connect_bd_net -net jesd204_phy_0_txp_out [get_bd_pins txp_out] [get_bd_pins jesd204_phy_0/txp_out]
  connect_bd_net -net pcie_dma_wrapper_0_user_clk [get_bd_pins tx_core_clk] [get_bd_pins jesd204_DAC/tx_core_clk] [get_bd_pins jesd204_phy_0/tx_core_clk]
  connect_bd_net -net rx_ref_clk_1 [get_bd_pins qpll1_refclk] [get_bd_pins jesd204_phy_0/qpll1_refclk]
  connect_bd_net -net rx_reset_1 [get_bd_pins rx_reset] [get_bd_pins jesd204_ADC/rx_reset]
  connect_bd_net -net rx_sys_reset_1 [get_bd_pins rx_sys_reset] [get_bd_pins jesd204_phy_0/rx_sys_reset]
  connect_bd_net -net rx_sysref_1 [get_bd_pins rx_sysref] [get_bd_pins jesd204_ADC/rx_sysref]
  connect_bd_net -net rxn_in_1 [get_bd_pins rxn_in] [get_bd_pins jesd204_phy_0/rxn_in]
  connect_bd_net -net rxp_in_1 [get_bd_pins rxp_in] [get_bd_pins jesd204_phy_0/rxp_in]
  connect_bd_net -net tx_ref_clk_1 [get_bd_pins qpll0_refclk] [get_bd_pins jesd204_phy_0/qpll0_refclk]
  connect_bd_net -net tx_reset_1 [get_bd_pins tx_reset] [get_bd_pins jesd204_DAC/tx_reset]
  connect_bd_net -net tx_sync_1 [get_bd_pins tx_sync] [get_bd_pins jesd204_DAC/tx_sync]
  connect_bd_net -net tx_sys_reset_1 [get_bd_pins tx_sys_reset] [get_bd_pins jesd204_phy_0/tx_sys_reset]
  connect_bd_net -net tx_sysref_1 [get_bd_pins tx_sysref] [get_bd_pins jesd204_DAC/tx_sysref]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins jesd204_ADC/s_axi_aresetn] [get_bd_pins jesd204_DAC/s_axi_aresetn] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set pcie_7x_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_7x_mgt ]

  # Create ports
  set adc_pd [ create_bd_port -dir O adc_pd ]
  set adcstatus [ create_bd_port -dir I -from 1 -to 0 adcstatus ]
  set clkd_sync [ create_bd_port -dir O clkd_sync ]
  set clkstatus [ create_bd_port -dir I -from 1 -to 0 clkstatus ]
  set common0_qpll0_lock_out [ create_bd_port -dir O common0_qpll0_lock_out ]
  set common0_qpll1_lock_out [ create_bd_port -dir O common0_qpll1_lock_out ]
  set cs_n [ create_bd_port -dir O -from 2 -to 0 cs_n ]
  set dac_rst [ create_bd_port -dir O dac_rst ]
  set dac_txen [ create_bd_port -dir O dac_txen ]
  set dacirq [ create_bd_port -dir I dacirq ]
  set led [ create_bd_port -dir O led ]
  set pcie_lnk_up [ create_bd_port -dir O pcie_lnk_up ]
  set rx_core_clk [ create_bd_port -dir I -type clk rx_core_clk ]
  set_property -dict [ list \
CONFIG.CLK_DOMAIN {trd03_base_xdma_0_0_axi_aclk} \
CONFIG.FREQ_HZ {250000000} \
 ] $rx_core_clk
  set rx_ref_clk [ create_bd_port -dir I -type clk rx_ref_clk ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {500000000} \
 ] $rx_ref_clk
  set rx_sync [ create_bd_port -dir O rx_sync ]
  set rx_sysref [ create_bd_port -dir I rx_sysref ]
  set rxn_in [ create_bd_port -dir I -from 3 -to 0 rxn_in ]
  set rxp_in [ create_bd_port -dir I -from 3 -to 0 rxp_in ]
  set sclk [ create_bd_port -dir O sclk ]
  set sdata [ create_bd_port -dir O sdata ]
  set sys_clk [ create_bd_port -dir I -type clk sys_clk ]
  set sys_clk_gt [ create_bd_port -dir I -type clk sys_clk_gt ]
  set sys_reset [ create_bd_port -dir I -type rst sys_reset ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_LOW} \
 ] $sys_reset
  set tx_core_clk [ create_bd_port -dir I -type clk tx_core_clk ]
  set_property -dict [ list \
CONFIG.CLK_DOMAIN {trd03_base_xdma_0_0_axi_aclk} \
CONFIG.FREQ_HZ {250000000} \
 ] $tx_core_clk
  set tx_ref_clk [ create_bd_port -dir I -type clk tx_ref_clk ]
  set_property -dict [ list \
CONFIG.FREQ_HZ {500000000} \
 ] $tx_ref_clk
  set tx_sync [ create_bd_port -dir I tx_sync ]
  set tx_sysref [ create_bd_port -dir I tx_sysref ]
  set txn_out [ create_bd_port -dir O -from 3 -to 0 txn_out ]
  set txp_out [ create_bd_port -dir O -from 3 -to 0 txp_out ]
  set user_clk [ create_bd_port -dir O user_clk ]

  # Create instance: DAQ2_CONTROLLER_0, and set properties
  set DAQ2_CONTROLLER_0 [ create_bd_cell -type ip -vlnv user.org:user:DAQ2_CONTROLLER:1.0 DAQ2_CONTROLLER_0 ]

  # Create instance: JESD
  create_hier_cell_JESD [current_bd_instance .] JESD

  # Create instance: JESD204B_PCIE_BRIDGE_0, and set properties
  set JESD204B_PCIE_BRIDGE_0 [ create_bd_cell -type ip -vlnv UW-Madison:WiMi:JESD204B_PCIE_BRIDGE:2.0 JESD204B_PCIE_BRIDGE_0 ]

  # Create instance: axi_lite_interconnect_1, and set properties
  set axi_lite_interconnect_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_lite_interconnect_1 ]
  set_property -dict [ list \
CONFIG.M00_HAS_REGSLICE {1} \
CONFIG.M01_HAS_REGSLICE {1} \
CONFIG.M02_HAS_REGSLICE {1} \
CONFIG.M03_HAS_REGSLICE {1} \
CONFIG.NUM_MI {2} \
CONFIG.NUM_SI {1} \
CONFIG.S00_HAS_REGSLICE {3} \
 ] $axi_lite_interconnect_1

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_0 ]
  set_property -dict [ list \
CONFIG.HAS_TREADY {1} \
CONFIG.TDATA_NUM_BYTES {16} \
 ] $axis_register_slice_0

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_1 ]
  set_property -dict [ list \
CONFIG.HAS_TREADY {1} \
CONFIG.TDATA_NUM_BYTES {16} \
 ] $axis_register_slice_1

  # Create instance: axis_register_slice_2, and set properties
  set axis_register_slice_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_2 ]
  set_property -dict [ list \
CONFIG.HAS_TLAST {1} \
CONFIG.HAS_TREADY {1} \
CONFIG.TDATA_NUM_BYTES {32} \
 ] $axis_register_slice_2

  # Create instance: axis_register_slice_3, and set properties
  set axis_register_slice_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_register_slice:1.1 axis_register_slice_3 ]
  set_property -dict [ list \
CONFIG.HAS_TLAST {1} \
CONFIG.HAS_TREADY {1} \
CONFIG.TDATA_NUM_BYTES {32} \
 ] $axis_register_slice_3

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {40.0} \
CONFIG.CLKOUT1_JITTER {107.111} \
CONFIG.CLKOUT1_PHASE_ERROR {85.928} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100} \
CONFIG.MMCM_CLKIN1_PERIOD {4.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.USE_LOCKED {true} \
CONFIG.USE_RESET {false} \
 ] $clk_wiz_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS.VALUE_SRC {DEFAULT} \
CONFIG.CLKOUT1_PHASE_ERROR.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN1_PERIOD.VALUE_SRC {DEFAULT} \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
 ] $clk_wiz_0

  # Create instance: reset_top1
  create_hier_cell_reset_top1 [current_bd_instance .] reset_top1

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:2.0 xdma_0 ]
  set_property -dict [ list \
CONFIG.PCIE_BOARD_INTERFACE {pci_express_x8} \
CONFIG.axi_data_width {256_bit} \
CONFIG.axilite_master_en {true} \
CONFIG.axilite_master_scale {Kilobytes} \
CONFIG.axilite_master_size {32} \
CONFIG.axisten_freq {250} \
CONFIG.cfg_mgmt_if {false} \
CONFIG.coreclk_freq {500} \
CONFIG.pf0_device_id {8038} \
CONFIG.pf0_interrupt_pin {INTA} \
CONFIG.pf0_msi_enabled {false} \
CONFIG.pf0_msix_cap_pba_bir {BAR_1} \
CONFIG.pf0_msix_cap_table_bir {BAR_1} \
CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
CONFIG.pl_link_cap_max_link_width {X8} \
CONFIG.xdma_axi_intf_mm {AXI Stream} \
CONFIG.xdma_pcie_64bit_en {false} \
 ] $xdma_0

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]

  # Create instance: xlconcat_1, and set properties
  set xlconcat_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_1 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net JESD204B_PCIE_BRIDGE_0_M00_AXIS [get_bd_intf_pins JESD204B_PCIE_BRIDGE_0/M00_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net JESD204B_PCIE_BRIDGE_0_M01_AXIS [get_bd_intf_pins JESD204B_PCIE_BRIDGE_0/M01_AXIS] [get_bd_intf_pins axis_register_slice_2/S_AXIS]
  connect_bd_intf_net -intf_net axi_lite_interconnect_1_M00_AXI [get_bd_intf_pins JESD204B_PCIE_BRIDGE_0/S00_AXI] [get_bd_intf_pins axi_lite_interconnect_1/M00_AXI]
  connect_bd_intf_net -intf_net axi_lite_interconnect_1_M01_AXI [get_bd_intf_pins DAQ2_CONTROLLER_0/S00_AXI] [get_bd_intf_pins axi_lite_interconnect_1/M01_AXI]
  connect_bd_intf_net -intf_net axis_register_slice_1_M_AXIS [get_bd_intf_pins JESD204B_PCIE_BRIDGE_0/S01_AXIS] [get_bd_intf_pins axis_register_slice_1/M_AXIS]
  connect_bd_intf_net -intf_net axis_register_slice_2_M_AXIS [get_bd_intf_pins axis_register_slice_2/M_AXIS] [get_bd_intf_pins xdma_0/S_AXIS_C2H_0]
  connect_bd_intf_net -intf_net axis_register_slice_3_M_AXIS [get_bd_intf_pins JESD204B_PCIE_BRIDGE_0/S00_AXIS] [get_bd_intf_pins axis_register_slice_3/M_AXIS]
  connect_bd_intf_net -intf_net xdma_0_M_AXIS_H2C_0 [get_bd_intf_pins axis_register_slice_3/S_AXIS] [get_bd_intf_pins xdma_0/M_AXIS_H2C_0]
  connect_bd_intf_net -intf_net xdma_0_M_AXI_LITE [get_bd_intf_pins axi_lite_interconnect_1/S00_AXI] [get_bd_intf_pins xdma_0/M_AXI_LITE]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_ports pcie_7x_mgt] [get_bd_intf_pins xdma_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net DAQ2_CONTROLLER_0_adc_pd [get_bd_ports adc_pd] [get_bd_pins DAQ2_CONTROLLER_0/adc_pd]
  connect_bd_net -net DAQ2_CONTROLLER_0_clkd_sync [get_bd_ports clkd_sync] [get_bd_pins DAQ2_CONTROLLER_0/clkd_sync]
  connect_bd_net -net DAQ2_CONTROLLER_0_cs_n [get_bd_ports cs_n] [get_bd_pins DAQ2_CONTROLLER_0/cs_n]
  connect_bd_net -net DAQ2_CONTROLLER_0_dac_rst [get_bd_ports dac_rst] [get_bd_pins DAQ2_CONTROLLER_0/dac_rst]
  connect_bd_net -net DAQ2_CONTROLLER_0_dac_txen [get_bd_ports dac_txen] [get_bd_pins DAQ2_CONTROLLER_0/dac_txen]
  connect_bd_net -net DAQ2_CONTROLLER_0_led [get_bd_ports led] [get_bd_pins DAQ2_CONTROLLER_0/led]
  connect_bd_net -net DAQ2_CONTROLLER_0_rx_reset [get_bd_pins DAQ2_CONTROLLER_0/rx_reset] [get_bd_pins JESD/rx_reset]
  connect_bd_net -net DAQ2_CONTROLLER_0_rx_sys_reset [get_bd_pins DAQ2_CONTROLLER_0/rx_sys_reset] [get_bd_pins JESD/tx_sys_reset]
  connect_bd_net -net DAQ2_CONTROLLER_0_sclk [get_bd_ports sclk] [get_bd_pins DAQ2_CONTROLLER_0/sclk]
  connect_bd_net -net DAQ2_CONTROLLER_0_sdout [get_bd_ports sdata] [get_bd_pins DAQ2_CONTROLLER_0/sdout]
  connect_bd_net -net DAQ2_CONTROLLER_0_tx_reset [get_bd_pins DAQ2_CONTROLLER_0/tx_reset] [get_bd_pins JESD/tx_reset]
  connect_bd_net -net JESD_common0_qpll0_lock_out [get_bd_ports common0_qpll0_lock_out] [get_bd_pins JESD/common0_qpll0_lock_out] [get_bd_pins xlconcat_1/In0]
  connect_bd_net -net JESD_common0_qpll1_lock_out [get_bd_ports common0_qpll1_lock_out] [get_bd_pins JESD/common0_qpll1_lock_out] [get_bd_pins xlconcat_1/In1]
  connect_bd_net -net JESD_rx_aresetn [get_bd_pins JESD/rx_aresetn] [get_bd_pins JESD204B_PCIE_BRIDGE_0/s01_axis_aresetn] [get_bd_pins axis_register_slice_1/aresetn]
  connect_bd_net -net JESD_rx_reset_done [get_bd_pins JESD/rx_reset_done] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net JESD_rx_tdata [get_bd_pins JESD/rx_tdata] [get_bd_pins axis_register_slice_1/s_axis_tdata]
  connect_bd_net -net JESD_rx_tvalid [get_bd_pins JESD/rx_tvalid] [get_bd_pins axis_register_slice_1/s_axis_tvalid]
  connect_bd_net -net JESD_rxoutclk [get_bd_ports rx_core_clk] [get_bd_pins JESD/rx_core_clk] [get_bd_pins JESD204B_PCIE_BRIDGE_0/s01_axis_aclk] [get_bd_pins axis_register_slice_1/aclk]
  connect_bd_net -net JESD_tx_aresetn [get_bd_pins JESD/tx_aresetn] [get_bd_pins JESD204B_PCIE_BRIDGE_0/m00_axis_aresetn] [get_bd_pins axis_register_slice_0/aresetn]
  connect_bd_net -net JESD_tx_reset_done [get_bd_pins JESD/tx_reset_done] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net JESD_tx_tready [get_bd_pins JESD/tx_tready] [get_bd_pins axis_register_slice_0/m_axis_tready]
  connect_bd_net -net JESD_txoutclk [get_bd_ports tx_core_clk] [get_bd_pins JESD/tx_core_clk] [get_bd_pins JESD204B_PCIE_BRIDGE_0/m00_axis_aclk] [get_bd_pins axis_register_slice_0/aclk]
  connect_bd_net -net M01_ARESETN_1 [get_bd_pins JESD204B_PCIE_BRIDGE_0/m01_axis_aresetn] [get_bd_pins JESD204B_PCIE_BRIDGE_0/s00_axis_aresetn] [get_bd_pins axi_lite_interconnect_1/ARESETN] [get_bd_pins axi_lite_interconnect_1/S00_ARESETN] [get_bd_pins axis_register_slice_2/aresetn] [get_bd_pins axis_register_slice_3/aresetn] [get_bd_pins xdma_0/axi_aresetn]
  connect_bd_net -net adcstatus_1 [get_bd_ports adcstatus] [get_bd_pins DAQ2_CONTROLLER_0/adcstatus]
  connect_bd_net -net axis_register_slice_0_m_axis_tdata [get_bd_pins JESD/tx_tdata] [get_bd_pins axis_register_slice_0/m_axis_tdata]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins DAQ2_CONTROLLER_0/s00_axi_aclk] [get_bd_pins JESD/s_axi_aclk] [get_bd_pins JESD204B_PCIE_BRIDGE_0/s00_axi_aclk] [get_bd_pins axi_lite_interconnect_1/M00_ACLK] [get_bd_pins axi_lite_interconnect_1/M01_ACLK] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins reset_top1/slowest_sync_clk]
  connect_bd_net -net clkstatus_1 [get_bd_ports clkstatus] [get_bd_pins DAQ2_CONTROLLER_0/clkstatus]
  connect_bd_net -net dacirq_1 [get_bd_ports dacirq] [get_bd_pins DAQ2_CONTROLLER_0/dacirq]
  connect_bd_net -net ext_reset_in_1 [get_bd_ports pcie_lnk_up] [get_bd_pins reset_top1/ext_reset_in] [get_bd_pins xdma_0/user_lnk_up]
  connect_bd_net -net jesd204_ADC_rx_sync [get_bd_ports rx_sync] [get_bd_pins JESD/rx_sync]
  connect_bd_net -net jesd204_phy_0_txn_out [get_bd_ports txn_out] [get_bd_pins JESD/txn_out]
  connect_bd_net -net jesd204_phy_0_txp_out [get_bd_ports txp_out] [get_bd_pins JESD/txp_out]
  connect_bd_net -net pcie_dma_wrapper_0_user_clk [get_bd_ports user_clk] [get_bd_pins JESD204B_PCIE_BRIDGE_0/m01_axis_aclk] [get_bd_pins JESD204B_PCIE_BRIDGE_0/s00_axis_aclk] [get_bd_pins axi_lite_interconnect_1/ACLK] [get_bd_pins axi_lite_interconnect_1/S00_ACLK] [get_bd_pins axis_register_slice_2/aclk] [get_bd_pins axis_register_slice_3/aclk] [get_bd_pins clk_wiz_0/clk_in1] [get_bd_pins xdma_0/axi_aclk]
  connect_bd_net -net reset_top1_interconnect_aresetn [get_bd_pins DAQ2_CONTROLLER_0/s00_axi_aresetn] [get_bd_pins JESD204B_PCIE_BRIDGE_0/s00_axi_aresetn] [get_bd_pins axi_lite_interconnect_1/M00_ARESETN] [get_bd_pins axi_lite_interconnect_1/M01_ARESETN] [get_bd_pins reset_top1/interconnect_aresetn]
  connect_bd_net -net rx_ref_clk_1 [get_bd_ports rx_ref_clk] [get_bd_pins JESD/qpll1_refclk]
  connect_bd_net -net rx_sys_reset_1 [get_bd_pins DAQ2_CONTROLLER_0/tx_sys_reset] [get_bd_pins JESD/rx_sys_reset]
  connect_bd_net -net rx_sysref_1 [get_bd_ports rx_sysref] [get_bd_pins JESD/rx_sysref]
  connect_bd_net -net rxn_in_1 [get_bd_ports rxn_in] [get_bd_pins JESD/rxn_in]
  connect_bd_net -net rxp_in_1 [get_bd_ports rxp_in] [get_bd_pins JESD/rxp_in]
  connect_bd_net -net sys_clk_1 [get_bd_ports sys_clk] [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net sys_clk_gt_1 [get_bd_ports sys_clk_gt] [get_bd_pins xdma_0/sys_clk_gt]
  connect_bd_net -net sys_reset_1 [get_bd_ports sys_reset] [get_bd_pins xdma_0/sys_rst_n]
  connect_bd_net -net tx_ref_clk_1 [get_bd_ports tx_ref_clk] [get_bd_pins JESD/qpll0_refclk]
  connect_bd_net -net tx_sync_1 [get_bd_ports tx_sync] [get_bd_pins JESD/tx_sync]
  connect_bd_net -net tx_sysref_1 [get_bd_ports tx_sysref] [get_bd_pins JESD/tx_sysref]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins DAQ2_CONTROLLER_0/reset_done] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconcat_1_dout [get_bd_pins DAQ2_CONTROLLER_0/clk_locked] [get_bd_pins xlconcat_1/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins JESD204B_PCIE_BRIDGE_0/s01_axis_tlast] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x00000000 [get_bd_addr_spaces xdma_0/M_AXI_LITE] [get_bd_addr_segs DAQ2_CONTROLLER_0/S00_AXI/S00_AXI_reg] SEG_DAQ2_CONTROLLER_0_S00_AXI_reg
  create_bd_addr_seg -range 0x00001000 -offset 0x00001000 [get_bd_addr_spaces xdma_0/M_AXI_LITE] [get_bd_addr_segs JESD204B_PCIE_BRIDGE_0/S00_AXI/S00_AXI_reg] SEG_JESD204B_PCIE_BRIDGE_0_S00_AXI_reg

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   commentid: "",
   guistr: "# # String gsaved with Nlview 6.5.12  2016-01-29 bk=1.3547 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port sys_reset -pg 1 -y 1130 -defaultsOSRD
preplace port tx_ref_clk -pg 1 -y 400 -defaultsOSRD
preplace port adc_pd -pg 1 -y 850 -defaultsOSRD
preplace port clkd_sync -pg 1 -y 790 -defaultsOSRD
preplace port dac_txen -pg 1 -y 810 -defaultsOSRD
preplace port led -pg 1 -y 770 -defaultsOSRD
preplace port sys_clk -pg 1 -y 1090 -defaultsOSRD
preplace port user_clk -pg 1 -y 1130 -defaultsOSRD
preplace port sdata -pg 1 -y 650 -defaultsOSRD
preplace port dacirq -pg 1 -y 720 -defaultsOSRD
preplace port rx_sync -pg 1 -y 400 -defaultsOSRD
preplace port sys_clk_gt -pg 1 -y 1110 -defaultsOSRD
preplace port rx_ref_clk -pg 1 -y 210 -defaultsOSRD
preplace port dac_rst -pg 1 -y 830 -defaultsOSRD
preplace port tx_core_clk -pg 1 -y 320 -defaultsOSRD
preplace port common0_qpll1_lock_out -pg 1 -y 440 -defaultsOSRD
preplace port rx_sysref -pg 1 -y 460 -defaultsOSRD
preplace port tx_sync -pg 1 -y 440 -defaultsOSRD
preplace port pcie_lnk_up -pg 1 -y 1110 -defaultsOSRD
preplace port rx_core_clk -pg 1 -y 90 -defaultsOSRD
preplace port common0_qpll0_lock_out -pg 1 -y 420 -defaultsOSRD
preplace port sclk -pg 1 -y 630 -defaultsOSRD
preplace port tx_sysref -pg 1 -y 420 -defaultsOSRD
preplace port pcie_7x_mgt -pg 1 -y 1090 -defaultsOSRD
preplace portBus cs_n -pg 1 -y 670 -defaultsOSRD
preplace portBus clkstatus -pg 1 -y 680 -defaultsOSRD
preplace portBus txn_out -pg 1 -y 320 -defaultsOSRD
preplace portBus rxn_in -pg 1 -y 230 -defaultsOSRD
preplace portBus txp_out -pg 1 -y 300 -defaultsOSRD
preplace portBus adcstatus -pg 1 -y 700 -defaultsOSRD
preplace portBus rxp_in -pg 1 -y 250 -defaultsOSRD
preplace inst axi_lite_interconnect_1 -pg 1 -lvl 2 -y 820 -defaultsOSRD
preplace inst xlconstant_0 -pg 1 -lvl 2 -y 600 -defaultsOSRD
preplace inst xlconcat_0 -pg 1 -lvl 4 -y 510 -defaultsOSRD
preplace inst JESD -pg 1 -lvl 3 -y 390 -defaultsOSRD
preplace inst axis_register_slice_0 -pg 1 -lvl 3 -y 80 -defaultsOSRD
preplace inst xlconcat_1 -pg 1 -lvl 5 -y 540 -defaultsOSRD
preplace inst axis_register_slice_1 -pg 1 -lvl 4 -y 310 -defaultsOSRD
preplace inst axis_register_slice_2 -pg 1 -lvl 5 -y 950 -defaultsOSRD
preplace inst xdma_0 -pg 1 -lvl 4 -y 1170 -defaultsOSRD
preplace inst JESD204B_PCIE_BRIDGE_0 -pg 1 -lvl 3 -y 870 -defaultsOSRD
preplace inst axis_register_slice_3 -pg 1 -lvl 3 -y 1280 -defaultsOSRD
preplace inst DAQ2_CONTROLLER_0 -pg 1 -lvl 4 -y 760 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 1 -y 670 -defaultsOSRD
preplace inst reset_top1 -pg 1 -lvl 1 -y 1020 -defaultsOSRD
preplace netloc JESD204B_PCIE_BRIDGE_0_M00_AXIS 1 2 2 760 10 1240
preplace netloc DAQ2_CONTROLLER_0_clkd_sync 1 4 2 NJ 790 NJ
preplace netloc adcstatus_1 1 0 4 NJ 730 NJ 970 NJ 1050 NJ
preplace netloc JESD_tx_aresetn 1 2 2 NJ 640 1210
preplace netloc JESD_rx_aresetn 1 2 2 NJ 650 1310
preplace netloc DAQ2_CONTROLLER_0_dac_rst 1 4 2 NJ 830 NJ
preplace netloc JESD_rxoutclk 1 0 4 NJ 90 NJ 90 NJ 630 NJ
preplace netloc DAQ2_CONTROLLER_0_led 1 4 2 NJ 770 NJ
preplace netloc JESD_common0_qpll1_lock_out 1 3 3 N 420 NJ 440 NJ
preplace netloc tx_sync_1 1 0 3 NJ 390 NJ 390 NJ
preplace netloc axis_register_slice_3_M_AXIS 1 2 2 800 1120 1220
preplace netloc axis_register_slice_0_m_axis_tdata 1 2 2 770 610 1220
preplace netloc DAQ2_CONTROLLER_0_adc_pd 1 4 2 NJ 850 NJ
preplace netloc DAQ2_CONTROLLER_0_dac_txen 1 4 2 NJ 820 NJ
preplace netloc DAQ2_CONTROLLER_0_rx_reset 1 2 3 810 580 NJ 580 1720
preplace netloc JESD_tx_reset_done 1 3 1 1320
preplace netloc sys_reset_1 1 0 4 NJ 1130 NJ 1130 NJ 1130 NJ
preplace netloc DAQ2_CONTROLLER_0_sdout 1 4 2 1760 650 NJ
preplace netloc xlconcat_1_dout 1 3 3 1340 430 NJ 430 2020
preplace netloc sys_clk_1 1 0 4 NJ 1100 NJ 1100 NJ 1150 NJ
preplace netloc pcie_dma_wrapper_0_user_clk 1 0 6 -80 750 320 680 NJ 1110 NJ 1030 1730 1130 NJ
preplace netloc rxp_in_1 1 0 3 NJ 240 NJ 240 NJ
preplace netloc rx_sys_reset_1 1 2 3 790 620 NJ 570 1730
preplace netloc DAQ2_CONTROLLER_0_rx_sys_reset 1 2 3 800 590 NJ 590 1710
preplace netloc jesd204_ADC_rx_sync 1 3 3 NJ 400 NJ 400 NJ
preplace netloc tx_sysref_1 1 0 3 NJ 350 NJ 350 NJ
preplace netloc axi_lite_interconnect_1_M01_AXI 1 2 2 660 690 NJ
preplace netloc xlconstant_0_dout 1 2 1 690
preplace netloc clkstatus_1 1 0 4 NJ 740 NJ 980 NJ 1090 NJ
preplace netloc xlconcat_0_dout 1 3 2 1350 450 1700
preplace netloc tx_ref_clk_1 1 0 3 NJ 250 NJ 250 NJ
preplace netloc rxn_in_1 1 0 3 NJ 230 NJ 230 NJ
preplace netloc clk_wiz_0_clk_out1 1 0 4 -110 880 290 660 710 1060 NJ
preplace netloc ext_reset_in_1 1 0 6 -80 1090 NJ 1090 NJ 1100 NJ 1050 1720 1110 NJ
preplace netloc axis_register_slice_2_M_AXIS 1 3 3 1350 940 NJ 880 2020
preplace netloc JESD204B_PCIE_BRIDGE_0_M01_AXIS 1 3 2 NJ 930 NJ
preplace netloc JESD_rx_tvalid 1 3 1 1260
preplace netloc DAQ2_CONTROLLER_0_cs_n 1 4 2 1770 670 NJ
preplace netloc dacirq_1 1 0 4 NJ 760 NJ 990 NJ 1070 NJ
preplace netloc xdma_0_pcie_mgt 1 4 2 NJ 1090 NJ
preplace netloc axi_lite_interconnect_1_M00_AXI 1 2 1 670
preplace netloc rx_ref_clk_1 1 0 3 NJ 210 NJ 210 NJ
preplace netloc xdma_0_M_AXI_LITE 1 1 4 330 670 NJ 670 NJ 950 1710
preplace netloc JESD_rx_tdata 1 3 1 1270
preplace netloc JESD_txoutclk 1 0 3 NJ 320 NJ 320 NJ
preplace netloc sys_clk_gt_1 1 0 4 NJ 1170 NJ 1170 NJ 1170 NJ
preplace netloc JESD_common0_qpll0_lock_out 1 3 3 NJ 410 NJ 410 NJ
preplace netloc reset_top1_interconnect_aresetn 1 1 3 300 1010 NJ 1080 NJ
preplace netloc rx_sysref_1 1 0 3 NJ 410 NJ 410 NJ
preplace netloc jesd204_phy_0_txp_out 1 3 3 NJ 220 NJ 220 NJ
preplace netloc xdma_0_M_AXIS_H2C_0 1 2 3 810 1160 NJ 1060 1700
preplace netloc axis_register_slice_1_M_AXIS 1 2 3 810 680 NJ 920 1740
preplace netloc JESD_tx_tready 1 3 1 1230
preplace netloc DAQ2_CONTROLLER_0_tx_reset 1 2 3 780 600 NJ 600 1700
preplace netloc DAQ2_CONTROLLER_0_sclk 1 4 2 NJ 630 NJ
preplace netloc JESD_rx_reset_done 1 3 1 1330
preplace netloc M01_ARESETN_1 1 1 4 330 960 NJ 1210 NJ 1280 1770
preplace netloc jesd204_phy_0_txn_out 1 3 3 NJ 200 NJ 200 NJ
levelinfo -pg 1 -140 100 480 1040 1560 1910 2060 -top -10 -bot 1350
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



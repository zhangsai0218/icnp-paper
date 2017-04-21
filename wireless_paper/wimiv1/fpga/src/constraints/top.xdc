# daq2
set_property -dict {PACKAGE_PIN GTHE3_COMMON_X0Y4} [get_ports rx_ref_clk_p]
set_property -dict {PACKAGE_PIN GTHE3_COMMON_X0Y4} [get_ports rx_ref_clk_n]
set_property -dict {PACKAGE_PIN G9 IOSTANDARD LVDS} [get_ports rx_sync_p]
set_property -dict {PACKAGE_PIN F9 IOSTANDARD LVDS} [get_ports rx_sync_n]
set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_p]
set_property -dict {PACKAGE_PIN A12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports rx_sysref_n]

set_property -dict {PACKAGE_PIN GTHE3_COMMON_X0Y4} [get_ports tx_ref_clk_p]
set_property -dict {PACKAGE_PIN GTHE3_COMMON_X0Y4} [get_ports tx_ref_clk_n]
set_property -dict {PACKAGE_PIN K10 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_p]
set_property -dict {PACKAGE_PIN J10 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sync_n]
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_p]
set_property -dict {PACKAGE_PIN K12 IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports tx_sysref_n]

set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS18} [get_ports cs_clk]
set_property -dict {PACKAGE_PIN L8 IOSTANDARD LVCMOS18} [get_ports cs_dac]
set_property -dict {PACKAGE_PIN H9 IOSTANDARD LVCMOS18} [get_ports cs_adc]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS18} [get_ports sclk]
set_property -dict {PACKAGE_PIN J9 IOSTANDARD LVCMOS18} [get_ports sdata]
set_property -dict {PACKAGE_PIN H8 IOSTANDARD LVCMOS18} [get_ports spi_dir]

set_property -dict {PACKAGE_PIN J8 IOSTANDARD LVCMOS18} [get_ports clkd_sync]
set_property -dict {PACKAGE_PIN K8 IOSTANDARD LVCMOS18} [get_ports dac_reset]
set_property -dict {PACKAGE_PIN D10 IOSTANDARD LVCMOS18} [get_ports dac_txen]
set_property -dict {PACKAGE_PIN D13 IOSTANDARD LVCMOS18} [get_ports adc_pd]

set_property -dict {PACKAGE_PIN D9 IOSTANDARD LVCMOS18} [get_ports {clock_status[0]}]
set_property -dict {PACKAGE_PIN C9 IOSTANDARD LVCMOS18} [get_ports {clock_status[1]}]
set_property -dict {PACKAGE_PIN E10 IOSTANDARD LVCMOS18} [get_ports dac_irq]
set_property -dict {PACKAGE_PIN K11 IOSTANDARD LVCMOS18} [get_ports adc_fda]
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS18} [get_ports adc_fdb]

set_property -dict {PACKAGE_PIN AL14 IOSTANDARD LVCMOS12} [get_ports {gpio_ant_cntl[0]}]
set_property -dict {PACKAGE_PIN AM14 IOSTANDARD LVCMOS12} [get_ports {gpio_ant_cntl[1]}]
set_property -dict {PACKAGE_PIN AP16 IOSTANDARD LVCMOS12} [get_ports {gpio_ant_cntl[2]}]
set_property -dict {PACKAGE_PIN AP15 IOSTANDARD LVCMOS12} [get_ports {gpio_ant_cntl[3]}]


##set_property  -dict {PACKAGE_PIN  F8  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_p]            ; ## H13  FMC_HPC_LA07_P
##set_property  -dict {PACKAGE_PIN  E8  IOSTANDARD LVDS DIFF_TERM_ADV TERM_100} [get_ports trig_n]            ; ## H14  FMC_HPC_LA07_N


##### SYS RESET###########
set_property LOC PCIE_3_1_X0Y0 [get_cells trd03_base_i/xdma_0/inst/pcie3_ip_i/inst/pcie3_uscale_top_inst/pcie3_uscale_wrapper_inst/PCIE_3_1_inst]
set_property PACKAGE_PIN K22 [get_ports perst_n]
set_property PULLUP true [get_ports perst_n]
set_property IOSTANDARD LVCMOS18 [get_ports perst_n]
set_false_path -from [get_ports perst_n]
##### SYS CLK###########

set_property LOC GTHE3_COMMON_X0Y1 [get_cells refclk_ibuf]


###############################################################################
# User Time Names / User Time Groups / Time Specs
###############################################################################
create_clock -period 10.000 -name sys_clk [get_ports pcie_ref_clk_p]
create_clock -period 4.000 -name tx_ref_clk [get_ports tx_ref_clk_p]
create_clock -period 4.000 -name rx_ref_clk [get_ports rx_ref_clk_p]
##create_clock -name tx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_daq2_gt/inst/g_lane_1[0].i_channel/i_gt/i_gthe3_channel/TXOUTCLK]
##create_clock -name rx_div_clk   -period  4.00 [get_pins i_system_wrapper/system_i/axi_daq2_gt/inst/g_lane_1[0].i_channel/i_gt/i_gthe3_channel/RXOUTCLK]

# gt pin assignments below are for reference only and are ignored by the tool!

##  set_property  -dict {PACKAGE_PIN  A4} [get_ports rx_data_p[0]] ; ## A10  FMC_HPC_DP3_M2C_P
##  set_property  -dict {PACKAGE_PIN  A3} [get_ports rx_data_n[0]] ; ## A11  FMC_HPC_DP3_M2C_N
##  set_property  -dict {PACKAGE_PIN  E4} [get_ports rx_data_p[1]] ; ## C06  FMC_HPC_DP0_M2C_P
##  set_property  -dict {PACKAGE_PIN  E3} [get_ports rx_data_n[1]] ; ## C07  FMC_HPC_DP0_M2C_N
##  set_property  -dict {PACKAGE_PIN  B2} [get_ports rx_data_p[2]] ; ## A06  FMC_HPC_DP2_M2C_P
##  set_property  -dict {PACKAGE_PIN  B1} [get_ports rx_data_n[2]] ; ## A07  FMC_HPC_DP2_M2C_N
##  set_property  -dict {PACKAGE_PIN  D2} [get_ports rx_data_p[3]] ; ## A02  FMC_HPC_DP1_M2C_P
##  set_property  -dict {PACKAGE_PIN  D1} [get_ports rx_data_n[3]] ; ## A03  FMC_HPC_DP1_M2C_N
##  set_property  -dict {PACKAGE_PIN  B6} [get_ports tx_data_p[0]] ; ## A30  FMC_HPC_DP3_C2M_P (tx_data_p[0])
##  set_property  -dict {PACKAGE_PIN  B5} [get_ports tx_data_n[0]] ; ## A31  FMC_HPC_DP3_C2M_N (tx_data_n[0])
##  set_property  -dict {PACKAGE_PIN  F6} [get_ports tx_data_p[1]] ; ## C02  FMC_HPC_DP0_C2M_P (tx_data_p[3])
##  set_property  -dict {PACKAGE_PIN  F5} [get_ports tx_data_n[1]] ; ## C03  FMC_HPC_DP0_C2M_N (tx_data_n[3])
##  set_property  -dict {PACKAGE_PIN  C4} [get_ports tx_data_p[2]] ; ## A26  FMC_HPC_DP2_C2M_P (tx_data_p[1])
##  set_property  -dict {PACKAGE_PIN  C3} [get_ports tx_data_n[2]] ; ## A27  FMC_HPC_DP2_C2M_N (tx_data_n[1])
##  set_property  -dict {PACKAGE_PIN  D6} [get_ports tx_data_p[3]] ; ## A22  FMC_HPC_DP1_C2M_P (tx_data_p[2])
##  set_property  -dict {PACKAGE_PIN  D5} [get_ports tx_data_n[3]] ; ## A23  FMC_HPC_DP1_C2M_N (tx_data_n[2])

#set_property LOC GTHE3_CHANNEL_X0Y16 [get_cells -hierarchical -filter {NAME =~ *gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]
#set_property LOC GTHE3_CHANNEL_X0Y17 [get_cells -hierarchical -filter {NAME =~ *gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]
#set_property LOC GTHE3_CHANNEL_X0Y18 [get_cells -hierarchical -filter {NAME =~ *gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]
#set_property LOC GTHE3_CHANNEL_X0Y19 [get_cells -hierarchical -filter {NAME =~ *gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]


###############################################################################
# User Physical Constraints
###############################################################################

##-------------------------------------
## LED Status Pinout   (bottom to top)
##-------------------------------------

set_property PACKAGE_PIN AP8 [get_ports {led[0]}]
set_property PACKAGE_PIN H23 [get_ports {led[1]}]
set_property PACKAGE_PIN P20 [get_ports {led[2]}]
set_property PACKAGE_PIN P21 [get_ports {led[3]}]
set_property PACKAGE_PIN N22 [get_ports {led[4]}]
set_property PACKAGE_PIN M22 [get_ports {led[5]}]
set_property PACKAGE_PIN R23 [get_ports {led[6]}]
set_property PACKAGE_PIN P23 [get_ports {led[7]}]


set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[7]}]




















set_false_path -from [get_clocks [get_clocks -of_objects [get_pins trd03_base_i/clk_wiz_0/inst/mmcme3_adv_inst/CLKOUT0]]] -to [list [get_clocks [get_clocks -of_objects [get_pins trd03_base_i/xdma_0/inst/pcie3_ip_i/inst/gt_top_i/phy_clk_i/bufg_gt_userclk/O]]] [get_clocks [list rx_ref_clk [get_clocks -of_objects [get_pins trd03_base_i/xdma_0/inst/pcie3_ip_i/inst/gt_top_i/phy_clk_i/bufg_gt_userclk/O]]]]]
set_input_jitter [get_clocks sys_clk] 0.125

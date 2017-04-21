//-----------------------------------------------------------------------------
//
// (c) Copyright 2014-2015 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information of Xilinx, Inc.
// and is protected under U.S. and international copyright and other
// intellectual property laws.
//
// DISCLAIMER
//
// This disclaimer is not a license and does not grant any rights to the
// materials distributed herewith. Except as otherwise provided in a valid
// license issued to you by Xilinx, and to the maximum extent permitted by
// applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
// FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
// IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
// MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
// and (2) Xilinx shall not be liable (whether in contract or tort, including
// negligence, or under any other theory of liability) for any loss or damage
// of any kind or nature related to, arising under or in connection with these
// materials, including for any direct, or any indirect, special, incidental,
// or consequential loss or damage (including loss of data, profits, goodwill,
// or any type of loss or damage suffered as a result of any action brought by
// a third party) even if such damage or loss was reasonably foreseeable or
// Xilinx had been advised of the possibility of the same.
//
// CRITICAL APPLICATIONS
//
// Xilinx products are not designed or intended to be fail-safe, or for use in
// any application requiring fail-safe performance, such as life-support or
// safety devices or systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any other
// applications that could lead to death, personal injury, or severe property
// or environmental damage (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and liability of any use of
// Xilinx products in Critical Applications, subject only to applicable laws
// and regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
// AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project  : Kintex UltraScale AXI Stream Dataplane Targeted Reference Design
// File     : trd03_base_top.v
//-----------------------------------------------------------------------------
`timescale 1 ps / 1 ps
(* CORE_GENERATION_INFO = "TRD03,kcu105_axis_dataplane,{kcu105_axis_dataplane=2015.2}" *)
module top
(	led,
	cs_adc,
cs_dac,
cs_clk,
sclk,
sdata,
clock_status,
pcie_ref_clk_n,
pcie_ref_clk_p,
pcie_rx_n,
pcie_rx_p,
pcie_tx_n,
pcie_tx_p,
perst_n,
spi_dir,
txp_out,
txn_out,
rxp_in,
rxn_in,
tx_sync_p,
tx_sync_n,
tx_sysref_p,
tx_sysref_n,
rx_sync_p,
rx_sync_n,
rx_sysref_p,
rx_sysref_n,
tx_ref_clk_p,
tx_ref_clk_n,
rx_ref_clk_p,
clkd_sync,
dac_reset,
dac_txen,
adc_pd,
dac_irq,
adc_fda,
adc_fdb,
gpio_ant_cntl,
rx_ref_clk_n

 );


output [ 7:0] led               ;
output        cs_adc            ;
output        cs_dac                  ;
output        cs_clk                  ;
output        sclk                    ;
output        sdata                   ;
input         pcie_ref_clk_n          ;
input         pcie_ref_clk_p          ;
input  [ 7:0] pcie_rx_n               ;
input  [ 7:0] pcie_rx_p               ;
output [ 7:0] pcie_tx_n               ;
output [ 7:0] pcie_tx_p               ;
input         perst_n                 ;
input  [ 1:0] clock_status            ;
output        spi_dir                 ;
output [ 3:0] txp_out                 ;
output [ 3:0] txn_out                 ;
output [ 3:0] gpio_ant_cntl           ;
input  [ 3:0] rxp_in                  ;
input  [ 3:0] rxn_in                  ;
input         tx_sync_p               ;
input         tx_sync_n               ;
input         tx_sysref_p             ;
input         tx_sysref_n             ;
output        rx_sync_p               ;
output        rx_sync_n               ;
input         rx_sysref_p             ;
input         rx_sysref_n             ;
input         tx_ref_clk_p            ;
input         tx_ref_clk_n            ;
input         rx_ref_clk_p            ;
input         rx_ref_clk_n            ;
output        clkd_sync               ;
output        dac_reset               ;
output        dac_txen                ;
output        adc_pd                  ;
input         dac_irq                 ;
input         adc_fda                 ;
input         adc_fdb                 ;


localparam LED_CTR_WIDTH              = 26;
localparam PL_LINK_CAP_MAX_LINK_SPEED = 2 ; //4-GEN3;2-GEN2
localparam NUM_LANES                  = 8 ;

wire                     pcie_ref_clk_n        ;
wire                     pcie_ref_clk_p        ;
wire [              7:0] pcie_rx_n             ;
wire [              7:0] pcie_rx_p             ;
wire [              7:0] pcie_tx_n             ;
wire [              7:0] pcie_tx_p             ;
wire                     perst_n               ;
wire                     user_lnk_up           ;
wire [              2:0] cfg_current_speed     ;
wire [              3:0] cfg_negotiated_width  ;
reg  [LED_CTR_WIDTH-1:0] led_ctr               ;
reg                      lane_width_error      ;
reg                      link_speed_error      ;
wire                     sclk                  ;
reg  [              4:0] spi_cnt               ;
wire                     spi_clk_en            ;
wire                     cs                    ;
wire [              2:0] cs_n                  ;
wire                     tx_ref_clk            ;
wire                     rx_ref_clk            ;
wire                     tx_ref_clk_gt            ;
wire                     rx_ref_clk_gt            ;
wire [              4:0] GPIO_O                ;
wire [              4:0] GPIO_I                ;
wire                     common0_qpll0_lock_out;
wire                     common0_qpll1_lock_out;
wire                     p_dl_link_up          ;
wire                     pcie_lnk_up           ;
wire                     tx_core_clk           ;
wire                     rx_core_clk           ;

  
  
IBUFDS i_ibufds_rx_sysref (
	.I (rx_sysref_p),
	.IB(rx_sysref_n),
	.O (rx_sysref  )
);
    
OBUFDS i_obufds_rx_sync (
	.I (rx_sync  ),
	.O (rx_sync_p),
	.OB(rx_sync_n)
);
  
IBUFDS i_ibufds_tx_sysref (
	.I (tx_sysref_p),
	.IB(tx_sysref_n),
	.O (tx_sysref  )
);
    
IBUFDS i_ibufds_tx_sync (
	.I (tx_sync_p),
	.IB(tx_sync_n),
	.O (tx_sync  )
);


IBUFDS_GTE3 refclk_ibuf (
	.O    (sys_clk_gt    ),
	.ODIV2(sys_clk       ),
	.I    (pcie_ref_clk_p),
	.CEB  (1'b0          ),
	.IB   (pcie_ref_clk_n)
);

IBUFDS_GTE3 #(
      .REFCLK_EN_TX_PATH(1'b0),   // Refer to Transceiver User Guide
      .REFCLK_HROW_CK_SEL(2'b00), // Refer to Transceiver User Guide
      .REFCLK_ICNTL_RX(2'b00)     // Refer to Transceiver User Guide
   )ref_tx_clk_ibuf (
	.O    (tx_ref_clk_gt  ),
	.ODIV2(tx_ref_clk  ),
	.I    (tx_ref_clk_p),
	.CEB  (1'b0        ),
	.IB   (tx_ref_clk_n)
);

BUFG_GT BUFG_GT_tx (
      .O(tx_core_clk),             // 1-bit output: Buffer
      .CE(1'b1),           // 1-bit input: Buffer enable
      .CEMASK(1'b1),   // 1-bit input: CE Mask
      .CLR(1'b0),         // 1-bit input: Asynchronous clear
      .CLRMASK(1'b1), // 1-bit input: CLR Mask
      .DIV(3'b000),         // 3-bit input: Dynamic divide Value
      .I(tx_ref_clk)              // 1-bit input: Buffer
   );


IBUFDS_GTE3 #(
      .REFCLK_EN_TX_PATH(1'b0),   // Refer to Transceiver User Guide
      .REFCLK_HROW_CK_SEL(2'b00), // Refer to Transceiver User Guide
      .REFCLK_ICNTL_RX(2'b00)     // Refer to Transceiver User Guide
   )ref_rx_clk_ibuf (
	.O    (rx_ref_clk_gt  ),
	.ODIV2(rx_ref_clk           ),
	.I    (rx_ref_clk_p),
	.CEB  (1'b0        ),
	.IB   (rx_ref_clk_n)
);

BUFG_GT BUFG_GT_rx (
      .O(rx_core_clk),             // 1-bit output: Buffer
      .CE(1'b1),           // 1-bit input: Buffer enable
      .CEMASK(1'b1),   // 1-bit input: CE Mask
      .CLR(1'b0),         // 1-bit input: Asynchronous clear
      .CLRMASK(1'b1), // 1-bit input: CLR Mask
      .DIV(3'b000),         // 3-bit input: Dynamic divide Value
      .I(rx_ref_clk)              // 1-bit input: Buffer
   );


// PCIe PERST# input buffer
IBUF perst_n_ibuf (.I(perst_n), .O(sys_reset));
   

wimi wimi_i (
	.common0_qpll0_lock_out  (common0_qpll0_lock_out  ),
	.common0_qpll1_lock_out  (common0_qpll1_lock_out  ),
	.cs_n                    (cs_n                    ),
	.pcie_7x_mgt_rxn         (pcie_rx_n                ),
	.pcie_7x_mgt_rxp         (pcie_rx_p                ),
	.pcie_7x_mgt_txn         (pcie_tx_n                ),
	.pcie_7x_mgt_txp         (pcie_tx_p                ),
	.pcie_lnk_up             (pcie_lnk_up             ),
	.rx_ref_clk              (rx_ref_clk_gt              ),
	.rx_sync                 (rx_sync                 ),
	.rx_sysref               (rx_sysref               ),
	.rxn_in                  (rxn_in                  ),
	.rxp_in                  (rxp_in                  ),
	.sclk                    (sclk                    ),
	.sdata                   (sdata                   ),
	.sys_clk                 (sys_clk                 ),
	.sys_clk_gt              (sys_clk_gt              ),
	.sys_reset               (sys_reset               ),
	.tx_ref_clk              (tx_ref_clk_gt              ),
	.tx_sync                 (tx_sync                 ),
	.tx_sysref               (tx_sysref               ),
	.txn_out                 (txn_out                 ),
	.txp_out                 (txp_out                 ),
	.user_clk                (user_clk                ),
	.tx_core_clk             (tx_core_clk            ),  
	.rx_core_clk             (rx_core_clk            ),
	.adc_pd(adc_pd),
    .adcstatus({adc_fda,adc_fdb}),
    .clkd_sync(clkd_sync),
    .clkstatus(clock_status),
    .dac_rst(dac_reset),
    .dac_txen(dac_txen),
    .dacirq(dac_irq),
    .led(led[0])

);
        
        
// LEDs - Status
// ---------------
// Heart beat LED; flashes when primary PCIe core clock is present
always @(posedge user_clk)
	begin
		led_ctr <= led_ctr + {{(LED_CTR_WIDTH-1){1'b0}}, 1'b1};
	end



assign led[7] = pcie_lnk_up;
assign led[6] = clock_status[1];
assign led[5] = ~clock_status[1];
assign led[4] = ~clock_status[0];
assign led[3] = led_ctr[LED_CTR_WIDTH-1];  // Flashes when user_clk is present
assign led[2] = common0_qpll0_lock_out;
assign led[1] = common0_qpll1_lock_out;





assign spi_dir = 1'b1;



assign cs_dac = cs_n[0];
assign cs_adc =  cs_n[1];
assign cs_clk = cs_n[2];



endmodule

`timescale 1 ns / 1 ps

	module DAQ2_CONTROLLER_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 7,
		parameter integer C_S_AXI_DATA_WIDTH    = 32
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,
		
		output wire sclk,
		output wire sdout,
		output wire [2:0]cs_n,
		
		input wire [1:0] clk_locked,
		input wire [1:0] reset_done,
		input wire [1:0] clkstatus,
		input wire [1:0] adcstatus,
		input wire dacirq,
		
		output wire tx_reset,
		output wire rx_reset,
		output wire rx_sys_reset,
		output wire tx_sys_reset,
		output wire led,
		output wire clkd_sync,
		output wire dac_txen,
		output wire dac_rst,
		output wire adc_pd  		
			
	);
	wire [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg1; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg2; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg3; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg4; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg5; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg6; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg7; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg8; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg9; 
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg10;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg11;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg12;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg13;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg14;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg15;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg16;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg17;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg18;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg19;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg20;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg21;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg22;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg23;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg24;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg25;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg26;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg27;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg28;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg29;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg30;
    wire [C_S_AXI_DATA_WIDTH-1:0]    slv_reg31;
	
// Instantiation of Axi Bus Interface S00_AXI
	DAQ2_CONTROLLER_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) DAQ2_CONTROLLER_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
	    .slv_reg0(slv_reg0),       
       .slv_reg1(slv_reg1),
       .slv_reg2(slv_reg2),
       .slv_reg3(slv_reg3),
       .slv4(slv_reg4),
       .slv5(slv_reg5),
       .slv6(slv_reg6),
       .slv7(slv_reg7),
       .slv8(slv_reg8),
       .slv_reg9(slv_reg9),
       .slv_reg10(slv_reg10),
       .slv_reg11(slv_reg11),
       .slv_reg12(slv_reg12),
       .slv_reg13(slv_reg13),
       .slv_reg14(slv_reg14),
       .slv_reg15(slv_reg15),
       .slv_reg16(slv_reg16),
       .slv_reg17(slv_reg17),
       .slv_reg18(slv_reg18),
       .slv_reg19(slv_reg19),
       .slv_reg20(slv_reg20),
       .slv_reg21(slv_reg21),
       .slv_reg22(slv_reg22),
       .slv_reg23(slv_reg23),
       .slv_reg24(slv_reg24),
       .slv_reg25(slv_reg25),
       .slv_reg26(slv_reg26),
       .slv_reg27(slv_reg27),
       .slv_reg28(slv_reg28),
       .slv_reg29(slv_reg29),
       .slv_reg30(slv_reg30),
       .slv_reg31(slv_reg31)
	);

	// Add user logic here
    spi u_spi(
    .rst_n(s00_axi_aresetn),
    .din(slv_reg0[23:0]),
    .wr_en(slv_reg1[0]),
    .clk(s00_axi_aclk),
    .sdout(sdout),
    .sclk(sclk),
    .cs());
    
    assign cs_n = slv_reg2[2:0];

    assign  slv_reg4 = {30'd0,clk_locked};
    assign  slv_reg5 = {30'd0,reset_done};
    assign  slv_reg6 = {30'd0,clkstatus};
    assign  slv_reg7 = {30'd0,adcstatus};
    assign  slv_reg8 = {31'd0,dacirq};

    assign  tx_reset = slv_reg16 [0] ;
    assign  rx_reset = slv_reg17 [0];
    assign  rx_sys_reset = slv_reg18 [0];
    assign  tx_sys_reset = slv_reg19 [0];
    assign  led = slv_reg20 [0];
    assign  clkd_sync = slv_reg21 [0];
    assign  dac_txen = slv_reg22 [0];
    assign  dac_rst  = slv_reg23 [0];
    assign  adc_pd  = slv_reg24 [0];  
    
	// User logic ends

	endmodule

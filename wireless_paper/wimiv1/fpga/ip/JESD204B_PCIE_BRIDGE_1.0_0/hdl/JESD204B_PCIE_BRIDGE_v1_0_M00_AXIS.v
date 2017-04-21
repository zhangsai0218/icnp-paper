
`timescale 1 ns / 1 ps
	module JESD204B_PCIE_BRIDGE_v1_0_TX_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 256,
		parameter integer C_M_AXIS_TDATA_WIDTH	= 128


	)
	(
		// Users to add ports here
        input  [31:0 ]num_words,
        input  start,
        input flush,
        
		// User ports ends
		// Do not modify the ports beyond this line

		// AXI4Stream sink: Clock
		input wire  S_AXIS_ACLK,
		// AXI4Stream sink: Reset
		input wire  S_AXIS_ARESETN,
		// Ready to accept data in
		output wire  S_AXIS_TREADY,
		// Data in
		input wire [C_S_AXIS_TDATA_WIDTH-1 : 0] S_AXIS_TDATA,
		// Data is in valid
		input wire  S_AXIS_TVALID,
		input wire  S_AXIS_TLAST,

		
		input wire  M_AXIS_ACLK,
        // 
        input wire  M_AXIS_ARESETN,
        // Master Stream Ports. TVALID indicates that the master is driving a valid transfer, A transfer takes place when both TVALID and TREADY are asserted. 
        output wire  M_AXIS_TVALID,
        // TDATA is the primary payload that is used to provide the data that is passing across the interface from the master.
        output wire [C_M_AXIS_TDATA_WIDTH-1 : 0] M_AXIS_TDATA,
        // TLAST indicates the boundary of a packet.
        // TREADY indicates that the slave can accept a transfer in the current cycle.
        input wire  M_AXIS_TREADY
	);
	// The control state machine oversees the writing of input streaming data to the FIFO,
	// and outputs the streaming data from the FIFO
	parameter [1:0] IDLE = 1'b0,        // This is the initial/idle state 
                    READ_FIFO   = 1'b1,
	                WRITE_FIFO  = 1'b1; // In this state FIFO is written with the
	                                    // input stream data S_AXIS_TDATA 
	wire  	axis_s_tready;
	wire  	axis_m_tvalid;
	wire    full;
	wire    empty;
	reg    start_m;
	// State variable
	reg s_state;  
	reg m_state;  
	wire  wren;
	wire  rden;
	reg  flush_s;

	// FIFO implementation signals

	assign S_AXIS_TREADY	= axis_s_tready;
	assign M_AXIS_TVALID	= axis_m_tvalid;
	// Control state machine implementation
	always @(posedge S_AXIS_ACLK) 
	begin  
	  if (!S_AXIS_ARESETN) 
	  // Synchronous reset (active low)
	    begin
	      s_state <= IDLE;
	    end  
	  else
	    case (s_state)
	      IDLE: 
	        // The sink starts accepting tdata when 
	        // there tvalid is asserted to mark the
	        // presence of valid streaming data 
	          if (flush_s)
	            begin
	              s_state <= WRITE_FIFO;
	            end
	          else
	            begin
	              s_state <= IDLE;
	            end
	      WRITE_FIFO: 
	        // When the sink has accepted all the streaming input data,
	        // the interface swiches functionality to a streaming master
	        if ( S_AXIS_TLAST)
	          begin
	            s_state <= IDLE;
	          end
	        else
	          begin
	            // The sink accepts and stores tdata 
	            // into FIFO
	            s_state <= WRITE_FIFO;
	          end

	    endcase
	end
	
    always @(posedge M_AXIS_ACLK) 
    begin  
      if (!S_AXIS_ARESETN) 
      // Synchronous reset (active low)
        begin
          m_state <= IDLE;
        end  
      else
        case (m_state)
          IDLE: 
            // The sink starts accepting tdata when 
            // there tvalid is asserted to mark the
            // presence of valid streaming data 
              if (start_m)
                begin
                  m_state <= READ_FIFO;
                end
              else
                begin
                  m_state <= IDLE;
                end
          READ_FIFO: 
            // When the sink has accepted all the streaming input data,
            // the interface swiches functionality to a streaming master
            if (empty)
              begin
                m_state <= IDLE;
              end
            else
              begin
                // The sink accepts and stores tdata 
                // into FIFO
                m_state <= READ_FIFO;
              end

        endcase
    end
	// AXI Streaming Sink 
	// 
	// The example design sink is always ready to accept the S_AXIS_TDATA  until
	// the FIFO is not filled with NUMBER_OF_INPUT_WORDS number of input words.
	assign axis_s_tready = (s_state == WRITE_FIFO) && (~full);
	assign axis_m_tvalid = (m_state == READ_FIFO)   && (~empty);

	// FIFO write enable generation

	
	 assign wren = S_AXIS_TVALID && axis_s_tready;

	
	
   
     assign rden = M_AXIS_TREADY && axis_m_tvalid;

   

    assign fifo_data = S_AXIS_TDATA;

	// User logic ends
	wire [127:0] dout; 
    fifo_256to128 inst_fifo_256to128(
      .rst(flush_s || (~M_AXIS_ARESETN) || (~S_AXIS_ARESETN)),                      // input wire rst
      .wr_clk(S_AXIS_ACLK),                // input wire wr_clk
      .rd_clk(M_AXIS_ACLK),                // input wire rd_clk
      .din({S_AXIS_TDATA[127:0],S_AXIS_TDATA[255:128]}),                      // input wire [127 : 0] din
      .wr_en(wren),                  // input wire wr_en
      .rd_en(rden),                  // input wire rd_en
      .dout(dout),                    // output wire [255 : 0] dout
      .full(full),                    // output wire full
      .empty(empty)                // output wire empty          
    );
    assign  M_AXIS_TDATA[0+:8]  = dout[8+:8];
    assign  M_AXIS_TDATA[8+:8]  = dout[40+:8]; 
    assign  M_AXIS_TDATA[16+:8] = dout[72+:8]; 
    assign  M_AXIS_TDATA[24+:8] = dout[104+:8];
    
    assign  M_AXIS_TDATA[32+:8] = dout[0+:8];
    assign  M_AXIS_TDATA[40+:8] = dout[32+:8]; 
    assign  M_AXIS_TDATA[48+:8] = dout[64+:8]; 
    assign  M_AXIS_TDATA[56+:8] = dout[96+:8]; 
    
    assign  M_AXIS_TDATA[64+:8] = dout[24+:8]; 
    assign  M_AXIS_TDATA[72+:8] = dout[56+:8]; 
    assign  M_AXIS_TDATA[80+:8] = dout[88+:8]; 
    assign  M_AXIS_TDATA[88+:8] =dout[120+:8];
    
    assign  M_AXIS_TDATA[96+:8] = dout[16+:8]; 
    assign  M_AXIS_TDATA[104+:8]= dout[48+:8];
    assign  M_AXIS_TDATA[112+:8]= dout[80+:8];
    assign  M_AXIS_TDATA[120+:8]= dout[112+:8];
    
//      assign  M_AXIS_TDATA[0+:8]  = dout[8+:8];0
//      assign  M_AXIS_TDATA[8+:8]  = dout[40+:8];1 
//      assign  M_AXIS_TDATA[16+:8] = dout[72+:8]; 2
//      assign  M_AXIS_TDATA[24+:8] = dout[104+:8];3
//      assign  M_AXIS_TDATA[32+:8] = dout[0+:8];4
//      assign  M_AXIS_TDATA[40+:8] = dout[32+:8];5 
//      assign  M_AXIS_TDATA[48+:8] = dout[64+:8]; 6
//      assign  M_AXIS_TDATA[56+:8] = dout[96+:8]; 7
//      assign  M_AXIS_TDATA[64+:8] = dout[24+:8]; 8
//      assign  M_AXIS_TDATA[72+:8] = dout[56+:8]; 9
//      assign  M_AXIS_TDATA[80+:8] = dout[88+:8]; a
//      assign  M_AXIS_TDATA[88+:8] =dout[120+:8];b
//      assign  M_AXIS_TDATA[96+:8] = dout[16+:8]; c
//      assign  M_AXIS_TDATA[104+:8]= dout[48+:8];d
//      assign  M_AXIS_TDATA[112+:8]= dout[80+:8];e
//      assign  M_AXIS_TDATA[120+:8]= dout[112+:8];f
     
   always @(posedge M_AXIS_ACLK or negedge M_AXIS_ARESETN) begin 		
      if(~M_AXIS_ARESETN) begin
       start_m <= 0;
  
     end else begin
       start_m <= start;
  
     end
   end
   
    always @(posedge S_AXIS_ACLK or negedge S_AXIS_ARESETN) begin 		
       if(~S_AXIS_ARESETN) begin
        flush_s <= 0;
   
      end else begin
        flush_s <= flush;
   
      end
    end
    
	endmodule

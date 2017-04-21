`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2016 10:27:38 PM
// Design Name: 
// Module Name: SPI_24bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module spi(
    input rst_n,
    input [23:0] din,
    input wr_en,
    input clk,
    output sdout,
    output sclk,
    output cs
    );
  
  localparam   C_IDLE   =  3'b0001,
               C_START  =  3'b0010,
               C_UPDATE =  3'b0100,
               C_WAIT   =  4'b1000;
  reg [3:0]  state;
  reg [5:0]  bit_cnt;
  reg [23:0] data; 
  reg [4:0]  clk16_cnt;
  wire       clk_en;
    
  always @(posedge clk)
    begin
      if ( ~rst_n )
        begin
          state  <= C_IDLE;
        end 
      else
                begin    
                    case (state)
                        C_IDLE: if  (wr_en) state <= C_START;
                                else state <= C_IDLE;           
                        C_START:   state <= C_UPDATE;
                        C_UPDATE: if (bit_cnt >= 24) state <= C_IDLE;
                                  else state <= C_UPDATE;
                        default: state <= C_IDLE;
                 endcase
                end
             end
             
    
   assign clk_en = (clk16_cnt == 5'b11111);
   
   always @(posedge clk) 
    if (~rst_n || (state == C_START)) clk16_cnt <=0;
    else clk16_cnt <= clk16_cnt+1;
  
   always @(posedge clk) 
     begin
        if (~rst_n || (state == C_IDLE)) bit_cnt <= 6'b0;
        else if (clk_en)begin
            if (state == C_UPDATE || state == C_WAIT) bit_cnt <= bit_cnt +1'b1;
            else bit_cnt <=0;
         end
        else bit_cnt <= bit_cnt; 
     end

    always @(posedge clk) 
      begin
        if (~rst_n) data <= 24'b0;
        else begin
            if (state == C_START) data <= din;
            else if (state == C_UPDATE && clk_en) data <= data << 1;
         end
     end

     
     assign sdout = data[23];
     assign sclk= clk16_cnt[4] && (state == C_UPDATE || state == C_WAIT);
     assign cs = (state != C_UPDATE);         
endmodule

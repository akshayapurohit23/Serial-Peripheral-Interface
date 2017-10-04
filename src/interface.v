`include "master_module.v"
`include "slave_module.v"

module interface(input clk,reset,enable,CPOL,CPHA,
				 input [1:0] clk_sel,
				 input [7:0] master_data_in,slave_data_in,
				 output [7:0] master_data_out,slave_data_out);
				 
	wire [7:0] SPDR_m,SPDR_s;
	wire sclk,ss,mosi,miso; 				 
	master m1(clk,reset,master_data_in,enable,miso,CPOL,CPHA,clk_sel,mosi,sclk,ss,master_data_out);
	slave s1 (sclk,reset,ss,mosi,CPOL,CPHA,slave_data_in,miso,slave_data_out);
endmodule				 
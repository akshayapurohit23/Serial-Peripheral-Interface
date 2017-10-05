`include "clock_generator.v"

module master(input clk,reset,
			  input [7:0] master_data_in,
              input enable,miso,CPOL,CPHA,
			  input [1:0] clk_sel,
			  output mosi, 
			  output reg sclk,ss,
			  output reg [7:0] master_data_out);		  
	wire clk_int;
	reg [3:0] count,next_count;
	reg [7:0] next_SPDR,SPDR_m;

	clock_generator CG (clk,CPOL,CPHA,reset,clk_sel,clk_int);

	always @(*)
	begin
	       if(enable)
			begin
				if(~(CPOL^CPHA))
					sclk = clk_int;
				else
					sclk = ~clk_int;
			end
			else
				sclk = CPOL;
	end		

	always@(posedge clk_int or posedge reset)
	begin
	if(reset)
			count<=0;
		else
			count<=next_count;
	end

	always@(*)
	begin
		if(enable)
		begin
			if(count==9)
				next_count=0;
			else
				next_count=count+1;
		end
		else
			next_count=0;
	end

	always@(posedge clk_int or posedge reset)
	begin
	    if(reset) 
			SPDR_m<=0;
		else      
			SPDR_m<=next_SPDR;
	end

	always@(*)
	begin
	   	if(enable)
		begin
			if(count==0)
				next_SPDR=master_data_in;
			else
				next_SPDR={miso,SPDR_m[7:1]};	
		end
		else
			next_SPDR=master_data_in;		
	end

	assign mosi = SPDR_m[0];

	always@(posedge clk_int)
	begin	
		if(enable)
			ss<=1;
		else
			ss<=0;
	end

	reg [7:0] data_out;

	always@(*)
	begin
		if(count==9)
		begin
			data_out = SPDR_m;
		end
		else
			data_out = data_out;
	end

	always@(posedge clk_int)
		master_data_out <= data_out;

endmodule 

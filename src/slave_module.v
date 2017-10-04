`include "clock_generator.v"

module slave(input sclk,reset,ss,mosi,CPOL,CPHA,
		     input [7:0] slave_data_in,
			 output miso,
			 output reg[7:0] slave_data_out);
			 
	reg [7:0] next_SPDR,data_out,SPDR_s;
	reg clk_int;
	reg [3:0] count,next_count;
				 

	always@(posedge clk_int)
	slave_data_out <= data_out;
	  			 
	always@(*)
	begin
	     if(ss)
	       begin
	          if(~(CPOL^CPHA))
	             clk_int=sclk;
	          else
	             clk_int=~sclk;
	       end
	      else
	           clk_int=0;
	end

	wire clear_count = reset||(~ss);			 
	always @(posedge clk_int or posedge clear_count)// or posedge not_ss)
	begin
	if(clear_count)//|| not_ss)
			count<=0;
		else
			count<=next_count;
	end

	always@(*)
	begin
	     if(count==9 || ~ss)
		      next_count=0;
		 else
	          next_count=count+1;
	end



	always@(*)
	begin
	     if(ss)
		   begin
	          if(count==0)
	             next_SPDR=slave_data_in;		  
	          else
	             next_SPDR={mosi,SPDR_s[7:1]};
	        end			 
		  else
	             next_SPDR=slave_data_in;
	end

	always @(posedge clk_int or posedge reset)
	begin
			if(reset) SPDR_s<=0;
			else		
				SPDR_s<=next_SPDR;
	end	  


	assign miso=SPDR_s[0];

	always@(*)
	begin
	  	  if(count==9)
	            data_out=SPDR_s;
	      else
	            data_out=slave_data_out;
	end
endmodule 
module clock_generator(input clk,CPOL,CPHA,reset,
					   input [1:0] clk_sel,
					   output reg clk_int);
					  
	reg clk2,clk4,clk16,clk32;
	reg [3:0] p16;
	reg [4:0] p32;					  
	reg [1:0] p4;
	always @(posedge clk)
	begin
	    if(reset)	
			clk2<=CPOL;
	    else    
			clk2<=~clk2;
		
	end 

	always @(posedge clk)
	begin
	     	if(reset)
				p4 <= 0;
			else
				p4 <= p4+1;
	end		

	always @(posedge clk)
	begin
	    if(reset)  clk4<=CPOL;
	    else   
		begin
				if(p4==1 || p4==3)	
					clk4<=~clk4;
				else
					clk4<=clk4;
		end
	end 

	always@(posedge clk)
	begin
		if(reset) 
			p16<=0;
		else
			p16<=p16+1;
	end

	always @(posedge clk)
	begin
	    if(reset)  
			clk16<=CPOL;
	    else
		begin
				if(p16==7 || p16==15)
					clk16<=~clk16;
				else
					clk16<=clk16;
		end
	end 

	always@(posedge clk)
	begin
		if(reset) 
			p32<=0;
		else
			p32<=p32+1;
	end

	always @(posedge clk)
	begin
	    if(reset)  
			clk32<=CPOL;
	    else
		begin
				if(p32==15 || p32==31)
					clk32<=~clk32;
				else
					clk32<=clk32;
		end
	end 

	always @(*)
	begin
			if(~(CPOL^CPHA))
			begin
				case(clk_sel[1:0])
				0:clk_int=clk2;
				1:clk_int=clk4;
				2:clk_int=clk16;
				3:clk_int=clk32;
				default:clk_int=clk2;
				endcase
			end
			else
			begin
				case(clk_sel[1:0])
				0:clk_int=~clk2;
				1:clk_int=~clk4;
				2:clk_int=~clk16;
				3:clk_int=~clk32;
				default:clk_int=~clk2;
				endcase
			end
	end
					  
endmodule
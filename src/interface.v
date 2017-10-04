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

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

module interface(input clk,reset,enable,CPOL,CPHA,
				 input [1:0] clk_sel,
				 input [7:0] master_data_in,slave_data_in,
				 output [7:0] master_data_out,slave_data_out);
				 
wire [7:0] SPDR_m,SPDR_s;
wire sclk,ss,mosi,miso; 				 
master m1(clk,reset,master_data_in,enable,miso,CPOL,CPHA,clk_sel,mosi,sclk,ss,master_data_out);
slave s1 (sclk,reset,ss,mosi,CPOL,CPHA,slave_data_in,miso,slave_data_out);
				 
endmodule				 
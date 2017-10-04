`timescale 1ns/100ps

module tb;

	reg clk,reset,enable,CPOL,CPHA;
	reg [7:0] master_data_in,slave_data_in,temp_master,temp_slave;
	reg [1:0] clk_sel;

	wire [7:0] master_data_out,slave_data_out;
	interface f1(clk,reset,enable,CPOL,CPHA,clk_sel,master_data_in,slave_data_in,master_data_out,slave_data_out);


	initial
	begin
	   reset =0;
	   #140;
	   reset=1;
	   #400;
	   reset=0;
	end   

	initial 
	begin
	  clk=0;
	  #400000;
	  $finish;
	end

	always
	begin
		#62.5;
		clk=~clk;
	end

	initial
	begin
	//	First posedge at 125, second at 375 : t=0
		clk_sel=0;
		enable=0;
		CPOL=0;
		CPHA=0;
		master_data_in=34;
		slave_data_in=62;

		#400; // t=400
		//Third posedge at 625

		enable=1;


		#2730; 
		// posedge at 3125 : t=3130
		//$display("\nmaster_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");

		enable=0;
		CPOL=1;
		master_data_in=25;
		slave_data_in=75;

		#250;
		//posedge at 3375 : t=3380
		enable = 1;

		#2500;
		//posedge at 5875 : t=5880
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");

		enable = 0;

		#250;
		//	First posedge at 125, second at 375 : t=0
		clk_sel=1;
		enable=0;
		CPOL=0;
		CPHA=1;
		master_data_in=250;
		slave_data_in=165;

		#800; // t=400
		//Third posedge at 625

		enable=1;


		#5460; 
		// posedge at 3125 : t=3130
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");

		enable=0;
		CPOL=1;
		master_data_in=0;
		slave_data_in=255;

		#500;
		//posedge at 3375 : t=3380
		enable = 1;

		#5000;
		//posedge at 5875 : t=5880
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");

		enable = 0;

		#500;
		//	First posedge at 125, second at 375 : t=0
		clk_sel=2;
		enable=0;
		CPOL=1;
		CPHA=1;
		master_data_in=34;
		slave_data_in=62;

		#1200; // t=400
		//Third posedge at 625

		enable=1;


		#21840; 
		// posedge at 3125 : t=3130
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");


		enable=0;
		CPOL=0;
		master_data_in=50;
		slave_data_in=150;

		#2000;
		//posedge at 3375 : t=3380
		enable = 1;

		#20000;
		//posedge at 5875 : t=5880
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");

		enable = 0;

		#1000;
		reset=1;
		#1000;
		reset=0;
		#1000;
		//	First posedge at 125, second at 375 : t=0
		clk_sel=3;
		enable=0;
		CPOL=1;
		CPHA=0;
		master_data_in=$random;
		slave_data_in=$random;

		#2400; // t=400
		//Third posedge at 625

		enable=1;


		#43680; 
		// posedge at 3125 : t=3130
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");


		enable=0;
		CPOL=0;
		master_data_in=$random;
		slave_data_in=$random;

		#8000;
		//posedge at 3375 : t=3380
		enable = 1;

		#40000;
		//posedge at 5875 : t=5880
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");

		master_data_in=$random;
		slave_data_in=$random;

		#40000;
		//posedge at 3375 : t=3380
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",master_data_in,slave_data_in,master_data_out,slave_data_out);
		if(master_data_in == slave_data_out &&  slave_data_in == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");
			
		enable = 0;
		CPHA=1;

		#8000;

		enable=1;
		master_data_in=$random;
		slave_data_in=$random;
		temp_master = master_data_in;
		temp_slave = slave_data_in;

		#10000;
		master_data_in=$random;
		slave_data_in=$random;
			
		#40000;	
		//$display("master_input = %d slave_input = %d\nmaster_output = %d slave_output = %d",temp_master,temp_slave,master_data_out,slave_data_out);
		if(temp_master == slave_data_out &&  temp_slave == master_data_out)
			$display("Successful  transmission\n");
		else
			$display("Failed transmission\n");
			
		enable =0;	

	end
endmodule
  
`timescale 10ns/1ns

module Testbench;
	
	reg [31:0] x1[999:0], x2[999:0], x3[999:0], x4[999:0], y1[999:0], y2[999:0], y3[999:0], y4[999:0], ansss[999:0];
	reg [31:0] X1, X2, X3, X4, Y1, Y2, Y3, Y4, anss;
	reg clk, reset, mode;
	reg [31:0] myans[1000:0];
	wire [47:0] out1, out2, out3, out4, out12;
	wire [7:0]  exp1, exp2, exp3, exp4, exp12;
	wire [51:0] sum1, sum2, sum3, sum4;
	wire [31:0] ans;
	wire s1, s2, s3, s4, s12;
	integer i, in, temp, k , w;
	
	wire [31:0] X1_reg, Y1_reg;
	mul_pipe mul_pipe( clk, reset, mode, X1, Y1, X2, Y2, X3, Y3, X4, Y4, out1, out2, out3, out4, exp1, exp2, exp3, exp4, s1, s2, s3, s4, sum1, sum2, sum3, sum4, s12, exp12, out12, ans);
	parameter t = 10;
	parameter th = 1;
	
	always #th clk = ~clk ;
	
	initial begin
		in = $fopen("FP32.txt","r");
		k = $fopen("FP32_answer.txt","r");
		w = $fopen("answer32.txt","w");
		//reset = 1;
		clk = 1;
		X1 <= 0;
		X2 <= 0;
		X3 <= 0;
		X4 <= 0;
		Y1 <= 0;
		Y2 <= 0;
		Y3 <= 0;
		Y4 <= 0;
		for(i = 0 ; i <= 999; i = i + 1)begin
			temp = $fscanf( in, "%h%h%h%h%h%h%h%h", x1[i], x2[i], x3[i], x4[i], y1[i], y2[i], y3[i], y4[i]);
			//temp = $fscanf( k, "%b", ansss[i]);
			temp = $fscanf( k, "%h", ansss[i]);
		end
		//#t;
		for  (i = 0 ; i <= 999; i = i + 1)begin
			reset <= 0;
			mode <= 1;
			X1 <= x1[i];
			X2 <= x2[i];
			X3 <= x3[i];
			X4 <= x4[i];
			Y1 <= y1[i];
			Y2 <= y2[i];
			Y3 <= y3[i];
			Y4 <= y4[i];
			anss <= ansss[i];
			myans[i] <= ans;
			#t;
		end
		myans[1000] <= ans;
		#t;
		for (i = 1 ; i <= 1000 ; i = i + 1)begin
			if (ansss[i-1] - myans[i] <= 20 || myans[i] - ansss[i-1] <= 20)begin
				$display("%d correct!!!",i);
			end
			else begin
				$display("%d %h %h",i,myans[i],ansss[i-1]);
			end
			$fwrite(w,"%h\n",myans[i]);
		end		
		$fclose(w);
		$fclose(in);
		$stop;
		
	end
endmodule
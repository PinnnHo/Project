`define buffer_size 226*2+2
`timescale 1ns/1ps
module dnn( clk, reset, inn, write, PE, bias, widx, read, relu, relu2, relu3, relu4,  sum1, sum2, sum3, sum4, out, in_last, WEN, CEN, WEN1, CEN1, addr, addr2, PE_temp, IN_temp);
	input clk, reset, write;
	input signed[63:0] PE, inn;
	input signed[15:0] bias;
	input signed[35:0] in_last;
	input	WEN;
	input	CEN,  WEN1, CEN1;
	input	[8:0]	addr, addr2;
	output  read;
	output signed[35:0] relu, relu2, relu3, relu4;
	output signed [35:0] sum1, sum2, sum3, sum4;
	output signed [35:0] out;
	output [63:0] PE_temp, IN_temp;
	output [15:0]widx;
	wire [15:0] widx2, widx3, widx4;
	wire [63:0] PE_temp;
	wire signed [15:0] PE1, PE2, PE3, PE4;
	wire read2, read3, read4;
	wire signed [35:0] tmp;
	wire signed [15:0] tmp2;
	wire [8:0]	AY; //10bit
	wire [8:0]	AY1; //10bit
	wire [63:0]	DY1; //32bit
	wire [63:0]	DY; //32bit
	wire 	CENY;
	wire 	CENY1;
	wire	WENY;
	wire	WENY1;
	wire nclk;
	wire [8:0] in, in2, in3, in4;
	assign nclk = ~clk;
	assign PE1 = PE_temp[63:48];
	assign PE2 = PE_temp[47:32];
	assign PE3 = PE_temp[31:16];
	assign PE4 = PE_temp[15:0];
	assign in = IN_temp[63:55];
	assign in2 = IN_temp[54:46];
	assign in3 = IN_temp[45:37];
	assign in4 = IN_temp[36:28];
	assign tmp = sum1 + sum2 + sum3 + sum4 + in_last;
	assign out = ( tmp <= 0)?  0 : tmp;		//Relu
	line line ( clk, reset, write, PE1, bias, in, widx, read, relu, sum1);
	line line2( clk, reset, write, PE2, bias, in2, widx2, read2, relu2, sum2);
	line line3( clk, reset, write, PE3, bias, in3, widx3, read3, relu3, sum3);
	line line4( clk, reset, write, PE4, bias, in4, widx4, read4, relu4, sum4);
	
	sram_sp_512x64 PE_SRAM(.CEN (CEN),.WEN (WEN),.A(addr),.D(PE), .Q(PE_temp),.CLK (nclk),.EMA(3'd0), .EMAW(2'd0), .EMAS(1'd0), .TEN(1'd1), .CENY(CENY1), .WENY(WENY),.AY(AY), .DY(DY),.BEN(1'd1), .TCEN(1'd1), .TWEN(1'd1), .TA(10'd0), .TD(32'd0), .TQ(32'd0), .RET1N(1'b1), .STOV(1'b0));
	sram_sp_512x64 INPUT_SRAM(.CEN (CEN1),.WEN (WEN1),.A(addr2),.D(inn), .Q(IN_temp),.CLK (nclk),.EMA(3'd0), .EMAW(2'd0), .EMAS(1'd0), .TEN(1'd1), .CENY(CENY), .WENY(WENY1),.AY(AY1), .DY(DY1),.BEN(1'd1), .TCEN(1'd1), .TWEN(1'd1), .TA(10'd0), .TD(32'd0), .TQ(32'd0), .RET1N(1'b1), .STOV(1'b0));
	
endmodule

module line( clk, reset, write, PE, bias, in, widx, read, relu, sum1);
	input clk, reset, write;
	input signed[15:0] PE;
	input signed[15:0] bias;
	input [8:0] in;
	output reg [15:0] widx;
	output reg read;
	output reg signed[35:0] relu;
	output reg signed [35:0] sum1;
	
	reg [8:0] out1, out2, out3, out4, out5, out6, out7, out8, out9;
	reg signed [35:0] temp1, temp2, temp3, temp4,temp7, temp5, temp6 , temp8;
	reg [8:0] buffer [0:`buffer_size];
	reg [3:0] pidx;
	reg signed[15:0] p1[0:8];
	
	integer i;
	
	
	always@(negedge clk or posedge reset)begin
		if(reset)begin
			widx = 0;
			read = 0;
			pidx = 0;
		end
		else begin
			if(write)begin
				if (widx <=  `buffer_size)begin
					if (widx > 0 && widx <= 10)begin
						p1[pidx] = PE;		//PE
						pidx = pidx + 1;
					end
					else begin
						pidx = pidx;
					end
					buffer[widx] =  in;		//Line buffer
					widx = widx + 1;
				end
				else begin
					pidx = 0;
					if (widx % 226 == 224 || widx % 226 == 225) read = 0;
					else if(widx < 226 * 226)	read = 1;
					else read = 0;
					
					for( i = 0;i < `buffer_size ; i = i + 1)begin
						buffer[i] = buffer[i+1];
					end
					
					buffer[`buffer_size] = in;
					out1 = buffer[0];
					out2 = buffer[1];
					out3 = buffer[2];
					out4 = buffer[226];
					out5 = buffer[227];
					out6 = buffer[228];
					out7 = buffer[452];
					out8 = buffer[453];
					out9 = buffer[454];
					widx = widx + 1;
				end
			end
			else begin
				widx = widx;
				pidx = 0;
			end
		end	
	end
	
	always@(*)begin	//adder_tree
		if( read == 0)begin
			relu = 0;
		end
		else begin
			temp1 = $signed(out1) * p1[0] + $signed(out2) * p1[1];
			temp2 = $signed(out3) * p1[2] + $signed(out4) * p1[3];
			temp3 = $signed(out5) * p1[4] + $signed(out6) * p1[5];
			temp4 = $signed(out7) * p1[6] + $signed(out8) * p1[7];
			temp5 = temp1 + temp2 ;
			temp6 = temp3 + temp4;
			temp7 = $signed(out9) * p1[8] + bias;
			temp8 = temp5 + temp6;
			sum1 =  temp8 + temp7;
			if(sum1 <= 0) relu = 0;
			else relu = sum1;
		end
	end
endmodule


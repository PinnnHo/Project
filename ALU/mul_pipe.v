`define TRUE 1'b1
`define FALSE 1'b0
module mul_pipe( clk, reset, mode, X1, Y1, X2, Y2, X3, Y3, X4, Y4, out1, out2, out3, out4, exp1, exp2, exp3, exp4, s1, s2, s3, s4, sum1, sum2, sum3, sum4, s, exp, out, ans);
	input clk, reset, mode;
	input [31:0] X1, Y1, X2, Y2, X3, Y3, X4, Y4;
	output [47:0] out1, out2, out3, out4, out;
	output [7:0]  exp1, exp2, exp3, exp4, exp;
	output s1, s2, s3, s4, s;
	output [51:0] sum1, sum2, sum3, sum4;
	output [31:0] ans;
	
	wire s12, s34, s;
	wire [7:0] exp12, exp34, exp;
	wire [47:0] out12, out34, out;
	wire [47:0] reg_out1, reg_out2, reg_out3, reg_out4, out12_reg, out34_reg;
	wire [7:0]  reg_exp1, reg_exp2, reg_exp3, reg_exp4, exp12_reg, exp34_reg;
	wire reg_s1, reg_s2, reg_s3, reg_s4, s12_reg, s34_reg;
	
	mul_all m1( clk, reset, mode, X1, Y1, reg_out1, reg_exp1, reg_s1, sum1);
	mul_all m2( clk, reset, mode, X2, Y2, reg_out2, reg_exp2, reg_s2, sum2);
	mul_all m3( clk, reset, mode, X3, Y3, reg_out3, reg_exp3, reg_s3, sum3);
	mul_all m4( clk, reset, mode, X4, Y4, reg_out4, reg_exp4, reg_s4, sum4);
	reg3 reg3( clk, reset, reg_out1, reg_out2, reg_out3, reg_out4, reg_exp1, reg_exp2, reg_exp3, reg_exp4, reg_s1, reg_s2, reg_s3, reg_s4, out1, out2, out3, out4, exp1, exp2, exp3, exp4,  s1, s2, s3, s4);
	add1 a1(  clk, reset,out1, out2, exp1, exp2, s1, s2, s12, exp12, out12);
	add1 a2(  clk, reset,out3, out4, exp3, exp4, s3, s4, s34, exp34, out34);
	reg4 reg4( clk, reset, out12, out34, exp12, exp34, s12, s34, out12_reg, out34_reg, exp12_reg, exp34_reg, s12_reg, s34_reg);
	add1 a3(  clk, reset, out12_reg, out34_reg, exp12_reg, exp34_reg, s12_reg, s34_reg, s, exp, out);
	assign ans = (mode)?	{s,exp,out[45:23]} : {16'b0,s,exp[4:0],out[45:36]};
endmodule

module reg4( clk, reset, out12, out34, exp12, exp34, s12, s34, out12_reg, out34_reg, exp12_reg, exp34_reg, s12_reg, s34_reg);
	input clk, reset;
	input [47:0] out12, out34;
	input [7:0] exp12, exp34;
	input s12, s34;
	output reg [47:0] out12_reg, out34_reg;
	output reg [7:0] exp12_reg, exp34_reg;
	output reg s12_reg, s34_reg;
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			out12_reg <= 0;
			out34_reg  <= 0;
			exp12_reg <= 0;
			exp34_reg <= 0;
			s12_reg <= 0;
			s34_reg <= 0;
		end
		else begin
			out12_reg <= out12;
			out34_reg  <=out34;
			exp12_reg <= exp12;
			exp34_reg <= exp34;
			s12_reg <= s12; 
			s34_reg <= s34; 
		end
	end
endmodule
module reg3( clk, reset, reg_out1, reg_out2, reg_out3, reg_out4, reg_exp1, reg_exp2, reg_exp3, reg_exp4, reg_s1, reg_s2, reg_s3, reg_s4, out1, out2, out3, out4, exp1, exp2, exp3, exp4,  s1, s2, s3, s4);
	input clk, reset;
	input [47:0] reg_out1, reg_out2, reg_out3, reg_out4;
	input [7:0]  reg_exp1, reg_exp2, reg_exp3, reg_exp4;
	input reg_s1, reg_s2, reg_s3, reg_s4;
	output reg [47:0] out1, out2, out3, out4;
	output reg [7:0]  exp1, exp2, exp3, exp4;
	output reg s1, s2, s3, s4;
	always@( posedge clk or posedge reset)begin
		if(reset)begin
			out1 <= 0;
			out2 <= 0;
			out3 <= 0;
			out4 <= 0;
			exp1 <= 0;
			exp2 <= 0;
			exp3 <= 0;
			exp4 <= 0;
			s1 <= 0;
			s2 <= 0;
			s3 <= 0;
			s4 <= 0;
		end
		else begin
			out1 <= reg_out1;
			out2 <= reg_out2;
			out3 <= reg_out3;
			out4 <= reg_out4;
			exp1 <= reg_exp1;
			exp2 <= reg_exp2;
			exp3 <= reg_exp3;
			exp4 <= reg_exp4;
			s1 <= reg_s1;
			s2 <= reg_s2;
			s3 <= reg_s3;
			s4 <= reg_s4;
		end
	end
	
endmodule

module mul_all( clk, reset, mode, x, y, mul_ans, exp_nor1, s, sum);//, x_ext1, x_ext2, y_ext1, y_ext2, xlyl,xhyl, xlyh, xhyh, sum
	input clk, reset, mode;
	input [31:0] x, y;
	output reg [47:0] mul_ans;
	output reg [7:0] exp_nor1;
	output reg s;
	output [51:0] sum;
	
	wire [25:0]  xlyl, xhyl, xlyh, xhyh;
	wire [51:0] sum;
	wire [7:0] out_exp1;
	wire [7:0] reg_out_exp1;
	wire [7:0] x_exp, y_exp;
	wire [12:0] x_ext1, x_ext2, y_ext1, y_ext2;
	wire [12:0] reg_x_ext2, reg_y_ext2;
	reg [51:0] sum_nor1;
	wire [12:0] x_ext1_reg, x_ext2_reg, y_ext1_reg, y_ext2_reg;
	wire s_reg, s_regg;
	assign s_reg = (mode)? x[31] ^ y[31] : x[15] ^ y[15];
	assign x_exp = (mode)? x[30:23] : x[14:10];
	assign y_exp = (mode)? y[30:23] : y[14:10];
	assign out_exp1 = (mode)? x_exp + y_exp - 8'd127 : x_exp + y_exp - 8'd15;
	assign x_ext1 = (mode)? {3'b001, x[22:13]} : 13'b0;
	assign x_ext2 = (mode)? x[12:0] : {3'b001, x[9:0]};
	assign y_ext1 = (mode)? {3'b001, y[22:13]} : 13'b0;
	assign y_ext2 = (mode)? y[12:0] : {3'b001, y[9:0]};
	assign sum = (mode)?{ xhyh, xlyl}+{ 13'b0, xhyl, 13'b0}+{ 13'b0, xlyh, 13'b0}: {xlyl,26'b0};
	reg1 reg1( clk, reset, s_reg, out_exp1, x_ext2, y_ext2, reg_x_ext2, reg_y_ext2, s_regg, reg_out_exp1);
	reg2 reg2( clk, reset, mode, x_ext1, x_ext2, y_ext1, y_ext2, x_ext1_reg, x_ext2_reg, y_ext1_reg, y_ext2_reg);
	mul1 mul1( reg_x_ext2, reg_y_ext2, xlyl);
	mul1 mul2( x_ext2_reg, y_ext1_reg, xlyh);
	mul1 mul3( x_ext1_reg, y_ext2_reg, xhyl);
	mul1 mul4( x_ext1_reg, y_ext1_reg, xhyh);
	always@(*)begin
		sum_nor1 = (sum[49])? sum >> 3 : (sum[48])? sum >> 2 :(sum[47])? sum >> 1 : sum;
		exp_nor1 = (sum[49])? reg_out_exp1 + 3 : (sum[48])? reg_out_exp1 + 2 :(sum[47])? reg_out_exp1 + 1 : reg_out_exp1;
		mul_ans = sum_nor1[47:0];
		s = s_regg;
	end
endmodule

module reg2( clk, reset, mode, x_ext1, x_ext2, y_ext1, y_ext2, x_ext1_reg, x_ext2_reg, y_ext1_reg, y_ext2_reg);
	input clk, reset, mode;
	input [12:0] x_ext1, x_ext2, y_ext1, y_ext2;
	output reg [12:0] x_ext1_reg, x_ext2_reg, y_ext1_reg, y_ext2_reg;
	wire gclk;
	assign gclk = clk & mode;
	always@(posedge gclk or posedge reset)begin
		if(reset)begin
			x_ext1_reg <= 0;
			x_ext2_reg <= 0;
			y_ext1_reg <= 0;
			y_ext2_reg <= 0;
		end
		else begin
			x_ext1_reg <= x_ext1;
			x_ext2_reg <= x_ext2;
			y_ext1_reg <= y_ext1;
			y_ext2_reg <= y_ext2;
		end
	end
endmodule

module reg1( clk, reset, s_reg, out_exp1, x_ext2, y_ext2, reg_x_ext2, reg_y_ext2, s_regg, reg_out_exp1);
	input clk, reset, s_reg;
	input [12:0]x_ext2, y_ext2;
	input [7:0] out_exp1;
	output reg s_regg;
	output reg [12:0] reg_x_ext2, reg_y_ext2;
	output reg [7:0] reg_out_exp1;
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			reg_x_ext2 = 0;
			reg_y_ext2 = 0;
			s_regg = 0;
			reg_out_exp1 = 0;
		end
		else begin
			reg_x_ext2 = x_ext2;
			reg_y_ext2 = y_ext2;
			s_regg = s_reg;
			reg_out_exp1 = out_exp1;
		end
	end
	
endmodule

module mul1( x, y, mul);
	input [12:0] x, y;
	output  [25:0] mul;
	assign mul = x * y;
endmodule

module add1( clk, reset, a, b, a_exp, b_exp, s_a, s_b, s_out, out_exp, out);
	input clk,reset;
	input [47:0] a, b;
	input [7:0] a_exp, b_exp;
	input s_a, s_b;
	output  s_out;
	output reg [47:0] out;
	output reg [7:0] out_exp;
	reg [48:0] a_alig,b_alig;
	wire [48:0] a_ext, b_ext, a_alig_reg, b_alig_reg, a_com, b_com;
	wire [7:0] exp, dis;
	wire [49:0] add_reg;
	reg [49:0] add;
	wire [47:0] addcom;
	wire [47:0] addcom_reg;
	reg [47:0] addcom_shift,addcom_shift_reg;
	reg [7:0] exp1,exp1_reg;
	reg [5:0] zero_cnt;
	reg con;
	integer i;
	assign exp = ( a_exp > b_exp)? a_exp : b_exp;
	assign dis = ( a_exp > b_exp)? a_exp - b_exp : b_exp - a_exp;
	assign a_ext = {1'b0, a};
	assign b_ext = {1'b0, b};
	assign a_alig_reg = (a_exp > b_exp)? a_ext : a_ext >> dis;
	assign b_alig_reg = (a_exp > b_exp)? b_ext >> dis : b_ext;
	assign a_com = (s_a)? ~(a_alig) + 1 : a_alig;
	assign b_com = (s_b)? ~(b_alig) + 1 : b_alig;
	assign add_reg = a_com + b_com;
	assign s_out = add[48];
	assign addcom = (add[48])? ~(add[47:0]) + 1 : add[47:0];
	always@(posedge clk)begin
		if(reset)begin
			a_alig <= 0;
			b_alig <= 0;
		end
		else begin
			a_alig <= a_alig_reg;
			b_alig <= b_alig_reg;
		end
	end
	always@(posedge clk)begin
		if(reset)begin
			add <= 0;
		end
		else begin
			add <= add_reg;
		end
	end
	always@(*)begin
		if (addcom[47] == 1)begin
			addcom_shift = addcom >> 1;
			exp1 = exp + 1;
		end
		else begin
			addcom_shift = addcom;
			exp1 = exp;
		end
		con = `TRUE;
		for (i=46; con && (i>=0); i=i-1) begin
			zero_cnt = addcom_shift[i] ? 6'd46-i: 6'd0;
			con = addcom_shift[i] ? `FALSE : `TRUE;
		end
		out = addcom_shift << zero_cnt;
		out_exp = exp1 - zero_cnt;
	end
endmodule


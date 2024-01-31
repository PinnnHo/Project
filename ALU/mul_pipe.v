`define TRUE 1'b1
`define FALSE 1'b0
module mul_pipe(  clk, reset, X1, X2, X3, X4, Y1,Y2, Y3, Y4, ans);
	input clk, reset;
	input [31:0] X1, Y1, X2, Y2, X3, Y3, X4, Y4;
	output [31:0] ans;
	
	//unpack
	wire  X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s;
	wire [7:0] x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4;
	wire  [12:0] x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4;

	//reg1
	wire  X1_s_reg, Y1_s_reg, X2_s_reg, Y2_s_reg, X3_s_reg, Y3_s_reg, X4_s_reg, Y4_s_reg;
	wire [7:0] x_exp1_reg, y_exp1_reg, x_exp2_reg, y_exp2_reg, x_exp3_reg, y_exp3_reg, x_exp4_reg, y_exp4_reg;
	wire  [12:0] x_ext1_1_reg, x_ext2_1_reg, y_ext1_1_reg, y_ext2_1_reg,x_ext1_2_reg, x_ext2_2_reg, y_ext1_2_reg, y_ext2_2_reg, x_ext1_3_reg, x_ext2_3_reg, y_ext1_3_reg, y_ext2_3_reg, x_ext1_4_reg, x_ext2_4_reg, y_ext1_4_reg, y_ext2_4_reg;

	//mul_add
	wire s1, s2, s3, s4;
	wire [7:0] exp1, exp2, exp3, exp4;
	wire [51:0] add1, add2, add3, add4;
	

	//reg2
	wire s1_reg, s2_reg, s3_reg, s4_reg;
	wire [7:0] exp1_reg, exp2_reg, exp3_reg, exp4_reg;
	wire [51:0] add1_reg, add2_reg, add3_reg, add4_reg;
	
	//alig1
	wire [51:0] sum1, sum2;
	wire [7:0] exp_1, exp_2;

	//reg3
	wire [51:0] sum1_reg, sum2_reg;
	wire [7:0] exp_1_reg, exp_2_reg;

	//alig2
	wire sign;
	wire [7:0] exp;
	wire [50:0] sum;

	//reg4
	wire sign_reg;
	wire [7:0] exp_reg;
	wire [50:0] sum_reg;

	wire s;
	wire [7:0] exp_o;
	wire [46:0] sum_o;

	wire sign_flag ;
	assign sign_flag = (X1[31:16] != 1'b0)? 1 : 0; 
	wire en;
	wire gclk;
	assign en = sign_flag;
	assign gclk = clk & en;
	
	Unpack m1 (X1, Y1, X2, Y2, X3, Y3, X4, Y4, sign_flag, X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s, x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4, x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4);
	reg1 reg1( clk, gclk, reset,  X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s, x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4, x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4,
			X1_s_reg, Y1_s_reg, X2_s_reg, Y2_s_reg, X3_s_reg, Y3_s_reg, X4_s_reg, Y4_s_reg, x_exp1_reg, y_exp1_reg, x_exp2_reg, y_exp2_reg, x_exp3_reg, y_exp3_reg, x_exp4_reg, y_exp4_reg, x_ext1_1_reg, x_ext2_1_reg, y_ext1_1_reg, y_ext2_1_reg,x_ext1_2_reg, x_ext2_2_reg, y_ext1_2_reg, y_ext2_2_reg, x_ext1_3_reg, x_ext2_3_reg, y_ext1_3_reg, y_ext2_3_reg, x_ext1_4_reg, x_ext2_4_reg, y_ext1_4_reg, y_ext2_4_reg);
	
	mul_add m2 ( X1_s_reg, Y1_s_reg, X2_s_reg, Y2_s_reg, X3_s_reg, Y3_s_reg, X4_s_reg, Y4_s_reg, x_exp1_reg, y_exp1_reg, x_exp2_reg, y_exp2_reg, x_exp3_reg, y_exp3_reg, x_exp4_reg, y_exp4_reg, x_ext1_1_reg, x_ext2_1_reg, y_ext1_1_reg, y_ext2_1_reg,x_ext1_2_reg, x_ext2_2_reg, y_ext1_2_reg, y_ext2_2_reg, x_ext1_3_reg, x_ext2_3_reg, y_ext1_3_reg, y_ext2_3_reg, x_ext1_4_reg, x_ext2_4_reg, y_ext1_4_reg, y_ext2_4_reg, s1, s2, s3, s4, exp1, exp2, exp3, exp4, add1, add2, add3, add4);
	reg2 reg2( clk, reset, s1, s2, s3, s4, exp1, exp2, exp3, exp4, add1, add2, add3, add4, s1_reg, s2_reg, s3_reg, s4_reg, exp1_reg, exp2_reg, exp3_reg, exp4_reg, add1_reg, add2_reg, add3_reg, add4_reg);

	alig_sum1 m3( s1_reg, s2_reg, s3_reg, s4_reg, exp1_reg, exp2_reg, exp3_reg, exp4_reg, add1_reg, add2_reg, add3_reg, add4_reg, sum1, sum2, exp_1, exp_2);
	reg3 reg3( clk, reset, sum1, sum2, exp_1, exp_2, sum1_reg, sum2_reg, exp_1_reg, exp_2_reg);

	alig_sum2 m4(  exp_1_reg, exp_2_reg, sum1_reg, sum2_reg, sign, exp, sum);
	reg4 reg4( clk, reset, sign, exp, sum, sign_reg, exp_reg, sum_reg);

	normal m5( sign_reg, exp_reg, sum_reg, s, exp_o, sum_o);
	
	pack m6( s, exp_o, sum_o, ans);

endmodule

module reg4( clk, reset, sign, exp, sum, sign_reg, exp_reg, sum_reg);
	input clk, reset;
	input sign;
	input [7:0] exp;
	input [50:0] sum;
	output reg sign_reg;
	output reg [7:0] exp_reg;
	output reg [50:0] sum_reg;
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			sign_reg <= 0;
			exp_reg  <= 0;
			sum_reg  <= 0;
		end
		else begin
			sign_reg <=	sign;
			exp_reg  <=	exp ;
			sum_reg  <=	sum ;
		end
	end
endmodule

module Unpack(  X1, Y1, X2, Y2, X3, Y3, X4, Y4, sign_flag, X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s, x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4, x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4);
	input sign_flag;
	input [31:0] X1, Y1, X2, Y2, X3, Y3, X4, Y4;
	output  X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s;
	output [7:0] x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4;
	output  [12:0] x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4;

	assign X1_s = (sign_flag)? X1[31] : X1[15]; 
	assign Y1_s = (sign_flag)? Y1[31] : Y1[15];
	assign X2_s = (sign_flag)? X2[31] : X2[15]; 
	assign Y2_s = (sign_flag)? Y2[31] : Y2[15];
	assign X3_s = (sign_flag)? X3[31] : X3[15]; 
	assign Y3_s = (sign_flag)? Y3[31] : Y3[15];
	assign X4_s = (sign_flag)? X4[31] : X4[15]; 
	assign Y4_s = (sign_flag)? Y4[31] : Y4[15];

	assign x_exp1 = (sign_flag)? X1[30:23] : X1[14:10];
	assign y_exp1 = (sign_flag)? Y1[30:23] : Y1[14:10];
	assign x_exp2 = (sign_flag)? X2[30:23] : X2[14:10];
	assign y_exp2 = (sign_flag)? Y2[30:23] : Y2[14:10];
	assign x_exp3 = (sign_flag)? X3[30:23] : X3[14:10];
	assign y_exp3 = (sign_flag)? Y3[30:23] : Y3[14:10];
	assign x_exp4 = (sign_flag)? X4[30:23] : X4[14:10];
	assign y_exp4 = (sign_flag)? Y4[30:23] : Y4[14:10];

	//hight
	assign x_ext1_1 = (sign_flag)? {3'b001, X1[22:13]} : 0;
	assign x_ext1_2 = (sign_flag)? {3'b001, X2[22:13]} : 0;
	assign x_ext1_3 = (sign_flag)? {3'b001, X3[22:13]} : 0;
	assign x_ext1_4 = (sign_flag)? {3'b001, X4[22:13]} : 0;

	//low
	assign x_ext2_1 = (sign_flag)? X1[12:0] : {3'b001, X1[9:0]};
	assign x_ext2_2 = (sign_flag)? X2[12:0] : {3'b001, X2[9:0]};
	assign x_ext2_3 = (sign_flag)? X3[12:0] : {3'b001, X3[9:0]};
	assign x_ext2_4 = (sign_flag)? X4[12:0] : {3'b001, X4[9:0]};

	//hight
	assign y_ext1_1 = (sign_flag)? {3'b001, Y1[22:13]} : 0;
	assign y_ext1_2 = (sign_flag)? {3'b001, Y2[22:13]} : 0;
	assign y_ext1_3 = (sign_flag)? {3'b001, Y3[22:13]} : 0;
	assign y_ext1_4 = (sign_flag)? {3'b001, Y4[22:13]} : 0;

	//low
	assign y_ext2_1 = (sign_flag)? Y1[12:0] : {3'b001, Y1[9:0]};
	assign y_ext2_2 = (sign_flag)? Y2[12:0] : {3'b001, Y2[9:0]};
	assign y_ext2_3 = (sign_flag)? Y3[12:0] : {3'b001, Y3[9:0]};
	assign y_ext2_4 = (sign_flag)? Y4[12:0] : {3'b001, Y4[9:0]};

endmodule

module reg1( clk, gclk, reset,  X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s, x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4, x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4,
			X1_s_reg, Y1_s_reg, X2_s_reg, Y2_s_reg, X3_s_reg, Y3_s_reg, X4_s_reg, Y4_s_reg, x_exp1_reg, y_exp1_reg, x_exp2_reg, y_exp2_reg, x_exp3_reg, y_exp3_reg, x_exp4_reg, y_exp4_reg, x_ext1_1_reg, x_ext2_1_reg, y_ext1_1_reg, y_ext2_1_reg,x_ext1_2_reg, x_ext2_2_reg, y_ext1_2_reg, y_ext2_2_reg, x_ext1_3_reg, x_ext2_3_reg, y_ext1_3_reg, y_ext2_3_reg, x_ext1_4_reg, x_ext2_4_reg, y_ext1_4_reg, y_ext2_4_reg);
	input  clk, gclk, reset, X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s;
	input [7:0] x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4;
	input  [12:0] x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4;
	output reg X1_s_reg, Y1_s_reg, X2_s_reg, Y2_s_reg, X3_s_reg, Y3_s_reg, X4_s_reg, Y4_s_reg;
	output reg [7:0] x_exp1_reg, y_exp1_reg, x_exp2_reg, y_exp2_reg, x_exp3_reg, y_exp3_reg, x_exp4_reg, y_exp4_reg;
	output reg [12:0] x_ext1_1_reg, x_ext2_1_reg, y_ext1_1_reg, y_ext2_1_reg,x_ext1_2_reg, x_ext2_2_reg, y_ext1_2_reg, y_ext2_2_reg, x_ext1_3_reg, x_ext2_3_reg, y_ext1_3_reg, y_ext2_3_reg, x_ext1_4_reg, x_ext2_4_reg, y_ext1_4_reg, y_ext2_4_reg;
	
	always@(posedge clk or posedge reset)begin
		if(reset)begin
			X1_s_reg <= 0;
			Y1_s_reg <= 0; 
			X2_s_reg <= 0; 
			Y2_s_reg <= 0; 
			X3_s_reg <= 0; 
			Y3_s_reg <= 0; 
			X4_s_reg <= 0;
			Y4_s_reg <= 0;

			x_exp1_reg <= 0;
			y_exp1_reg <= 0;
			x_exp2_reg <= 0; 
			y_exp2_reg <= 0;
			x_exp3_reg <= 0;
			y_exp3_reg <= 0;
			x_exp4_reg <= 0;
			y_exp4_reg <= 0;
			
			x_ext2_1_reg <= 0;
			x_ext2_2_reg <= 0;
			x_ext2_3_reg <= 0;
			x_ext2_4_reg <= 0;
			y_ext2_1_reg <= 0;
			y_ext2_2_reg <= 0;
			y_ext2_3_reg <= 0;
			y_ext2_4_reg <= 0;

		end 
		else begin
			X1_s_reg <= X1_s;
			Y1_s_reg <= Y1_s; 
			X2_s_reg <= X2_s; 
			Y2_s_reg <= Y2_s; 
			X3_s_reg <= X3_s; 
			Y3_s_reg <= Y3_s; 
			X4_s_reg <= X4_s;
			Y4_s_reg <= Y4_s;

			x_exp1_reg <= x_exp1;
			y_exp1_reg <= y_exp1;
			x_exp2_reg <= x_exp2; 
			y_exp2_reg <= y_exp2;
			x_exp3_reg <= x_exp3;
			y_exp3_reg <= y_exp3;
			x_exp4_reg <= x_exp4;
			y_exp4_reg <= y_exp4;

			x_ext2_1_reg <= x_ext2_1;
			x_ext2_2_reg <= x_ext2_2;
			x_ext2_3_reg <= x_ext2_3;
			x_ext2_4_reg <= x_ext2_4;
			y_ext2_1_reg <= y_ext2_1;
			y_ext2_2_reg <= y_ext2_2;
			y_ext2_3_reg <= y_ext2_3;
			y_ext2_4_reg <= y_ext2_4;
		end
	end
	
	always@(posedge gclk or posedge reset)begin
		if(reset)begin
			x_ext1_1_reg <= 0 ;
			x_ext1_2_reg <= 0 ;
			x_ext1_3_reg <= 0 ;
			x_ext1_4_reg <= 0 ;
			y_ext1_1_reg <= 0 ;
			y_ext1_2_reg <= 0 ;
			y_ext1_3_reg <= 0 ;
			y_ext1_4_reg <= 0 ;
		end
		else begin
			x_ext1_1_reg <= x_ext1_1 ;
			x_ext1_2_reg <= x_ext1_2 ;
			x_ext1_3_reg <= x_ext1_3 ;
			x_ext1_4_reg <= x_ext1_4 ;
			y_ext1_1_reg <= y_ext1_1 ;
			y_ext1_2_reg <= y_ext1_2 ;
			y_ext1_3_reg <= y_ext1_3 ;
			y_ext1_4_reg <= y_ext1_4 ;
		end
	end

endmodule

module mul_add(  X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s, x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4, x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4, s1, s2, s3, s4, exp1, exp2, exp3, exp4, add1, add2, add3, add4);
	input  X1_s, Y1_s, X2_s, Y2_s, X3_s, Y3_s, X4_s, Y4_s;
	input [7:0] x_exp1, y_exp1, x_exp2, y_exp2, x_exp3, y_exp3, x_exp4, y_exp4;
	input  [12:0] x_ext1_1, x_ext2_1, y_ext1_1, y_ext2_1,x_ext1_2, x_ext2_2, y_ext1_2, y_ext2_2, x_ext1_3, x_ext2_3, y_ext1_3, y_ext2_3, x_ext1_4, x_ext2_4, y_ext1_4, y_ext2_4;
	output s1, s2, s3, s4;
	output [7:0] exp1, exp2, exp3, exp4;
	output [51:0] add1, add2, add3, add4;

	wire sign_flag;
	reg [25:0] m1[1:4];
	reg [25:0] m2[1:4];
	reg [25:0] m3[1:4];
	reg [25:0] m4[1:4];
	
	assign sign_flag = (x_ext1_1)? 1 : 0;

	assign s1 =  X1_s ^ Y1_s;
	assign s2 =  X2_s ^ Y2_s;
	assign s3 =  X3_s ^ Y3_s;
	assign s4 =  X4_s ^ Y4_s;

	assign exp1 = (sign_flag)? x_exp1 + y_exp1 - 127 : x_exp1 + y_exp1 - 15;
	assign exp2 = (sign_flag)? x_exp2 + y_exp2 - 127 : x_exp2 + y_exp2 - 15;
	assign exp3 = (sign_flag)? x_exp3 + y_exp3 - 127 : x_exp3 + y_exp3 - 15;
	assign exp4 = (sign_flag)? x_exp4 + y_exp4 - 127 : x_exp4 + y_exp4 - 15;

	//add mul
	assign add1 = {m1[4], 26'b0} + {m1[3], {13{1'b0}}} + {m1[2], {13{1'b0}}} + m1[1];
	assign add2 = {m2[4], 26'b0} + {m2[3], {13{1'b0}}} + {m2[2], {13{1'b0}}} + m2[1];
	assign add3 = {m3[4], 26'b0} + {m3[3], {13{1'b0}}} + {m3[2], {13{1'b0}}} + m3[1];
	assign add4 = {m4[4], 26'b0} + {m4[3], {13{1'b0}}} + {m4[2], {13{1'b0}}} + m4[1];
	
	//h-h
	always@(*)begin
		m1[4] = x_ext1_1 * y_ext1_1;
		m2[4] = x_ext1_2 * y_ext1_2;
		m3[4] = x_ext1_3 * y_ext1_3;
		m4[4] = x_ext1_4 * y_ext1_4;
	end

	//l-h
	always@(*)begin
		m1[3] = x_ext2_1 * y_ext1_1;
		m2[3] = x_ext2_2 * y_ext1_2;
		m3[3] = x_ext2_3 * y_ext1_3;
		m4[3] = x_ext2_4 * y_ext1_4;
	end

	//h-l
	always@(*)begin
		m1[2] = x_ext1_1 * y_ext2_1;
		m2[2] = x_ext1_2 * y_ext2_2;
		m3[2] = x_ext1_3 * y_ext2_3;
		m4[2] = x_ext1_4 * y_ext2_4;
	end

	//l-l
	always@(*)begin
		m1[1] = x_ext2_1 * y_ext2_1;
		m2[1] = x_ext2_2 * y_ext2_2;
		m3[1] = x_ext2_3 * y_ext2_3;
		m4[1] = x_ext2_4 * y_ext2_4;
	end
endmodule

module reg2(clk, reset, s1, s2, s3, s4, exp1, exp2, exp3, exp4, add1, add2, add3, add4, s1_reg, s2_reg, s3_reg, s4_reg, exp1_reg, exp2_reg, exp3_reg, exp4_reg, add1_reg, add2_reg, add3_reg, add4_reg);
	input clk, reset;
	input s1, s2, s3, s4;
	input [7:0] exp1, exp2, exp3, exp4;
	input [51:0] add1, add2, add3, add4;
	output reg s1_reg, s2_reg, s3_reg, s4_reg;
	output reg [7:0] exp1_reg, exp2_reg, exp3_reg, exp4_reg;
	output reg [51:0] add1_reg, add2_reg, add3_reg, add4_reg;

	always@(posedge clk or posedge reset)begin
		if(reset)begin
			s1_reg <= 0;
			s2_reg <= 0;
			s3_reg <= 0;
			s4_reg <= 0;
			exp1_reg <= 0;
			exp2_reg <= 0;
			exp3_reg <= 0;
			exp4_reg <= 0; 
			add1_reg <= 0;
			add2_reg <= 0;
			add3_reg <= 0;
			add4_reg <= 0;
		end
		else begin
			s1_reg <= s1;
			s2_reg <= s2;
			s3_reg <= s3;
			s4_reg <= s4;
			exp1_reg <= exp1;
			exp2_reg <= exp2;
			exp3_reg <= exp3;
			exp4_reg <= exp4; 
			add1_reg <= add1;
			add2_reg <= add2;
			add3_reg <= add3;
			add4_reg <= add4;
		end
	end
endmodule

module alig_sum1(s1, s2, s3, s4, exp1, exp2, exp3, exp4, add1, add2, add3, add4, sum1, sum2, exp_1, exp_2);
	input s1, s2, s3, s4;
	input [7:0] exp1, exp2, exp3, exp4;
	input [51:0] add1, add2, add3, add4;
	output [51:0] sum1, sum2;
	output [7:0] exp_1, exp_2;

	wire [51:0] add_1, add_2, add_3, add_4;
	wire [51:0] add_1_2, add_2_2, add_3_2, add_4_2;

	//alignment
	assign exp_1 = (exp1 > exp2)? exp1 : exp2;
	assign exp_2 = (exp3 > exp4)? exp3 : exp4;
	assign add_1 = (exp1 > exp2)? add1 : add1 >> (exp2 - exp1);
	assign add_2 = (exp1 > exp2)? add2 >> (exp1 - exp2) : add2;
	assign add_3 = (exp3 > exp4)? add3 : add3 >> (exp4 - exp3);
	assign add_4 = (exp3 > exp4)? add4 >> (exp3 - exp4) : add4;

	//2's
	assign add_1_2 = (s1) ? ~add_1 + 1 : add_1;
	assign add_2_2 = (s2) ? ~add_2 + 1 : add_2;
	assign add_3_2 = (s3) ? ~add_3 + 1 : add_3;
	assign add_4_2 = (s4) ? ~add_4 + 1 : add_4;

	//add12 add34
	assign sum1 = add_1_2 + add_2_2;
	assign sum2 = add_3_2 + add_4_2;

endmodule

module reg3 ( clk, reset, sum1, sum2, exp_1, exp_2, sum1_reg, sum2_reg, exp_1_reg, exp_2_reg);
	input clk, reset;
	input [51:0] sum1, sum2;
	input [7:0] exp_1, exp_2;
	output reg  [51:0] sum1_reg, sum2_reg;
	output reg  [7:0] exp_1_reg, exp_2_reg;

	always@(posedge clk or posedge reset)begin
		if(reset)begin
			sum1_reg <= 0;
			sum2_reg <= 0;
			exp_1_reg <= 0;
			exp_2_reg <= 0;
		end
		else begin
			sum1_reg <= sum1;
			sum2_reg <= sum2;
			exp_1_reg <= exp_1;
			exp_2_reg <= exp_2;
		end
	end
endmodule

module alig_sum2(  exp_1, exp_2, sum1, sum2, sign, exp, sum);
	input signed[51:0] sum1, sum2;
	input [7:0] exp_1, exp_2;
	output sign;
	output [7:0] exp;
	output [50:0] sum;
	wire s1, s2;
	
	wire signed [51:0] sum1_1, sum2_1;
	wire [52:0] add;

	//alignment
	assign s1 = sum1[51];
	assign s2 = sum2[51];
	assign exp = (exp_1 > exp_2)? exp_1 : exp_2;
	assign sum1_1 = (exp_1 > exp_2)? sum1 : sum1 >>> (exp_2 - exp_1);
	assign sum2_1 = (exp_1 > exp_2)? sum2 >>> (exp_1 - exp_2) : sum2;

	//add1234
	assign add = sum1_1 + sum2_1;

	//2's
	assign sign = add[51];
	assign sum = (add[51])? ~add[50:0] + 1 : add[50:0];

endmodule

module normal( sign, exp, sum, s, exp_o, sum_o);
	input sign;
	input [7:0] exp;
	input [50:0] sum;
	output s;
	output reg [7:0] exp_o;
	output reg [46:0] sum_o;
	reg [5:0] zero_cnt;
	wire flag;
	reg con;
	integer i;
	assign flag = (sum[50:24] == 0)? 0 : 1;
	assign s = sign;
	always@(*)begin
		con = `TRUE;
		for( i = 50 ; con && (i>=0); i = i - 1)begin
			zero_cnt = (sum[i])? 6'd50 - i : 0;
			con = (sum[i])? `FALSE : `TRUE;
		end
	end
	
	always@(*)begin
		if(flag)begin
			if(sum[49])begin
				exp_o = exp + 3;
				sum_o = sum[48:0] >> 2;
			end
			else if(sum[48])begin
				exp_o = exp + 2;
				sum_o = sum[47:0] >> 1;
			end
			else if(sum[47])begin
				exp_o = exp + 1;
				sum_o = sum[46:0];
			end
			else begin
				exp_o = exp - (zero_cnt - 4);
				sum_o = sum[46:0] << (zero_cnt - 3);
			end
		end
		else begin
			if(sum[23])begin
				exp_o = exp + 3;
				sum_o = sum[22:0] >> 2;
			end
			else if(sum[22])begin
				exp_o = exp + 2;
				sum_o = sum[21:0] >> 1;
			end
			else if(sum[21])begin
				exp_o = exp + 1;
				sum_o = sum[20:0];
			end
			else begin
				exp_o = exp - (zero_cnt - 30);
				sum_o = sum[20:0] << (zero_cnt - 29);
			end
		end
	end
endmodule

module pack(sign, exp, sum, ans);
	input sign;
	input [7:0] exp;
	input [46:0] sum;
	output [31:0] ans;

	wire flag;
	assign flag = (sum[46:24] == 0)? 0 : 1;
	wire G, R, S, L, Gh, Rh, Sh, Lh;
	reg [22:0] sum_1;

	assign G = sum[23];
	assign R = sum[22];
	assign S = (sum[21:0] != 0) ? 1 : 0;
	assign L = sum[24];
	assign Gh = sum[10];
	assign Rh = sum[9];
	assign Sh = (sum[8:0] != 0) ? 1 : 0;
	assign Lh = sum[11];
	assign ans = (flag)? {sign, exp, sum_1} : {16'b0,sign,exp[4:0],sum_1[9:0]};
	always@(*)begin
		if(flag)begin
			if(G && ( R || S || L))	sum_1 = sum[46:24] + 1;
			else sum_1 = sum[46:24];
		end
		else begin
			if(Gh && (Rh || Sh || Lh)) sum_1 = sum[20:11] + 1;
			else sum_1 = sum[20:11] ;
		end
	end
endmodule
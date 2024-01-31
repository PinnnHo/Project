`timescale 1ns/1ps
`define bits 9
module Datapath ( inportR, inportG, inportB, control, clk, rst_n, outportY, outportU, outportV, done );
	input [`bits-1:0] inportR, inportG, inportB;
	input [14:0] control;
	input clk, rst_n, done;
	output [`bits-1:0] outportY, outportU, outportV;
	wire [`bits-1:0] M1_OUT, M2_OUT, M3_OUT, M4_OUT, M5_OUT, M6_OUT, M7_OUT;
	wire [`bits-1:0] M8_OUT, M9_OUT, add1, mul2, add2, mul3, add3, mul1, R1, R2, R3, R4, R5, R6, R7, R8;
	wire [`bits*3-1:0]  data;

	Register r1( .D(M2_OUT), .reset(rst_n), .clk(clk), .load(control[14:14]), .Q(R1) );
	Register r2( .D(M3_OUT), .reset(rst_n), .clk(clk), .load(control[13:13]), .Q(R2) );
	Register r3( .D(M4_OUT), .reset(rst_n), .clk(clk), .load(control[12:12]), .Q(R3) );
	Register r4( .D(mul1), .reset(rst_n), .clk(clk), .load(control[11:11]), .Q(R4) );
	Register r5( .D(mul2), .reset(rst_n), .clk(clk), .load(control[10:10]), .Q(R5) );
	Register r6( .D(M5_OUT), .reset(rst_n), .clk(clk), .load(control[9:9]), .Q(R6) );
	Register r7( .D(add1), .reset(rst_n), .clk(clk), .load(control[8:8]), .Q(R7) );
	Register r8( .D(mul3), .reset(rst_n), .clk(clk), .load(control[7:7]), .Q(R8) );
	
	MUX2 M1 ( .A(R6), .B(R3), .S(control[4:4]), .Y(M1_OUT) );
	MUX2 M2 ( .A(inportR), .B(add3), .S(control[3:3]), .Y(M2_OUT) );
	MUX2 M3 ( .A(inportG), .B(add3), .S(control[2:2]), .Y(M3_OUT) );
	MUX2 M4 ( .A(inportB), .B(add2), .S(control[1:1]), .Y(M4_OUT) );
	MUX2 M5 ( .A(mul3), .B(add3), .S(control[0:0]), .Y(M5_OUT) );
	
	Mul FU1 ( .A(R1), .B(data[26:18]), .Mul(mul1) );
	Add FU2 ( .A(R4), .B(R5), .Add(add1) );
	
	Mul FU3 ( .A(R2), .B(data[17:9]), .Mul(mul2) );
	Add FU4 ( .A(R8), .B(9'b010000000), .Add(add2) );
	
	Mul FU5 ( .A(R3), .B(data[8:0]), .Mul(mul3) );
	Add FU6 ( .A(M1_OUT), .B(R7), .Add(add3) );
	
	ROM ROM1 ( .clk(clk), .addr(control[6:5]), .data(data) );
	Register r11(R1, rst_n, clk, done, outportY);
	Register r12(R6, rst_n, clk, done, outportU);
	Register r13(R2, rst_n, clk, done, outportV);
endmodule
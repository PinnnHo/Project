`timescale 1ns/1ps
`define bits 9
`define S0 4'b0000
`define S1 4'b0001
`define S2 4'b0010
`define S3 4'b0011
`define S4 4'b0100
`define S5 4'b0101
`define S6 4'b0110
module Controller ( start, rst_n, clk, done, control);
	input start, rst_n, clk;
	output reg done;
	output reg [14:0] control;
	reg [3:0] Current_State, Next_State;
	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) Current_State <= `S0;
		else Current_State <= Next_State;
	end
	
	always @(Current_State or start)
	begin
		case (Current_State)
			`S0:
			begin
				control = 15'b1_1_1_0_0_0_0_0_00_0_0_0_0_0;
				done = 1'b0;
				if(~start) Next_State = `S0;
				else Next_State = `S1;
			end
			`S1:
			begin
				control = 15'b0_0_0_1_1_1_0_0_01_0_0_0_0_0;
				done = 1'b0;
				Next_State = `S2;
			end
			`S2:
			begin
				control = 15'b0_0_0_1_1_0_1_1_10_0_0_0_0_0;
				done = 1'b0;
				Next_State = `S3;
			end
			`S3:
			begin
				control = 15'b1_0_1_1_1_0_1_1_11_0_1_0_1_0;
				done = 1'b0;
				Next_State = `S4;
			end
			`S4:
			begin
				control = 15'b0_0_1_0_0_1_1_0_00_1_0_0_1_1;
				done = 1'b0;
				Next_State = `S5;
			end
			`S5:
			begin
				control = 15'b0_1_0_0_0_0_0_0_00_1_0_1_0_0;
				done = 1'b0;
				Next_State = `S6;
			end
			`S6:
			begin
				control = 15'b0_1_0_0_0_0_0_0_00_1_0_1_0_0;
				done = 1'b1;
				Next_State = `S0;
			end
			default:
			begin
				control= 15'b0_1_0_0_0_0_0_0_00_1_0_1_0_0;
				done = 1'b1;
				Next_State = `S0;
			end
		endcase
	end
endmodule
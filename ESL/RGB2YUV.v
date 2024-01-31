`timescale 1ns/1ps
`define bits 9

module RGB2YUV (start, clk, rst_n, inportR, inportG, inportB, done, outportY, outportU, outportV);
	input start, clk, rst_n; //0-1
	input [`bits-1:0] inportR, inportG, inportB; //2-4
	output done;	//5
	output [`bits-1:0] outportY, outportU, outportV;	//6-8
	wire [14:0] control;
	
	Controller Controller( .start(start), .rst_n(rst_n), .clk(clk), .done(done), .control(control) );
	Datapath Datapath( .inportR(inportR), .inportG(inportG), .inportB(inportB), .control(control), .clk(clk),
		.rst_n(rst_n), .outportY(outportY), .outportU(outportU), .outportV(outportV) ,.done(done) );
endmodule
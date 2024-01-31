module ROM (clk, addr, data);
	input clk;
	input [1:0] addr;
	output reg [26:0] data;
	
	always @(*)
	begin
		case(addr)
			2'b00: data <= 27'b0;
			2'b01: data <= 27'b001001100_010010110_000011101;
			2'b10: data <= 27'b111010101_110101100_010000000;
			2'b11: data <= 27'b010000000_110010101_111101100;
		endcase
	end
endmodule
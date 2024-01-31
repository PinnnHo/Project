`define buffer_size 226*2+2
`define img_size 226*226
module Top( clk, reset, in, in2, in3, in4, weight1, weight2, weight3, weight4, bias, in_last, out, write);
    input clk, reset;
    input signed[15:0] weight1, weight2, weight3, weight4;
	input signed[15:0] bias;
	input [8:0] in, in2, in3, in4, in_last;
    output signed [35:0] out;
    output reg write;
    wire [8:0] out1_1, out2_1, out3_1, out4_1, out5_1, out6_1, out7_1, out8_1, out9_1;
    wire [8:0] out1_2, out2_2, out3_2, out4_2, out5_2, out6_2, out7_2, out8_2, out9_2;
    wire [8:0] out1_3, out2_3, out3_3, out4_3, out5_3, out6_3, out7_3, out8_3, out9_3;
    wire [8:0] out1_4, out2_4, out3_4, out4_4, out5_4, out6_4, out7_4, out8_4, out9_4;
    reg [16:0] cnt_addre;
    reg [1:0] state, next_state;
    wire signed[35:0] tmp ;
    parameter IDLE = 0, LOAD_IMG = 1, OP = 2, FINISH = 3;
    reg read, read2;
    wire signed [35:0] out1, out2, out3, out4;
    integer i;
    assign tmp = out1 + out2 + out3 + out4 + in_last;
    assign out = (tmp <= 0)? 0 : tmp;
    always@(posedge clk)begin
        if(reset)   cnt_addre <= 0;
        else cnt_addre <= cnt_addre + 1;
    end
    always@(posedge clk or posedge reset)begin
        if(reset)   state <= IDLE;
        else state <= next_state;
    end
    
    always@(*)begin
        case(state)
            IDLE: next_state = (reset)? IDLE : LOAD_IMG;
            LOAD_IMG:begin
                if(cnt_addre <= `buffer_size)   next_state = LOAD_IMG;
                else next_state = OP;
            end
            OP:begin
                if(cnt_addre <= `img_size - 1)  next_state = OP;
                else next_state = FINISH;
            end
            FINISH: next_state = FINISH;
            default:    next_state = FINISH; 
        endcase
    end
    
    always@(posedge clk)begin
        if(reset) write <= 0;
        else if(cnt_addre%226==224 || cnt_addre%226 == 225) write <= 0;
        else write <= 1;
    end

    always@(*)begin
        if(reset) read <= 0;
        else if(state == LOAD_IMG || state == OP)   read <= 1;
        else read <= 0;
    end
    always@(*)begin
        if(reset) read2 <= 0;
        else if(state == OP)   read2 <= 1;
        else read2 <= 0;
    end

    line line1 ( clk, reset, read, in, out1_1, out2_1, out3_1, out4_1, out5_1, out6_1, out7_1, out8_1, out9_1);
    line line2 ( clk, reset, read, in2, out1_2, out2_2, out3_2, out4_2, out5_2, out6_2, out7_2, out8_2, out9_2);
    line line3 ( clk, reset, read, in3, out1_3, out2_3, out3_3, out4_3, out5_3, out6_3, out7_3, out8_3, out9_3);
    line line4 ( clk, reset, read, in4, out1_4, out2_4, out3_4, out4_4, out5_4, out6_4, out7_4, out8_4, out9_4);

    weightbuffer_adder ww (clk, reset,  read, read2, weight1, bias, out1_1, out2_1, out3_1, out4_1, out5_1, out6_1, out7_1, out8_1, out9_1, out1);
    weightbuffer_adder ww2 (clk, reset,  read, read2, weight2, bias, out1_2, out2_2, out3_2, out4_2, out5_2, out6_2, out7_2, out8_2, out9_2, out2);
    weightbuffer_adder ww3 (clk, reset,  read, read2, weight3, bias, out1_3, out2_3, out3_3, out4_3, out5_3, out6_3, out7_3, out8_3, out9_3, out3);
    weightbuffer_adder ww4 (clk, reset,  read, read2, weight4, bias, out1_4, out2_4, out3_4, out4_4, out5_4, out6_4, out7_4, out8_4, out9_4, out4);
endmodule

module weightbuffer_adder(clk, reset,  read, read2, weight, bias, out1, out2, out3, out4, out5, out6, out7, out8, out9, out);
    input clk, reset, read, read2;
    input signed[15:0] weight;
    input signed[15:0] bias;
    input [8:0] out1, out2, out3, out4, out5, out6, out7, out8, out9;
    output reg signed [35:0] out;
    reg signed[15:0] w [1:9];
    reg signed [35:0] temp1, temp2, temp3, temp4, temp5, temp6 , temp7, temp8, sum, relu, tt;
    reg [15:0] cnt_add;
    integer i;
    always@(posedge clk)begin
        if(reset)   for(i = 1 ;i < 10 ;i = i+1) w[i] <= 0; 
        else if(read) w[cnt_add] <= weight;
        else w[cnt_add] <= w[cnt_add];
    end
    always@(posedge clk) begin
        if(reset) cnt_add <= 0;
        else cnt_add <= cnt_add + 1;
    end
    always@(*)begin
        tt = w[1];
    end
    always@(*)begin//adder_tree
        if(read2==0)   relu = 0;
        else begin
            temp1 = $signed(out1) * w[1] + $signed(out2) * w[2];
			temp2 = $signed(out3) * w[3] + $signed(out4) * w[4];
			temp3 = $signed(out5) * w[5] + $signed(out6) * w[6];
			temp4 = $signed(out7) * w[7] + $signed(out8) * w[8];
			temp5 = temp1 + temp2 ;
			temp6 = temp3 + temp4;
			temp7 = $signed(out9) * w[9] + bias;
            temp8 = temp5 + temp6;
			sum =  temp8 + temp7;
            relu = (sum <= 0)? 0 : sum;
        end
    end
    
    always@(posedge clk)begin
        if(reset)   out <= 0;
        else if(read2) out <= relu;
        else out <= 0;
    end
endmodule

module line( clk, reset, read, in, out1, out2, out3, out4, out5, out6, out7, out8, out9);
    input clk, reset, read;
    input [8:0] in;
    output reg [8:0] out1, out2, out3, out4, out5, out6, out7, out8, out9;
    reg [8:0] buffer[1:`buffer_size+1];
    integer i;

    always@(posedge clk)begin
        buffer[`buffer_size+1] <= in;
        for(i = `buffer_size  ; i > 0 ; i = i -1)    buffer[i] <= buffer[i+1];
    end

    always@(posedge clk)begin
        if(reset)  begin
            out1 <= 0;
            out2 <= 0;
            out3 <= 0;
            out4 <= 0;
            out5 <= 0;
            out6 <= 0;
            out7 <= 0;
            out8 <= 0;
            out9 <= 0;
        end
        else if(read) begin
            out1 <= buffer[1];
            out2 <= buffer[2];
            out3 <= buffer[3];
            out4 <= buffer[227];
            out5 <= buffer[228];
            out6 <= buffer[229];
            out7 <= buffer[453];
            out8 <= buffer[454];
            out9 <= buffer[455];
        end
        else begin
            out1 <= out1;
            out2 <= out2;
            out3 <= out3;
            out4 <= out4;
            out5 <= out5;
            out6 <= out6;
            out7 <= out7;
            out8 <= out8;
            out9 <= out9;
        end
    end

endmodule

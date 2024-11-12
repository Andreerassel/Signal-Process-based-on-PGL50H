`timescale	1ns/1ns
module tb_test();
reg			sys_clk	;
reg			sys_rst_n	;
wire  [7:0] data;   
reg   [7:0] cnt_data;
reg   [15:0]cnt_key;
reg         key_in1;
reg         key_in2;
reg         key_in3;

reg [7:0] 	tb_cnt	;
reg [7:0] 	tb_cnt1	;
reg [7:0] 	tb_cnt2	;

reg 		tb_start_2;	
reg 		tb_start_3;	
initial
	begin
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		#20
		sys_rst_n <= 1'b1;
	end

always #10 sys_clk = ~sys_clk;

always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 1'd0)
		cnt_data <= 1'b0;
	else if(cnt_data == 8'd255)
		cnt_data <= 1'b0;
	else
		cnt_data <= cnt_data +1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 8'd0)begin
		tb_cnt <= 1'b0;
		tb_start_2 <= 1'd0;
	end
	else if(tb_cnt == 8'd249)begin
		tb_cnt <= tb_cnt;
		tb_start_2 <= 1'd1;
	end
	else
		tb_cnt <= tb_cnt +1'b1;
		
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 8'd0)begin
		tb_cnt1 <= 1'b0;
		tb_start_3 <= 1'd0;
	end
	else if(tb_start_2)begin 
		if(tb_cnt1 == 8'd249)begin
			tb_cnt1 <= tb_cnt1;
			tb_start_3 <= 1'd1;
		end
		else
			tb_cnt1 <= tb_cnt1 +1'b1;
	end

always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 8'd0)begin
		tb_cnt2 <= 1'b0;
	end
	else if(tb_start_3)begin 
		if(tb_cnt2 == 8'd249)begin
			tb_cnt2 <= tb_cnt2;
		end
		else
			tb_cnt2 <= tb_cnt2 +1'b1;
	end

always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 8'd0)
		key_in1 <= 1'b1;
	else if(((tb_cnt >= 8'd19) && (tb_cnt <=8'd49)) 
		|| ((tb_cnt >= 8'd149)&&(tb_cnt <=8'd199)))
		key_in1 <= {$random}%2;
	else if((tb_cnt < 8'd19) ||(tb_cnt > 8'd199))
		key_in1 <= 1'b1;
	else
	key_in1 <= 1'b0;

always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 8'd0)
		key_in2 <= 1'b1;
	else if(tb_start_2)begin 
		if(((tb_cnt1 >= 8'd19) && (tb_cnt1 <=8'd49)) 
			|| ((tb_cnt1 >= 8'd149)&&(tb_cnt1 <=8'd199)))
			key_in2 <= {$random}%2;
		else if((tb_cnt1 < 8'd19) ||(tb_cnt1 > 8'd199))
			key_in2 <= 1'b1;
		else
			key_in2 <= 1'b0;
	end
	
	
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 8'd0)
		key_in3 <= 1'b1;
	else if(tb_start_3)begin 
		if(((tb_cnt2 >= 8'd19) && (tb_cnt2 <=8'd49)) 
			|| ((tb_cnt2 >= 8'd149)&&(tb_cnt2 <=8'd199)))
			key_in3 <= {$random}%2;
		else if((tb_cnt2 < 8'd19) ||(tb_cnt2 > 8'd199))
			key_in3 <= 1'b1;
		else
			key_in3 <= 1'b0;
	end
	

logic_analyzer u_logic_analyzer(
    .clk       (sys_clk),
    .rst       (sys_rst_n),
    .data_in   (cnt_data),
    .key_1     (key_in1),
    .key_2     (key_in2),
	.key_3	   (key_in3),
   .data_out   (data)
   );

wire GRS_N;
GTP_GRS GRS_INST (
.GRS_N(1'b1)
);

endmodule
`timescale	1ns/1ns
module tb_ctrl_test();
reg			sys_clk	;
reg			sys_rst_n	;
reg 		key_in	;
reg [25:0] 	tb_cnt	;
wire		key_flag;
// wire		da_clk;
// wire  [7:0] da_data;

parameter CNT_MAX = 2_999_999;
parameter DEBOUNCE_MAX = 999_999;

initial
	begin
		sys_clk = 1'b1;
		sys_rst_n <= 1'b0;
		#20
		sys_rst_n <= 1'b1;
	end

always #10 sys_clk = ~sys_clk;

always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 8'd0)
		tb_cnt <= 1'b0;
	else if(tb_cnt == CNT_MAX)
		tb_cnt <= 1'b1;
	else
		tb_cnt <= tb_cnt +1'b1;
always@(posedge sys_clk or negedge sys_rst_n)
	if(sys_rst_n == 8'd0)
		key_in <= 1'b1;
	else if(((tb_cnt >= 8'd19) && (tb_cnt <=8'd100)) )
		key_in <= {$random}%2;
	else if((tb_cnt >8'd100) &&(tb_cnt <= 8'd200))
		key_in <= 1'b1;
	else
	key_in <= 1'b0;

wire GRS_N;
GTP_GRS GRS_INST (
.GRS_N(1'b1)
);

Key_Debounce Key_Debounce_inst(
   .sys_clk      	(sys_clk) 	,
   .sys_rst_n		(sys_rst_n)	,
   .key_in			(key_in	) 	,
   .key_flag		(key_flag)
);
endmodule
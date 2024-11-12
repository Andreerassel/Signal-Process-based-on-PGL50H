`timescale	1ns/1ns
module tb_sampler();
reg			sys_clk	   ;
reg			sys_rst_n	;

wire        clkout_0;
wire        clkout_1;
wire        clkout_2;
wire        clkout_3;
wire        clkout_4;

reg [7:0]   cnt_data ;
reg         INPUT    ;
reg [1:0]   mode     ;
wire        rst_pll  ;
wire        data_in  ;
wire[9:0]   addrq    ;
wire        wren     ;
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
	if(sys_rst_n == 1'd0)
		INPUT <= 1'b0;
	else if(cnt_data == 8'd51 || cnt_data == 8'd102 || cnt_data == 8'd153 || cnt_data == 8'd204 || cnt_data == 8'd255)
		INPUT <= ~INPUT;
	else
		INPUT <= INPUT ;

always @(posedge sys_clk or negedge sys_rst_n) begin
   if(sys_rst_n == 1'b0)
      mode <= 2'd0;
   else if(cnt_data == 8'd255)
      mode <= mode + 1;
   else
      mode <= mode  ;
end


sampler 
#(
   .BUS_WIDTH     (1)
)
u_sampler
(
   .INPUT         (INPUT), // 8-bit
   .trig_kind     (mode), //(00 - none, 01 - rising, 10 - falling 11 - both)
   .rst           (~sys_rst_n),
   .clk           (sys_clk), 

   .Q             (data_in), 
   .addrq         (addrq), // 样本地址
   .wren          (wren),
   .trigger       ()
);
// glitch_free u_glitch_free(
//    .clk1    (clkout_1),
//    .clk2    (clkout_2),
//    .clk3    (clkout_3),
//    .rstn    (rst),
//    .sel     (mode),
//    .clk_out (clkout_4)
// );

// PLL_4 u_pll (
//   .clkin1(sys_clk),        // input
//   .pll_lock(rst_pll),     // output
//   .clkout0(clkout_0),      // 1Mhz
//   .clkout1(clkout_1),      // 25Mhz
//   .clkout2(clkout_2),      // 50Mhz
//   .clkout3(clkout_3)       // 100Mhz
// );
endmodule

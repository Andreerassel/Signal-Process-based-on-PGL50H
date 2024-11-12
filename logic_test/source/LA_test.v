module LA_test(
   input clk,
   input rst,/* synthesis PAP_MARK_DEBUG = "true" */

   input key_1_start,//开始
   input key_2_frq,//频率
   input key_3_tri,//触发方式
   input key_4_wave,//数字信号波形
   input key_5_frq//数字信号频率
   );

wire [7:0] data_out;/* synthesis PAP_MARK_DEBUG = "true" */ 
wire [7:0] data_read;/* synthesis PAP_MARK_DEBUG = "true" */ 
wire clk_250M;/* synthesis PAP_MARK_DEBUG = "true" */ 
wire pll_lock;


logic_analyzer u_logic_analyzer(
   .clk        (clk),
   .rst        (rst),
   .data_in    (data_out),
   .key_1      (key_1_start),
   .key_2      (key_2_frq),
   .key_3      (key_3_tri),
   .data_out   (data_read)   
   );   
Signal_generators u_Signal_generators(
   .clk_50M         (clk),
   .key_4		  (key_4_wave),
   .key_5           (key_5_frq),
   .da_clk          (),
   .da_data         (data_out)
   );

pll_ pll_250 (
  .clkin1(clk),        // input
  .pll_lock(pll_lock),    // output
  .clkout0(clk_250M)      // output
);

endmodule
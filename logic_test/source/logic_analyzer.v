module logic_analyzer(
   input clk,
   input rst,
   input wire [7:0] data_in,/* synthesis PAP_MARK_DEBUG = "true" */
   input key_1,
   input key_2,
   input key_3,
   output wire [7:0] data_out/* synthesis PAP_MARK_DEBUG = "true" */
   );
wire  clkout_0 ;
wire  clkout_1 ;
wire  clkout_2 ;
wire  clkout_3 ;
wire  clkout_4 ;
reg  [1:0] mode_2_frq;/* synthesis PAP_MARK_DEBUG = "true" */
reg  [1:0] mode_3_tri;/* synthesis PAP_MARK_DEBUG = "true" */
reg   start    ;
wire  key_en1 ;/* synthesis PAP_MARK_DEBUG = "true" */
wire  key_en2 ;/* synthesis PAP_MARK_DEBUG = "true" */
wire  key_en3 ;/* synthesis PAP_MARK_DEBUG = "true" */

wire        rst_pll  ;

wire  [7:0] rd_data  ;

wire  [9:0] addrq    /* synthesis PAP_MARK_DEBUG = "true" */;
wire  [7:0] data_q;
wire  [9:0] rd_addr  /* synthesis PAP_MARK_DEBUG = "true" */;
reg   [9:0] read_cnt ;
wire        begin_read;   
wire         wren     /* synthesis PAP_MARK_DEBUG = "true" */;

// always @(posedge clk or negedge rst) begin//开始
//    if(~rst)
//       start <= 1'b0;
//    else if(key_en1 == 1'b1)
//       start <= ~start;
// end

always @(posedge clk) begin//模式转换
   if (rst == 1'b0)
      mode_2_frq <= 2'd0;   
   else if(mode_2_frq == 2'd3+1)
      mode_2_frq <= 2'd1;
   else if(key_en2)
      mode_2_frq <= mode_2_frq + 2'd1; 
   else
      mode_2_frq <= mode_2_frq;
end

always @(posedge clk) begin//模式转换
   if (rst == 1'b0)
      mode_3_tri <= 2'd0;   
   else if(mode_3_tri == 2'd3+1)
      mode_3_tri <= 2'd1;
   else if(key_en3)
      mode_3_tri <= mode_3_tri + 2'd1; 
   else
      mode_3_tri <= mode_3_tri;
end

assign begin_read = (addrq == 1023) ? 1'd1 :1'd0;
always @(posedge clkout_4 or negedge rst_pll)
   begin
      if(rst_pll == 1'b0)
         read_cnt <= 10'd0    ;
      else if(~begin_read)
         read_cnt <= 10'd0    ;
      else
         read_cnt <= read_cnt + 1 ;
end


assign rd_addr = read_cnt[9:0];

assign data_out = rd_data;

RAM_0 u_RAM (
  .wr_data(data_q),     // input [7:0]
  .wr_addr(addrq),      // input [9:0]
  .rd_addr(rd_addr),    // input [9:0]
  .wr_clk(clkout_4),    // input
  .rd_clk(clkout_4),    // input
  .wr_en(wren),         // input
  .rst(~rst),           // input
  .rd_data(rd_data)     // output [7:0]
);

PLL_4 u_pll (
  .clkin1(clk),            // input
  .pll_lock(rst_pll),     // output
  .clkout0(clkout_0),      // 1Mhz
  .clkout1(clkout_1),      // 25Mhz
  .clkout2(clkout_2),      // 50Mhz
  .clkout3(clkout_3)/* synthesis PAP_MARK_DEBUG = "true" */       // 100Mhz
);

glitch_free u_glitch_free(
   .clk1    (clkout_1),
   .clk2    (clkout_2),
   .clk3    (clkout_3),
   .rstn    (rst),
   .sel     (mode_2_frq),
   .clk_out (clkout_4)
);

sampler 
#(
   .BUS_WIDTH     (8)
)
u_sampler
(
   .INPUT         (data_in), // 8-bit
   .trig_kind     (mode_3_tri), //(00 - none, 01 - rising, 10 - falling 11 - both)
   .rst           (~rst_pll),
   .clk           (clkout_4), 
   .key_start     (key_en1),
   .Q             (data_q  ), 
   .addrq         (addrq), // 样本地址
   .wren          (wren),
   .trigger       ()
);

Key_Debounce 
#(
	.CNT_MAX       (21'd999_999)
)
u_key_1
(
	.sys_clk       (clkout_4) ,
	.sys_rst_n     (rst) ,
	.key_in        (key_1) ,

	.key_flag      (key_en1)
);

Key_Debounce 
#(
	.CNT_MAX       (21'd999_999)
)
u_key_2
(
	.sys_clk       (clk) ,
	.sys_rst_n     (rst) ,
	.key_in        (key_2) ,

	.key_flag      (key_en2)
);

Key_Debounce 
#(
	.CNT_MAX       (21'd999_999)
)
u_key_3
(
	.sys_clk       (clk) ,
	.sys_rst_n     (rst) ,
	.key_in        (key_3) ,

	.key_flag      (key_en3)
);
endmodule
module Signal_generators(
   input    wire  clk_50M         ,
   input	   wire  key_4			    ,
   input    wire  key_5           ,
   output   wire  da_clk          ,
   output   wire  [7:0] da_data   /* synthesis PAP_MARK_DEBUG = "true" */
   );
wire rst_n	 	;
wire clk_125M 	;
wire key_4_en	;/* synthesis PAP_MARK_DEBUG = "true" */
wire key_5_en  ;/* synthesis PAP_MARK_DEBUG = "true" */
reg 	[1:0]mode_4_wave;/* synthesis PAP_MARK_DEBUG = "true" */
reg   [1:0]mode_5_frq;/* synthesis PAP_MARK_DEBUG = "true" */
reg   [11:0]	rom_addr 			;
reg   [11:0]   u_rom_addr        /* synthesis PAP_MARK_DEBUG = "true" */;
reg   [7:0]		rom_data_out		;
wire  [7:0]		rom_data_out_sin 	;
wire  [7:0]		rom_data_out_squ 	;
wire  [7:0]		rom_data_out_tri 	;
wire  [7:0]		rom_data_out_saw 	;

assign da_clk = clk_125M  ;
assign da_data = rom_data_out  ;
   
always @(negedge clk_125M or negedge rst_n) begin
   if (!rst_n)
      rom_addr <= 12'd0 ;
   else if (rom_addr >= 12'd2047)
      rom_addr <= 12'd0 ;
   else
     rom_addr <= rom_addr + u_rom_addr     ;                //The output wave frequency is 122Khz
   //  rom_addr <= rom_addr + 10'd2     ;                //The output wave frequency is 244Khz
//    rom_addr <= rom_addr + 10'd4     ;                //The output wave frequency is 488Khz
//    rom_addr <= rom_addr + 10'd32    ;                //The output wave frequency is 3.9Mhz
//    rom_addr <= rom_addr + 10'd128   ;                //The output wave frequency is 15.6Mhz
end
always @(negedge clk_50M or negedge rst_n) begin
   if (!rst_n)
		mode_4_wave <= 2'd0;
	else if(mode_4_wave == 2'd3 + 1)
		mode_4_wave <= 2'd0;
   else if(key_4_en == 1'b1)
      mode_4_wave <= mode_4_wave + 2'd1;
   else
      mode_4_wave <= mode_4_wave;   
end
always @(negedge clk_50M or negedge rst_n) begin
   if (!rst_n)
		mode_5_frq <= 2'd0;
	else if(mode_5_frq == 2'd2 + 1)
		mode_5_frq <= 2'd0;
   else if(key_5_en == 1'b1)
      mode_5_frq <= mode_5_frq + 2'd1;
   else
      mode_5_frq <= mode_5_frq;   
end
//always @(posedge clk_50M or negedge rst_n)
//begin
//	if(begin_m)
//	begin
//		if(end_m)
//			mode <= 2'd0;
//		else
//			mode <= mode + 2'd1;
//	end
//end
//assign	begin_m = key_1_en;
//assign	end_m	= begin_m && mode == 2'd3;

always @(posedge clk_125M)begin
    case(mode_4_wave)
            2'd1 : rom_data_out <= rom_data_out_sin;
            2'd2 : rom_data_out <= rom_data_out_saw;
            2'd3 : rom_data_out <= rom_data_out_tri;
            2'd0 : rom_data_out <= rom_data_out_squ;
            default : rom_data_out <= rom_data_out_sin;
    endcase
end

always @(posedge clk_125M)begin
    case(mode_5_frq)
            2'd0 : u_rom_addr <= 11'd1;
            2'd1 : u_rom_addr <= 11'd2;
            2'd2 : u_rom_addr <= 11'd4;
            default : u_rom_addr <= 11'd1;
    endcase
end  

ad_clock_125m u_pll (
  .clkin1(clk_50M),          // input
  .pll_lock(rst_n),          // output
  .clkout0(clk_125M)         // output
);


rom_sin_wave u_rom_sin (
  .addr(rom_addr),           // input [9:0]
  .clk(clk_125M),            // input
  .rst(1'b0),                // input
  .rd_data(rom_data_out_sin)     // output [7:0]
);

rom_square_wave u_rom_squ (
  .addr(rom_addr[9:0]),           // input [9:0]
  .clk(clk_125M),            // input
  .rst(1'b0),                // input
  .rd_data(rom_data_out_squ)     // output [7:0]
);
 

rom_triangular_wave u_rom_tri (
  .addr(rom_addr[9:0]),           // input [9:0]
  .clk(clk_125M),            // input
  .rst(1'b0),                // input
  .rd_data(rom_data_out_tri)     // output [7:0]
);

rom_sawtooth_wave u_rom_saw (
  .addr(rom_addr[9:0]),           // input [9:0]
  .clk(clk_125M),            // input
  .rst(1'b0),                // input
  .rd_data(rom_data_out_saw)     // output [7:0]
);

Key_Debounce
#(
	.CNT_MAX 	(20'd999_999)//测试设置为24，原来应该9999_99
)
u_key_4
(
	.sys_clk	   (clk_50M 		),
	.sys_rst_n	(rst_n         ),
	.key_in		(key_4		   ),

	.key_flag   (key_4_en	   )
   ); 
Key_Debounce
#(
	.CNT_MAX 	(20'd999_999)//测试设置为24，原来应该9999_99
)
u_key_5
(
	.sys_clk	   (clk_50M 		),
	.sys_rst_n	(rst_n         ),
	.key_in		(key_5		   ),

	.key_flag   (key_5_en	   )
   ); 
   
endmodule
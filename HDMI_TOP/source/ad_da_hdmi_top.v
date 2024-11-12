module ad_da_hdmi_top(input wire clk_50M,
                      input wire rst_n,
                      output wire rstn_out,
                      output wire iic_tx_scl,
                      inout wire iic_tx_sda,
                      output wire led_int,
                      input wire [7:0]ad_data_in,
                      output wire ad_clk,/* synthesis PAP_MARK_DEBUG = "true" */
                      output wire da_clk,
                      output wire [7:0]da_data_out/* synthesis PAP_MARK_DEBUG = "true" */,
                      output wire vout_hs,
                      output wire vout_vs,
                      output wire vout_de,
                      output wire vout_clk,
                      output wire [23:0]vout_data,
                      input wire key_3_wave	,
                      input wire key_4_frq,
                      input wire key_5_fft,
                      input wire key_2_adda,        //输入key2，用来指定模拟输入还是内部数字输�??
                      input wire key_6_ad_clk,        //用来指定HDMI输出�??�??时钟
                      input wire key_7_hor,           //用来指定输出HDMI的读地址跳变（横轴）
                      //input wire key_lon,           //用来指定输出HDMI的信号幅值变化（纵轴�??
                      //input wire key_def
                      input  uart_rx/* synthesis PAP_MARK_DEBUG = "true" */,
                      output  uart_tx/* synthesis PAP_MARK_DEBUG = "true" */,
                      output [7:0] led/* synthesis PAP_MARK_DEBUG = "true" */
                      );          
    
    wire clk_125M ;/* synthesis PAP_MARK_DEBUG = "true" */
    wire lock ;
    wire pll_lock /* synthesis PAP_MARK_DEBUG = "true" */;
    wire lock_multi;
    wire lock_fft;
    wire clk_118_8 ;
    wire clk_29_7 ;
    wire clk_200M;/* synthesis PAP_MARK_DEBUG = "true" */
    wire pix_clk ;
    wire fft_clk/* synthesis PAP_MARK_DEBUG = "true" */;
    wire clk_5M;
    wire clk_10M;
    wire clk_60M;
    // wire clk_70M;
    // wire clk_80M;
    // wire clk_90M;
    // wire clk_100M;
    // wire clk_fft_1M;
    // wire clk_fft_1_5M;
    wire clk_fft_2M;
    wire [7:0]  hdmi_r_out ;
    wire [7:0]  hdmi_g_out ;
    wire [7:0]  hdmi_b_out ;
    wire hdmi_vs_out ;
    wire hdmi_hs_out ;
    wire hdmi_de_out ;
    
    wire [23:0]  grid_data_out ;
    wire grid_vs_out ;
    wire grid_hs_out ;
    wire grid_de_out ;
    
    
    
    
    wire key_3_wave_en	;/* synthesis PAP_MARK_DEBUG = "true" */
    wire key_4_frq_en  ;/* synthesis PAP_MARK_DEBUG = "true" */
    wire key_2_adda_en;/* synthesis PAP_MARK_DEBUG = "true" */
    wire key_6_ad_clk_en;/* synthesis PAP_MARK_DEBUG = "true" */
    wire key_7_hor_en;/* synthesis PAP_MARK_DEBUG = "true" */
    // wire key_fft_clk_en;
    //wire key_lon_en;/* synthesis PAP_MARK_DEBUG = "true" */
    //wire key_def_en;/* synthesis PAP_MARK_DEBUG = "true" */
    wire  [7:0]		rom_data_out_sin 	;
    wire  [7:0]		rom_data_out_squ 	;
    wire  [7:0]		rom_data_out_tri 	;
    wire  [7:0]		rom_data_out_saw 	;
    reg 	[1:0]                  mode_3_wave;
    reg   [1:0]                mode_4_frq;
    reg   [1:0]             mode_2_adda;
    reg   [3:0]             mode_6_ad_clk;/* synthesis PAP_MARK_DEBUG = "true" */
    reg   [3:0]             mode_7_hor;/* synthesis PAP_MARK_DEBUG = "true" */

    reg   [13:0]	rom_addr 			;
    reg   [13:0]   u_rom_addr        ;
    reg   [7:0]		rom_data_out		;
    reg   [7:0]    data_wave         ;
    wire           sys_rstn          ;
    wire           sys_rst           ;
    wire           fft_start         ;
    reg            fft_start_reg     ;
    reg           fft_start_rise     ;/* synthesis PAP_MARK_DEBUG = "true" */
    reg     [4:0]      par_hor       ;/* synthesis PAP_MARK_DEBUG = "true" */
    // reg           par_lon            ;/* synthesis PAP_MARK_DEBUG = "true" */
    wire            ser_tx              ;
    wire [7:0]      led_buf             ;
    
    
    always @(posedge clk_50M or negedge rst_n) begin
        if (!rst_n)begin
            fft_start_reg <= 0;
        end
        else
            fft_start_reg <= fft_start;
    end
    
    always @(posedge clk_50M or negedge rst_n) begin
        if (!rst_n)begin
            fft_start_rise <= 0;
        end
        else if (fft_start && ~fft_start_reg)
            fft_start_rise <= fft_start;
        
        else
        fft_start_rise <= fft_start_rise;
    end
    
    pll_clock_125m u_pll (
    .clkin1(clk_50M),        // input    // 50Mhz
    .pll_lock(lock),         // output
    .clkout0(clk_125M),       // output
    .clkout1(clk_200M),
    .clkout2(clk_5M),
    .clkout3(clk_10M)
    

    );


    
    pll_adda u_pll_adda (
    .clkin1(clk_50M),         // input    // 50Mhz
    .pll_lock(pll_lock),      // output
    .clkout0(clk_118_8),      // output   //118.8Mhz
    .clkout1(clk_29_7)        // output   //29.7Mhz
    );
    
    pll_fft_256 u_pll_fft_256 (
      .clkin1(clk_50M),        // input
      .pll_lock(lock_fft),    // output
      .clkout2(clk_fft_2M),       // output
      .clkout3(clk_60M)
    );
    
    
    Key_Debounce u_key_rst
    (
    .sys_clk	   (clk_50M 		),
    .sys_rst_n	(1'b1),
    .key_in		(rst_n		),
    
    .key_flag   (sys_rst	)
    );
    
    Key_Debounce u_key_3_wave
    (
    .sys_clk	   (clk_50M 		),
    .sys_rst_n	(rst_n),
    .key_in		(key_3_wave		),
    
    .key_flag   (key_3_wave_en	)
    );
    
    Key_Debounce u_key_4_frq
    (
    .sys_clk	   (clk_50M 		),
    .sys_rst_n	(rst_n),
    .key_in		(key_4_frq		),
    
    .key_flag   (key_4_frq_en	)
    );
    
    
    Key_Debounce u_key_fft_start
    (
    .sys_clk	   (clk_50M 		),
    .sys_rst_n	(1'b1),
    .key_in		(key_5_fft		),
    
    .key_flag   (fft_start	)
    );
    
    Key_Debounce u_key_2_adda
    (
    .sys_clk	   (clk_50M 		),
    .sys_rst_n	(rst_n),
    .key_in		(key_2_adda		),
    
    .key_flag   (key_2_adda_en)
    );

    Key_Debounce u_key_6_ad_clk
    (
    .sys_clk	   (clk_50M 		),
    .sys_rst_n	(rst_n),
    .key_in		(key_6_ad_clk		),
    
    .key_flag   (key_6_ad_clk_en)
    );
    

    Key_Debounce u_key_7_hor
    (
    .sys_clk	   (clk_50M 		),
    .sys_rst_n	(rst_n),
    .key_in		(key_7_hor		),
    
    .key_flag   (key_7_hor_en)
    );
    
    Key_Debounce u_key_fft_clk
    (
    .sys_clk	   (clk_50M 		),
    .sys_rst_n	(rst_n),
    .key_in		(key_fft_clk		),
    
    .key_flag   (key_fft_clk_en)
    );

   //  Key_Debounce u_key_lon
   //  (
   //  .sys_clk	   (clk_50M 		),
   //  .sys_rst_n	   (rst_n),
   //  .key_in		   (key_lon		),
    
   //  .key_flag     (key_lon_en)
   //  );
    

   //  Key_Debounce u_key_def
   //  (
   //  .sys_clk	   (clk_50M 		),
   //  .sys_rst_n	   (rst_n),
   //  .key_in		   (key_def		),
    
   //  .key_flag     (key_def_en)
   //  );
    


     picosoc u_picosoc (
	.clk_50m                (clk_50M),
	.resetn                 (rst_n),
//interrupt
	.irq_5                  (key_5_fft),
	.irq_6                  (key_6_ad_clk),
	.irq_7                  (key_7_hor),
//uart
	.ser_tx                 (ser_tx),
	.ser_rx                 (uart_rx),
//led
    .led                    (led_buf)
);
    
    //output color bar
    hdmi_test  hdmi_color(
    .sys_clk      (clk_50M) ,// input system clock 50MHz
    .rstn_out     (rstn_out) ,
    .iic_tx_scl   (iic_tx_scl) ,
    .iic_tx_sda   (iic_tx_sda) ,
    .led_int      (led_int) ,
    .pix_clk      (pix_clk) ,//pixclk
    .vs_out       (hdmi_vs_out) ,
    .hs_out       (hdmi_hs_out) ,
    .de_out       (hdmi_de_out) ,
    .r_out        (hdmi_r_out) ,
    .g_out        (hdmi_g_out) ,
    .b_out        (hdmi_b_out) 
    );
    
    //output grid
    grid_display grid_display_1(
    .rst_n      (rst_n) ,
    .pclk       (pix_clk) ,
    .i_hs       (hdmi_hs_out) ,
    .i_vs       (hdmi_vs_out) ,
    .i_de       (hdmi_de_out) ,
    .i_data     ({hdmi_r_out[7:0] , hdmi_g_out[7:0] , hdmi_b_out[7:0]}) ,
    .o_hs       (grid_hs_out) ,
    .o_vs       (grid_vs_out) ,
    .o_de       (grid_de_out) ,
    .o_data     (grid_data_out)
    );
    
    //output hdmi wave
    wav_display wav_display_1(
    .rst_n         (sys_rstn) ,
    .pclk          (pix_clk) ,
    .wave_color    (24'hff0000) , //红色
    //.wave_color    (24'h9932cc) , //紫色
    .ad_clk        (ad_clk) ,
    .fft_clk        (fft_clk) ,
    .ad_data_in    (data_wave) ,
    .i_hs          (grid_hs_out) ,
    .i_vs          (grid_vs_out) ,
    .i_de          (grid_de_out) ,
    .i_data        (grid_data_out) ,
    .o_hs          (vout_hs) ,
    .o_vs          (vout_vs) ,
    .o_de          (vout_de) ,
    .o_data        (vout_data) ,
    .key_fft_pulse (fft_start_rise),
    .par_hor       (par_hor)        
    );
    
    
    ad9708_sin_wave  a_sin_wave  (
    .clk           (clk_118_8) ,
    .rst_n         (rst_n)    ,
    // .da_clk        (da_clk)   ,
    .da_data       (rom_data_out_sin),  //  116Khz sine wave
    .rom_addr      (rom_addr)
    );
    
    rom_sawtooth_wave a_sawtooth_wave (
    .addr(rom_addr[9:0]),           // input [9:0]
    .clk(clk_125M),            // input
    .rst(~rst_n),                // input
    .rd_data(rom_data_out_saw)     // output [7:0]
    
    );
    
    rom_triangular_wave u_rom_tri (
    .addr(rom_addr[9:0]),           // input [9:0]
    .clk(clk_125M),            // input
    .rst(~rst_n),                // input
    .rd_data(rom_data_out_tri)     // output [7:0]
    );
    
    rom_square_wave u_rom_squ (
    .addr(rom_addr[9:0]),           // input [9:0]
    .clk(clk_125M),            // input
    .rst(~rst_n),                // input
    .rd_data(rom_data_out_squ)     // output [7:0]
    );
    
    
    
    
    //assign
    
    //assign data_wave = rom_data_out;
    
    assign vout_clk = pix_clk ;
    assign sys_rstn = ~sys_rst;
    assign ad_clk   = (mode_6_ad_clk == 0) ? clk_5M  :
                      (mode_6_ad_clk == 1) ? clk_10M :
                      (mode_6_ad_clk == 2) ? clk_29_7:
                      (mode_6_ad_clk == 3) ? clk_50M:
                      (mode_6_ad_clk == 4) ? clk_60M: clk_29_7;
    // assign fft_clk   =(mode_fft_clk == 0) ? clk_fft_2M:
    //                  (mode_fft_clk == 1) ? clk_fft_2M:
    //                  (mode_fft_clk == 2) ? clk_fft_2M : clk_fft_2M;
    assign fft_clk = clk_fft_2M;

    assign uart_tx = ser_tx;
    assign led = led_buf;
    assign da_data_out = rom_data_out;
    assign da_clk = clk_125M;

    
    
    
    //output wave
    
    always @(negedge clk_50M or negedge rst_n) begin
        if (!rst_n)
            mode_3_wave <= 2'd0;
        else if (mode_3_wave == 2'd3 + 1)
            mode_3_wave <= 2'd0;
        else if (key_3_wave_en == 1'b1)
            mode_3_wave <= mode_3_wave + 2'd1;
        else
            mode_3_wave <= mode_3_wave;
    end
    always @(negedge clk_50M or negedge rst_n) begin
        if (!rst_n)
            mode_4_frq <= 2'd0;
        else if (mode_4_frq == 2'd2 + 1)
            mode_4_frq <= 2'd0;
        else if (key_4_frq_en == 1'b1)
            mode_4_frq <= mode_4_frq + 2'd1;
        else
            mode_4_frq <= mode_4_frq;
    end
    
    always @(negedge clk_50M or negedge rst_n) begin
        if (!rst_n)
            mode_2_adda <= 2'd0;
        else if (mode_2_adda == 2'd1 + 1)
            mode_2_adda <= 2'd0;
        else if (key_2_adda_en == 1'b1)
            mode_2_adda <= mode_2_adda + 2'd1;
        else
            mode_2_adda <= mode_2_adda;
    end
    always @(negedge clk_50M or negedge rst_n) begin
        if (!rst_n)
            mode_6_ad_clk <= 2'd0;
        else if (mode_6_ad_clk == 4'd4 +1)
            mode_6_ad_clk <= 2'd0;
        else if (key_6_ad_clk_en == 1'b1)
            mode_6_ad_clk <= mode_6_ad_clk + 2'd1;
        else
            mode_6_ad_clk <= mode_6_ad_clk;
    end
    always @(negedge clk_50M or negedge rst_n) begin
        if (!rst_n)
        mode_7_hor <= 2'd0;
        else if (mode_7_hor == 4'd3 +1)
         mode_7_hor <= 2'd0;
        else if (key_7_hor_en == 1'b1)
         mode_7_hor <= mode_7_hor + 2'd1;
        else
         mode_7_hor <= mode_7_hor;
    end

//     always @(negedge clk_50M or negedge rst_n) begin
//       if (!rst_n)
//       mode_fft_clk <= 2'd0;
//       else if (mode_fft_clk == 3)
//          mode_fft_clk <= 2'd0;
//       else if (key_fft_clk_en == 1'b1)
//          mode_fft_clk <= mode_fft_clk + 2'd1;
//       else
//          mode_fft_clk <= mode_fft_clk;
//   end
   //  always @(negedge clk_50M or negedge rst_n) begin
   //      if (!rst_n)
   //          mode_lon <= 2'd0;
   //      else if (mode_lon == 2'd3 + 1)
   //       mode_lon <= 2'd0;
   //      else if (key_lon_en == 1'b1)
   //       mode_lon <= mode_lon + 2'd1;
   //      else
   //       mode_lon <= mode_lon;
   //  end

//     always @(negedge clk_50M or negedge rst_n) begin
//       if (!rst_n)
//       mode_def <= 2'd0;
//       else if (mode_def == 2'd1 +1)
//          mode_def <= 2'd0;
//       else if (key_def_en == 1'b1)
//          mode_def <= mode_def + 2'd1;
//       else
//          mode_def <= mode_def;
//   end
    
    always @(posedge clk_118_8)begin
        case(mode_3_wave)
            2'd0 : rom_data_out    <= rom_data_out_sin;
            2'd1 : rom_data_out    <= rom_data_out_squ;
            2'd2 : rom_data_out    <= rom_data_out_saw;
            2'd3 : rom_data_out    <= rom_data_out_tri;
            default : rom_data_out <= rom_data_out_sin;
        endcase
    end
    
    always @(posedge clk_118_8)begin
        case(mode_4_frq)
            2'd0 : u_rom_addr    <= 11'd1;
            2'd1 : u_rom_addr    <= 11'd2;
            2'd2 : u_rom_addr    <= 11'd4;
            default : u_rom_addr <= 11'd1;
        endcase
    end
    
    always @(posedge clk_118_8)begin
        case(mode_2_adda)
            2'd0 : data_wave    <= ad_data_in;
            2'd1 : data_wave    <= rom_data_out;
            default : data_wave <= ad_data_in;
        endcase
    end

    always @(posedge clk_118_8)begin
      case(mode_7_hor)
          2'd0 : par_hor    <= 2'd1;
          2'd1 : par_hor    <= 2'd2;
          2'd2 : par_hor    <= 2'd3;
          2'd3 : par_hor    <= 3'd4;
          default : par_hor <= 2'd1;
      endcase
  end

//   always @(posedge clk_118_8)begin
//    case(mode_lon)
//        2'd0 : par_lon    <= 3'd3;
//        2'd1 : par_lon    <= 3'd4;
//        2'd2 : par_lon    <= 3'd5;
//        default : par_lon <= 3'd3;
//    endcase
// end

    
    always @(negedge clk_118_8 or negedge rst_n) begin
        if (!rst_n)
            rom_addr <= 14'd0 ;
        else if (rom_addr >= 14'd8192)
            rom_addr <= 14'd0 ;
        else
            rom_addr       <= rom_addr + u_rom_addr     ;                //The output wave frequency is 122Khz
            //  rom_addr   <= rom_addr + 10'd2     ;                //The output wave frequency is 244Khz
            //    rom_addr <= rom_addr + 10'd4     ;                //The output wave frequency is 488Khz
            //    rom_addr <= rom_addr + 10'd32    ;                //The output wave frequency is 3.9Mhz
            //    rom_addr <= rom_addr + 10'd128   ;                //The output wave frequency is 15.6Mhz
    end

    
    
    
    
    
    
    
    
endmodule

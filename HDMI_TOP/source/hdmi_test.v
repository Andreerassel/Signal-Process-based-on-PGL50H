`timescale 1ns / 1ps

`define UD #1

module hdmi_test(
    input wire        sys_clk       ,// input system clock 50MHz    
    output            rstn_out      ,
    output            iic_tx_scl    ,
    inout             iic_tx_sda    ,
    output            led_int       ,
//hdmi_out 
    output            pix_clk /* synthesis PAP_MARK_DEBUG = "true" */      ,                         
    output            vs_out        , 
    output            hs_out        , 
    output            de_out        ,
    output     [7:0]  r_out         , 
    output     [7:0]  g_out         , 
    output     [7:0]  b_out         
    //input      [1:0]  mode_def          

);

parameter   X_WIDTH_0 = 4'd12;
parameter   Y_WIDTH_0 = 4'd12;


// parameter   X_WIDTH_1 = 8'd20; 
// parameter   Y_WIDTH_1 = 8'd20;    

//MODE_1080p
    parameter V_TOTAL_0 = 12'd1125;
    parameter V_FP_0 = 12'd4;
    parameter V_BP_0 = 12'd36;
    parameter V_SYNC_0 = 12'd5;
    parameter V_ACT_0 = 12'd1080;/* synthesis PAP_MARK_DEBUG = "true" */
    parameter H_TOTAL_0 = 12'd2200;
    parameter H_FP_0 = 12'd88;
    parameter H_BP_0 = 12'd148;
    parameter H_SYNC_0 = 12'd44;
    parameter H_ACT_0 = 12'd1920;
    parameter HV_OFFSET_0 = 12'd0;
//MODE_2560x1600p
    parameter V_TOTAL_1= 12'd1646;
    parameter V_FP_1 = 12'd3;
    parameter V_BP_1 = 12'd37;
    parameter V_SYNC_1 = 12'd6;
    parameter V_ACT_1 = 12'd1600;/* synthesis PAP_MARK_DEBUG = "true" */
    parameter H_TOTAL_1 = 12'd2720;
    parameter H_FP_1 = 12'd48;
    parameter H_BP_1 = 12'd80;
    parameter H_SYNC_1 = 12'd32;
    parameter H_ACT_1 = 12'd2560;
    parameter HV_OFFSET_1 = 12'd0;
//MODE CTRL
    // parameter V_TOTAL= (mode_def==1) ? V_TOTAL_1:V_TOTAL_0;
    // parameter V_FP = 12'd3;
    // parameter V_BP = 12'd37;
    // parameter V_SYNC = 12'd6;
    // parameter V_ACT = 12'd1600;
    // parameter H_TOTAL = 12'd2720;
    // parameter H_FP = 12'd48;
    // parameter H_BP = 12'd80;
    // parameter H_SYNC = 12'd32;
    // parameter H_ACT = 12'd2560;
    // parameter HV_OFFSET = 12'd0;





    //wire                        pix_clk    ;
    wire                        pix_clk_0   ;
    wire                        pix_clk_1   ;
    wire                        cfg_clk    ;
    wire                        locked     ;
    wire                        rstn       ;
    wire                        init_over  ;
    reg  [15:0]                 rstn_1ms   ;
    //
    // wire [X_WIDTH - 1'b1:0]     act_x      ;
    // wire [Y_WIDTH - 1'b1:0]     act_y      ;    
    // wire                        hs         ;
    // wire                        vs         ;
    // wire                        de         ;
    // wire                        vs_out     ; 
    // wire                        hs_out     ; 
    // wire                        de_out     ;
    // wire     [7:0]              r_out      ; 
    // wire     [7:0]              g_out      ; 
    // wire     [7:0]              b_out      ;
    //1080p
    wire [X_WIDTH_0 - 1'b1:0]     act_x_0      ;
    wire [Y_WIDTH_0 - 1'b1:0]     act_y_0      ;    
    wire                        hs_0         ;
    wire                        vs_0         ;
    wire                        de_0         ;
    wire                        vs_out_0     ; 
    wire                        hs_out_0     ; 
    wire                        de_out_0     ;
    wire     [7:0]              r_out_0      ; 
    wire     [7:0]              g_out_0      ; 
    wire     [7:0]              b_out_0      ;
    //1600p
    // wire [X_WIDTH_1 - 1'b1:0]     act_x_1      ;
    // wire [Y_WIDTH_1 - 1'b1:0]     act_y_1      ;    
    // wire                        hs_1         ;
    // wire                        vs_1         ;
    // wire                        de_1         ;
    // wire                        vs_out_1     ; 
    // wire                        hs_out_1     ; 
    // wire                        de_out_1     ;
    // wire     [7:0]              r_out_1      ; 
    // wire     [7:0]              g_out_1      ; 
    // wire     [7:0]              b_out_1      ;

    reg  [3:0]                  reset_delay_cnt;
    // reg  [11:0]                 V_TOTAL;
    // reg  [11:0]                 V_FP;
    // reg  [11:0]                 V_BP;
    // reg  [11:0]                 V_SYNC;
    // reg  [11:0]                 V_ACT;
    // reg  [11:0]                 H_FP;
    // reg  [11:0]                 H_BP;
    // reg  [11:0]                 H_SYNC;
    // reg  [11:0]                 H_ACT;
    // reg  [11:0]                 H_TOTAL;
    // reg  [11:0]                 HV_OFFSET;
    

    pll u_pll (
        .clkin1   (  sys_clk    ),//50MHz
        .clkout0  (  pix_clk    ),//148.5MHz
        .clkout1  (  cfg_clk    ),//10MHz
        .pll_lock (  locked     )//
    );

    ms72xx_ctl ms72xx_ctl(
        .clk         (  cfg_clk    ), //input       clk,
        .rst_n       (  rstn_out   ), //input       rstn,
                                
        .init_over   (  init_over  ), //output      init_over,
        .iic_tx_scl  (  iic_tx_scl ), //output      iic_scl,
        .iic_tx_sda  (  iic_tx_sda ), //inout       iic_sda
        .iic_scl     (  iic_scl    ), //output      iic_scl,
        .iic_sda     (  iic_sda    )  //inout       iic_sda
    );
   assign    led_int    =     init_over;
    
    always @(posedge cfg_clk)
    begin
    	if(!locked)
    	    rstn_1ms <= 16'd0;
    	else
    	begin
    		if(rstn_1ms == 16'h20)
    		    rstn_1ms <= rstn_1ms;
    		else
    		    rstn_1ms <= rstn_1ms + 1'b1;
    	end
    end

    assign rstn_out = (rstn_1ms == 16'h20);

//1080p


    sync_vg #(
        .X_BITS               (  X_WIDTH_0              ), 
        .Y_BITS               (  Y_WIDTH_0              )                      
 
    ) sync_vg_1080p                                         
    (                                                 
        .clk                  (  pix_clk               ),//input                   clk,                                 
        .rstn                 (  rstn_out                 ),//input                   rstn,                            
        .vs_out               (  vs_0                   ),//output reg              vs_out,                                                                                                                                      
        .hs_out               (  hs_0                   ),//output reg              hs_out,            
        .de_out               (  de_0                   ),//output reg              de_out,             
        .x_act                (  act_x_0                ),//output reg [X_BITS-1:0] x_out,             
        .y_act                (  act_y_0                ), //output reg [Y_BITS:0]   y_out, 
        .V_TOTAL              (  V_TOTAL_0              ),//                        
        .V_FP                 (  V_FP_0                 ),//                        
        .V_BP                 (  V_BP_0                 ),//                        
        .V_SYNC               (  V_SYNC_0               ),//                        
        .V_ACT                (  V_ACT_0                ),//                        
        .H_TOTAL              (  H_TOTAL_0              ),//                        
        .H_FP                 (  H_FP_0                 ),//                        
        .H_BP                 (  H_BP_0                 ),//                        
        .H_SYNC               (  H_SYNC_0               ),//                        
        .H_ACT                (  H_ACT_0                ) //              
    );
    
    pattern_vg #(
        .COCLOR_DEPP          (  8                    ), // Bits per channel
        .X_BITS               (  X_WIDTH_0              ),
        .Y_BITS               (  Y_WIDTH_0              )
    ) // Number of fractional bits for ramp pattern
    pattern_vg_1080p (
        .rstn                 (  rstn_out                 ),//input                         rstn,                                                     
        .pix_clk              (  pix_clk              ),//input                         clk_in,  
        .act_x                (  act_x_0                ),//input      [X_BITS-1:0]       x,   
        // input video timing
        .vs_in                (  vs_0                   ),//input                         vn_in                        
        .hs_in                (  hs_0                   ),//input                         hn_in,                           
        .de_in                (  de_0                   ),//input                         dn_in,
        // test pattern image output                                                    
        .vs_out               (  vs_out_0               ),//output reg                    vn_out,                       
        .hs_out               (  hs_out_0               ),//output reg                    hn_out,                       
        .de_out               (  de_out_0               ),//output reg                    den_out,                      
        .r_out                (  r_out_0                ),//output reg [COCLOR_DEPP-1:0]  r_out,                      
        .g_out                (  g_out_0                ),//output reg [COCLOR_DEPP-1:0]  g_out,                       
        .b_out                (  b_out_0                ), //output reg [COCLOR_DEPP-1:0]  b_out   
        .H_ACT                (  H_ACT_0                ),
        .V_ACT                (  V_ACT_0                )
    );

//1600p

    // sync_vg #(
    //     .X_BITS               (  X_WIDTH_1              ), 
    //     .Y_BITS               (  Y_WIDTH_1              )                      
 
    // ) sync_vg_1600p                                         
    // (                                                 
    //     .clk                  (  pix_clk_1               ),//input                   clk,                                 
    //     .rstn                 (  rstn_out                 ),//input                   rstn,                            
    //     .vs_out               (  vs_1                   ),//output reg              vs_out,                                                                                                                                      
    //     .hs_out               (  hs_1                   ),//output reg              hs_out,            
    //     .de_out               (  de_1                   ),//output reg              de_out,             
    //     .x_act                (  act_x_1                ),//output reg [X_BITS-1:0] x_out,             
    //     .y_act                (  act_y_1                ), //output reg [Y_BITS:0]   y_out, 
    //     .V_TOTAL              (  V_TOTAL_1              ),//                        
    //     .V_FP                 (  V_FP_1                 ),//                        
    //     .V_BP                 (  V_BP_1                 ),//                        
    //     .V_SYNC               (  V_SYNC_1               ),//                        
    //     .V_ACT                (  V_ACT_1                ),//                        
    //     .H_TOTAL              (  H_TOTAL_1              ),//                        
    //     .H_FP                 (  H_FP_1                 ),//                        
    //     .H_BP                 (  H_BP_1                 ),//                        
    //     .H_SYNC               (  H_SYNC_1               ),//                        
    //     .H_ACT                (  H_ACT_1                ) //              
    // );
    
    // pattern_vg #(
    //     .COCLOR_DEPP          (  8                    ), // Bits per channel
    //     .X_BITS               (  X_WIDTH_1              ),
    //     .Y_BITS               (  Y_WIDTH_1              )
    // ) // Number of fractional bits for ramp pattern
    // pattern_vg_1600p (
    //     .rstn                 (  rstn_out                 ),//input                         rstn,                                                     
    //     .pix_clk              (  pix_clk_1               ),//input                         clk_in,  
    //     .act_x                (  act_x_1                ),//input      [X_BITS-1:0]       x,   
    //     // input video timing
    //     .vs_in                (  vs_1                   ),//input                         vn_in                        
    //     .hs_in                (  hs_1                   ),//input                         hn_in,                           
    //     .de_in                (  de_1                   ),//input                         dn_in,
    //     // test pattern image output                                                    
    //     .vs_out               (  vs_out_1               ),//output reg                    vn_out,                       
    //     .hs_out               (  hs_out_1               ),//output reg                    hn_out,                       
    //     .de_out               (  de_out_1               ),//output reg                    den_out,                      
    //     .r_out                (  r_out_1                ),//output reg [COCLOR_DEPP-1:0]  r_out,                      
    //     .g_out                (  g_out_1                ),//output reg [COCLOR_DEPP-1:0]  g_out,                       
    //     .b_out                (  b_out_1                ), //output reg [COCLOR_DEPP-1:0]  b_out   
    //     .H_ACT                (  H_ACT_1                ),
    //     .V_ACT                (  V_ACT_1                )
    // );


    //assign  pix_clk=(mode_def==1) ? pix_clk_1:pix_clk_0;
    // assign  pix_clk=pix_clk_0;
    assign  vs_out=vs_out_0;
    assign  hs_out=hs_out_0;
    assign  de_out=de_out_0;
    assign  r_out=r_out_0;
    assign  g_out=g_out_0;
    assign  b_out=b_out_0;

endmodule

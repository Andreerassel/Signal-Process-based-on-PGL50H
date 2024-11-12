`timescale  1ns / 1ps

module tb_hdmi();

// ad_da_hdmi_top Parameters
parameter PERIOD  = 20;


// ad_da_hdmi_top Inputs
reg   clk_50M                              =0;
reg   rst_n                                =0;
reg   [7:0]  ad_data_in                    ;

// ad_da_hdmi_top Outputs
wire  rstn_out                             ;
wire  iic_tx_scl                           ;
wire  led_int                              ;
wire  ad_clk                               ;
wire  da_clk                               ;
wire  [7:0]  da_data_out                   ;
wire  vout_hs                              ;
wire  vout_vs                              ;
wire  vout_de                              ;
wire  vout_clk                             ;
wire  [23:0]  vout_data                    ;

// ad_da_hdmi_top Bidirs
wire  iic_tx_sda                           ;

wire GRS_N;

GTP_GRS GRS_INST (
.GRS_N(1'b1)
);

always #(PERIOD/2)  clk_50M=~clk_50M;

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

ad_da_hdmi_top  u_ad_da_hdmi_top (
    .clk_50M                 ( clk_50M             ),
    .rst_n                   ( rst_n               ),
    .ad_data_in              ( ad_data_in   [7:0]  ),

    .rstn_out                ( rstn_out            ),
    .iic_tx_scl              ( iic_tx_scl          ),
    .led_int                 ( led_int             ),
    .ad_clk                  ( ad_clk              ),
    .da_clk                  ( da_clk              ),
    .da_data_out             ( da_data_out  [7:0]  ),
    .vout_hs                 ( vout_hs             ),
    .vout_vs                 ( vout_vs             ),
    .vout_de                 ( vout_de             ),
    .vout_clk                ( vout_clk            ),
    .vout_data               ( vout_data    [23:0] ),

    .iic_tx_sda              ( iic_tx_sda          )
);


endmodule
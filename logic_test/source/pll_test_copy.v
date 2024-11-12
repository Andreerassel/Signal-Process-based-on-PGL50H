module pll_test_copy(
   input clk,
   input rst,
   input wire [7:0] data_in,
   // output clkout0,
   // output clkout1,
   // output clkout2,
   // output clkout3,
   // output clkout4,
   output wire [7:0] data_out
   );
wire  clkout_0;
wire  clkout_1;
wire  clkout_2;
wire  clkout_3;
wire  clkout_4;
reg  [1:0] mode;
reg  [5:0]cnt_mode;
// assign clkout0 = clkout_0;
// assign clkout1 = clkout_1;
// assign clkout2 = clkout_2;
// assign clkout3 = clkout_3;
// assign clkout4 = clkout_4;

reg [3:0] tr_state ;
parameter IDLE       = 3'b001 ;
parameter WRITE      = 3'b010 ;
parameter SND_REQ    = 3'b011 ;
parameter CHK_ACK    = 3'b100 ;
parameter CHK_COMM_END = 3'b101;


reg [3:0] re_state ;
parameter RE_IDLE    = 3'b001 ;
parameter CHK_REQ    = 3'b010 ;
parameter READ       = 3'b011 ;
parameter SND_ACK    = 3'b100 ;
parameter CHK_REQ_RELEASE = 3'b101 ;
wire        rst_pll  ;

wire  [7:0] rd_data  ;
reg   [7:0] data_reg1;
reg   [7:0] data_reg2;

wire  [9:0] wr_addr  ;
reg   [9:0] WRITE_cnt;
wire  [9:0] rd_addr  ;
reg   [9:0] read_cnt ;
reg         wren     ;
reg         req      ;
reg         ack      ; 
// always @(posedge clk or negedge rst) begin
//    if (rst == 1'b0)
//       cnt_mode <= 6'd0;
//    else if(cnt_mode == 6'd63)
//       cnt_mode <= 6'd0;
//    else
//       cnt_mode <= cnt_mode + 6'd1; 
// end

// always @(posedge clk) begin
//    if (rst == 1'b0)
//       mode <= 2'd0;   
//    else if(mode == 2'd3+1)
//       mode <= 2'd1;
//    else if(cnt_mode == 6'd63 - 1)
//       mode <= mode + 2'd1; 
//    else
//       mode <= mode;
// end
always @(posedge clkout_3 or negedge rst) begin //data数据锁存
   if(rst_pll == 1'b0)
   begin
      data_reg1 <= 8'd0;
      data_reg2 <= 8'd0;
   end
   else
   begin
      data_reg1 <= data_in;
      data_reg2 <= data_reg1;
   end
end
always @(posedge clkout_3 or negedge rst) begin
	if (~rst)begin
		tr_state <= 3'b001 ;
		wren <= 1'b0 ;
		WRITE_cnt <= 10'd0;
		// read_cnt <= 10'd0;
	end
	else begin
		case (tr_state)
			IDLE : begin
				// if(start == 1'b1)//start控制开始状态
            // begin
               tr_state <= WRITE ; 
               req <= 1'b0 ;
            // end
            // else
            //    tr_state <= IDLE;
			end 
			WRITE : begin
				if(WRITE_cnt == 10'd1023)
				begin
					WRITE_cnt <= 10'd0;
					tr_state <= SND_REQ;
				end
				else
				begin
					WRITE_cnt <= WRITE_cnt + 10'd1;
					wren <= 1'b1;
				end
			end
         SND_REQ:begin
            req <= 1'b1 ;//发送请求信号
            tr_state <= CHK_ACK; 
            wren <= 1'b0;
         end

         CHK_ACK: begin
            if(ack == 1'b1)
            begin
               req <= 1'b0 ;
               tr_state <= CHK_COMM_END ;
            end
            else
               tr_state <= CHK_ACK ;
         end

         CHK_COMM_END:begin//通讯结束，一次握手结束。
            begin
               if(ack == 1'b0)
                  tr_state <= WRITE;
               else
                  tr_state <= CHK_COMM_END;
            end
         end
			default: tr_state <= IDLE ; 
		endcase
	end 
end

always @(posedge clk or negedge rst) begin
   begin
      if(rst == 1'b0)
      begin
         re_state <= RE_IDLE  ;
         ack      <= 1'b0     ;
         read_cnt <= 10'd0    ;
      end
      else
      case (re_state)
         RE_IDLE : 
         begin
            read_cnt <= 10'd0;
            re_state <= CHK_REQ;
         end
         CHK_REQ :
         begin
            if(req == 1'b1)
               re_state <= READ;
            else
               re_state <= CHK_REQ;
         end
   	   READ : 
         begin
		   	if(read_cnt == 10'd1023)
		   	begin
		   		re_state <= SND_ACK;
		   		read_cnt <= 10'd0;
		   	end
		   	else
		   		read_cnt <= read_cnt + 10'd1;
		   end
         SND_ACK:
         begin
            ack <= 1'b1;
            re_state <= CHK_REQ_RELEASE;
         end
         CHK_REQ_RELEASE:
         begin
            if(req == 1'b0)
            begin
               ack <= 1'b0;
               re_state <= CHK_REQ;
            end
            else
               re_state <= re_state;
         end
         default: re_state <= RE_IDLE;
      endcase
   end
end
assign wr_addr = WRITE_cnt[9:0];
assign rd_addr = read_cnt[9:0];
assign clkout4 = (mode[0] == 1) ? (mode[1] ? clkout_3:clkout_2) : (mode[1] ? clkout_1 : clkout_0); 

assign data_out = rd_data;

RAM_0 the_instance_name (
  .wr_data(data_reg1),    // input [7:0]
  .wr_addr(wr_addr),    // input [9:0]
  .rd_addr(rd_addr),    // input [9:0]
  .wr_clk(clkout_3),      // input
  .rd_clk(clk),      // input
  .wr_en(wren),        // input
  .rst(~rst),            // input
  .rd_data(rd_data)     // output [7:0]
);

PLL_4 u_pll (
  .clkin1(clk),            // input
  .pll_lock(rst_pll),     // output
  .clkout0(clkout_0),      // 1Mhz
  .clkout1(clkout_1),      // 25Mhz
  .clkout2(clkout_2),      // 50Mhz
  .clkout3(clkout_3)       // 100Mhz
);


endmodule
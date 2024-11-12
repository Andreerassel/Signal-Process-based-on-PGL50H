module ad9708_sin_wave(
   input    wire  clk        ,
   input    wire  rst_n           ,
   // output   wire  da_clk          ,
   output   wire  [7:0]da_data   ,
   input    [10:0]rom_addr
   );

//wire rst_n ;

// reg   [10:0]rom_addr/* synthesis PAP_MARK_DEBUG="true" */ ;
wire  [7:0]rom_data_out ;

// assign da_clk = clk  ;
assign da_data = rom_data_out  ;

// always @(negedge clk or negedge rst_n) begin
//    if (!rst_n)
//       rom_addr <= 11'd0 ;
//    else if (rom_addr == 11'd1023)
//       rom_addr <= 11'd0 ;
//    else 
//       rom_addr <= rom_addr + 11'd1     ; 
// end

rom_sin_wave u_rom (
  .addr(rom_addr[9:0]),           // input [9:0]
  .clk(clk),            // input
  .rst(~rst_n),                // input
  .rd_data(rom_data_out)     // output [7:0]
);




endmodule
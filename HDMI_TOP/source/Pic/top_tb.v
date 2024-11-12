// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

`timescale 1 ns / 1 ps

module top_tb;
	reg clk_50m;
	reg resetn;
    reg irq_5;
    reg irq_6;
    reg irq_7;
	wire ser_tx;
	reg  ser_rx;
    wire [7:0] led ;


	initial begin
	   clk_50m = 1;
	   resetn = 1;
       irq_5 = 1;
       irq_6 = 1;
       irq_7 = 1;

     end
	
     always #10 clk_50m = ~clk_50m;

	picosoc uut (
		.clk_50m     (clk_50m),
		.resetn      (resetn),
        .irq_5       (irq_5),
        .irq_6       (irq_6),
        .irq_7       (irq_7),
        .ser_tx      (ser_tx),
        .ser_rx      (ser_rx),
		.led         (led) 
	);

    GTP_GRS  GRS_INST ( 
      .GRS_N(1'b1)
    ); 
endmodule

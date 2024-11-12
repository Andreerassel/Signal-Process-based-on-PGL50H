`timescale 1ns / 1ps

module glitch_free(
    input clk1,
    input clk2,
    input clk3,
    input rstn,
    input [1:0] sel,
    output clk_out
    );
    
    wire sel1,sel2,sel3;
    wire ck_sel1,ck_sel2,ck_sel3;
    wire clk1_or,clk2_or,clk3_or;
    reg ck_sel1_r1,ck_sel1_r2,ck_sel1_neg;
    reg ck_sel2_r1,ck_sel2_r2,ck_sel2_neg;
    reg ck_sel3_r1,ck_sel3_r2,ck_sel3_neg;
    
    
   
    assign sel1=(sel==2'b00);
    assign sel2=(sel==2'b01);
    assign sel3=(sel==2'b10);
    
    assign ck_sel1=sel1&(~ck_sel2_neg)&(~ck_sel3_neg);
    assign ck_sel2=sel2&(~ck_sel1_neg)&(~ck_sel3_neg);
    assign ck_sel3=sel3&(~ck_sel1_neg)&(~ck_sel2_neg);
    
    assign clk1_or = clk1 & ck_sel1_neg;
    assign clk2_or = clk2 & ck_sel2_neg;
    assign clk3_or = clk3 & ck_sel3_neg;
    
    assign clk_out = clk1_or|clk2_or|clk3_or;
    
    always @ (posedge clk1 or negedge rstn)begin
        if (!rstn) 
            {ck_sel1_r1,ck_sel1_r2} <= 2'b00;
        else 
            {ck_sel1_r2,ck_sel1_r1} <= {ck_sel1_r1,ck_sel1};
    end
    
    always @ (negedge clk1 or negedge rstn)begin
        if (!rstn)
            ck_sel1_neg <= 1'b0;
        else
            ck_sel1_neg <= ck_sel1_r2;
    end
    
    always @ (posedge clk2 or negedge rstn)begin
        if (!rstn) 
            {ck_sel2_r1,ck_sel2_r2} <= 2'b00;
        else 
            {ck_sel2_r2,ck_sel2_r1} <= {ck_sel2_r1,ck_sel2};
    end
    
    always @ (negedge clk2 or negedge rstn)begin
        if (!rstn)
            ck_sel2_neg <= 1'b0;
        else
            ck_sel2_neg <= ck_sel2_r2;
    end
    always @ (posedge clk3 or negedge rstn)begin
        if (!rstn) 
            {ck_sel3_r1,ck_sel3_r2} <= 2'b00;
        else 
            {ck_sel3_r2,ck_sel3_r1} <= {ck_sel3_r1,ck_sel3};
    end
    
    always @ (negedge clk3 or negedge rstn)begin
        if (!rstn)
            ck_sel3_neg <= 1'b0;
        else
            ck_sel3_neg <= ck_sel3_r2;
    end
    
endmodule
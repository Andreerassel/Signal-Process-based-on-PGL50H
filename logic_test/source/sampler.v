module sampler #(
    parameter BUS_WIDTH = 8,
    parameter MEMORY_SIZE = 1024
)(
    input wire [BUS_WIDTH-1:0] INPUT, // 8-bit
    input wire [1:0] trig_kind, //(00 - none, 01 - rising, 10 - falling 11 - both)
    input wire rst,
    input wire clk, 
    input wire key_start, 
    output reg [BUS_WIDTH-1:0] Q, 
    output reg [$clog2(MEMORY_SIZE)-1:0] addrq, // 样本地址
    output reg wren,
    output reg trigger
);

    localparam SAMPLES_NUM = MEMORY_SIZE; // 样本个数

    reg [BUS_WIDTH-1:0] INPUT_prev;
    reg trigger_int/* synthesis PAP_MARK_DEBUG = "true" */;
    // reg trigger_int_prev;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            trigger_int <= 1'b0;
            INPUT_prev <= {BUS_WIDTH{1'b0}};
        end 
        else begin
            trigger_int <= 1'b0;
            for (i = 0; i < BUS_WIDTH; i = i + 1) begin
                case (trig_kind)
                    2'b00: ; // 没触发不干活
                    2'b01: // rising edge 
                        if (INPUT[i] == 1'b1 && INPUT_prev[i] == 1'b0)
                            trigger_int <= 1'b1;
                    2'b10: // falling edge 
                        if (INPUT[i] == 1'b0 && INPUT_prev[i] == 1'b1)
                            trigger_int <= 1'b1;
                    2'b11: // both edges 
                        if (INPUT[i] != INPUT_prev[i])
                            trigger_int <= 1'b1;
                    default: ; // do nothing
                endcase
            end
            INPUT_prev <= INPUT;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            addrq <= 11'd0;
            wren <= 1'b0;
            Q <= {BUS_WIDTH{1'b0}};
            // trigger_int_prev <= 1'b0;
        end 
        else begin
            if (key_start)
                begin
                    // wren <= 1'b1;
                    addrq<=0;
                end
            // trigger_int_prev <= trigger_int;
            else if (trigger_int == 1'b1) begin
                Q <= INPUT_prev;
                wren <= 1'b1;
                if (addrq == SAMPLES_NUM - 1) begin
                    wren <= 1'b0;
                end 
                else 
                    addrq <= addrq + 1;
            end
            else 
                wren <= 1'b0;
        end
    end

    always @* begin
        trigger = trigger_int;
    end

endmodule

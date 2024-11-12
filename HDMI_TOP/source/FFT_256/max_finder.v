module max_finder (
    input                       clk,
    input                       rst_n,
    input                      valid,             // 数据有效信号,高电平有效
    input      [63:0]           o_axi4s_data_tdata, // 假设数据宽度为32位
    input      [15:0]            o_axi4s_data_tuser, // 假设索引宽度为8位
    output reg [63:0]           max_value,         // 最大值输出
    output reg [65:0]           max_amp,         // 最大值输出
    output reg [15:0]            max_index,         // 最大值对应的索引输出
    output reg [15:0]            max_amp_index,         // 最大值对应的索引输出
    output reg                  max_valid,          // 最大值输出有效信号
    output reg                  max_amp_valid          // 最大值输出有效信号
);

    // 用于存储当前最大值和对应索引的寄存器
    reg [63:0] current_max_value;
    reg [65:0] current_max_amp;
    reg [15:0]  current_max_index;
    reg [15:0]  current_max_amp_index;

    wire [31:0] data_front;
    wire [31:0] data_after;
    wire [65:0] data_amp;

    // 状态寄存器，用于指示是否正在进行最大值查找
    reg finding_max;
    reg finding_max_amp;

    assign data_front= o_axi4s_data_tdata[63:32];
    assign data_after= o_axi4s_data_tdata[31:0];
    assign data_amp = data_front*data_front+data_after*data_after;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 复位所有寄存器
            current_max_value <= 0;
            current_max_index <= 0;
            max_value <= 0;
            max_index <= 0;
            max_valid <= 0;
            finding_max <= 0;
        end else begin
            if (valid) begin
                // 开始查找最大值
                if (!finding_max) begin
                    // 初始化为当前输入值和索引
                    current_max_value <= o_axi4s_data_tdata;
                    current_max_index <= o_axi4s_data_tuser;
                    finding_max <= 1;
                    max_valid <= 0;
                end else begin
                    // 比较并更新最大值
                    if (o_axi4s_data_tdata > current_max_value) begin
                        current_max_value <= o_axi4s_data_tdata;
                        current_max_index <= o_axi4s_data_tuser;
                    end
                end
            end else if (finding_max) begin
                // 完成最大值查找
                max_value <= current_max_value;
                max_index <= current_max_index;
                max_valid <= 1;
                finding_max <= 0;
            end else begin
                // 无效数据，清除有效信号
                max_valid <= 0;
            end
        end
    end


//幅度


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // 复位所有寄存器
            current_max_amp <= 0;
            current_max_amp_index <= 0;
            max_amp <= 0;
            max_amp_index <= 0;
            max_amp_valid <= 0;
            finding_max_amp <= 0;
        end else begin
            if (valid) begin
                // 开始查找最大值
                if (!finding_max_amp) begin
                    // 初始化为当前输入值和索引
                    current_max_amp <= data_amp;
                    current_max_amp_index <= o_axi4s_data_tuser;
                    finding_max_amp <= 1;
                    max_amp_valid <= 0;
                end else begin
                    // 比较并更新最大值
                    if (data_amp > current_max_amp) begin
                        current_max_amp <= data_amp;
                        current_max_amp_index <= o_axi4s_data_tuser;
                    end
                end
            end else if (finding_max_amp) begin
                // 完成最大值查找
                max_amp <= current_max_amp;
                max_amp_index <= current_max_amp_index;
                max_amp_valid <= 1;
                finding_max_amp <= 0;
            end else begin
                // 无效数据，清除有效信号
                max_amp_valid <= 0;
            end
        end
    end



endmodule

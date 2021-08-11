/* 简单伪随机数产生。
    以下产生的随机数序列是固定的，要更随机一点，要引入外部的随机量来改变 taps 的值
    比如AD噪声、按键按下的时长（计数值）等 */
module pseudo_random
(
    input clk_in;
    input rst_n_in;
    output reg [3:0]random;
)
    integer i;
    parameter taps = 4`b1001;
    
    always @(posedge clk_in or negedge rst_n_in)
        begin
            if(!rst_n_in) random <= 4`b0001;
            else
                begin
                    for(i = 0;i <= 2;i = i + 1)
                    if(taps[i])
                        random[i + 1]   <= random[i] ^ random[3];
                    else
                        random[i + 1]   <= random[i];
                        random[0]       <= random[3];
                end
        end


endmodule
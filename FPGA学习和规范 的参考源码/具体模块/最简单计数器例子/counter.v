
module counter
#(
    `define counter_wide 32
)
(
    input clk_in;
    input rst_n_in;
    
    output reg [`counter_wide - 1 : 0]count;
    output reg overflow;
)

	parameter FULL_COUNTE = `counter_wide'd1_000;

	always @(posedge clk_in or negedge rst_n_in)
	 begin
        if(!rst_n_in)
            begin
                count <= `counter_wide'b0;
                overflow <= 1'b0;
            end
        else
            begin
                if(count > FULL_COUNTE)
                    begin
                        count <= `counter_wide'b0;
                        overflow <= 1'b1;
                    end
                else
                    begin
                        count <= count + 1'b1;
                        overflow <= 1'b0;
                    end
            end
	 end
     
endmodule
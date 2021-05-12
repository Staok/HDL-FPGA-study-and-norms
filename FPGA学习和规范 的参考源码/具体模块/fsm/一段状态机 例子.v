/*
 一段状态机例子 适用于简单逻辑，一个 always 块中信号太多也不利于维护和修改
 
状态机注意要点：
	关键是画好状态图；
	状态完备；
	组合逻辑条件完备；
	不能进入死循环；
	不能进入非预知状态；
	需要穷举所有状态对应的输出动作，或者使用 default 来定义未定义状态动作；
	推荐都使用三段式状态机。

*/
module hello_det_fsm_module
(
	input clk_in,
	input rst_n_in,
	input [7:0]data_in,
	
	output reg det_out
);

/* 状态名和状态编码定义，用户定义 */
	localparam
			STATE_check_H  = 5'b0_0001,
			STATE_check_e  = 5'b0_0010,
			STATE_check_l1 = 5'b0_0100,
			STATE_check_l2 = 5'b0_1000,
			STATE_check_o  = 5'b1_0000;

	reg[4:0]cur_state;
	
	always@(posedge clk_in or negedge rst_n_in)
		begin
			if(!rst_n_in)
				begin
					det_out <= 1'b0;
					cur_state <= STATE_check_H;
				end
			else
				begin
					case(cur_state)
						STATE_check_H:
							begin
								if(data_in == "H")
									cur_state <= STATE_check_e;
								else
									cur_state <= STATE_check_H;
							end
							
						STATE_check_e:
							begin
								if(data_in == "e")
									cur_state <= STATE_check_l1;
								else
									cur_state <= STATE_check_H;
							end
							
						STATE_check_l1:
							begin
								if(data_in == "l")
									cur_state <= STATE_check_l2;
								else
									cur_state <= STATE_check_H;
							end
							
						STATE_check_l2:
							begin
								if(data_in == "l")
									cur_state <= STATE_check_o;
								else
									cur_state <= STATE_check_H;
							end
							
						STATE_check_o:
							begin
								cur_state <= STATE_check_H;
								if(data_in == "o")
									det_out <= 1'b1;
								else
									det_out <= det_out;
							end
						
						default:cur_state <= STATE_check_H;
					endcase
				end
		end

endmodule
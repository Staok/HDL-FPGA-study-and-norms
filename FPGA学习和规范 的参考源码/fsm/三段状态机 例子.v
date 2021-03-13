/*
三段状态机 例子 用摩尔状态机设计 1101 序列检测器
两段式状态机缺点是，组合逻辑较容易产生毛刺等常见问题，三段式没有此问题

转自 https://www.cnblogs.com/ninghechuan/p/7898297.html

状态机注意要点：
	关键是画好状态图；
	状态完备；
	组合逻辑条件完备；
	不能进入死循环；
	不能进入非预知状态；
	需要穷举所有状态对应的输出动作，或者使用 default 来定义未定义状态动作；
	推荐都使用三段式状态机。

*/
module state_module
	(
		input clk_in,
		input rst_n_in,
		input din_in,
		
		output reg dout_in;
    );
	
	/* 状态名和状态编码定义，用户定义 */
	localparam
		STATE_0 = 3'b000,
		STATE_1 = 3'b001,
		STATE_2 = 3'b010,
		STATE_3 = 3'b011,
		STATE_4 = 3'b100;



	/* 状态寄存器 固定写法 */
	reg [2:0] present_state, next_state;
	
	/* 当前状态转移到下个状态的同步时序逻辑（用非阻塞赋值“<=”），固定写法 */
	always @(posedge mclk or negedge rst_n)
		begin
			if(!rst_n)
				present_state <= STATE_0;
			else
				present_state <= next_state;
		end
	
	
	
	/* 状态机的 状态转换 定义
	
	组合逻辑（阻塞赋值“=”）；必须采用 always @(*) 的方式；判断条件一定要包含所有情况！可以用else保证包含完全
	
	用户定义 */
	always @(*)
		begin
			case(present_state)
				STATE_0:
					begin
						if(din==1)
							next_state = STATE_1;
						 else
							next_state = STATE_0;
					end
						
				STATE_1:
					begin
						if(din==1)
							next_state = STATE_2;
						else
							next_state = STATE_0;
					end	
				STATE_2:
					begin
						if(din==0)
							next_state = STATE_3;
						else
							next_state = STATE_2;
					end
				STATE_3:
					begin
						if(din==1)
							next_state = STATE_4;
						else
							next_state = STATE_0;
					end
				STATE_4:
					begin
						if(din==0)
							next_state = STATE_0;
						else
							next_state = STATE_2;
					end
				default: next_state = STATE_0;
				
			endcase
		end



	/* 输出条件定义，同步时序逻辑（用非阻塞赋值“<=”），
	
	如果输出更多，可以写更多的 always@ 时需同步输出逻辑
	
	用户定义 */
	always @(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				dout <= 1'b0;
			else if(present_state == STATE_4)
				dout <= 1'b1;
			else
				dout <= 1'b0;
		end
	
	
endmodule
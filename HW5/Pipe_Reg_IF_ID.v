//吳禹璇 0516022

module Pipe_Reg_IF_ID(
    clk_i,
    rst_i,
    ifid_Stall_i,
    if_Flush_i,
    data_i,
    data_o
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input	ifid_Stall_i;
input	if_Flush_i;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;
	  
always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i || if_Flush_i == 1'b1) begin
        data_o <= 0;
	end
	else if(ifid_Stall_i == 1'b1) begin
		data_o <= data_o;
	end
    else begin
        data_o <= data_i;
	end
end

endmodule	
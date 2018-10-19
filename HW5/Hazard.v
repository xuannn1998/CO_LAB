//吳禹璇 0516022

module Hazard(
	PCSrc_i,
	ifid_RsRt_i,
	idex_Rt_i,
	idex_memRead_i,
	PCWrite_o,
	ifid_Stall_o,
	if_Flush_o,
	id_Flush_o,
	ex_Flush_o
	);

input PCSrc_i;
input [9:0]ifid_RsRt_i;
input [4:0]idex_Rt_i;
input idex_memRead_i;
output PCWrite_o;
output ifid_Stall_o;
output if_Flush_o;
output id_Flush_o;
output ex_Flush_o;

reg PCWrite_o;
reg ifid_Stall_o;
reg if_Flush_o;
reg id_Flush_o;
reg ex_Flush_o;

always@(*)begin
	case(PCSrc_i)
	1'b0: begin //hazard
		if((idex_memRead_i == 1'b1) && (idex_Rt_i == ifid_RsRt_i[9:5] || idex_Rt_i == ifid_RsRt_i[4:0])) begin
			PCWrite_o <= 1'b0; 
			ifid_Stall_o <= 1'b1; 
			if_Flush_o <= 1'b0;
			id_Flush_o <= 1'b1;
			ex_Flush_o <= 1'b0;
		end
		else begin //no hazard
			PCWrite_o <= 1'b1;
			ifid_Stall_o <= 1'b0;
			if_Flush_o <= 1'b0;
			id_Flush_o <= 1'b0;
			ex_Flush_o <= 1'b0;
		end
	end
	1'b1: begin //branch
              PCWrite_o <= 1'b1;
	      ifid_Stall_o <= 1'b0;
              if_Flush_o <= 1'b1;
	      id_Flush_o <= 1'b1;
              ex_Flush_o <= 1'b1;
	end
endcase
end
endmodule
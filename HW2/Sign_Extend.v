//吳禹璇 0516022

//Subject:     CO project 2 - Sign extend
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Sign_Extend(
    data_i,
    data_o,
    select_i
    );
               
//I/O ports
input   [16-1:0] data_i;
output  [32-1:0] data_o;
input            select_i;

//Internal Signals
reg     [32-1:0] data_o;

//Sign extended
always@(*) begin
    data_o <= select_i ? {{16{data_i[15]}}, data_i} : {{16{1'b0}}, data_i};
end
          
endmodule      
     
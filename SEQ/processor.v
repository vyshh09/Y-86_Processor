`include "fetch.v"
`include "decode.v"
`include "Execute.v"
`include "memory.v"
`include "write_back.v"
`include "pc_update.v"

module processor(mem_err,icode,instruct_err,clk,PC,valA,valB,valC,valE,valM,valP);
    
    input mem_err,instruct_err,clk;
    input [63:0] PC;
    input [63:0] valA,valB,valC,valE,valM,valP;
    input [3:0] icode;

always @(posedge(clk)) 
begin
    if(instruct_err==1)
    begin
        $display("************************************instruction error*************************************\n");
        $finish;
    end
end


endmodule
module pc_update(clk, cnd, icode,  valC, valM, valP, PC_new);

input cnd;
input clk;
input [3:0] icode;
input [63:0] valC, valM, valP;

output reg [63:0] PC_new;

always@(*)
    begin
        case(icode)
        
        4'b0111:
        begin
            if(cnd)
                PC_new = valC;
            else
                PC_new = valP;
        end

        4'b1001: 
        begin 
            PC_new = valM;
        end

        4'b1000:
        begin 
            PC_new = valC; 
        end
            
        default: 
        begin 
            PC_new = valP;
        end
        endcase
    end

endmodule
module decode (clk,icode,ra,rb,valA,valB);
    input clk;                     
    input [3:0] icode, ra, rb;      
    output reg [63:0] valA, valB;   

    reg [63:0] register [0:14];    

    initial begin
       
        for (integer i = 0; i < 15; i = i + 1)
            begin
                register[i]=i;          
            end
    end

    always @(*) begin
        case (icode)
            4'h2: begin             // cmovq
                valA = register[ra];
                valB = 64'h0;
            end
            4'h4, 4'h6: begin             // rmmovq
                valA = register[ra];
                valB = register[rb];
            end
            4'h5: begin             // mrmovq
                valB = register[rb];
            end
            4'h8: begin             // call
                valB = register[4];
            end
            4'h9: begin             // ret
                valA = register[4];
                valB = register[4];
            end
            4'hA: begin             // pushq
                valA = register[ra];
                valB = register[4];
            end
            4'hB: begin             // popq
                valA = register[4];
                valB = register[4];
            end
         
        endcase
    end
endmodule







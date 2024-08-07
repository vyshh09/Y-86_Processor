module write_back (clk,icode,ra,rb,cnd,valE,valM,regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14);
    
    
    
    output reg [63:0] regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14;        
    reg [63:0] register[0:14];  

    input clk,cnd;                    
    input [3:0] icode,ra,rb;           
    input [63:0] valE,valM; 

initial 
    begin
        for(integer i=0;i<15;i=i+1) 
        begin
            register[i]=i;        
        end
    end

always @(*) 
    begin
        case (icode)
    4'h2: begin
        if (cnd) begin
            register[rb] = valE;
        end
    end
    4'h3, 4'h6: begin
        register[rb] = valE;
    end
    4'h5: begin
        register[ra] = valM;
    end
    4'h8: begin
        register[4] = valE;
    end
    4'h9, 4'hA: begin
        register[4] = valE;
    end
    4'hB: begin
        register[4] = valE;
        register[ra] = valM;
    end
         endcase    


    regis0<=register[0];           
    regis1<=register[1];
    regis2<=register[2];
    regis3<=register[3];
    regis4<=register[4];
    regis5<=register[5];
    regis6<=register[6];
    regis7<=register[7];
    regis8<=register[8];
    regis9<=register[9];
    regis10<=register[10];
    regis11<=register[11];
    regis12<=register[12];
    regis13<=register[13];
    regis14<=register[14];
    end

endmodule 
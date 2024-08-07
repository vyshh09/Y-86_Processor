module Execute(clk,E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_destE,E_destM,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_destE,M_destM,e_valE,e_destE,e_Cnd,setcc,cc_in);

  input clk;
  input [0:3] E_stat;
  input [3:0] E_icode,E_ifun,E_destE,E_destM;
  input signed [63:0] E_valA,E_valB,E_valC;
  input setcc;

  output reg signed [63:0] M_valA,e_valE,M_valE;
  output reg [3:0] e_destE,M_destE,M_destM,M_icode;
  output reg e_Cnd;
  output reg [0:3] M_stat;
  output reg M_Cnd;

  output reg [2:0] cc_in = 3'b000;
  reg [1:0] CONTROL;
  reg signed [63:0] Input1,Input2;
  wire signed [63:0] Output;
  wire OVERFLOW;

  ALU alu1(Input1,Input2,CONTROL,Output,OVERFLOW);
  
  always @(*) 
    begin
     case (E_icode)
       4'b0010 : begin //cmovXX
        e_valE <= E_valA;
      end
      
      4'b0011 : begin //irmovq
        e_valE <= E_valC;
      end

       4'b0010: begin //rrmovq
        e_valE <= E_valA;
      end
      
      
      4'b0100: begin //rmmovq
        
        CONTROL = 2'b00;
        Input1 = E_valB;
        Input2 = E_valC;
        e_valE <= Output ;
      end
         4'b0101 : begin //mrmovq
       
        CONTROL = 2'b00;
        Input1 = E_valB;
        Input2 = E_valC;
        e_valE <= Output ;
      end
   
      
      4'b0110 : begin //OPq 
        
            case (E_ifun)
            4'b0010: begin // and
                CONTROL = 2'b10;
            end
              
            4'b0011: begin // xor
                CONTROL = 2'b11;
            end
            4'b0000: begin // add
                CONTROL = 2'b00;
            end
            4'b0001: begin // sub
                CONTROL = 2'b01;
            end
          
            default: begin
                
            end
        endcase
        e_valE <= Output;
        Input1 = E_valA;
        Input2 = E_valB;
        if(setcc)
        begin
        
        cc_in[2] <= OVERFLOW;
        cc_in[0] <= (e_valE ==0) ? 1'b1:1'b0;
        cc_in[1] <= e_valE[63];
        
        end
      end
   
      4'b0111: begin //jmp
      end
      4'b1010 : begin //pushq
   
        CONTROL = 2'b01;
        Input1 = E_valB;
        Input2 = 64'd8;
        e_valE <= Output ;
      end 
      4'b1011 : begin //popq
        // valE <= valB + 64'd1;
        CONTROL = 2'b00;
        Input1 = E_valB;
        Input2 = 64'd8;
        e_valE <= Output ;
      end 
      4'b1000: begin //Call
        
        CONTROL = 2'b01;
        Input1 = E_valB;
        Input2 = 64'd8;
        e_valE <= Output ;
      end
      
      4'b1001 : begin //Ret
        
        CONTROL = 2'b00;
        Input1 = E_valB;
        Input2 = 64'd8;
        e_valE <= Output ;
      end
      default: begin

      end
     endcase     
    end 

  wire zf,sf,of;
  assign zf = cc_in[0];
  assign sf = cc_in[1];
  assign of = cc_in[2];

  always @(*)
  begin
   
     if (E_icode == 4'b0010 ) begin
      
    case (E_ifun)
        4'h0: e_Cnd = 1; // unconditional
        4'h1: e_Cnd = (of ^ sf) | zf; // le
        4'h2: e_Cnd = (of ^ sf); // l
        4'h3: e_Cnd = zf; // e
        4'h4: e_Cnd = ~zf; // ne
        4'h5: e_Cnd = ~(of ^ sf); // ge
        4'h6: e_Cnd = ~(of ^ sf) & ~zf; // g
        default: e_Cnd = 0; // default case
    endcase

    if (e_Cnd == 1) begin
        e_destE = E_destE;
    end
    else begin
        e_destE = 4'b1111;
    end
end
else if (E_icode == 4'b0111 ) begin
    case (E_ifun)
        4'h0: e_Cnd = 1; // unconditional
        4'h1: e_Cnd = (of ^ sf) | zf; // le
        4'h2: e_Cnd = (of ^ sf); // l
        4'h3: e_Cnd = zf; // e
        4'h4: e_Cnd = ~zf; // ne
        4'h5: e_Cnd = ~(of ^ sf); // ge
        4'h6: e_Cnd = ~(of ^ sf) & ~zf; // g
        default: e_Cnd = 0; // default case
    endcase

    if (!e_Cnd == 1) begin
      e_destE = 4'b1111;
        
    end
    else if(e_Cnd == 1) begin
        e_destE = E_destE;
    end
end
else begin
    e_destE = E_destE;
    e_Cnd = 0;
end

  end

  always@(posedge clk)
  begin
    M_valE <= e_valE;
      M_valA <= E_valA;
      M_destE <= e_destE;
      M_stat <= E_stat;
      M_icode <= E_icode;
      M_Cnd <= e_Cnd;
      M_destM <= E_destM;
    
  end
endmodule

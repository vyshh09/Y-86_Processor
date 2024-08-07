module decode_and_writeback(clk, reg_mem0,reg_mem1 , reg_mem2 ,reg_mem3 ,
                             reg_mem4 , reg_mem5 ,reg_mem6 ,reg_mem7 ,reg_mem8
                              , reg_mem9 , reg_mem10 ,reg_mem11 , reg_mem12 ,
                               reg_mem13 , reg_mem14,E_icode,E_ifun,D_bubble,E_bubble,D_stat,D_icode,D_ifun,E_destM,E_srcA,E_srcB,E_stat,D_rA,D_rB,D_valC,D_valP,
                            e_destE,e_valE,M_destE,M_valE,M_destM,m_valM,W_destM,W_valM,W_destE,W_valE
                            ,E_valC,E_valA,E_valB,E_destE,
                            W_icode,d_srcA,d_srcB) ;

    input clk ;                        
output reg signed [63:0] reg_mem0;
output reg signed [63:0] reg_mem1;
output reg signed [63:0] reg_mem2;
output reg signed [63:0] reg_mem3;
output reg signed [63:0] reg_mem4;
output reg signed [63:0] reg_mem5;
output reg signed [63:0] reg_mem6;
output reg signed [63:0] reg_mem7;
output reg signed [63:0] reg_mem8;
output reg signed [63:0] reg_mem9;
output reg signed [63:0] reg_mem10;
output reg signed [63:0] reg_mem11;
output reg signed [63:0] reg_mem12;
output reg signed [63:0] reg_mem13;
output reg signed [63:0] reg_mem14;
output reg signed [63:0] E_valC,E_valA,E_valB;
output reg [3:0] E_icode,E_ifun;
output reg [3:0] E_destM,E_srcA,E_srcB,d_srcA,d_srcB,E_destE;
output reg [0:3] E_stat;
reg signed [63:0] d_rvalA,d_rvalB,d_valA,d_valB;
reg [63:0] reg_mem[0:14];
reg [3:0] d_destE,d_destM;
input E_bubble,D_bubble;

input signed [63:0] D_valC,e_valE,M_valE,m_valM,W_valE,W_valM;
input [63:0] D_valP;


input [3:0] D_icode,D_ifun,D_rA,D_rB,e_destE,M_destE,M_destM,W_destE,W_destM,W_icode;
input [0:3] D_stat;
reg const;


initial 
  begin
    reg_mem[0] = 64'd12;        //rax
    reg_mem[1] = 64'd98;        //rcx
    reg_mem[2] = 64'd14;       //rdx
    reg_mem[3] = 64'd3;         //rbx
    reg_mem[4] = 64'd200;       //rsp
    reg_mem[5] = 64'd50;        //rbp
    reg_mem[6] = 64'd145;      //rsi
    reg_mem[7] = 64'd10;     //rdi
    reg_mem[8] = 64'd900;    //r8
    reg_mem[9] = 64'd15;    //r9
    reg_mem[10] = 64'd89;    //r10
    reg_mem[11] = 64'd100;    //r11
    reg_mem[12] = 64'd78;        //r12
    reg_mem[13] = 64'd5;     //r13
    reg_mem[14] = 64'd45;     //r14
  end
always @(*)
begin

    d_destE = 4'b1111;
  d_destM = 4'b1111;


  d_srcA = 4'b1111;
  d_srcB = 4'b1111;


  case(D_icode)
    4'b0010: // cmovxx
      begin
        d_srcA = D_rA;
        d_destE = D_rB;
      
      end
    4'b0011: // irmovq
      begin
        d_destE = D_rB;
      end
    4'b0100: // rmmovq
      begin
        d_srcA = D_rA;
        d_srcB = D_rB;
       
      end
    4'b0101: // mrmovq
      begin
        d_srcB = D_rB;
        d_destM = D_rA;
      
      end
    4'b0110: // OPq
      begin
        d_srcB = D_rB;
        d_destE = D_rB;
        d_srcA = D_rA;
        
       
      end
    4'b1000: // call
      begin
        d_srcB = 4;
        d_destE = 4;
     d_rvalB = reg_mem[4];
      end
    4'b1001: // ret
      begin
        d_srcA = 4;
        d_srcB = 4;
        d_destE = 4;
        d_rvalA = reg_mem[4];
        d_rvalB = reg_mem[4];
       
      end
    4'b1010: // pushq
      begin
        d_srcA = D_rA;
        d_srcB = 4;
        d_destE = 4;
        
      end
    4'b1011: // popq
      begin
        d_srcA = 4;
        d_srcB = 4;
        d_destE = 4;
        d_destM = D_rA;
        
      end
    default:
      begin
        d_srcA = 4'b1111;
        d_srcB = 4'b1111;
        d_destE = 4'b1111;
        d_destM = 4'b1111;
      end
  endcase





  // Data forwarding for A
  case(D_icode)
    4'h7, 4'h8: 
      d_valA = D_valP;
    default:
      begin
        if (d_srcA == e_destE & e_destE != 4'b1111)
          d_valA = e_valE;
        else if (d_srcA == W_destE & W_destE != 4'b1111)
          d_valA = W_valE;  
        else if (d_srcA == M_destM & M_destM != 4'b1111)
          d_valA = m_valM;
        else if (d_srcA == W_destM & W_destM != 4'b1111)
          d_valA = W_valM;
        else if (d_srcA == M_destE & M_destE != 4'b1111)
          d_valA = M_valE;
        
        else
          d_valA = d_rvalA;
      end
  endcase
end
 

always @(*)
begin
 
  case(D_icode)
    4'b0010: // cmovxx
      begin
        d_rvalA = reg_mem[D_rA];
        d_rvalB = 0;
      end
    4'b0011: // irmovq
      begin
        
      end
    4'b0100: // rmmovq
      begin
       
        d_rvalA = reg_mem[D_rA];
        d_rvalB = reg_mem[D_rB];
      end
    4'b0101: // mrmovq
      begin
        d_srcB = D_rB;
        d_destM = D_rA;
        d_rvalB = reg_mem[D_rB];
      end
    4'b0110: // OPq
      begin 
        d_rvalA = reg_mem[D_rA];
        d_rvalB = reg_mem[D_rB];
      end
    4'b1000: // call
      begin
       
        d_rvalB = reg_mem[4];
      end
    4'b1001: // ret
      begin
     
        d_rvalA = reg_mem[4];
        d_rvalB = reg_mem[4];
      end
    4'b1010: // pushq
      begin
       
        d_rvalA = reg_mem[D_rA];
        d_rvalB = reg_mem[4];
      end
    4'b1011: // popq
      begin
      
        d_rvalA = reg_mem[4];
        d_rvalB = reg_mem[4];
      end
    
  endcase



end




always @(*)
begin
  const = 0;
  case(D_icode)
    default:
      begin
        if (d_srcB == e_destE & e_destE != 4'b1111) begin
          d_valB = e_valE;
          const = 1;
        end
       
        if (d_srcB == W_destE & W_destE != 4'b1111) begin
          d_valB = W_valE;
          const = 1;
        end
         
        if (d_srcB == W_destM & W_destM != 4'b1111) begin
          d_valB = W_valM;
          const = 1;
        end

      
        
        if (d_srcB == M_destM & M_destM != 4'b1111) begin
          d_valB = m_valM;
          const = 1;
        end

        if (d_srcB == M_destE & M_destE != 4'b1111) begin
          d_valB = M_valE;
          const = 1;
        end

        if (const == 0)
          d_valB = d_rvalB;
      end
  endcase
end

always@(posedge clk)
  begin 
    if(E_bubble)
    begin
       E_destE <= 4'b1111;
      E_destM <= 4'b1111;
      E_srcA <= 4'b1111;
      E_srcB <= 4'b1111;
      E_stat <= 4'b1000;
      E_icode <= 4'b0001;
      E_ifun <= 4'b0000;
      E_valC <= 4'b0000;
      E_valA <= 4'b0000;
      E_valB <= 4'b0000;
     
    end
    
    begin
       E_srcA <= d_srcA;
      E_srcB <= d_srcB;
      E_destE <= d_destE;
      E_destM <= d_destM;
      E_stat <= D_stat;
      E_icode <= D_icode;
      E_ifun <= D_ifun;
      E_valC <= D_valC;
      E_valA <= d_valA;
      E_valB <= d_valB;
     
    end

  end

// Write back stage
always@(posedge clk)  
  begin

    if(W_icode == 4'b0010) //cmovxx
      begin
        reg_mem[W_destE] = W_valE ;
      end
        else if(W_icode == 4'b0010) //rrmovq
      begin
          reg_mem[W_destE] = W_valE;
          
      end 
         else if(W_icode == 4'b1011) //popq
      begin
          reg_mem[W_destE] = W_valE;
          reg_mem[W_destM] = W_valM;
      end
        else if(W_icode == 4'b1001) //ret
      begin
        reg_mem[W_destE] = W_valE ;
      end
    else if(W_icode==4'b0011) //irmovq
      begin
        reg_mem[W_destE] = W_valE;
      end
    else if(W_icode == 4'b0101) //mrmovq
      begin
          reg_mem[W_destM] = W_valM ;
      end
 else if(W_icode == 4'b1010) //pushq
      begin
          reg_mem[W_destE] = W_valE ;
      end
    else if(W_icode == 4'b0110) //OPq
      begin
          reg_mem[W_destE] = W_valE ;
      end

    
   
    else if(W_icode == 4'b1000) //call
      begin
          reg_mem[W_destE] = W_valE ;
      end

   

   

   
    

    reg_mem0 <= reg_mem[0];
    reg_mem1 <= reg_mem[1];
    reg_mem2 <= reg_mem[2];
    reg_mem3 <= reg_mem[3];
    reg_mem4 <= reg_mem[4];
    reg_mem5 <= reg_mem[5];
    reg_mem6 <= reg_mem[6];
    reg_mem7 <= reg_mem[7];
    reg_mem8 <= reg_mem[8];
    reg_mem9 <= reg_mem[9];
    reg_mem10 <= reg_mem[10];
    reg_mem11 <= reg_mem[11];
    reg_mem12 <= reg_mem[12];
    reg_mem13 <= reg_mem[13];
    reg_mem14 <= reg_mem[14];
    
  end
endmodule

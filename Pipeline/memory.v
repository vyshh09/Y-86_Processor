module data_memory(clk,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_destE,M_destM,m_stat,m_valM,W_stat,W_icode,W_valE,W_valM,W_destE,W_destM);

  input clk;
  input [0:3] M_stat;
  input [3:0] M_icode;
  input [3:0] M_destE;
  input [3:0] M_destM;
  input M_Cnd;
  input [63:0] M_valE;
  input [63:0] M_valA;
  reg [63:0] data_memory [255:0];
  reg memvalid = 0;
  output reg [0:3] m_stat;
    output reg signed [63:0] W_valE;
  output reg signed [63:0] W_valA;
  output reg signed [63:0] W_valM;
  output reg signed [63:0] m_valM;
  output reg [0:3] W_stat;
  output reg [3:0] W_icode;
  output reg [3:0] W_destE;
  output reg [3:0] W_destM;
 
always @(*)
begin
  case(M_icode)

    4'b0101: // mrmovq
      begin
        if (M_valE > 255)
          memvalid = 1;
        else
          memvalid = 0;
        
      end

    4'b1001: // ret
      begin
        if (M_valA > 255)
          memvalid = 1;
        else
          memvalid = 0;
       
      end

    4'b1011: // popq
      begin
        if (M_valE > 255)
          memvalid = 1;
        else
          memvalid = 0;
      
      end

    default:
      memvalid = 0;
  endcase

  case(M_icode)
    4'b0101: // mrmovq
      begin
       
        m_valM = data_memory[M_valE];
      end
     4'b1011: // popq
      begin
       
        m_valM = data_memory[M_valA];
      end

    4'b1001: // ret
      begin
     
        m_valM = data_memory[M_valA];
      end

   
    default:
      memvalid = 0;
  endcase
end
always @(*) begin
  
  m_stat = (!memvalid) ? M_stat : 4'b0010;
end
  always @(posedge clk) begin
  memvalid = 0;

 case(M_icode)
  4'b0100,4'b1000, 4'b1010:
    begin
      if (M_valE > 255)
        memvalid = 1;
      data_memory[M_valE] <= M_valA;
    end

endcase

  W_destE <= M_destE;
  W_destM <= M_destM;
  W_valE <= M_valE;
  W_stat <= m_stat;
  W_icode <= M_icode;
  W_valM <= m_valM;
 
  
end


endmodule
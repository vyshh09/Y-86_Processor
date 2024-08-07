module Fetch(clk,D_stall,D_bubble,curr_inst,F_predPC,f_predPC,M_icode,W_icode,M_valA,W_valM,M_Cnd,F_stall,D_stat,D_ifun,D_icode,D_rA,D_rB,D_valC,D_valP,D_stat,PC);


input [63:0] F_predPC;
input clk ;
input [3:0] M_icode;
input [3:0] W_icode;
input signed [63:0] M_valA;
input signed [63:0] W_valM;
input M_Cnd;
input F_stall;
input D_stall;
input D_bubble;
input [0:79] curr_inst;

output reg [63:0] f_predPC;
output reg [3:0] D_ifun ;
output reg [3:0] D_icode ;
output reg [3:0] D_rA ;
output reg [3:0] D_rB ; 
output reg signed[63:0] D_valC ;
output reg [63:0] D_valP ;
output reg [0:3] D_stat;

// Registers
output reg [63:0] PC;
reg [0:7] byte1 ;//ifun icode
reg [0:7] byte2 ;//rA rB
reg [3:0] icode,ifun;
reg signed [63:0] valC;
reg [63:0] valP;
reg is_instruction_valid = 1'b1;
reg pcvalid = 1'b0;
reg halt_prog=1'b0;
reg [0:3] stat;
reg [3:0] rA,rB;

always @(*)
  begin
    if(M_icode == 4'b0111 & !M_Cnd)
      begin
        PC <= M_valA;
        f_predPC <=M_valA;
      end
    else if(W_icode == 4'b1001 )
      begin
        PC <= W_valM;
        f_predPC <= W_valM;
      end
    else
      PC <= F_predPC;
  end

always@(*) 

  begin 
    rA=4'hF;
    rB=4'hF;
    byte1 = {curr_inst[0:7]} ;
    byte2 = {curr_inst[8:15]} ;

    icode = byte1[0:3];
    ifun  = byte1[4:7];

  
    if(icode == 4'b0000) // Halt instruction
    begin
      halt_prog = 1;
      valP = PC;  
      f_predPC =  valP;
    
    end
    else if(icode == 4'b0010) //cmovxx
    begin
      
      valP = PC + 64'd2;
      f_predPC =  valP;
    end
    else if(icode == 4'b0001) //nop
    begin
      valP = PC + 64'd1;
      f_predPC =  valP;
        
      
    end

    

    else if(icode == 4'b0011) //irmovq
    begin
    
      valC = curr_inst[16:79];
      valP = PC + 64'd10;
      f_predPC =  valP;
    end

    else if(icode == 4'b0100) //rmmovq
    begin
     
      valC = curr_inst[16:79];
      valP = PC + 64'd10;
      f_predPC =  valP;
    end

    
    else if(icode == 4'b0110) //OPq
    begin
      
      valP = PC + 64'd2;
      f_predPC =  valP;
    end
    else if(icode==4'b0111) //jxx
    begin
    
      valP = PC + 64'd9;
      f_predPC =  valC;
    end

    else if(icode == 4'b1000) //call
    begin
     
      valP = PC + 64'd9;
      // $display("valC =",valC);
      f_predPC =  valC;
    end
    else if(icode == 4'b0101) //mrmovq
    begin
   
      valC = curr_inst[16:79];
      valP = PC + 64'd10;
      f_predPC =  valP;
    end

    
    else if(icode == 4'b1001) //ret
    begin
      valP = PC+64'd1;
    end

    else if(icode == 4'b1010) //pushq
    begin
   
      valP = PC + 64'd2;
      f_predPC =  valP;
    end

    else if(icode==4'b1011) //popq
    begin
    
      valP = PC + 64'd2;
      f_predPC =  PC + 64'd2;
    end

    else 
    begin
      is_instruction_valid = 1'b0;
    end

    if(PC > 1023)
    begin
      pcvalid = 1'b1 ;
    end
  end
always@(*) 
  begin 
    rA=4'hF;
    rB=4'hF;
    byte1 = {curr_inst[0:7]} ;
    byte2 = {curr_inst[8:15]} ;
    icode = byte1[0:3];
    ifun  = byte1[4:7];
    if(icode == 4'b0000) // Halt instruction should be called
    begin
      halt_prog = 1;
     
      // $finish;
    end

    else if(icode == 4'b0001) //nop
    begin
      valP = PC + 64'd1;
    
      
    end

    

    else if(icode == 4'b0011) //irmovq
    begin
      rA = byte2[0:3];
      rB = byte2[4:7];
      valC = curr_inst[16:79];
  
    end

    else if(icode == 4'b0100) //rmmovq
    begin
      rA = byte2[0:3];
      rB = byte2[4:7];
      valC = curr_inst[16:79];
      
    end
    else if(icode == 4'b0010) //cmovxx
    begin
      rA = byte2[0:3];
      rB = byte2[4:7];
     
    end

    else if(icode == 4'b0101) //mrmovq
    begin
      rA = byte2[0:3];
      rB = byte2[4:7];
      valC = curr_inst[16:79];
      
    end

    else if(icode == 4'b0110) //OPq
    begin
      rA = byte2[0:3];
      rB = byte2[4:7];
      valP = PC + 64'd2;
     
    end

    else if(icode==4'b0111) //jxx
    begin
      valC = curr_inst[8:71];
      
    end

    else if(icode == 4'b1000) //call
    begin
      valC = curr_inst[8:71];
      valP = PC + 64'd9;
      
    end

    else if(icode == 4'b1001) //ret
    begin
      //noop
      
    end

    else if(icode == 4'b1010) //pushq
    begin
      rA = byte2[0:3];
      rB = byte2[4:7];
   
    end

    else if(icode==4'b1011) //popq
    begin
      rA = byte2[0:3];
      rB = byte2[4:7];
    
    end

    else 
    begin
      is_instruction_valid = 1'b0;
    end

  end

always @(*)begin
 if(is_instruction_valid == 0)begin 
        stat = 4'b0001;
        $display("instr_invalid");
        $finish; 
    end
end

always @(*)begin
    stat = 4'b1000;
    if(halt_prog == 1)begin //halt
        stat = 4'b0100;
       
    end
  
  end


always @(*)begin
    if((pcvalid == 1))begin 
        stat = 4'b0010;//Memory error//ADR
        $display("mem_error");
        $finish; 
    end
    
end





  always @(posedge clk) begin
    
    if (D_bubble) 
      begin
        D_rB <= 4'b1111;
        D_valC <= 64'b0;
        D_valP <= 64'b0;
        D_stat <= 4'b1000;
        D_icode <= 4'b0001;
        D_ifun <= 4'b0000;
        D_rA <= 4'b1111;
        
      end
    if (D_stall) 
      begin  
      end
    else if (F_stall) 
      begin
        
      end
    else
      begin
        D_rB <= rB;
        D_valC <= valC;
        D_valP <= valP;
        D_stat <= stat;
        D_icode <= icode;
        D_ifun <= ifun;
        D_rA <= rA;
        
      end
  end

endmodule

`include "alu.v"
`include "fetch.v"
`include "execute.v"
`include "decode_and_writeback.v"
`include "memory.v"
`include "pipeline_ctrl.v"

module processor;
    reg [0:3]stat_con = 4'b1000;
    reg clk;
    reg [7:0] inst_mem[0:1023]; 

    reg [0:79] curr_inst;
    wire signed [63:0] D_valC;
    wire [63:0] f_predPC,D_valP,PC;
   wire signed [63:0] E_valC,E_valA,E_valB;
    wire  halt_prog ,pcvalid;
    wire is_instruction_valid ;
    wire [3:0] E_destE,E_destM,E_srcA,E_srcB;
    wire [3:0] D_ifun,D_icode;
    wire [3:0] D_rA,D_rB;
   
    wire [3:0]  M_destE,M_destM;
    wire [3:0]  W_destE,W_destM;
    wire [0:3] E_stat,D_stat;
    wire [0:3] M_stat,W_stat,m_stat;
    wire [3:0] M_icode,W_icode;
    wire [3:0]  e_destE;
 
    wire signed [63:0] M_valA, W_valM;
    wire signed [63:0] e_valE,M_valE,m_valM,W_valE,e_valA;
    reg [63:0] F_predPC;
    wire M_Cnd,e_Cnd;
    wire [2:0] cc_in;

    wire [3:0] E_icode,E_ifun,d_srcA,d_srcB;
 

   
    wire F_stall,D_stall,D_bubble,E_bubble,setcc;

    wire signed [63:0] reg_mem0 , reg_mem1 , reg_mem2 ,reg_mem3 , reg_mem4 , reg_mem5 ,reg_mem6 ,reg_mem7 ,reg_mem8 , reg_mem9 , reg_mem10 ,reg_mem11 , reg_mem12 , reg_mem13 , reg_mem14; 

    Fetch Fetch(clk,D_stall,D_bubble,curr_inst,F_predPC,f_predPC,M_icode,W_icode,M_valA,W_valM,M_Cnd,F_stall,D_stat,D_ifun,D_icode,D_rA,D_rB,D_valC,D_valP,D_stat,PC);
     decode_and_writeback decode(clk, reg_mem0,reg_mem1 , reg_mem2 ,reg_mem3 ,
                             reg_mem4 , reg_mem5 ,reg_mem6 ,reg_mem7 ,reg_mem8
                              , reg_mem9 , reg_mem10 ,reg_mem11 , reg_mem12 ,
                               reg_mem13 , reg_mem14,E_icode,E_ifun,D_bubble,E_bubble,D_stat,D_icode,D_ifun,E_destM,E_srcA,E_srcB,E_stat,D_rA,D_rB,D_valC,D_valP,
                            e_destE,e_valE,M_destE,M_valE,M_destM,m_valM,W_destM,W_valM,W_destE,W_valE
                            ,E_valC,E_valA,E_valB,E_destE,
                            W_icode,d_srcA,d_srcB) ;
    Execute execute1(clk,E_stat,E_icode,E_ifun,E_valC,E_valA,E_valB,E_destE,E_destM,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_destE,M_destM,e_valE,e_destE,e_Cnd,setcc,cc_in);
    data_memory memory1(clk,M_stat,M_icode,M_Cnd,M_valE,M_valA,M_destE,M_destM,m_stat,m_valM,W_stat,W_icode,W_valE,W_valM,W_destE,W_destM);
    pipeline_ctrl ctrl1(e_Cnd,D_icode,E_icode,E_destM,M_icode,d_srcA,d_srcB,m_stat,W_stat,setcc,D_bubble,E_bubble,F_stall,D_stall);
    
  always@(PC) begin  
    curr_inst={
      inst_mem[PC],
      inst_mem[PC+1],
      inst_mem[PC+2],
      inst_mem[PC+3],
      inst_mem[PC+4],
      inst_mem[PC+5],
      inst_mem[PC+6],
      inst_mem[PC+7],
      inst_mem[PC+8],
      inst_mem[PC+9]
    };
  end

    always@(W_stat) begin
        if(W_stat==4'b0100) begin//halt//HLT
        $display("halt");
        $finish;
        end 
    end
     always@(W_stat) begin
       if(W_stat==4'b0001) begin//invalid instruction//INS
        $display("instr_invalid");
        $finish;
        end
    end
    always@(W_stat) begin
    if(W_stat==4'b0010) begin//Memory error//ADR
        $display("mem_error");
        $finish;
    end
    end
    always @(W_stat)
    begin
        stat_con = W_stat;
    end

initial begin
    $dumpfile("processor.vcd");
    $dumpvars(0, processor);
end

always #10  begin 
        clk = ~clk;
    end
always @(posedge clk) 
        begin 
        if(!F_stall)
            F_predPC <= f_predPC ;
        end

always @(posedge clk)
    begin 
    $display("\n------------------------------------------------------------");
    $display("Fetch stage D_ :- clk=",clk," D_stat=",D_stat," F_predPC=",F_predPC," f_predPC=",f_predPC," icode=",D_icode," ifun=",D_ifun,"\n \t\t > rsp =",reg_mem4," rA=",D_rA," rB=",D_rB," valC=",D_valC," D_valP=",D_valP);
    $display("Decode stage E_ :- clk=",clk," E_stat=",E_stat," icode=",E_icode," ifun=",E_ifun," rsp =",reg_mem4,"\n \t\t > valA=",E_valA," valB=",E_valB, " valC=",E_valC," destE=",E_destE," destM=",E_destM,"E_srcA=",E_srcA,"E_srcB=",E_srcB,"d_srcA=",d_srcA,"d_srcB=",d_srcB);
    $display("Execute stage M_ :- clk=",clk," M_stat=",M_stat," icode=",M_icode," rsp =",reg_mem4,"\n \t\t > CND=",e_Cnd," OF",cc_in[2]," SF",cc_in[1]," ZF",cc_in[0]," valA =",M_valA," valE=",M_valE," destE=",M_destE," destM=",M_destM);
    $display("Memory stage W_:- clk=",clk," W_stat=",W_stat," icode=",W_icode," rsp=",reg_mem4,"\n \t\t > valM =",W_valM," valE=",W_valE," destE=",W_destE," destM=",W_destM);
    $display("fetch_stall",F_stall," D_bubble",D_bubble," D_stall",D_stall," E_bubble",E_bubble,"");
    $display("Register 0: %d", reg_mem0);
    $display("Register 1: %d", reg_mem1);
    $display("Register 2: %d", reg_mem2);
    $display("Register 3: %d", reg_mem3);
    $display("Register 4: %d", reg_mem4);
    $display("Register 5: %d", reg_mem5);
    $display("Register 6: %d", reg_mem6);
    $display("Register 7: %d", reg_mem7);
    $display("Register 8: %d", reg_mem8);
    $display("Register 9: %d", reg_mem9);
    $display("Register 10: %d", reg_mem10);
    $display("Register 11: %d", reg_mem11);
    $display("Register 12: %d", reg_mem12);
    $display("Register 13: %d", reg_mem13);
    $display("Register 14: %d", reg_mem14);
    $display("------------------------------------------------------------");
    end
initial begin
    stat_con = 4'b1000;//Normal Operation //AOK
    F_predPC=64'd00;
    clk=0;

// inst_mem[72] = 8'h10; // OPq
// inst_mem[73] = 8'h10;

// inst_mem[74] = 8'h10; // no op
// inst_mem[75] = 8'h10;
// inst_mem[76] = 8'h10; // no op
// inst_mem[77] = 8'h10;

// inst_mem[78] = 8'h80; // call
// inst_mem[79] = 64'd81;
// inst_mem[80] = 8'h10; // no op
// inst_mem[81] = 8'h10; // no op

// inst_mem[82] = 8'h10; // no op
// inst_mem[83] = 8'h10; // no op
// inst_mem[84] = 8'h00; // return
// inst_mem[85] = 8'h90; // no op
// inst_mem[86] = 8'h10; // no op
// inst_mem[87] = 8'h10; // no op

 
// F_predPC=64'd00;
// inst_mem[0] = 8'h10; // nop
// inst_mem[1] = 8'h10; // nop

// inst_mem[2] = 8'h20; // rrmovq
// inst_mem[3] = 8'h12;

// inst_mem[4] = 8'h30; // irmovq
// inst_mem[5] = 8'hE2;
// inst_mem[6] = 8'h00;
// inst_mem[7] = 8'h00;
// inst_mem[8] = 8'h00;
// inst_mem[9] = 8'h00;
// inst_mem[10] = 8'h00;
// inst_mem[11] = 8'h00;
// inst_mem[12] = 8'h00;
// inst_mem[13] = 8'b00000010;

// inst_mem[14] = 8'h40; // rmmovq
// inst_mem[15] = 8'h24;
// inst_mem[16] = 64'd1;
// inst_mem[17] = 64'd1;
// inst_mem[18] = 64'd1;
// inst_mem[19] = 64'd1;
// inst_mem[20] = 64'd1;
// inst_mem[21] = 64'd1;
// inst_mem[22] = 64'd1;
// inst_mem[23] = 64'd1;

// inst_mem[24] = 8'h40; // rmmovq
// inst_mem[25] = 8'h53;
// inst_mem[26] = 64'd0;
// inst_mem[27] = 64'd0;
// inst_mem[28] = 64'd0;
// inst_mem[29] = 64'd0;
// inst_mem[30] = 64'd0;
// inst_mem[31] = 64'd0;
// inst_mem[32] = 64'd0;
// inst_mem[33] = 64'd0;

// inst_mem[34] = 8'h50; // mrmovq
// inst_mem[35] = 8'h53;
// inst_mem[36] = 64'd0;
// inst_mem[37] = 64'd0;
// inst_mem[38] = 64'd0;
// inst_mem[39] = 64'd0;
// inst_mem[40] = 64'd0;
// inst_mem[41] = 64'd0;
// inst_mem[42] = 64'd0;
// inst_mem[43] = 64'd0;

// inst_mem[44] = 8'h60; // opq
// inst_mem[45] = 8'h9A;

// inst_mem[46] = 8'h73; // je
// inst_mem[47] = 64'd00;
// inst_mem[48] = 64'd00;
// inst_mem[49] = 64'd00;
// inst_mem[50] = 64'd00;
// inst_mem[51] = 64'd00;
// inst_mem[52] = 64'd00;
// inst_mem[53] = 64'd00;
// inst_mem[54] = 64'd12;

// inst_mem[55] = 8'b00010000;

// inst_mem[56] = 8'hA0; // pushq
// inst_mem[57] = 8'h9F;

// inst_mem[58] = 8'hB0; // popq
// inst_mem[59] = 8'h9F;

// inst_mem[60] = 8'h60; // opq
// inst_mem[61] = 8'h9A;

// inst_mem[62] = 8'h30; // irmovq
// inst_mem[63] = 8'h00;
// inst_mem[64] = 8'h00;
// inst_mem[65] = 8'b00001000;
// inst_mem[66] = 8'h00;
// inst_mem[67] = 8'h00;
// inst_mem[68] = 8'h00;
// inst_mem[69] = 8'h00;
// inst_mem[70] = 8'h00;
// inst_mem[71] = 8'b00000010;

inst_mem[0] = 8'h10; //nop
inst_mem[1]  = 8'h10; //nop

inst_mem[2] = 8'h20; //rrmovq
inst_mem[3] = 8'h12;

inst_mem[4] = 8'h30;//irmovq
inst_mem[5] = 8'hF2;
inst_mem[6] = 8'h00;
inst_mem[7] = 8'h00;
inst_mem[8] = 8'h00;
inst_mem[9] = 8'h00;
inst_mem[10] = 8'h00;
inst_mem[11] = 8'h00;
inst_mem[12] = 8'h00;
inst_mem[13] = 8'b00000110;

inst_mem[14] = 8'h40;//rmmovq
inst_mem[15] = 8'h24;
{inst_mem[16],inst_mem[17],inst_mem[18],inst_mem[19],inst_mem[20],inst_mem[21],inst_mem[22],inst_mem[23]} = 64'd1;
inst_mem[24] = 8'h10;  // nop

inst_mem[25] = 8'h50; // mrmovq
inst_mem[26] = 8'b01110100; // ra rb
inst_mem[27] = 8'h00;
inst_mem[28] = 8'h00;
inst_mem[29] = 8'd00;
inst_mem[30] = 8'h00;
inst_mem[31] = 8'h00;
inst_mem[32] = 8'h00;
inst_mem[33] = 8'h00;
inst_mem[34] = 8'd1;  // D=1
inst_mem[35] = 8'h40; // rmmovq
inst_mem[36] = 8'h65; // ra and rb
inst_mem[37] = 8'h00;
inst_mem[38] = 8'd00;
inst_mem[39] = 8'd00;
inst_mem[40] = 8'h00; // 3 0
inst_mem[41] = 8'h00; // F rB=7
inst_mem[42] = 8'h00;
inst_mem[43] = 8'h00;
inst_mem[44] = 8'd5;  // D value

inst_mem[45] = 8'h60;//opq
inst_mem[46] = 8'h9A;
inst_mem[47] = 8'h10;
inst_mem[48] = 8'h10;
inst_mem[49] = 8'h10;
inst_mem[50] = 8'h10;
inst_mem[51] = 8'h10;


inst_mem[52] = 8'h10;//nop
inst_mem[53] = 8'h10;

inst_mem[54] = 8'h10;//nop
inst_mem[55] = 8'h10;

inst_mem[56] = 8'hA0;//pushq
inst_mem[57] = 8'h9F;

inst_mem[58] = 8'hB0;//popq
inst_mem[59] = 8'h6F;

inst_mem[60] = 8'h10;//nop
inst_mem[61] = 8'h10;

inst_mem[62] = 8'h10;//nop
inst_mem[63] = 8'h10;
inst_mem[64] = 8'h10;

inst_mem[65] = 8'h00;


end
endmodule

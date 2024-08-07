`timescale 1ns/1ps
`include "fetch.v"
`include "decode.v"
`include "write_back.v"

module writeback_tb;

  reg clk,cond=1;
  reg [63:0] PC;
  reg [0:79] instruct;
  reg [7:0] inst_arr[0:1034];

  wire [3:0] icode,ifun,ra,rb; 
  wire [63:0] valA, valB, valC,valP;
  wire [63:0] valE,valM;    
  wire imem_error, instr_valid;
  wire [63:0] regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14;        //registers
  
  fetch temp0(.clk(clk),.PC(PC),.instruct(instruct),.icode(icode),.ifun(ifun),.ra(ra),.rb(rb),.valC(valC),.valP(valP),.mem_err(mem_err),.instruct_err(instruct_err));
  decode temp1(.clk(clk),.icode(icode),.ra(ra),.rb(rb),.valA(valA),.valB(valB));
  write_back temp2(.clk(clk),.icode(icode),.ra(ra),.rb(rb),.cnd(cnd),.valE(valE),.valM(valM),.regis0(regis0),.regis1(regis1),.regis2(regis2),.regis3(regis3),.regis4(regis4),.regis5(regis5),.regis6(regis6),.regis7(regis7),.regis8(regis8),.regis9(regis9),.regis10(regis10),.regis11(regis11),.regis12(regis12),.regis13(regis13),.regis14(regis14));


always @(PC) 
    begin
        instruct={
        inst_arr[PC],
        inst_arr[PC+1],
        inst_arr[PC+2],
        inst_arr[PC+3],
        inst_arr[PC+4],
        inst_arr[PC+5],
        inst_arr[PC+6],
        inst_arr[PC+7],
        inst_arr[PC+8],
        inst_arr[PC+9]
    };
    end


    initial begin
        
      
        // irmovq
        inst_arr[66] = 8'b00110101;  // 3 ge 
        inst_arr[67] = 8'b01010011;  // rA rB 
        inst_arr[68] = 8'b00000000;  // valC  
        inst_arr[69] = 8'b00000000;  // valC
        inst_arr[70] = 8'b00000000;  // valC
        inst_arr[71] = 8'b00000000;  // valC
        inst_arr[72] = 8'b00000000;  // valC
        inst_arr[73] = 8'b00000000;  // valC
        inst_arr[74] = 8'b00000000;  // valC
        inst_arr[75] = 8'b00000110;  // valC
        // pushq

            inst_arr[2] = 8'b00100000; // rrmovq 
            inst_arr[3] = 8'b00000011; // src = %rax dest = %rdx
    
    
    
    inst_arr[4] = 8'b01000000; //4-rmmovq 
    inst_arr[5] = 8'b00000011; //rax and (rbx)
    inst_arr[6] = 8'b00000000;  //VALC ---->from 6 to 13
    inst_arr[7] = 8'b00000000;
    inst_arr[8] = 8'b00000000;
    inst_arr[9] = 8'b00000000;
    inst_arr[10] = 8'b00000000;
    inst_arr[11] = 8'b00000000;
    inst_arr[12] = 8'b00000000;
    inst_arr[13] = 8'b00001111;
    
    
        inst_arr[171] = 8'b10100000;  // A 0 
        // jxx
        inst_arr[90] = 8'b01110001;  // 7 fn
        inst_arr[91] = 8'b00000000;  // Destination
          // Destination
        inst_arr[34] = 8'b01000000;  // 4 0 rmmovq
        inst_arr[35] = 8'b00100001;  // 2 1
        inst_arr[36] = 8'b00000000;
        inst_arr[38] = 8'b00000001;
        inst_arr[39] = 8'b00000010;  
        inst_arr[40] = 8'b00000011;
        inst_arr[41] = 8'b00000100;
        inst_arr[42] = 8'b00000101;
        inst_arr[43] = 8'b00000110;
        inst_arr[44] = 8'b00000111;
        inst_arr[45] = 8'b00001000;
        inst_arr[46] = 8'b00001001;
        inst_arr[47] = 8'b00001011;
         inst_arr[0] = 8'b00000000; //halt
    clk = 1;
    PC = 64'd66;
    #10;
    clk = ~clk;
    PC = 64'd2;
    #10;
    clk = ~clk;
    PC = 64'd4;
     #10;
    clk = ~clk;
    PC = 64'd34;
    #10;
    clk = ~clk;
    PC = 64'd0;
 
    end


           assign display = {clk,  icode, ifun, ra, rb, valA, valB};


  always @(
          clk) begin
    $display("clk=%b icode=%b ifun=%b ra=%b rb=%b valA=%d valB=%d valE=%d valM=%d regis0=%d regis1=%d regis2=%d regis3=%d regis4=%d regis5=%d regis6=%d regis7=%d regis8=%d regis9=%d regis10=%d regis11=%d regis12=%d regis13=%d regis14=%d",clk,icode,ifun,ra,rb,valA,valB,valE,valM,regis0,regis1,regis2,regis3,regis4,regis5,regis6,regis7,regis8,regis9,regis10,regis11,regis12,regis13,regis14);

end
 
endmodule


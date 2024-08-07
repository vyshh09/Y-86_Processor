`timescale 1ns/1ps
`include "pc_update.v"

module test_pc_update_seq();

reg clk;
reg cnd;
reg [3:0] icode;
reg [63:0] valC, valM, valP;
wire [63:0] PC_new;

pc_update PC1(clk, cnd,icode, valC, valM, valP, PC_new);

initial
    begin   
       
         $monitor("time=%0d  icode=%0h  cnd=%0d  valP=%0d  valC=%0d  valM=%0d  new_PC=%0d",$time, icode, cnd, valP, valC, valM, PC_new);
       
        valP = 1;
        valC = 2;
        valM = 80;  
        cnd = 0;
        
        valP = 3;
        icode = 4'b0110;
        #5;
        valP = 5;
        icode = 4'b0010;
        #5;
        valP = 15;
        icode = 4'b0011;
      
       
        #5;
        valP = 46;
        icode = 4'b0111;
        cnd = 0;
        
        #5;
        valP = 57;
        icode = 4'b0111;
        cnd = 1;
        
       
      
       
    end
endmodule

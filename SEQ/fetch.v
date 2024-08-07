

module fetch(clk, PC ,instruct,  icode , ifun , ra , rb , valC , valP,halt,instruct_err,mem_err ) ;

reg [0:7] Split ;
reg [0:71] Align ;
reg [0:0] need_valC;
input [63:0] PC ;
input clk ;
input [0:79] instruct; 

output reg [3:0] ifun ;
output reg [3:0] icode ;
output reg [3:0] ra ;
output reg [3:0] rb ; 

output reg signed[63:0] valC ;
output reg [63:0] valP ;  

output reg instruct_err ;
output reg halt; 
output reg mem_err ;


always@(*) 

  begin 
    
    Split = {instruct[0:7]} ;

    Align = {instruct[8:79]} ;

    icode = Split[0:3];


    ifun  = Split[4:7];

    instruct_err = 1'b0 ;
    halt=0;
    mem_err = 1'b0;
    if(PC> 64) begin
      mem_err=1;
    end
    
    if (icode == 4'b0011 || icode == 4'b0110 || icode == 4'b1010 || icode == 4'b1011 || icode == 4'b0100 || icode == 4'b0101) begin
        need_valC = 1'b1;
    end
    if(icode == 4'b0000)  // halt
    begin
      halt=1;
      valP = PC + 64'd1; 
      $finish;
    end

    else if(icode == 4'b0001) //nop
    begin
      valP = PC + 64'd1;
    end

    else if(icode == 4'b0010) //cmovxx
    begin
      ra = Align[0:3];
      rb = Align[4:7];
      valP = PC + 64'd2;
    end

    else if(icode == 4'b0011) //irmovq
    begin
      ra = Align[0:3];
      rb = Align[4:7];
      if (need_valC)
            valC = instruct[16:79];
      valP = PC + 64'd10;
    end

    else if(icode == 4'b0100) //rmmovq
    begin
      ra = Align[0:3];
      rb = Align[4:7];
      if (need_valC)
            valC = instruct[16:79];

      valP = PC + 64'd10;
    end

    else if(icode == 4'b0101) //mrmovq
    begin
      ra = Align[0:3];
      rb = Align[4:7];
      if (need_valC)
            valC = instruct[16:79];
      valP = PC + 64'd10;
    end

    else if(icode == 4'b0110) //OPq
    begin
      ra = Align[0:3];
      rb = Align[4:7];
      valP = PC + 64'd2;
    end

    else if(icode==4'b0111) //jxx
    begin
      if (need_valC)
            valC = instruct[8:71];
      valP = PC + 64'd9;
    end

    else if(icode == 4'b1000) //call
    begin
      if (need_valC)
            valC = instruct[8:71];
      valP = PC + 64'd9;
    end

    else if(icode == 4'b1001) //ret
    begin
      valP = PC+64'd1;
    end

    else if(icode == 4'b1010) //pushq
    begin
      ra = Align[0:3];
      rb = Align[4:7];
      valP = PC + 64'd2;
    end

    else if(icode==4'b1011) //popq

    begin
      ra = Align[0:3];
      rb = Align[4:7];
      valP = PC + 64'd2;
    end

    else 

    begin
      instruct_err = 1'b1;
    end

    


    end
    
endmodule


// module fetch(clk,PC,instruct,icode,ifun,ra,rb,valC,valP,mem_err,instruct_err);

//     input clk;             
//     input [63:0] PC;       
//     input [0:79] instruct;


//     output reg [3:0] ra, rb;
//     output reg [3:0] icode, ifun;
//     output reg [63:0] valC, valP;  
//     output reg mem_err, instruct_err;  


// initial begin
//     instruct_err = 0;
//     mem_err = 0;
// end

// always @(*) begin

//     icode = instruct[0:3];  
//     ifun = instruct[4:7];   

//     case (icode)
//             4'h0, 4'h1: begin  
//                 valP = PC + 1;
//             end
//             4'h0: begin            
//                $finish;
//             end
//             4'h2, 4'hA, 4'hB: begin 
//                 {ra, rb} = instruct[8:15];
//                 valP = PC + 2;
//             end
//             4'h3, 4'h4, 4'h5: begin 
//                 {ra, rb, valC} = instruct[8:79];
//                 valP = PC + 10;
//             end
//             4'h6: begin 
//                 {ra, rb} = instruct[8:15];
//                 valP = PC + 2;
//             end
//             4'h7, 4'h8: begin 
//                 valC = instruct[8:71];
//                 valP = PC + 9;
//             end
//             4'h9: begin 
//                 valP = PC + 1;
//             end
//             default: begin  
//                 instruct_err = 1;
//             end
//         endcase
// end

// endmodule
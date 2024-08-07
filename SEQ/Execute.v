`include "alu.v"

module Execute(icode, ifun, valA, valB, valC, valE, clk, cnd, cc_in, cc_out, zf, sf, of);

  input clk;
  input [3:0] icode, ifun; 
  input [2:0] cc_in;
  input signed [63:0] valA, valB, valC;

  output reg [63:0] valE;
  output reg cnd, zf, sf, of;
  output reg [2:0] cc_out;
 
  reg [1:0] ctrl;
  reg signed [63:0] in1, in2, ans;
  wire signed [63:0] Output;
  wire overflo;

  ALU alu1(in1, in2, ctrl, Output, overflo);

  initial 
  begin
    cnd = 0;
    zf <= cc_in[0];
    sf <= cc_in[1];
    of <= cc_in[2]; 
  end

  always @(*) 
  begin
    case (icode)
      4'b0010: begin 
        case (ifun)
          4'h0: cnd = 1;  
          4'h1: cnd = sf | of; // le
          4'h2: cnd = (of ^ sf); // l
          4'h3: cnd = zf; // e
          4'h4: cnd = ~zf; // ne
          4'h5: cnd = ~(of ^ sf); // ge
          4'h6: cnd = (of ^ sf) | zf; // g
          default: cnd = 0;
        endcase
          ctrl = 2'b00;
          in1 = valA;
          in2 = 0;
      end

      4'b0011: begin // rmmovq, mrmovq
        ctrl = 2'b00;
        in1 = valC;
        in2 = 0;
      end // irmovq

      4'b0100, 4'b0101: begin // rmmovq, mrmovq
        ctrl = 2'b00;
        in1 = valB;
        in2 = valC;
      end

      4'b0110: begin 
        case (ifun)
          4'b0000: ctrl = 2'b00; 
          4'b0001: ctrl = 2'b01; 
          4'b0010: ctrl = 2'b10; 
          4'b0011: ctrl = 2'b11; 
          default: ctrl = 2'b00;
        endcase
        in1 <= valA;
        in2 <= valB;
      end

      4'b0111: begin // jmp
        case (ifun)
          4'h0: cnd = 1; // unconditional 
          4'h1: cnd = sf | of; // le
          4'h2: cnd = (of ^ sf); // l
          4'h3: cnd = zf; // e
          4'h4: cnd = ~zf; // ne
          4'h5: cnd = ~(of ^ sf); // ge
          4'h6: cnd = (of ^ sf) | zf; // g
          default: cnd = 0;
        endcase
      end

      4'b1000: // Some description
          begin
              in1 = 8;
              in2 = valB;
              ctrl = 2'b01;
          end
      4'b1001: // Some description
          begin
              in1 = 8;
              in2 = valB;
              ctrl = 2'b00;
          end
      4'b1010: // Some description
          begin
              in1 = 8;
              in2 = valB;
              ctrl = 2'b01;
          end
      4'b1011: 
          begin
              in1 = 8;
              in2 = valB;
              ctrl = 2'b00;
          end
      
    endcase
      ans = Output;
      valE <= Output;
    if(Output!=0)
      begin
        zf <= 0;
      end
      else 
      begin
        zf <= 1;
      end 
      sf <= Output[63];
      of <= overflo;
      cc_out[0] <= zf;
      cc_out[1] <= sf;
      cc_out[2] <= of; 

  end

endmodule
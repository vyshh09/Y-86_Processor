module memory (clk,icode,valP,valA,valB,valM,valE,mem_err);


                
    output reg mem_err;                 
    output reg [63:0] valM; 

    input clk;                          
    input [3:0] icode;                  
    input [63:0] valP,valA,valB,valE;  
            
    reg [63:0] memo_arr[0:1023];     
    initial 
    begin
        mem_err=0;
        valM=64'b0;   
        for(integer i=0;i<1024;i=i+1)
        begin
            memo_arr[i]=i; 
        end
    end
always @(*) 
    begin
        if(icode==4'h4)             //rmmovq
            begin
                if(valE>1023)
                begin
                    mem_err=1;     //memory error
                end
                else 
                begin
                    memo_arr[valE]=valA;    //store value A in memory       
                    valM=valA;
                    mem_err=0;
                end
            end 
        else if(icode==4'h5)        //mrmovq
            begin
                if(valE>1023)
                begin
                    mem_err=1;     //memory error
                end
                else 
                begin
                    valM=memo_arr[valE];    //load value E from memory
                    mem_err=0;                    
                end
            end
        else if(icode==4'h8)        //call
            begin 
                if(valE>1023)
                begin
                    mem_err=1;     //memory error
                end
                else 
                begin
                    memo_arr[valE]=valP;    //store next PC in memory
                    valM=valP;
                    mem_err=0;
                end
            end
        else if(icode==4'h9)        //ret
            begin
                if(valA>1023)
                begin
                    mem_err=1;     //memory error
                end
                else
                begin
                    valM=memo_arr[valA];    //load value E from memory
                    mem_err=0;
                end
            end
        else if(icode==4'hA)        //pushq
            begin
                if(valE>1023)
                begin
                    mem_err=1;     //memory error
                end
                else 
                begin
                    memo_arr[valE]=valA;    //store value A in memory       
                    valM=memo_arr[valE];
                    mem_err=0;
                end
            end
        else if(icode==4'hB)        //popq
            begin
                if(valA>1023)
                begin
                    mem_err=1;     //memory error
                end
                else
                begin
                    valM=memo_arr[valA];    //load value E from memory
                    mem_err=0;
                end
            end
        else 
            begin
                mem_err=0;
// do nothing 
            end 
    end
endmodule
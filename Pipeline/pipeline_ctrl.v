module pipeline_ctrl (
        input e_Cnd,

    input [3:0] D_icode,
    input [3:0] E_icode,
    input [3:0] E_destM,
    input [3:0] d_srcA,
    input [3:0] d_srcB,
    input [3:0] M_icode,
    input [0:3] m_stat,
    input [0:3] W_stat,
    output reg setcc,
    output reg D_bubble,
    output reg E_bubble,
    output reg F_stall,
    output reg D_stall
);

always @* begin
    setcc = 1'b1;

   if(E_icode == 4'h5 || E_icode == 4'hB) 
   begin
        if(( (E_destM != 4'hF && E_destM == d_srcB ) || ( E_destM != 4'hF && E_destM == d_srcA ) ) ||
                (D_icode == 4'h9 || M_icode == 4'h9 || E_icode == 4'h9 ))
                begin
                    F_stall =  (E_icode == 4'h5 || E_icode == 4'hB) &&
                ( (E_destM != 4'hF && E_destM == d_srcB ) || ( E_destM != 4'hF && E_destM == d_srcA ) ) ||
                (D_icode == 4'h9 || M_icode == 4'h9 || E_icode == 4'h9 );
                end

    end
    else 
    begin
        F_stall =  (E_icode == 4'h5 || E_icode == 4'hB) &&
                ( (E_destM != 4'hF && E_destM == d_srcB ) || ( E_destM != 4'hF && E_destM == d_srcA ) ) ||
                (D_icode == 4'h9 || M_icode == 4'h9 || E_icode == 4'h9 );
    end

    if(E_icode == 4'h5 || E_icode == 4'hB) 
   begin
        if((E_destM != 4'hF && E_destM == d_srcA ) || (E_destM != 4'hF && E_destM == d_srcB ))
                begin
                    D_stall = (E_icode == 4'h5 || E_icode == 4'hB) &&
               ((E_destM != 4'hF && E_destM == d_srcA ) || (E_destM != 4'hF && E_destM == d_srcB ));
                end

    end
    else 
    begin
        D_stall = (E_icode == 4'h5 || E_icode == 4'hB) &&
               ((E_destM != 4'hF && E_destM == d_srcA ) || (E_destM != 4'hF && E_destM == d_srcB ));
    end

    D_bubble = (!e_Cnd && E_icode == 4'h7) ||
               !((E_icode == 4'h5 || E_icode == 4'hB) &&
               ((E_destM != 4'hF && E_destM == d_srcA) || (E_destM != 4'hF && E_destM == d_srcB ))) &&
               (D_icode == 4'h9 || M_icode == 4'h9 ||  E_icode == 4'h9);
    
    E_bubble = ( !e_Cnd && E_icode == 4'h7) ||
               ((E_icode == 4'h5 || E_icode == 4'hB) &&
               ((E_destM != 4'hF && E_destM == d_srcA ) || (E_destM != 4'hF && E_destM == d_srcB )));
    
    if (E_icode == 4'h0 || W_stat != 4'b1000 || m_stat != 4'b1000) begin
        setcc = 1'b0;
    end
end

endmodule

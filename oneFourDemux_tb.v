`timescale 1ns / 1ps

module oneForDemux_tb();

    reg E,S1,S0,I;
    wire Y0,Y1,Y2,Y3;
    
    oneFourDemux uut(E,S1,S2,I,Y0,Y1,Y2,Y3);
    integer i;
    initial begin
        for(i=0;i<4;i=i+1)begin
            E = 1'b1;
            I = 1'b1;
            {S1,S0} = i;
            #10 $display("E = %b, S1 = %b, S0 = %b, I = %b, Y0 = %b, Y1 = %b, Y2 = %b, Y3 = %b", E,S1,S0,I,Y0,Y1,Y2,Y3);
        end
    end
endmodule

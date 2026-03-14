`timescale 1ns / 1ps

module oneFourDemux(
    input E,
    input S1,
    input S0,
    input I,
    output Y0,
    output Y1,
    output Y2,
    output Y3
    );
    
    assign Y0 = E & ~S1 & ~S0 & I;
    assign Y1 = E & ~S1 & S0 & I;
    assign Y2 = E & S1 & ~S0 & I;
    assign Y3 = E & S1 & S0 & I;
    
endmodule

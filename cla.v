`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2025 08:41:01 AM
// Design Name: 
// Module Name: cla
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module gp1(input wire a, b,
           output wire g, p);
    assign g = a & b;
    assign p = a | b;
endmodule

module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);

   // TODO: your code here
    //assign pout = &pin; // Pout is true if all p bits are true
    assign pout = pin[3] & pin[2] & pin[1] & pin[0]; //all p bit = 1 -> pout = 1

    assign gout = gin[3] | (pin[3] & gin[2]) |  (pin[3] & pin[2] & gin[1]) | (pin[3] & pin[2] & pin[1] & gin[0]);

    //logic for cout - internal carry
    wire c1, c2, c3;
    assign c1 = gin[0] | (pin[0] & cin);
    assign c2 = gin[1] | (pin[1] & c1);
    assign c3 = gin[2] |  (pin[2] & c2);

    assign cout = {c3, c2, c1}; //concatenate bit 
endmodule

/** Same as gp4 but for an 8-bit window instead */
module gp8(input wire [7:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [6:0] cout);

   // TODO: your code here
    wire  c4, c8, c12, c16, c20, c24, c28;

    wire G_1_0 = gin[1] | (pin[1] & gin[0]);
    wire P_1_0 = pin[1] & pin[0];
    wire G_2_0 = gin[2] | (pin[2] & G_1_0);
    wire P_2_0 = pin[2] & P_1_0;
    wire G_3_0 = gin[3] | (pin[3] & G_2_0);
    wire P_3_0 = pin[3] & P_2_0;
    wire G_4_0 = gin[4] | (pin[4] & G_3_0);
    wire P_4_0 = pin[4] & P_3_0;
    wire G_5_0 = gin[5] | (pin[5] & G_4_0);
    wire P_5_0 = pin[5] & P_4_0;
    wire G_6_0 = gin[6] | (pin[6] & G_5_0);
    wire P_6_0 = pin[6] & P_5_0;

    assign c4 = gin[0] | (pin[0] & cin);
    assign c8 = G_1_0 | (P_1_0 & cin);
    assign c12 = G_2_0 | (P_2_0 & cin);
    assign c16 = G_3_0 | (P_3_0 & cin);
    assign c20 = G_4_0 | (P_4_0 & cin); 
    assign c24 = G_5_0 | (P_5_0 & cin);
    assign c28 = G_6_0 | (P_6_0 & cin);

    assign cout = {c28, c24, c20, c16, c12, c8, c4};

endmodule

module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);
   
   

   // TODO: your code here
    wire [31:0] g; 
    wire [31:0] p;

    wire [31:0] a_xor_b;
    wire [7:0] g4, p4;
    wire [2:0] c_gp4 [0:7]; //carry internal from 8 gp4

    wire [6:0] c_gp8; //carry between gp8
    wire [31:0] c;

    assign a_xor_b = a ^ b;

    //calculate 32 gp1
    genvar i;
    generate
        for (i = 0; i <32; i = i + 1) begin: gp1_gen
            gp1 gp1_inst (a[i], b[i], g[i], p[i]);
        end
    endgenerate

    //calculate carry between gp8
    gp8 gp8_inst (
        .gin(g4), .pin(p4), .cin(cin),
        .gout(), .pout(),
        .cout(c_gp8) //output is C4, C8, C12,
    );

    //calculate 8 gp4
    generate
        for (i = 0; i < 8; i = i + 1) begin: gp4_gen
            gp4 gp4_inst (
                .gin(g[4*i+3 : 4*i]), //gp4[0] is [3:0],...
                .pin(p[4*i+3 : 4*i]),
                .cin( (i == 0) ? cin : c_gp8[i-1] ), //cin for gp4[0] is cin of module, others is carry-out from previous gp4
                .gout(g4[i]), 
                .pout(p4[i]),
                .cout(c_gp4[i]) //internal carry (C1-C3, C5-C7,...)
            );
        end
    endgenerate

    //final carry signals
    assign c[0] = cin;
    generate
        for (i = 0; i < 8; i = i + 1) begin: sum_gen
        //take 3 internal carry form gp4
            assign c[4*i+1] = c_gp4[i][0];
            assign c[4*i+2] = c_gp4[i][1];
            assign c[4*i+3] = c_gp4[i][2];
            if (i <7) begin
            //take carry from gp8
                assign c[4*(i+1)] = c_gp8[i];
            end
        end
    endgenerate
    
    assign sum = a_xor_b ^ c; //final sum calculation
    
    
endmodule
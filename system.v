`include "cla.v" 
module SystemDemo(
   input wire [3:0] btn,
   output wire [5:0] led
);
   wire [31:0] sum;
   wire local_overflow;
   
   assign a = 32'd26;
   assign b = {28'd0, btn};
   cla cla_inst(
      .a(32'd26),
     .b({28'd0, btn}),
     .cin(cin), 
     .sum(sum)
   );
   assign local_overflow = sum[5];
   
   wire [5:0] led_normal_case = {1'b0, sum[4:0]};
   
   wire [5:0] led_overflow_case = 6'b100000;
   
   assign led = local_overflow ? led_overflow_case : led_normal_case;
   /*
   wire [4:0] g_local, p_local; // Tín hiệu G/P cho 5 bit thấp
   wire c5_local;             // Carry-out từ bit 4, chính là cờ tràn cục bộ
   wire local_overflow;

   // Tạo G/P cho 5 bit đầu tiên
   assign g_local[0] = a[0] & b[0];
   assign p_local[0] = a[0] | b[0];
   assign g_local[1] = a[1] & b[1];
   assign p_local[1] = a[1] | b[1];
   assign g_local[2] = a[2] & b[2];
   assign p_local[2] = a[2] | b[2];
   assign g_local[3] = a[3] & b[3];
   assign p_local[3] = a[3] | b[3];
   assign g_local[4] = a[4] & b[4];
   assign p_local[4] = a[4] | b[4];

   
   wire G_3_0_local = g_local[3] | (p_local[3] & g_local[2]) | (p_local[3] & p_local[2] & g_local[1]) | (p_local[3] & p_local[2] & p_local[1] & g_local[0]);
   wire P_3_0_local = p_local[3] & p_local[2] & p_local[1] & p_local[0];

   
   wire c4_local = G_3_0_local | (P_3_0_local & cin);
   assign c5_local = g_local[4] | (p_local[4] & c4_local);

   assign local_overflow = c5_local;
   
   assign led = local_overflow ? 6'b100000 : {1'b0, sum[4:0]};
   */
endmodule

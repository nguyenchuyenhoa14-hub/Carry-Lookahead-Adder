`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.12.2025 17:07:02
// Design Name: 
// Module Name: cla_tb
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


module cla_tb;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg cin;

    // Outputs
    wire [31:0] sum;

    // Instantiate the Unit Under Test (UUT)
    cla uut (
        .a(a), 
        .b(b), 
        .cin(cin), 
        .sum(sum)
    );

    initial begin
        // Setup file để xem Waveform (nếu dùng Icarus Verilog/GTKWave)
        $dumpfile("cla_waveform.vcd");
        $dumpvars(0, cla_tb);

        // Monitor để in kết quả ra terminal
        $monitor("Time=%0t | A=%d (%b) | B=%d (%b) | CIN=%b | SUM=%d (%b)", 
                 $time, a, a, b, b, cin, sum, sum);

        // ==========================================
        // KHỞI TẠO
        // ==========================================
        a = 0; b = 0; cin = 0;
        #10;

        // ==========================================
        // CÁC TEST CASE GIỐNG TRÊN FPGA (A = 26)
        // ==========================================
        
        // Case 1: 26 + 0
        // Kết quả mong đợi: 26 (...011010)
        a = 32'd26; b = 32'd0; cin = 0;
        #10;

        // Case 2: 26 + 4
        // Kết quả mong đợi: 30 (...011110)
        a = 32'd26; b = 32'd4; cin = 0;
        #10;

        // Case 3: 26 + 5
        // Kết quả mong đợi: 31 (...011111) -> 5 LED sáng
        a = 32'd26; b = 32'd5; cin = 0;
        #10;

        // Case 4: 26 + 6 (Overflow 5 bit thấp)
        // Kết quả mong đợi: 32 (...100000) -> Bit thứ 6 lên 1
        a = 32'd26; b = 32'd6; cin = 0;
        #10;

        // ==========================================
        // CÁC TEST CASE KHÁC (EDGE CASES)
        // ==========================================

        // Case 5: Phép cộng lớn (Kiểm tra carry lan truyền xa)
        // 16777215 + 1 = 16777216
        a = 32'd16777215; b = 32'd1; cin = 0;
        #10;

        // Case 6: Max 32-bit + 1 (Overflow 32-bit)
        // FFFFFFFF + 1 = 0
        a = 32'hFFFFFFFF; b = 32'd1; cin = 0;
        #10;

        // Case 7: Kiểm tra Cin
        // 10 + 10 + 1 = 21
        a = 32'd10; b = 32'd10; cin = 1;
        #10;

        // Kết thúc mô phỏng
        $finish;
    end
      
endmodule

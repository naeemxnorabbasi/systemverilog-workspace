`timescale 1ns/1ps

import register_pkg::*;

module class_tb;

  localparam int CLK_HALF_PERIOD = 10;

  logic       clk;
  logic       rst_n;
  logic       load_en;
  logic [7:0] din;
  logic [7:0] dout;

  class_demo_dut dut (
    .clk    (clk),
    .rst_n  (rst_n),
    .load_en(load_en),
    .din    (din),
    .dout   (dout)
  );

  initial begin
    clk     = 0;
    rst_n   = 0;
    load_en = 0;
    din     = 8'h00;
  end

  initial begin : Clocking
    clk = 0;
    forever #(CLK_HALF_PERIOD) clk = ~clk;
  end

  task automatic drive_dut(logic [7:0] value);
    din     = value;
    load_en = 1'b1;
    @(posedge clk);
    #1step;
    load_en = 1'b0;
    if (dout !== value) begin
      $display("[%0t] FAIL: DUT dout=%0h expected=%0h load_en=%b din=%0h",
               $time, dout, value, load_en, din);
      $finish(1);
    end
  endtask

  task automatic check_eq(string msg, logic [7:0] got, logic [7:0] exp);
    if (got !== exp) begin
      $display("[%0t] FAIL: %s got=%0h expected=%0h", $time, msg, got, exp);
      $finish(1);
    end
  endtask

  initial begin : Stimulus
    Register            accum;
    Register            accum1;
    Register            accum2;
    Register            accum3[10];
    RegisterVal#(8)     accum8;
    RegisterVal#(.n(16)) accum16;
    RegisterType#(int)  accum_int;
    RegisterType#(bit [7:0]) accum_bits;
    ShiftRegister       SR;
    WideShiftRegister   WSR;
    Register            base_handle;
    ShiftRegister       derived_handle;
    int                 count_before;
    int                 count_after;

    $display("[%0t] Starting class construct demo", $time);

    // F1: define + construct + load
    $display("[%0t] FEATURE: F1 Register new/load", $time);
    accum = new;
    accum.load(8'h1f);
    check_eq("F1 load", accum.data, 8'h1f);

    // F2: handle declaration and new forms
    $display("[%0t] FEATURE: F2 handles and new forms", $time);
    accum1 = new;
    accum2 = new(8'hff);
    check_eq("F2 new(8'hff)", accum2.data, 8'hff);
    foreach (accum3[i])
      accum3[i] = new;
    accum3[5].data = 8'h55;
    check_eq("F2 array handle", accum3[5].data, 8'h55);

    // F3: direct member access
    $display("[%0t] FEATURE: F3 member access", $time);
    accum.data = 8'h3c;
    check_eq("F3 direct assign", accum.data, 8'h3c);

    // F4: parameterized by value
    $display("[%0t] FEATURE: F4 param by value", $time);
    accum8  = new(8'h12);
    accum16 = new(16'habcd);
    check_eq("F4 Register#(8)", accum8.data, 8'h12);
    if (accum16.data !== 16'habcd) begin
      $display("[%0t] FAIL: F4 Register#(.n(16)) got=%0h", $time, accum16.data);
      $finish(1);
    end

    // F5: parameterized by type
    $display("[%0t] FEATURE: F5 param by type", $time);
    accum_int  = new(32);
    accum_bits = new(8'h77);
    if (accum_int.data !== 32) begin
      $display("[%0t] FAIL: F5 Register#(int)", $time);
      $finish(1);
    end
    check_eq("F5 Register#(bit[7:0])", accum_bits.data, 8'h77);

    // F6/F7: inheritance, extern methods, inherited load
    $display("[%0t] FEATURE: F7 ShiftRegister load/shiftleft", $time);
    SR = new;
    SR.load(8'h55);
    SR.shiftleft();
    check_eq("F7 shiftleft -> 8'haa", SR.data, 8'haa);
    SR.shiftright();
    check_eq("F7 shiftright -> 8'h55", SR.data, 8'h55);

    // F8: derived new calls super.new first
    $display("[%0t] FEATURE: F8 super.new in derived constructor", $time);
    WSR = new(8'h42, 8'h99);
    check_eq("F8 WideShiftRegister data", WSR.data, 8'h42);
    check_eq("F8 WideShiftRegister tag", WSR.tag, 8'h99);

    // F9: static property shared across instances
    $display("[%0t] FEATURE: F9 static instance_count", $time);
    begin
      Register tmp_a;
      Register tmp_b;
      count_before = Register::instance_count;
      tmp_a = new;
      tmp_b = new;
      count_after = Register::instance_count;
    end
    if (count_after !== count_before + 2) begin
      $display("[%0t] FAIL: F9 static count before=%0d after=%0d",
               $time, count_before, count_after);
      $finish(1);
    end

    // F10: legal $cast from base handle to derived handle
    $display("[%0t] FEATURE: F10 $cast base -> derived", $time);
    base_handle = SR;
    if (!$cast(derived_handle, base_handle)) begin
      $display("[%0t] FAIL: F10 $cast should succeed", $time);
      $finish(1);
    end
    check_eq("F10 cast handle data", derived_handle.data, 8'h55);

    // Drive DUT using class-modeled register value
    $display("[%0t] FEATURE: DUT load from Register class", $time);
    rst_n = 0;
    repeat (2) @(posedge clk);
    rst_n = 1;
    repeat (2) @(posedge clk);
    accum.load(8'hc3);
    drive_dut(accum.data);

    $display("[%0t] PASS: class construct demo complete", $time);
    disable Clocking;
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, class_tb);
  end

endmodule

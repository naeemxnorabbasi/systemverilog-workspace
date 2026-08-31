`timescale 1ns/1ps

module forever_tb;

  localparam int CLK_HALF_PERIOD = 10;
  localparam int WIDTH           = 8;

  logic             clk;
  logic             rst_n;
  logic             en;
  logic [WIDTH-1:0] count;

  counter #(.WIDTH(WIDTH)) dut (
    .clk  (clk),
    .rst_n(rst_n),
    .en   (en),
    .count(count)
  );

  // Pattern 1: forever with timing control — classic testbench clock generator.
  initial begin : Clocking
    clk = 0;
    forever
      #(CLK_HALF_PERIOD) clk = ~clk;
  end

  // Pattern 2: forever with break — run until a condition is met.
  // Pattern 3: disable — terminate the named Clocking block above.
  initial begin : Stimulus
    int               cycles;
    logic [WIDTH-1:0] expected;
    logic             clk_sample;

    $display("[%0t] Starting forever construct demo", $time);

    rst_n = 0;
    en    = 0;
    #(CLK_HALF_PERIOD * 2);
    rst_n = 1;
    en    = 1;

    forever begin
      @(posedge clk);
      #1step;
      cycles++;
      expected = cycles[WIDTH-1:0];

      if (count !== expected) begin
        $display("[%0t] FAIL: cycle=%0d expected=%0d got=%0d",
                 $time, cycles, expected, count);
        $finish(1);
      end

      if (cycles == 10) begin
        $display("[%0t] Stimulus: break after %0d enabled cycles", $time, cycles);
        break;
      end
    end

    en = 0;
    #(CLK_HALF_PERIOD * 2);

    $display("[%0t] Disabling Clocking block (stops forever clock loop)", $time);
    disable Clocking;

    clk_sample = clk;
    #(CLK_HALF_PERIOD * 2);
    if (clk !== clk_sample) begin
      $display("[%0t] FAIL: clock still toggling after disable Clocking", $time);
      $finish(1);
    end

    $display("[%0t] PASS: forever demo complete", $time);
    $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, forever_tb);
  end

endmodule

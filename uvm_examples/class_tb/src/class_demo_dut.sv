module class_demo_dut (
  input  logic       clk,
  input  logic       rst_n,
  input  logic       load_en,
  input  logic [7:0] din,
  output logic [7:0] dout
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      dout <= 8'h00;
    else if (load_en)
      dout <= din;
  end

endmodule

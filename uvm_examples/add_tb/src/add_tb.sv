module add_tb();
add_if aif();
 
add dut (.a(aif.a), .b(aif.b), .y(aif.y));
 
initial begin
 
$dumpfile("dump.vcd");
$dumpvars; 
uvm_config_db #(virtual add_if)::set(null, "*", "aif", aif);
run_test("test");
end
 
endmodule

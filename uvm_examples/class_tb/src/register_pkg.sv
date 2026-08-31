package register_pkg;

  // F1: base class with constructor and load method (guide p.69)
  class Register;
    static int instance_count = 0;

    logic [7:0] data;

    function new(logic [7:0] d = 0);
      data = d;
      instance_count++;
    endfunction

    task load(logic [7:0] d);
      data = d;
    endtask
  endclass

  // F4: parameterized class by value (guide p.70)
  class RegisterVal #(parameter int n = 8);
    logic [n-1:0] data;

    function new(logic [n-1:0] d = '0);
      data = d;
    endfunction
  endclass

  // F5: parameterized class by type (guide p.70)
  class RegisterType #(parameter type T = logic [7:0]);
    T data;

    function new(T d = T'(0));
      data = d;
    endfunction
  endclass

  // F6/F7: derived class with extern methods (guide p.70)
  class ShiftRegister extends Register;
    function new(logic [7:0] d = 0);
      super.new(d);  // F8: super.new must be first when overriding new
    endfunction

    extern task shiftleft();
    extern task shiftright();
  endclass

  task ShiftRegister::shiftleft();
    data = data << 1;
  endtask

  task ShiftRegister::shiftright();
    data = data >> 1;
  endtask

  // F8: derived constructor with extra args — super.new(d) first
  class WideShiftRegister extends Register;
    logic [7:0] tag;

    function new(logic [7:0] d = 0, logic [7:0] t = 8'h00);
      super.new(d);
      tag = t;
    endfunction
  endclass

endpackage

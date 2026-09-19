// tb.v
// Testbench to expose the sensitivity and non-blocking bugs in alu.v

module tb;

  reg  [3:0] t_a;
  reg  [3:0] t_b;
  reg        t_op;
  wire [3:0] t_result;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // Test 1: Expose sensitivity list bug
    // Set a and b, then change op WITHOUT changing a or b.
    t_a = 4'd5; t_b = 4'd2; t_op = 1'b0; // 5 + 2 = 7
    #10;
    
    t_op = 1'b1; // Switch to SUB (5 - 2 = 3). 
    // In the buggy ALU, result stays 7 because 'op' is not in the sensitivity list!
    #10;

    // Test 2: Expose blocking/non-blocking bug
    // Perform a fresh subtraction.
    t_a = 4'd7; t_b = 4'd4; t_op = 1'b1; // 7 - 4 = 3
    // In the buggy ALU, b_inv and b_twos update at the end of the time step, 
    // causing result to compute using stale, uninitialized values.
    #10;

    $finish;
  end

  initial
    $monitor($time, " a=%d b=%d op=%b | result=%d", t_a, t_b, t_op, t_result);

endmodule
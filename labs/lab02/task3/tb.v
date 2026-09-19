// tb.v
// Self-checking testbench for 2-bit comparator

module tb;

  reg  [1:0] t_A;
  reg  [1:0] t_B;
  wire       t_GT;
  wire       t_LT;
  wire       t_EQ;
  
  integer i, j;
  integer errors = 0;

  comp2 DUT (
    .A  (t_A),
    .B  (t_B),
    .GT (t_GT),
    .LT (t_LT),
    .EQ (t_EQ)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // Exhaustive test: iterate through all 16 combinations of A and B
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_A = i;
        t_B = j;
        #5; 
        
        // SELF-CHECKING LOGIC
        // Rule: Exactly ONE output must be high (1)
        if ((t_GT + t_LT + t_EQ) != 1) begin
          $display("ERROR: A=%0d, B=%0d | GT=%b, LT=%b, EQ=%b", t_A, t_B, t_GT, t_LT, t_EQ);
          errors = errors + 1;
        end
      end
    end
    
    if (errors == 0)
      $display("SUCCESS: All tests passed!");
    else
      $display("FAILED: %0d errors found.", errors);
      
    $finish;
  end

endmodule
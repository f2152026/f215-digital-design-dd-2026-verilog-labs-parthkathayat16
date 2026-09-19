// and_beh_before.v
// Behavioral implementation with delay BEFORE evaluation (Inter-assignment)
module and_beh_before (
  input  a,
  input  b,
  output reg y
);
  always @(a or b) begin
    // The simulator waits 5 units, THEN evaluates (a & b).
    // If a or b changed during the wait, it uses the NEW values, leading to incorrect output.
    #5 y = a & b;
  end

endmodule
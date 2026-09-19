// and_beh_intra.v
// Behavioral implementation with INTRA-assignment delay
module and_beh_intra (
  input  a,
  input  b,
  output reg y
);
  always @(a or b) begin
    // Evaluates (a & b) IMMEDIATELY upon an input change, stores the result, 
    // waits 5 units, and then assigns the stored result to y.
    // Models transport delay: all changes are delayed and passed through.
    y = #5 (a & b);
  end

endmodule
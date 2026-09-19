// and_df.v
// Dataflow implementation (Inertial Delay)
module and_df (
  input  a,
  input  b,
  output wire y
);
  // Continuous assignment with delay.
  // Models inertial delay: pulses shorter than 5 time units are filtered out.
  assign #5 y = a & b;

endmodule
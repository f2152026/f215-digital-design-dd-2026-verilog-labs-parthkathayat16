// mux_df.v
// 2-to-1 multiplexer, DATAFLOW style.

module mux_df (
  input       I0,
  input       I1,
  input       S,
  output wire Y  // FIXED: Changed 'reg' to 'wire' (or just 'output Y')
);

  assign Y = S ? I1 : I0;

endmodule
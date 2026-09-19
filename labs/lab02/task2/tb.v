// tb.v
// Testbench to verify the parameterized lookup table (lut.v).

module tb;

  // TODO: declare the inputs and outputs
  // For default DEPTH=4, sel is 2 bits. For default WIDTH=8, dout is 8 bits.
  reg  [1:0] t_sel;
  wire [7:0] t_dout;

  integer i;

  // TODO: instantiate DUT here
  lut DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // TODO: apply different input combinations
    // Loop through all 4 addresses (0 to 3), waiting 5 time units between each
    for (i = 0; i < 4; i = i + 1) begin
      t_sel = i;
      #5;
    end
    
    $finish;
  end

  initial
    // change as required to match the LUT signals
    $monitor($time, " sel=%0d | dout=%0d (which is %0d squared)", t_sel, t_dout, t_sel); 

endmodule
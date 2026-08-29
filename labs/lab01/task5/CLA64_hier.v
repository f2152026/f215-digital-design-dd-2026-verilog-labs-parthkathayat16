// cla4_pg.v / helper submodule: 4-bit CLA with Block P/G outputs
module cla4_pg(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       p_blk,
  output       g_blk
);
  wire [3:0] p, g;
  wire c1, c2, c3;

  // Bit-level Propagate and Generate
  assign #(2) p = a ^ b;
  assign #(2) g = a & b;

  // Internal carry equations within the 4-bit block
  assign #(2) c1 = g[0] | (p[0] & cin);
  assign #(2) c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
  assign #(2) c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);

  // Block Propagate and Generate
  assign #(2) p_blk = &p; // p[3] & p[2] & p[1] & p[0]
  assign #(2) g_blk = g[3] | 
                      (p[3] & g[2]) | 
                      (p[3] & p[2] & g[1]) | 
                      (p[3] & p[2] & p[1] & g[0]);

  // Sum bits
  assign #(2) sum = p ^ {c3, c2, c1, cin};

endmodule


// =====================================================================
// cla64_hier.v: Top-level 64-bit Hierarchical Carry-Lookahead Adder
// =====================================================================
module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [15:0] Pblk, Gblk;
  wire [16:1] Cblk; // Block carries: Cblk[1] is carry-in to block 1, Cblk[16] is cout

  // -------------------------------------------------------------------
  // Level 2 Lookahead: Direct Block-Carry Equations (16-block Lookahead Unit)
  // -------------------------------------------------------------------
  assign #(2) Cblk[1]  = Gblk[0]  | (&Pblk[0:0]  & cin);
  assign #(2) Cblk[2]  = Gblk[1]  | (&Pblk[1:1]  & Gblk[0])  | (&Pblk[1:0]  & cin);
  assign #(2) Cblk[3]  = Gblk[2]  | (&Pblk[2:2]  & Gblk[1])  | (&Pblk[2:1]  & Gblk[0])  | (&Pblk[2:0]  & cin);
  assign #(2) Cblk[4]  = Gblk[3]  | (&Pblk[3:3]  & Gblk[2])  | (&Pblk[3:2]  & Gblk[1])  | (&Pblk[3:1]  & Gblk[0])  | (&Pblk[3:0]  & cin);
  assign #(2) Cblk[5]  = Gblk[4]  | (&Pblk[4:4]  & Gblk[3])  | (&Pblk[4:2]  & Gblk[1])  | (&Pblk[4:1]  & Gblk[0])  | (&Pblk[4:0]  & cin);
  assign #(2) Cblk[6]  = Gblk[5]  | (&Pblk[5:5]  & Gblk[4])  | (&Pblk[5:3]  & Gblk[2])  | (&Pblk[5:1]  & Gblk[0])  | (&Pblk[5:0]  & cin);
  assign #(2) Cblk[7]  = Gblk[6]  | (&Pblk[6:6]  & Gblk[5])  | (&Pblk[6:4]  & Gblk[3])  | (&Pblk[6:1]  & Gblk[0])  | (&Pblk[6:0]  & cin);
  assign #(2) Cblk[8]  = Gblk[7]  | (&Pblk[7:7]  & Gblk[6])  | (&Pblk[7:5]  & Gblk[4])  | (&Pblk[7:1]  & Gblk[0])  | (&Pblk[7:0]  & cin);
  assign #(2) Cblk[9]  = Gblk[8]  | (&Pblk[8:8]  & Gblk[7])  | (&Pblk[8:6]  & Gblk[5])  | (&Pblk[8:1]  & Gblk[0])  | (&Pblk[8:0]  & cin);
  assign #(2) Cblk[10] = Gblk[9]  | (&Pblk[9:9]  & Gblk[8])  | (&Pblk[9:7]  & Gblk[6])  | (&Pblk[9:1]  & Gblk[0])  | (&Pblk[9:0]  & cin);
  assign #(2) Cblk[11] = Gblk[10] | (&Pblk[10:10]& Gblk[9])  | (&Pblk[10:8] & Gblk[7])  | (&Pblk[10:1] & Gblk[0])  | (&Pblk[10:0] & cin);
  assign #(2) Cblk[12] = Gblk[11] | (&Pblk[11:11]& Gblk[10]) | (&Pblk[11:9] & Gblk[8])  | (&Pblk[11:1] & Gblk[0])  | (&Pblk[11:0] & cin);
  assign #(2) Cblk[13] = Gblk[12] | (&Pblk[12:12]& Gblk[11]) | (&Pblk[12:10]& Gblk[9])  | (&Pblk[12:1] & Gblk[0])  | (&Pblk[12:0] & cin);
  assign #(2) Cblk[14] = Gblk[13] | (&Pblk[13:13]& Gblk[12]) | (&Pblk[13:11]& Gblk[10]) | (&Pblk[13:1] & Gblk[0])  | (&Pblk[13:0] & cin);
  assign #(2) Cblk[15] = Gblk[14] | (&Pblk[14:14]& Gblk[13]) | (&Pblk[14:12]& Gblk[11]) | (&Pblk[14:1] & Gblk[0])  | (&Pblk[14:0] & cin);
  assign #(2) Cblk[16] = Gblk[15] | (&Pblk[15:15]& Gblk[14]) | (&Pblk[15:13]& Gblk[12]) | (&Pblk[15:1] & Gblk[0])  | (&Pblk[15:0] & cin);

  assign cout = Cblk[16];

  // -------------------------------------------------------------------
  // Level 1: 16 Instantiate 4-bit CLA Blocks
  // -------------------------------------------------------------------
  cla4_pg block0  (.a(a[3:0]),   .b(b[3:0]),   .cin(cin),      .sum(sum[3:0]),   .p_blk(Pblk[0]),  .g_blk(Gblk[0]));
  cla4_pg block1  (.a(a[7:4]),   .b(b[7:4]),   .cin(Cblk[1]),  .sum(sum[7:4]),   .p_blk(Pblk[1]),  .g_blk(Gblk[1]));
  cla4_pg block2  (.a(a[11:8]),  .b(b[11:8]),  .cin(Cblk[2]),  .sum(sum[11:8]),  .p_blk(Pblk[2]),  .g_blk(Gblk[2]));
  cla4_pg block3  (.a(a[15:12]), .b(b[15:12]), .cin(Cblk[3]),  .sum(sum[15:12]), .p_blk(Pblk[3]),  .g_blk(Gblk[3]));
  cla4_pg block4  (.a(a[19:16]), .b(b[19:16]), .cin(Cblk[4]),  .sum(sum[19:16]), .p_blk(Pblk[4]),  .g_blk(Gblk[4]));
  cla4_pg block5  (.a(a[23:20]), .b(b[23:20]), .cin(Cblk[5]),  .sum(sum[23:20]), .p_blk(Pblk[5]),  .g_blk(Gblk[5]));
  cla4_pg block6  (.a(a[27:24]), .b(b[27:24]), .cin(Cblk[6]),  .sum(sum[27:24]), .p_blk(Pblk[6]),  .g_blk(Gblk[6]));
  cla4_pg block7  (.a(a[31:28]), .b(b[31:28]), .cin(Cblk[7]),  .sum(sum[31:28]), .p_blk(Pblk[7]),  .g_blk(Gblk[7]));
  cla4_pg block8  (.a(a[35:32]), .b(b[35:32]), .cin(Cblk[8]),  .sum(sum[35:32]), .p_blk(Pblk[8]),  .g_blk(Gblk[8]));
  cla4_pg block9  (.a(a[39:36]), .b(b[39:36]), .cin(Cblk[9]),  .sum(sum[39:36]), .p_blk(Pblk[9]),  .g_blk(Gblk[9]));
  cla4_pg block10 (.a(a[43:40]), .b(b[43:40]), .cin(Cblk[10]), .sum(sum[43:40]), .p_blk(Pblk[10]), .g_blk(Gblk[10]));
  cla4_pg block11 (.a(a[47:44]), .b(b[47:44]), .cin(Cblk[11]), .sum(sum[47:44]), .p_blk(Pblk[11]), .g_blk(Gblk[11]));
  cla4_pg block12 (.a(a[51:48]), .b(b[51:48]), .cin(Cblk[12]), .sum(sum[51:48]), .p_blk(Pblk[12]), .g_blk(Gblk[12]));
  cla4_pg block13 (.a(a[55:52]), .b(b[55:52]), .cin(Cblk[13]), .sum(sum[55:52]), .p_blk(Pblk[13]), .g_blk(Gblk[13]));
  cla4_pg block14 (.a(a[59:56]), .b(b[59:56]), .cin(Cblk[14]), .sum(sum[59:56]), .p_blk(Pblk[14]), .g_blk(Gblk[14]));
  cla4_pg block15 (.a(a[63:60]), .b(b[63:60]), .cin(Cblk[15]), .sum(sum[63:60]), .p_blk(Pblk[15]), .g_blk(Gblk[15]));

endmodule
module pll #(
    parameter int REF_DEV_WIDTH = 4,
    parameter int FB_DIV_WIDTH  = 8
) (
    input  logic                     arst_ni,
    input  logic                     clk_ref_i,
    input  logic [REF_DEV_WIDTH-1:0] refdiv_i,
    input  logic [ FB_DIV_WIDTH-1:0] fbdiv_i,
    output logic                     clk_o,
    output logic                     locked_o
);

  logic    [REF_DEV_WIDTH-1:0] refdiv_q;
  logic    [ FB_DIV_WIDTH-1:0] fbdiv_q;

  logic                        stable;

  realtime                     ref_clk_tick = 0;
  realtime                     timeperiod = 1us;

  logic                        internal_lock;
  logic    [             15:0] lock_array;

  always_ff @(posedge clk_ref_i or negedge arst_ni) begin
    if (~arst_ni) begin
      refdiv_q <= '0;
      fbdiv_q  <= '0;
    end else begin
      refdiv_q <= refdiv_i;
      fbdiv_q  <= fbdiv_i;
    end
  end

  always_comb stable = arst_ni & (refdiv_q == refdiv_i) & (fbdiv_q == fbdiv_i);

  always_ff @(posedge clk_o or negedge stable) begin
    if (~stable) begin
      lock_array <= '0;
    end else begin
      lock_array <= {lock_array[14:0], internal_lock};
    end
  end

  always_comb locked_o = lock_array[15];

  always_ff @(clk_ref_i or negedge arst_ni) begin
    if (~arst_ni) begin
      timeperiod = 1us;
      internal_lock = '0;
    end else begin
      realtime target_timeperiod;
      target_timeperiod = $realtime - ref_clk_tick;
      if (refdiv_i) target_timeperiod = target_timeperiod * unsigned'(refdiv_i);
      if (fbdiv_i) target_timeperiod = target_timeperiod / unsigned'(fbdiv_i);
      if (target_timeperiod > 500us) target_timeperiod = 500us;
      if (target_timeperiod < 50ps) target_timeperiod = 50ps;
      if (timeperiod < target_timeperiod)
        timeperiod = timeperiod * 0.97 + 0.03 * target_timeperiod + 1ps;
      else timeperiod = timeperiod * 0.97 + 0.03 * target_timeperiod - 1ps;
      if (((timeperiod - target_timeperiod) > -10ps) && ((timeperiod - target_timeperiod) < 10ps))
        internal_lock = '1;
      else internal_lock = '0;
    end
    ref_clk_tick = $realtime;
  end

  initial begin
    clk_o <= '0;
    forever begin
      if (arst_ni) clk_o <= '1;
      #(timeperiod);
      clk_o <= '0;
      #(timeperiod);
    end
  end

endmodule

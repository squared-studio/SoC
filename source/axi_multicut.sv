// These can be used to relax timing pressure on very long AXI busses.
module axi_multicut #(
    parameter int unsigned NoCuts = 32'd1,  // Number of cuts.
    // AXI channel structs
    parameter type aw_chan_t = logic,
    parameter type w_chan_t = logic,
    parameter type b_chan_t = logic,
    parameter type ar_chan_t = logic,
    parameter type r_chan_t = logic,
    // AXI request & response structs
    parameter type axi_req_t = logic,
    parameter type axi_resp_t = logic
) (
    input  logic      clk_i,       // Clock
    input  logic      rst_ni,      // Asynchronous reset active low
    // slave port
    input  axi_req_t  slv_req_i,
    output axi_resp_t slv_resp_o,
    // master port
    output axi_req_t  mst_req_o,
    input  axi_resp_t mst_resp_i
);

  if (NoCuts == '0) begin : gen_no_cut
    // degenerate case, connect input to output
    assign mst_req_o  = slv_req_i;
    assign slv_resp_o = mst_resp_i;
  end else begin : gen_axi_cut
    // instantiate all needed cuts
    axi_req_t  [NoCuts:0] cut_req;
    axi_resp_t [NoCuts:0] cut_resp;

    // connect slave to the lowest index
    assign cut_req[0] = slv_req_i;
    assign slv_resp_o = cut_resp[0];

    // AXI cuts
    for (genvar i = 0; i < NoCuts; i++) begin : gen_axi_cuts
      axi_cut #(
          .Bypass    (1'b0),
          .aw_chan_t (aw_chan_t),
          .w_chan_t  (w_chan_t),
          .b_chan_t  (b_chan_t),
          .ar_chan_t (ar_chan_t),
          .r_chan_t  (r_chan_t),
          .axi_req_t (axi_req_t),
          .axi_resp_t(axi_resp_t)
      ) i_cut (
          .clk_i,
          .rst_ni,
          .slv_req_i (cut_req[i]),
          .slv_resp_o(cut_resp[i]),
          .mst_req_o (cut_req[i+1]),
          .mst_resp_i(cut_resp[i+1])
      );
    end

    // connect master to the highest index
    assign mst_req_o        = cut_req[NoCuts];
    assign cut_resp[NoCuts] = mst_resp_i;
  end

endmodule

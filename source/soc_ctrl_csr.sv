module soc_ctrl_csr #(
    parameter logic [63:0] MEM_BASE  = 0,
    parameter int          NUM_CORES = 1,
    parameter type         req_t     = logic,
    parameter type         resp_t    = logic
) (
    input  logic  clk_i,
    input  logic  arst_ni,
    input  req_t  req_i,
    output resp_t resp_o,

    output logic [NUM_CORES-1:0][63:0] boot_vector_o
);

endmodule

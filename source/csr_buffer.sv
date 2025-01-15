import ariane_pkg::*;

module csr_buffer (
    input  logic                     clk_i,          // Clock
    input  logic                     rst_ni,         // Asynchronous reset active low
    input  logic                     flush_i,

    input  fu_data_t                 fu_data_i,

    output logic                     csr_ready_o,    // FU is ready e.g. not busy
    input  logic                     csr_valid_i,    // Input is valid
    output logic [63:0]              csr_result_o,
    input  logic                     csr_commit_i,   // commit the pending CSR OP
    // to CSR file
    output logic  [11:0]             csr_addr_o      // CSR address to commit stage
);
    // this is a single entry store buffer for the address of the CSR
    // which we are going to need in the commit stage
    struct packed {
        logic [11:0] csr_address;
        logic        valid;
    } csr_reg_n, csr_reg_q;

    // control logic, scoreboard signals
    assign csr_result_o   = fu_data_i.operand_a;
    assign csr_addr_o     = csr_reg_q.csr_address;

    // write logic
    always_comb begin : write
        csr_reg_n  = csr_reg_q;
        // by default we are ready
        csr_ready_o = 1'b1;
        // if we have a valid uncomiited csr req or are just getting one WITHOUT a commit in, we are not ready
        if ((csr_reg_q.valid || csr_valid_i) && ~csr_commit_i)
            csr_ready_o = 1'b0;
        // if we got a valid from the scoreboard
        // store the CSR address
        if (csr_valid_i) begin
            csr_reg_n.csr_address = fu_data_i.operand_b[11:0];
            csr_reg_n.valid       = 1'b1;
        end
        // if we get a commit and no new valid instruction -> clear the valid bit
        if (csr_commit_i && ~csr_valid_i) begin
            csr_reg_n.valid       = 1'b0;
        end
        // clear the buffer if we flushed
        if (flush_i)
            csr_reg_n.valid       = 1'b0;
    end
    // sequential process
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if(~rst_ni) begin
            csr_reg_q <= '{default: 0};
        end else begin
            csr_reg_q <= csr_reg_n;
        end
    end

endmodule

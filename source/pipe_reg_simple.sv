
module pipe_reg_simple #(
    parameter type dtype         = logic,
    parameter int unsigned Depth = 1
)(
    input  logic clk_i,    // Clock
    input  logic rst_ni,   // Asynchronous reset active low
    input  dtype d_i,
    output dtype d_o
);

    // register of depth 0 is a wire
    if (Depth == 0) begin
        assign d_o = d_i;
    // register of depth 1 is a simple register
    end else if (Depth == 1) begin
        always_ff @(posedge clk_i or negedge rst_ni) begin
            if (~rst_ni) begin
                d_o <= '0;
            end else begin
                d_o <= d_i;
            end
        end
    // if depth is greater than 1 it becomes a shift register
    end else if (Depth > 1) begin
        dtype [Depth-1:0] reg_d, reg_q;
        assign d_o = reg_q[Depth-1];
        assign reg_d = {reg_q[Depth-2:0], d_i};

        always_ff @(posedge clk_i or negedge rst_ni) begin
            if (~rst_ni) begin
                reg_q <= '0;
            end else begin
                reg_q <= reg_d;
            end
        end
    end

endmodule

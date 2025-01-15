module generic_memory #(
    parameter bit RESETTABLE = 1,
    parameter int ADDR_WIDTH = 10,
    parameter int DATA_WIDTH = 32
) (
    input  logic                    clk_i,
    input  logic                    arst_ni,
    input  logic [  ADDR_WIDTH-1:0] addr_i,
    input  logic [  DATA_WIDTH-1:0] wdata_i,
    input  logic [DATA_WIDTH/8-1:0] be_i,
    input  logic                    we_i,
    output logic [  DATA_WIDTH-1:0] rdata_o
);

  // Memory array
  logic [(2**ADDR_WIDTH)-1:0][DATA_WIDTH-1:0] mem_array;

  // Read operation
  always_comb rdata_o = mem_array[addr_i];

  if (RESETTABLE) begin : g_reset
    // Write operation
    always_ff @(posedge clk_i or negedge arst_ni) begin
      if (~arst_ni) begin
        mem_array <= '0;
      end else if (we_i) begin
        foreach (be_i[i]) begin
          if (be_i[i]) begin
            mem_array[addr_i][i*8+:8] <= wdata_i[i*8+:8];
          end
        end
      end
    end
  end else begin : g_no_reset
    // Write operation
    always_ff @(posedge clk_i) begin
      if (we_i) begin
        foreach (be_i[i]) begin
          if (be_i[i]) begin
            mem_array[addr_i][i*8+:8] <= wdata_i[i*8+:8];
          end
        end
      end
    end
  end

endmodule

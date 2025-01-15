module block_memory #(
    parameter bit VERIF_ONLY = 0,    // Specify that the memory is only for verification
    parameter bit RESETTABLE = 0,    // Specify that the memory is only for verification
    parameter int ADDR_WIDTH = 24,   // Address bus width
    parameter int DATA_WIDTH = 64,   // Data bus width
    parameter int NUM_ROW    = 1024, // Number of rows
    parameter int NUM_COL    = 2     // Number of columns
) (
    input  logic                    clk_i,    // Clock signal
    input  logic                    arst_ni,  // Active-low aynchronous reset signal
    input  logic [  ADDR_WIDTH-1:0] addr_i,   // Address signal
    input  logic [  DATA_WIDTH-1:0] wdata_i,  // Write data signal
    input  logic [DATA_WIDTH/8-1:0] be_i,     // Byte enable signal
    input  logic                    we_i,     // Write enable signal
    output logic [  DATA_WIDTH-1:0] rdata_o   // Read data signal
);

  // Number of pages
  localparam int NumPage = (2 ** (ADDR_WIDTH + 3)) / (DATA_WIDTH * NUM_ROW);
  // Data bits per column
  localparam int DataBitsPerCol = DATA_WIDTH / NUM_COL;
  // Data bytes per column
  localparam int DataBytesPerCol = DataBitsPerCol / 8;
  // Byte offset address width
  localparam int ByteOffsetAddrWidth = $clog2(DataBytesPerCol);
  // Column address width
  localparam int ColAddrWidth = $clog2(NUM_COL);
  // Row address width
  localparam int RowAddrWidth = $clog2(NUM_ROW);
  // Page address width
  localparam int PageAddrWidth = ADDR_WIDTH - RowAddrWidth - ColAddrWidth - ByteOffsetAddrWidth;
  // Byte offset index start
  localparam int ByteOffsetIndexStart = 0;
  // Byte offset index end
  localparam int ByteOffsetIndexEnd = ByteOffsetAddrWidth + ByteOffsetIndexStart - 1;
  // Column index start
  localparam int ColIndexStart = ByteOffsetIndexEnd + 1;
  // Column index end
  localparam int ColIndexEnd = ColIndexStart + ColAddrWidth - 1;
  // Row index start
  localparam int RowIndexStart = ColIndexEnd + 1;
  // Row index end
  localparam int RowIndexEnd = RowIndexStart + RowAddrWidth - 1;
  // Page index start
  localparam int PageIndexStart = RowIndexEnd + 1;
  // Page index end
  localparam int PageIndexEnd = PageIndexStart + PageAddrWidth - 1;

  if (VERIF_ONLY) begin : g_vip

    logic [ADDR_WIDTH-1:0] addr;
    assign addr = {addr_i[ADDR_WIDTH-1:RowIndexStart], {RowIndexStart{1'b0}}};

    logic [7:0] mem[longint];

    if (RESETTABLE) begin : g_reset
      always @(clk_i or negedge arst_ni) begin
        if (~arst_ni) begin
          mem.delete();
        end
        foreach (be_i[i]) begin
          rdata_o[i*8+:8] = mem[addr+i];
        end
        if (we_i & clk_i & arst_ni) begin
          foreach (be_i[i]) begin
            if (be_i[i]) begin
              mem[addr+i] = wdata_i[i*8+:8];
            end
          end
        end
      end
    end else begin : g_no_reset
      always @(clk_i) begin
        foreach (be_i[i]) begin
          rdata_o[i*8+:8] = mem[addr+i];
        end
        if (we_i & clk_i) begin
          foreach (be_i[i]) begin
            if (be_i[i]) begin
              mem[addr+i] = wdata_i[i*8+:8];
            end
          end
        end
      end
    end

  end else begin : g_sip

    logic [NumPage-1:0][DATA_WIDTH-1:0] page_mux_in;

    for (genvar page = 0; page < NumPage; page++) begin : g_block
      logic write_enable;
      assign write_enable = we_i & (addr_i[PageIndexEnd:PageIndexStart] == page);
      for (genvar col = 0; col < NUM_COL; col++) begin : g_page
        generic_memory #(
            .RESETTABLE(RESETTABLE),
            .ADDR_WIDTH($clog2(NUM_ROW)),
            .DATA_WIDTH(DATA_WIDTH / NUM_COL)
        ) mem_inst (
            .clk_i(clk_i),
            .arst_ni(arst_ni),
            .addr_i(addr_i[RowIndexEnd:RowIndexStart]),
            .wdata_i(wdata_i[col*DataBitsPerCol+:DataBitsPerCol]),
            .be_i(be_i[col*DataBytesPerCol+:DataBytesPerCol]),
            .we_i(write_enable),
            .rdata_o(page_mux_in[page][col*DataBitsPerCol+:DataBitsPerCol])
        );
      end
    end

    assign rdata_o = page_mux_in[addr_i[PageIndexEnd:PageIndexStart]];

  end

endmodule

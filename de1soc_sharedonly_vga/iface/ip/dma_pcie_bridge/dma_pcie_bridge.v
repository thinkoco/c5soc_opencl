// Converts the 256-bit DMA master to the 64-bit PCIe slave
// Doesn't handle any special cases - the GUI validates that the parameters are consistant with our assumptions
module dma_pcie_bridge
(
   clk,
   reset,

   // DMA interface (slave)
   dma_address,
   dma_read,
   dma_readdata,
   dma_readdatavalid,
   dma_write,
   dma_writedata,
   dma_burstcount,
   dma_byteenable,
   dma_waitrequest,
   
   // PCIe interface (master)
   pcie_address,
   pcie_read,
   pcie_readdata,
   pcie_readdatavalid,
   pcie_write,
   pcie_writedata,
   pcie_burstcount,
   pcie_byteenable,
   pcie_waitrequest
);

// Parameters set from the GUI
parameter DMA_WIDTH = 256;
parameter PCIE_WIDTH = 64;
parameter DMA_BURSTCOUNT = 6;
parameter PCIE_BURSTCOUNT = 10;
parameter PCIE_ADDR_WIDTH = 30;  // Byte-address width required
parameter ADDR_OFFSET = 0;

// Derived parameters
localparam DMA_WIDTH_BYTES = DMA_WIDTH / 8;
localparam PCIE_WIDTH_BYTES = PCIE_WIDTH / 8;
localparam WIDTH_RATIO = DMA_WIDTH / PCIE_WIDTH;
localparam ADDR_SHIFT = $clog2( WIDTH_RATIO );
localparam DMA_ADDR_WIDTH = PCIE_ADDR_WIDTH - $clog2( DMA_WIDTH_BYTES );

// Global ports
input clk;
input reset;

// DMA slave ports
input [DMA_ADDR_WIDTH-1:0] dma_address;
input dma_read;
output [DMA_WIDTH-1:0 ]dma_readdata;
output dma_readdatavalid;
input dma_write;
input [DMA_WIDTH-1:0] dma_writedata;
input [DMA_BURSTCOUNT-1:0] dma_burstcount;
input [DMA_WIDTH_BYTES-1:0] dma_byteenable;
output dma_waitrequest;

// PCIe master ports
output [31:0] pcie_address;
output pcie_read;
input [PCIE_WIDTH-1:0] pcie_readdata;
input pcie_readdatavalid;
output pcie_write;
output [PCIE_WIDTH-1:0] pcie_writedata;
output [PCIE_BURSTCOUNT-1:0] pcie_burstcount;
output [PCIE_WIDTH_BYTES-1:0] pcie_byteenable;
input pcie_waitrequest;

// Address decoding into byte-address
wire [31:0] dma_byte_address;
assign dma_byte_address = (dma_address * DMA_WIDTH_BYTES);

// Read logic - Buffer the pcie words into a full-sized dma word.  The
// last word gets passed through, the first few words are stored
reg [DMA_WIDTH-1:0] r_buffer; // The last PCIE_WIDTH bits are not used and will be swept away
reg [$clog2(WIDTH_RATIO)-1:0] r_wc;
reg [DMA_WIDTH-1:0] r_demux;
wire [DMA_WIDTH-1:0] r_data;
wire r_full;
wire r_waitrequest;

   // Full indicates that a full word is ready to be passed on to the DMA
   // as soon as the next pcie-word arrives
assign r_full = &r_wc;
   // True when a read request is being stalled (not a function of this unit)
assign r_waitrequest = pcie_waitrequest;
   // Groups the previously stored words with the next read data on the pcie bus
assign r_data = {pcie_readdata, r_buffer[DMA_WIDTH-PCIE_WIDTH-1:0]};
   // Store the first returned words in a buffer, keep track of which word
   // we are waiting for in the word counter (r_wc)
always@(posedge clk or posedge reset)
begin
   if(reset == 1'b1)
   begin
      r_wc <= {$clog2(DMA_WIDTH){1'b0}};
      r_buffer <= {(DMA_WIDTH){1'b0}};
   end
   else
   begin
      r_wc <= pcie_readdatavalid ? (r_wc + 1) : r_wc;
      if(pcie_readdatavalid)
         r_buffer[ r_wc*PCIE_WIDTH +: PCIE_WIDTH ] <= pcie_readdata;
   end
end

// Write logic - First word passes through, last words are registered
// and passed on to the fabric in order.  Master is stalled until the
// full write has been completed (in PCIe word sized segments)
reg [$clog2(WIDTH_RATIO)-1:0] w_wc;
wire [PCIE_WIDTH_BYTES-1:0] w_byteenable;
wire [PCIE_WIDTH-1:0] w_writedata;
wire w_waitrequest;
wire w_sent;

   // Indicates the successful transfer of a pcie-word to PCIe
assign w_sent = pcie_write && !pcie_waitrequest;
   // Select the appropriate word to send downstream
assign w_writedata = dma_writedata[w_wc*PCIE_WIDTH +: PCIE_WIDTH];
assign w_byteenable = dma_byteenable[w_wc*PCIE_WIDTH_BYTES +: PCIE_WIDTH_BYTES];
   // True when avalon is waiting, or the full word has not been written
assign w_waitrequest = (pcie_write && !(&w_wc)) || pcie_waitrequest;
   // Keep track of which word segment we are sending in the word counter (w_wc)
always@(posedge clk or posedge reset)
begin
   if(reset == 1'b1)
      w_wc <= {$clog2(DMA_WIDTH){1'b0}};
   else
      w_wc <= w_sent ? (w_wc + 1) : w_wc;
end

// Shared read/write logic
assign pcie_address = ADDR_OFFSET + dma_byte_address;
assign pcie_read = dma_read;
assign pcie_write = dma_write;
assign pcie_writedata = w_writedata;
assign pcie_burstcount = (dma_burstcount << ADDR_SHIFT);
assign pcie_byteenable = pcie_write ? w_byteenable : dma_byteenable;
assign dma_readdata = r_data;
assign dma_readdatavalid = r_full && pcie_readdatavalid;
assign dma_waitrequest = r_waitrequest || w_waitrequest;

endmodule


module mem_window (
   clk,
   reset,

   // Memory slave port
   s1_address,
   s1_read,
   s1_readdata,
   s1_readdatavalid,
   s1_write,
   s1_writedata,
   s1_burstcount,
   s1_byteenable,
   s1_waitrequest,

   // Configuration register slave port
   cra_write,
   cra_writedata,
   cra_byteenable,

   // Bridged master port to memory
   m1_address,
   m1_read,
   m1_readdata,
   m1_readdatavalid,
   m1_write,
   m1_writedata,
   m1_burstcount,
   m1_byteenable,
   m1_waitrequest
);

parameter PAGE_ADDRESS_WIDTH = 20;
parameter MEM_ADDRESS_WIDTH = 32;
parameter NUM_BYTES = 32;
parameter BURSTCOUNT_WIDTH = 1;
parameter CRA_BITWIDTH = 32;
localparam ADDRESS_SHIFT = $clog2(NUM_BYTES);
localparam PAGE_ID_WIDTH = MEM_ADDRESS_WIDTH - PAGE_ADDRESS_WIDTH - ADDRESS_SHIFT;
localparam DATA_WIDTH = NUM_BYTES * 8;

input clk;
input reset;

// Memory slave port
input [PAGE_ADDRESS_WIDTH-1:0] s1_address;
input s1_read;
output [DATA_WIDTH-1:0] s1_readdata;
output s1_readdatavalid;
input s1_write;
input [DATA_WIDTH-1:0] s1_writedata;
input [BURSTCOUNT_WIDTH-1:0] s1_burstcount;
input [NUM_BYTES-1:0] s1_byteenable;
output s1_waitrequest;

// Bridged master port to memory
output [MEM_ADDRESS_WIDTH-1:0] m1_address;
output m1_read;
input [DATA_WIDTH-1:0] m1_readdata;
input m1_readdatavalid;
output m1_write;
output [DATA_WIDTH-1:0] m1_writedata;
output [BURSTCOUNT_WIDTH-1:0] m1_burstcount;
output [NUM_BYTES-1:0] m1_byteenable;
input m1_waitrequest;

// CRA slave
input cra_write;
input [CRA_BITWIDTH-1:0] cra_writedata;
input [CRA_BITWIDTH/8-1:0] cra_byteenable;

// Architecture

// CRA slave allows the master to change the active page
reg [PAGE_ID_WIDTH-1:0] page_id;
reg [CRA_BITWIDTH-1:0] cra_writemask;
integer i;
always@*
  for (i=0; i<CRA_BITWIDTH; i=i+1)
    cra_writemask[i] = cra_byteenable[i/8] & cra_write;

always@(posedge clk or posedge reset)
begin
   if(reset == 1'b1)
      page_id <= {PAGE_ID_WIDTH{1'b0}};
   else
      page_id <= (cra_writedata & cra_writemask) | (page_id & ~cra_writemask);
end

// The s1 port bridges to the m1 port - with the page ID tacked on to the address
assign m1_address = {page_id, s1_address, {ADDRESS_SHIFT{1'b0}}};
assign m1_read = s1_read;
assign s1_readdata = m1_readdata;
assign s1_readdatavalid = m1_readdatavalid;
assign m1_write = s1_write;
assign m1_writedata = s1_writedata;
assign m1_burstcount = s1_burstcount;
assign m1_byteenable = s1_byteenable;
assign s1_waitrequest = m1_waitrequest;

endmodule


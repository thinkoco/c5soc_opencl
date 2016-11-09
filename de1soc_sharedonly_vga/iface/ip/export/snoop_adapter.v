module snoop_adapter (
    clk,
    reset,
    kernel_clk,
    kernel_reset,

    address,
    read,
    readdata,
    readdatavalid,
    write,
    writedata,
    burstcount,
    byteenable,
    waitrequest,
    burstbegin,

    snoop_data,
    snoop_valid,
    snoop_ready,

    export_address,
    export_read,
    export_readdata,
    export_readdatavalid,
    export_write,
    export_writedata,
    export_burstcount,
    export_burstbegin,
    export_byteenable,
    export_waitrequest
);

parameter NUM_BYTES = 4;
parameter BYTE_ADDRESS_WIDTH = 32;
parameter WORD_ADDRESS_WIDTH = 32;
parameter BURSTCOUNT_WIDTH = 1;
localparam DATA_WIDTH = NUM_BYTES * 8;
localparam ADDRESS_SHIFT = BYTE_ADDRESS_WIDTH - WORD_ADDRESS_WIDTH;

localparam DEVICE_BLOCKRAM_MIN_DEPTH = 256; //Stratix IV M9Ks
localparam FIFO_SIZE = DEVICE_BLOCKRAM_MIN_DEPTH;
localparam LOG2_FIFO_SIZE =$clog2(FIFO_SIZE);

input clk;
input reset;

input kernel_clk;
input kernel_reset;

input [WORD_ADDRESS_WIDTH-1:0] address;
input read;
output [DATA_WIDTH-1:0] readdata;
output readdatavalid;
input write;
input [DATA_WIDTH-1:0] writedata;
input [BURSTCOUNT_WIDTH-1:0] burstcount;
input burstbegin;
input [NUM_BYTES-1:0] byteenable;
output waitrequest;

output [1+WORD_ADDRESS_WIDTH+BURSTCOUNT_WIDTH-1:0] snoop_data;
output snoop_valid;
input  snoop_ready;

output [BYTE_ADDRESS_WIDTH-1:0] export_address;
output export_read;
input [DATA_WIDTH-1:0] export_readdata;
input export_readdatavalid;
output export_write;
output [DATA_WIDTH-1:0] export_writedata;
output [BURSTCOUNT_WIDTH-1:0] export_burstcount;
output export_burstbegin;
output [NUM_BYTES-1:0] export_byteenable;
input export_waitrequest;

reg snoop_overflow;


  // Register snoop data first
  reg  [WORD_ADDRESS_WIDTH+BURSTCOUNT_WIDTH-1:0]     snoop_data_r;  //word-address
  reg                   snoop_valid_r;
  wire snoop_fifo_empty;
  wire overflow;
  wire [ LOG2_FIFO_SIZE-1 : 0 ] rdusedw;


  always@(posedge clk)
  begin
    snoop_data_r<={address,export_burstcount};
    snoop_valid_r<=export_write && !export_waitrequest;
  end

  // 1) Fifo to store snooped accesses from host
  dcfifo  dcfifo_component (
    .wrclk (clk),
    .data (snoop_data_r),
    .wrreq (snoop_valid_r),
    .rdclk (kernel_clk),
    .rdreq (snoop_valid & snoop_ready),
    .q (snoop_data[WORD_ADDRESS_WIDTH+BURSTCOUNT_WIDTH-1:0]),
    .rdempty (snoop_fifo_empty),
    .rdfull (overflow),
    .aclr (1'b0),
    .rdusedw (rdusedw),
    .wrempty (),
    .wrfull (),
    .wrusedw ());
  defparam
    dcfifo_component.intended_device_family = "Stratix IV",
    dcfifo_component.lpm_numwords = FIFO_SIZE,
    dcfifo_component.lpm_showahead = "ON",
    dcfifo_component.lpm_type = "dcfifo",
    dcfifo_component.lpm_width = WORD_ADDRESS_WIDTH+BURSTCOUNT_WIDTH,
    dcfifo_component.lpm_widthu = LOG2_FIFO_SIZE,
    dcfifo_component.overflow_checking = "ON",
    dcfifo_component.rdsync_delaypipe = 4,
    dcfifo_component.underflow_checking = "ON",
    dcfifo_component.use_eab = "ON",
    dcfifo_component.wrsync_delaypipe = 4;

  assign snoop_valid=~snoop_fifo_empty;

  always@(posedge kernel_clk)
    snoop_overflow = ( rdusedw >= ( FIFO_SIZE - 12 ) );

  // Overflow piggy backed onto MSB of stream.  Since overflow guarantees
  // there is something to be read out, we can be sure that this will reach
  // the cache.
  assign snoop_data[WORD_ADDRESS_WIDTH+BURSTCOUNT_WIDTH] = snoop_overflow;

assign export_address = address << ADDRESS_SHIFT;
assign export_read = read;
assign readdata = export_readdata;
assign readdatavalid = export_readdatavalid;
assign export_write = write;
assign export_writedata = writedata;
assign export_burstcount = burstcount;
assign export_burstbegin = burstbegin;
assign export_byteenable = byteenable;
assign waitrequest = export_waitrequest;

endmodule


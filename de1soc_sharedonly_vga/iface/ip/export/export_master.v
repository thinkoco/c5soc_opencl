module export_master (
    clk,
    reset,

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

    export_address,
    export_read,
    export_readdata,
    export_readdatavalid,
    export_write,
    export_writedata,
    export_burstcount,
    export_burstbegin,
    export_byteenable,
    export_waitrequest,

    interrupt,
    export_interrupt
);

parameter NUM_BYTES = 4;
parameter BYTE_ADDRESS_WIDTH = 32;
parameter WORD_ADDRESS_WIDTH = 32;
parameter BURSTCOUNT_WIDTH = 1;
localparam DATA_WIDTH = NUM_BYTES * 8;
localparam ADDRESS_SHIFT = BYTE_ADDRESS_WIDTH - WORD_ADDRESS_WIDTH;

input clk;
input reset;

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
output interrupt;

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
input export_interrupt;

assign export_address = address << ADDRESS_SHIFT;
assign export_read = read;
assign readdata = export_readdata;
assign readdatavalid = export_readdatavalid;
assign export_write = write;
assign export_writedata = writedata;
assign export_burstcount = burstcount;
assign export_burstbegin = burstbegin;
assign export_byteenable = byteenable;
assign interrupt = export_interrupt;
assign waitrequest = export_waitrequest;

endmodule

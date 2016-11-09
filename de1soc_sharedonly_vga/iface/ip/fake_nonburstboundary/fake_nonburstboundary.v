module fake_nonburstboundary #
(
    parameter WIDTH_D = 256,
    parameter S_WIDTH_A = 26,
    parameter M_WIDTH_A = S_WIDTH_A+$clog2(WIDTH_D/8),
    parameter BURSTCOUNT_WIDTH = 6,
    parameter BYTEENABLE_WIDTH = WIDTH_D,
    parameter MAX_PENDING_READS = 64
)
(
    input clk,
    input resetn,

    // Slave port
    input [S_WIDTH_A-1:0] slave_address,  // Word address
    input [WIDTH_D-1:0] slave_writedata,
    input slave_read,
    input slave_write,
    input [BURSTCOUNT_WIDTH-1:0] slave_burstcount,
    input [BYTEENABLE_WIDTH-1:0] slave_byteenable,
    output slave_waitrequest,
    output [WIDTH_D-1:0] slave_readdata,
    output slave_readdatavalid,

    output [M_WIDTH_A-1:0] master_address,  // Byte address
    output [WIDTH_D-1:0] master_writedata,
    output master_read,
    output master_write,
    output [BURSTCOUNT_WIDTH-1:0] master_burstcount,
    output [BYTEENABLE_WIDTH-1:0] master_byteenable,
    input master_waitrequest,
    input [WIDTH_D-1:0] master_readdata,
    input master_readdatavalid
);


assign master_read = slave_read;
assign master_write = slave_write;
assign master_writedata = slave_writedata;
assign master_burstcount = slave_burstcount;
assign master_address = {slave_address,{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
assign master_byteenable = slave_byteenable;
assign slave_waitrequest = master_waitrequest;
assign slave_readdatavalid = master_readdatavalid;
assign slave_readdata = master_readdata;

endmodule

module temperature #
(
    parameter WIDTH = 32,
    parameter S_WIDTH_A = 1
)
(
    input clk, // Must be less than 80 MHz, should be greater than 20 MHz
    input resetn,

    // Slave port
    input [S_WIDTH_A-1:0] slave_address,  // Word address
    input [WIDTH-1:0] slave_writedata,
    input slave_read,
    input slave_write,
    input [WIDTH/8-1:0] slave_byteenable,
    output slave_waitrequest,
    output [WIDTH-1:0] slave_readdata,
    output slave_readdatavalid
);

localparam DIVIDER = 80;

wire tsdcaldone;
wire [7:0] tsdcalo;

temp_sense temp(
	.ce(slave_read),
	.clk(clk),
	.clr(!slave_read),
	.tsdcaldone(tsdcaldone),
	.tsdcalo(tsdcalo));


assign slave_waitrequest = slave_read && !tsdcaldone;
assign slave_readdata = {{WIDTH-8{1'b0}},tsdcalo} - 32'h080;  // Convert to Celsius
assign slave_readdatavalid = slave_read && tsdcaldone;

endmodule

module timer #
(
    parameter WIDTH = 64,
    parameter USE_2XCLK = 0,
    parameter S_WIDTH_A = 2
)
(
    input clk,
    input clk2x,
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

reg [WIDTH-1:0] counter;
reg [WIDTH-1:0] counter2x;

reg clock_sel;

always@(posedge clk or negedge resetn)
  if (!resetn)
    clock_sel <= 1'b0;
  else if (slave_write)
    if (|slave_writedata)
      clock_sel <= 1'b1;
    else
      clock_sel <= 1'b0;

always@(posedge clk or negedge resetn)
  if (!resetn)
    counter <= {WIDTH{1'b0}};
  else if (slave_write)
    counter <= {WIDTH{1'b0}};
  else
    counter <= counter + 2'b01;

always@(posedge clk2x or negedge resetn)
  if (!resetn)
    counter2x <= {WIDTH{1'b0}};
  else if (slave_write)
    counter2x <= {WIDTH{1'b0}};
  else
    counter2x <= counter2x + 2'b01;

assign slave_waitrequest = 1'b0;
assign slave_readdata = (USE_2XCLK && clock_sel) ? counter2x : counter;
assign slave_readdatavalid = slave_read;

endmodule

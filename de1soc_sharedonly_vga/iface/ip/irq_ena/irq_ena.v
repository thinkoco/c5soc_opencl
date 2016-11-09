module irq_ena
(
   input         clk,
   input         resetn,
   input         irq,

   input         slave_address, 
   input  [31:0] slave_writedata,
   input  	 slave_read,
   input         slave_write,
   input  [3:0]  slave_byteenable,
   output [31:0] slave_readdata,
   output        slave_waitrequest,

   output        irq_out
);

reg ena_state;

initial   
    ena_state <= 1'b1;
always@(posedge clk or negedge resetn)
  if (!resetn)
    ena_state <= 1'b1;
  else if (slave_write)
    ena_state <= slave_writedata[0];

assign irq_out = irq & ena_state;

assign slave_waitrequest = 1'b0;
assign slave_readdata[0] = ena_state;
assign slave_readdata[31:1] = 31'b0;
  
endmodule


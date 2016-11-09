module pll_lock_avs 
#( 
  parameter WIDTH=32
)
(
   input clk,
   input resetn,

   // Slave port
   input slave_read,
   output slave_readdata,

   input  lock,
   output lock_export
);

reg locked;
always@(posedge clk)
  locked <= lock;

assign slave_readdata = locked;
assign lock_export = lock;

endmodule


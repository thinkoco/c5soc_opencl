module version_id 
#( 
  parameter WIDTH=32,
  parameter VERSION_ID=0
)
(
   input clk,
   input resetn,

   // Slave port
   input slave_read,
   output [WIDTH-1:0] slave_readdata
);

assign slave_readdata = VERSION_ID;

endmodule


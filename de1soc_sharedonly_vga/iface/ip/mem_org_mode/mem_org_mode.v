module mem_org_mode 
#( 
  parameter WIDTH=32,
  parameter CONDUIT_WIDTH=2
)
(
   input clk,
   input resetn,

   // Slave port
   input [WIDTH-1:0] slave_writedata,
   input slave_read,
   input slave_write,
   output slave_readdata,
   output slave_waitrequest,

   output [CONDUIT_WIDTH-1:0] mem_organization_kernel,
   output [CONDUIT_WIDTH-1:0] mem_organization_host
);

reg [CONDUIT_WIDTH-1:0] mem_organization;

(* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -from [get_registers *mem_organization*]\"" *)
always@(posedge clk or negedge resetn)
  if (!resetn)
    mem_organization <= {CONDUIT_WIDTH{1'b0}};
  else if (slave_write)
    mem_organization <= slave_writedata;

assign mem_organization_kernel = mem_organization;
assign mem_organization_host = mem_organization;

assign slave_readdata = mem_organization;

endmodule


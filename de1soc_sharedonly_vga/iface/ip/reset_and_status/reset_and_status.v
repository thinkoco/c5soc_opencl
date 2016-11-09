module reset_and_status 
#( 
  parameter PIO_WIDTH=32
)
(
   input clk,
   input resetn,

   output reg [PIO_WIDTH-1 : 0 ]  pio_in,
   input      [PIO_WIDTH-1 : 0 ]  pio_out,

   input  lock_kernel_pll,
   input  fixedclk_locked,          // pcie fixedclk lock 

   input  mem0_local_cal_success,
   input  mem0_local_cal_fail,
   input  mem0_local_init_done,

   input  mem1_local_cal_success,
   input  mem1_local_cal_fail,
   input  mem1_local_init_done,

   output reg [1:0] mem_organization,
   output     [1:0] mem_organization_export,
   output           pll_reset,
   output reg       sw_reset_n_out
);

reg   [1:0] pio_out_ddr_mode;
reg  pio_out_pll_reset;
reg  pio_out_sw_reset;


reg [9:0] reset_count;
always@(posedge clk or negedge resetn)
  if (!resetn)
    reset_count <= 10'b0;
  else if (pio_out_sw_reset)
    reset_count <= 10'b0;
  else if (!reset_count[9])
    reset_count <= reset_count + 2'b01;

// false paths set for pio_out_*
(* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -to [get_registers *pio_out_*]\"" *)

always@(posedge clk)
begin
  pio_out_ddr_mode = pio_out[9:8];
  pio_out_pll_reset = pio_out[30];
  pio_out_sw_reset = pio_out[31];
end

// false paths for pio_in - these are asynchronous
(* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -to [get_registers *pio_in*]\"" *)
always@(posedge clk)
begin
  pio_in = {
            lock_kernel_pll,
            fixedclk_locked,
            1'b0,
            1'b0,
            mem1_local_cal_fail,
            mem0_local_cal_fail,
            mem1_local_cal_success,
            mem1_local_init_done,
            mem0_local_cal_success,
            mem0_local_init_done};
end

(* altera_attribute  = "-name SDC_STATEMENT \"set_false_path -from [get_registers *mem_organization*]\"" *)
always@(posedge clk)
  mem_organization = pio_out_ddr_mode;

assign mem_organization_export = mem_organization;

assign pll_reset = pio_out_pll_reset;

// Export sw kernel reset out of iface to connect to kernel
always@(posedge clk)
  sw_reset_n_out = !(!reset_count[9] && (reset_count[8:0] != 0));

endmodule


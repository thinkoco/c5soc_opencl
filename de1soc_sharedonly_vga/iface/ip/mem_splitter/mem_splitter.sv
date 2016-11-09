module mem_splitter #
(
    parameter WIDTH_D = 256,
    parameter S_WIDTH_A = 26,
    parameter NUM_BANKS = 2,
    parameter M_WIDTH_A = S_WIDTH_A+$clog2(WIDTH_D/8)-$clog2(NUM_BANKS), 
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

    // Splitting mode select
    input mode,  // 0 for burst-boundary striping, 1 for consecutive banks

    output [M_WIDTH_A-1:0] bank1_address,  // Byte address
    output [WIDTH_D-1:0] bank1_writedata,
    output bank1_read,
    output bank1_write,
    output [BURSTCOUNT_WIDTH-1:0] bank1_burstcount,
    output [BYTEENABLE_WIDTH-1:0] bank1_byteenable,
    input bank1_waitrequest,
    input [WIDTH_D-1:0] bank1_readdata,
    input bank1_readdatavalid,

    output [M_WIDTH_A-1:0] bank2_address,  // Byte address
    output [WIDTH_D-1:0] bank2_writedata,
    output bank2_read,
    output bank2_write,
    output [BURSTCOUNT_WIDTH-1:0] bank2_burstcount,
    output [BYTEENABLE_WIDTH-1:0] bank2_byteenable,
    input bank2_waitrequest,
    input [WIDTH_D-1:0] bank2_readdata,
    input bank2_readdatavalid,

    output [M_WIDTH_A-1:0] bank3_address,  // Byte address
    output [WIDTH_D-1:0] bank3_writedata,
    output bank3_read,
    output bank3_write,
    output [BURSTCOUNT_WIDTH-1:0] bank3_burstcount,
    output [BYTEENABLE_WIDTH-1:0] bank3_byteenable,
    input bank3_waitrequest,
    input [WIDTH_D-1:0] bank3_readdata,
    input bank3_readdatavalid,

    output [M_WIDTH_A-1:0] bank4_address,  // Byte address
    output [WIDTH_D-1:0] bank4_writedata,
    output bank4_read,
    output bank4_write,
    output [BURSTCOUNT_WIDTH-1:0] bank4_burstcount,
    output [BYTEENABLE_WIDTH-1:0] bank4_byteenable,
    input bank4_waitrequest,
    input [WIDTH_D-1:0] bank4_readdata,
    input bank4_readdatavalid,

    output [M_WIDTH_A-1:0] bank5_address,  // Byte address
    output [WIDTH_D-1:0] bank5_writedata,
    output bank5_read,
    output bank5_write,
    output [BURSTCOUNT_WIDTH-1:0] bank5_burstcount,
    output [BYTEENABLE_WIDTH-1:0] bank5_byteenable,
    input bank5_waitrequest,
    input [WIDTH_D-1:0] bank5_readdata,
    input bank5_readdatavalid,

    output [M_WIDTH_A-1:0] bank6_address,  // Byte address
    output [WIDTH_D-1:0] bank6_writedata,
    output bank6_read,
    output bank6_write,
    output [BURSTCOUNT_WIDTH-1:0] bank6_burstcount,
    output [BYTEENABLE_WIDTH-1:0] bank6_byteenable,
    input bank6_waitrequest,
    input [WIDTH_D-1:0] bank6_readdata,
    input bank6_readdatavalid,

    output [M_WIDTH_A-1:0] bank7_address,  // Byte address
    output [WIDTH_D-1:0] bank7_writedata,
    output bank7_read,
    output bank7_write,
    output [BURSTCOUNT_WIDTH-1:0] bank7_burstcount,
    output [BYTEENABLE_WIDTH-1:0] bank7_byteenable,
    input bank7_waitrequest,
    input [WIDTH_D-1:0] bank7_readdata,
    input bank7_readdatavalid,

    output [M_WIDTH_A-1:0] bank8_address,  // Byte address
    output [WIDTH_D-1:0] bank8_writedata,
    output bank8_read,
    output bank8_write,
    output [BURSTCOUNT_WIDTH-1:0] bank8_burstcount,
    output [BYTEENABLE_WIDTH-1:0] bank8_byteenable,
    input bank8_waitrequest,
    input [WIDTH_D-1:0] bank8_readdata,
    input bank8_readdatavalid

);


logic b_arb_request [NUM_BANKS];
logic b_arb_read [NUM_BANKS];
logic b_arb_write [NUM_BANKS];
logic [WIDTH_D-1:0] b_arb_writedata [NUM_BANKS];
logic [BURSTCOUNT_WIDTH-1:0] b_arb_burstcount [NUM_BANKS];
logic [S_WIDTH_A-1-1:0] b_arb_address [NUM_BANKS]; // Word addr
logic [BYTEENABLE_WIDTH-1:0] b_arb_byteenable [NUM_BANKS];
logic b_arb_stall [NUM_BANKS];
logic b_wrp_ack [NUM_BANKS];
logic b_rrp_datavalid [NUM_BANKS];
logic [WIDTH_D-1:0] b_rrp_data [NUM_BANKS];


reg [S_WIDTH_A-1:0] slave_address_transformed; // Word addr

generate
if (NUM_BANKS==1)
begin
  always@* slave_address_transformed = slave_address;
end
else
begin 
  logic [S_WIDTH_A-1:0] slave_address_swdimm; // Word addr
  logic [S_WIDTH_A-1:0] slave_address_burstinterleaved; // Word addr

  // Dynamically reconfigure here by selecting either swdimm or burst
  // interleaved address.  Normally the router handles the address
  // re-arranging but here we transform the address to have the bank select
  // bits as the MSBs, then we tell the router to look for them there.
  always@*
  begin
    if (mode)
      slave_address_transformed = slave_address_swdimm;
    else
      slave_address_transformed = slave_address_burstinterleaved;
  end

  acl_iface_address_to_bankaddress #(
    .ADDRESS_W( S_WIDTH_A ),
    .NUM_BANKS( NUM_BANKS ),
    .BANK_SEL_BIT( S_WIDTH_A - 1 - ($clog2(NUM_BANKS) - 1)))
    a2b_swdimm (
      .address(slave_address),
      .bank_sel_fe(slave_address_swdimm[S_WIDTH_A-1:S_WIDTH_A-$clog2(NUM_BANKS)]),
      .bank_address(slave_address_swdimm[S_WIDTH_A-$clog2(NUM_BANKS)-1:0]));

  acl_iface_address_to_bankaddress #(
    .ADDRESS_W( S_WIDTH_A ),
    .NUM_BANKS( NUM_BANKS ),
    .BANK_SEL_BIT( BURSTCOUNT_WIDTH-1))
    a2b_burst_interleaved (
      .address(slave_address),
      .bank_sel_fe(slave_address_burstinterleaved[S_WIDTH_A-1:S_WIDTH_A-$clog2(NUM_BANKS)]),
      .bank_address(slave_address_burstinterleaved[S_WIDTH_A-$clog2(NUM_BANKS)-1:0]));
end
endgenerate

assign bank1_read = b_arb_read[0] & b_arb_request[0];
assign bank1_write = b_arb_write[0] & b_arb_request[0];
assign bank1_writedata = b_arb_writedata[0];
assign bank1_burstcount = b_arb_burstcount[0];
assign bank1_address = {b_arb_address[0],{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
assign bank1_byteenable = b_arb_byteenable[0];
assign b_arb_stall[0] = bank1_waitrequest;
assign b_rrp_datavalid[0] = bank1_readdatavalid;
assign b_rrp_data[0] = bank1_readdata;

generate
if (NUM_BANKS>=2) begin
  assign bank2_read = b_arb_read[1] & b_arb_request[1];
  assign bank2_write = b_arb_write[1] & b_arb_request[1];
  assign bank2_writedata = b_arb_writedata[1];
  assign bank2_burstcount = b_arb_burstcount[1];
  assign bank2_address = {b_arb_address[1],{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
  assign bank2_byteenable = b_arb_byteenable[1];
  assign b_arb_stall[1] = bank2_waitrequest;
  assign b_rrp_datavalid[1] = bank2_readdatavalid;
  assign b_rrp_data[1] = bank2_readdata;     
end
endgenerate

generate
if (NUM_BANKS>=3) begin
  assign bank3_read = b_arb_read[2] & b_arb_request[2];
  assign bank3_write = b_arb_write[2] & b_arb_request[2];
  assign bank3_writedata = b_arb_writedata[2];
  assign bank3_burstcount = b_arb_burstcount[2];
  assign bank3_address = {b_arb_address[2],{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
  assign bank3_byteenable = b_arb_byteenable[2];
  assign b_arb_stall[2] = bank3_waitrequest;
  assign b_rrp_datavalid[2] = bank3_readdatavalid;
  assign b_rrp_data[2] = bank3_readdata;     
end
endgenerate

generate
if (NUM_BANKS>=4) begin
  assign bank4_read = b_arb_read[3] & b_arb_request[3];
  assign bank4_write = b_arb_write[3] & b_arb_request[3];
  assign bank4_writedata = b_arb_writedata[3];
  assign bank4_burstcount = b_arb_burstcount[3];
  assign bank4_address = {b_arb_address[3],{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
  assign bank4_byteenable = b_arb_byteenable[3];
  assign b_arb_stall[3] = bank4_waitrequest;
  assign b_rrp_datavalid[3] = bank4_readdatavalid;
  assign b_rrp_data[3] = bank4_readdata;     
end
endgenerate

generate
if (NUM_BANKS>=5) begin
  assign bank5_read = b_arb_read[4] & b_arb_request[4];
  assign bank5_write = b_arb_write[4] & b_arb_request[4];
  assign bank5_writedata = b_arb_writedata[4];
  assign bank5_burstcount = b_arb_burstcount[4];
  assign bank5_address = {b_arb_address[4],{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
  assign bank5_byteenable = b_arb_byteenable[4];
  assign b_arb_stall[4] = bank5_waitrequest;
  assign b_rrp_datavalid[4] = bank5_readdatavalid;
  assign b_rrp_data[4] = bank5_readdata;     
end
endgenerate

generate
if (NUM_BANKS>=6) begin
  assign bank6_read = b_arb_read[5] & b_arb_request[5];
  assign bank6_write = b_arb_write[5] & b_arb_request[5];
  assign bank6_writedata = b_arb_writedata[5];
  assign bank6_burstcount = b_arb_burstcount[5];
  assign bank6_address = {b_arb_address[5],{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
  assign bank6_byteenable = b_arb_byteenable[5];
  assign b_arb_stall[5] = bank6_waitrequest;
  assign b_rrp_datavalid[5] = bank6_readdatavalid;
  assign b_rrp_data[5] = bank6_readdata;     
end
endgenerate

generate
if (NUM_BANKS>=7) begin
  assign bank7_read = b_arb_read[6] & b_arb_request[6];
  assign bank7_write = b_arb_write[6] & b_arb_request[6];
  assign bank7_writedata = b_arb_writedata[6];
  assign bank7_burstcount = b_arb_burstcount[6];
  assign bank7_address = {b_arb_address[6],{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
  assign bank7_byteenable = b_arb_byteenable[6];
  assign b_arb_stall[6] = bank7_waitrequest;
  assign b_rrp_datavalid[6] = bank7_readdatavalid;
  assign b_rrp_data[6] = bank7_readdata;     
end
endgenerate

generate
if (NUM_BANKS>=8) begin
  assign bank8_read = b_arb_read[7] & b_arb_request[7];
  assign bank8_write = b_arb_write[7] & b_arb_request[7];
  assign bank8_writedata = b_arb_writedata[7];
  assign bank8_burstcount = b_arb_burstcount[7];
  assign bank8_address = {b_arb_address[7],{$clog2(WIDTH_D/8){1'b0}}}; //byteaddr
  assign bank8_byteenable = b_arb_byteenable[7];
  assign b_arb_stall[7] = bank8_waitrequest;
  assign b_rrp_datavalid[7] = bank8_readdatavalid;
  assign b_rrp_data[7] = bank8_readdata;     
end
endgenerate

mem_router_reorder #(
  .DATA_W(WIDTH_D),
  .BURSTCOUNT_W(BURSTCOUNT_WIDTH),
  .ADDRESS_W(S_WIDTH_A), // Warning: icm uses word address!
  .BYTEENA_W(BYTEENABLE_WIDTH),
  .NUM_BANKS(NUM_BANKS),
  .BANK_SEL_BIT(S_WIDTH_A-1-($clog2(NUM_BANKS)-1)), // MSBs choose bank
  .BANK_MAX_PENDING_READS(MAX_PENDING_READS),
  .BANK_MAX_PENDING_WRITES(1024))
  router (
    .clock(clk),
    .resetn(resetn),
    //.bank_select((2'b01<<slave_address_transformed[S_WIDTH_A-1])), // Not used
    .m_arb_request(slave_read | slave_write),
    .m_arb_read(slave_read),
    .m_arb_write(slave_write),
    .m_arb_writedata(slave_writedata),
    .m_arb_burstcount(slave_burstcount),
    .m_arb_address(slave_address_transformed),
    .m_arb_byteenable(slave_byteenable),
    .m_arb_stall(slave_waitrequest),
    .m_wrp_ack(),
    .m_rrp_datavalid(slave_readdatavalid),
    .m_rrp_data(slave_readdata),
    .b_arb_request (b_arb_request ),
    .b_arb_read (b_arb_read ),
    .b_arb_write (b_arb_write ),
    .b_arb_writedata (b_arb_writedata ),
    .b_arb_burstcount (b_arb_burstcount ),
    .b_arb_address (b_arb_address ),
    .b_arb_byteenable (b_arb_byteenable ),
    .b_arb_stall(b_arb_stall),
    .b_wrp_ack(b_wrp_ack),
    .b_rrp_datavalid(b_rrp_datavalid),
    .b_rrp_data(b_rrp_data)
  );

genvar b;
generate
  for (b=0; b<NUM_BANKS; b=b+1)
  begin : banks
    always@(posedge clk or negedge resetn)
      if (!resetn)
      begin
        b_wrp_ack[b] <= 1'b0;
      end
      else
      begin
        b_wrp_ack[b] <= b_arb_request[b] && b_arb_write[b] && !b_arb_stall[b];
      end
  end
endgenerate

endmodule

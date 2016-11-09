// (C) 1992-2012 Altera Corporation. All rights reserved.                         
// Your use of Altera Corporation's design tools, logic functions and other       
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Altera MegaCore Function License Agreement, or other applicable     
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Altera and sold by   
// Altera or its authorized distributors.  Please refer to the applicable         
// agreement for further details.                                                 
    


module acl_iface_address_to_bankaddress #(    
    parameter integer ADDRESS_W = 32,               // > 0
    parameter integer NUM_BANKS = 2,                // > 1
    parameter integer BANK_SEL_BIT = ADDRESS_W-$clog2(NUM_BANKS)
)
(
    input  logic [ADDRESS_W-1:0] address,
    output logic [NUM_BANKS-1:0] bank_sel_1hot,   // one-hot
    output logic [$clog2(NUM_BANKS)-1:0] bank_sel_fe,   // full encoded
    output logic [ADDRESS_W-$clog2(NUM_BANKS)-1:0] bank_address
);

integer i;

// To support NUM_BANKS=1 we need a wider address
logic [ADDRESS_W:0] wider_address;

assign wider_address = {1'b0,address};

always@*
begin
  for (i=0; i<NUM_BANKS; i=i+1)
    bank_sel_1hot[i] = (wider_address[BANK_SEL_BIT+$clog2(NUM_BANKS)-1 : BANK_SEL_BIT] == i);
end

always@*
begin
  bank_sel_fe = (wider_address>>BANK_SEL_BIT) & ~(64'b1<<$clog2(NUM_BANKS));
end

assign bank_address = ((address>>(BANK_SEL_BIT+$clog2(NUM_BANKS)))<<(BANK_SEL_BIT)) |
    address[BANK_SEL_BIT-1:0];

endmodule

// (C) 2001-2012 Altera Corporation. All rights reserved.
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


`timescale 1ps/1ps

module altera_pll_reconfig_top
#(
    parameter   reconf_width            = 64,
    parameter   device_family           = "Stratix V",
    parameter   RECONFIG_ADDR_WIDTH     = 6,
    parameter   RECONFIG_DATA_WIDTH     = 32,
    
	parameter   ROM_ADDR_WIDTH          = 9,
    parameter   ROM_DATA_WIDTH          = 32,
	parameter	ROM_NUM_WORDS           = 512,

    parameter   ENABLE_MIF              = 0,    
    parameter   MIF_FILE_NAME           = ""
) ( 

    //input
    input   wire    mgmt_clk,
    input   wire    mgmt_reset,


    //conduits
    output  wire [reconf_width-1:0] reconfig_to_pll,
    input  wire [reconf_width-1:0] reconfig_from_pll,

    // user data (avalon-MM slave interface)
    output  wire [31:0] mgmt_readdata,
    output  wire        mgmt_waitrequest,
    input   wire [5:0]  mgmt_address,
    input   wire        mgmt_read,
    input   wire        mgmt_write,
    input   wire [31:0] mgmt_writedata
);

localparam  MIF_ADDR_REG = 6'b011111;
localparam  START_REG = 6'b000010;

generate
if (ENABLE_MIF == 1)
begin:mif_reconfig // Generate Reconfig with MIF

    // MIF-related regs/wires
    reg [RECONFIG_ADDR_WIDTH-1:0]   reconfig_mgmt_addr;
    reg                             reconfig_mgmt_read;
    reg                             reconfig_mgmt_write;
    reg [RECONFIG_DATA_WIDTH-1:0]   reconfig_mgmt_writedata;
    wire                            reconfig_mgmt_waitrequest;
    wire [RECONFIG_DATA_WIDTH-1:0]   reconfig_mgmt_readdata;

    wire [RECONFIG_ADDR_WIDTH-1:0]   mif2reconfig_addr;
    wire										mif2reconfig_busy;
    wire                             mif2reconfig_read;
    wire                             mif2reconfig_write;
    wire [RECONFIG_DATA_WIDTH-1:0]   mif2reconfig_writedata;
    wire  [ROM_ADDR_WIDTH-1:0]        mif_base_addr;
    reg mif_select;
    reg user_start;

    wire reconfig2mif_start_out;

    assign mgmt_waitrequest = reconfig_mgmt_waitrequest | mif2reconfig_busy | user_start;
    // Don't output readdata if MIF streaming is taking place
    assign mgmt_readdata = (mif_select) ? 32'b0 : reconfig_mgmt_readdata;

    always @(posedge mgmt_clk)
    begin
        if (mgmt_reset)
        begin
            reconfig_mgmt_addr      <= 0;
            reconfig_mgmt_read      <= 0;
            reconfig_mgmt_write     <= 0;
            reconfig_mgmt_writedata <= 0;
            user_start              <= 0;
        end
        else
        begin
            reconfig_mgmt_addr      <= (mif_select) ? mif2reconfig_addr : mgmt_address;
            reconfig_mgmt_read      <= (mif_select) ? mif2reconfig_read : mgmt_read;
            reconfig_mgmt_write     <= (mif_select) ? mif2reconfig_write : mgmt_write;
            reconfig_mgmt_writedata <= (mif_select) ? mif2reconfig_writedata : mgmt_writedata;
            user_start              <= (mgmt_address == START_REG && mgmt_write == 1'b1) ? 1'b1 : 1'b0;
        end
    end

    always @(*)
    begin
        if (mgmt_reset)
        begin
            mif_select <= 0;
        end
        else 
        begin
            mif_select <= (reconfig2mif_start_out || mif2reconfig_busy) ? 1'b1 : 1'b0;
        end
    end

    altera_pll_reconfig_mif_reader 
    #(
        .RECONFIG_ADDR_WIDTH(RECONFIG_ADDR_WIDTH),
        .RECONFIG_DATA_WIDTH(RECONFIG_DATA_WIDTH),
        .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH),
        .ROM_DATA_WIDTH(ROM_DATA_WIDTH),
        .ROM_NUM_WORDS(ROM_NUM_WORDS),
        .DEVICE_FAMILY(device_family),
        .ENABLE_MIF(ENABLE_MIF),
        .MIF_FILE_NAME(MIF_FILE_NAME)
    ) altera_pll_reconfig_mif_reader_inst0 (
        .mif_clk(mgmt_clk),
        .mif_rst(mgmt_reset),
        
        //Altera_PLL Reconfig interface
        //inputs
        .reconfig_busy(reconfig_mgmt_waitrequest),
        .reconfig_read_data(reconfig_mgmt_readdata),
        //outputs
        .reconfig_write_data(mif2reconfig_writedata),
        .reconfig_addr(mif2reconfig_addr),
        .reconfig_write(mif2reconfig_write),
        .reconfig_read(mif2reconfig_read),

        //MIF Ctrl Interface
        //inputs
        .mif_base_addr(mif_base_addr),
        .mif_start(reconfig2mif_start_out),
        //outputs
        .mif_busy(mif2reconfig_busy)
    );

    // ------ END MIF-RELATED MANAGEMENT ------


    altera_pll_reconfig_core
    #(
        .reconf_width(reconf_width),
        .device_family(device_family),
        .RECONFIG_ADDR_WIDTH(RECONFIG_ADDR_WIDTH),
        .RECONFIG_DATA_WIDTH(RECONFIG_DATA_WIDTH),
        .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH),
        .ROM_DATA_WIDTH(ROM_DATA_WIDTH),
        .ROM_NUM_WORDS(ROM_NUM_WORDS)
    ) altera_pll_reconfig_core_inst0 (
        //inputs
        .mgmt_clk(mgmt_clk),
        .mgmt_reset(mgmt_reset),

        //PLL interface conduits
        .reconfig_to_pll(reconfig_to_pll),
        .reconfig_from_pll(reconfig_from_pll),

        //User data outputs
        .mgmt_readdata(reconfig_mgmt_readdata),
        .mgmt_waitrequest(reconfig_mgmt_waitrequest),
        
        //User data inputs
        .mgmt_address(reconfig_mgmt_addr),
        .mgmt_read(reconfig_mgmt_read),
        .mgmt_write(reconfig_mgmt_write),
        .mgmt_writedata(reconfig_mgmt_writedata),

        // other
        .mif_start_out(reconfig2mif_start_out),
        .mif_base_addr(mif_base_addr)
    );

end // End generate reconfig with MIF
else
begin:reconfig_core // Generate Reconfig core only

    wire reconfig2mif_start_out;
    wire  [ROM_ADDR_WIDTH-1:0]        mif_base_addr;

    altera_pll_reconfig_core
    #(
        .reconf_width(reconf_width),
        .device_family(device_family),
        .RECONFIG_ADDR_WIDTH(RECONFIG_ADDR_WIDTH),
        .RECONFIG_DATA_WIDTH(RECONFIG_DATA_WIDTH),
        .ROM_ADDR_WIDTH(ROM_ADDR_WIDTH),
        .ROM_DATA_WIDTH(ROM_DATA_WIDTH),
        .ROM_NUM_WORDS(ROM_NUM_WORDS)
    ) altera_pll_reconfig_core_inst0 (
        //inputs
        .mgmt_clk(mgmt_clk),
        .mgmt_reset(mgmt_reset),

        //PLL interface conduits
        .reconfig_to_pll(reconfig_to_pll),
        .reconfig_from_pll(reconfig_from_pll),

        //User data outputs
        .mgmt_readdata(mgmt_readdata),
        .mgmt_waitrequest(mgmt_waitrequest),
        
        //User data inputs
        .mgmt_address(mgmt_address),
        .mgmt_read(mgmt_read),
        .mgmt_write(mgmt_write),
        .mgmt_writedata(mgmt_writedata),

        // other
        .mif_start_out(reconfig2mif_start_out),
        .mif_base_addr(mif_base_addr)
    );

    
end // End generate reconfig core only
endgenerate

endmodule


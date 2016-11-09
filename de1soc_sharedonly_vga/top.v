`define ENABLE_HPS
module top(

     inout              ADC_CS_N,
      output             ADC_DIN,
      input              ADC_DOUT,
      output             ADC_SCLK,

      ///////// AUD /////////
      input              AUD_ADCDAT,
      inout              AUD_ADCLRCK,
      inout              AUD_BCLK,
      output             AUD_DACDAT,
      inout              AUD_DACLRCK,
      output             AUD_XCK,

      ///////// CLOCK2 /////////
      input              CLOCK2_50,

      ///////// CLOCK3 /////////
      input              CLOCK3_50,

      ///////// CLOCK4 /////////
      input              CLOCK4_50,

      ///////// CLOCK /////////
      input              CLOCK_50,

      ///////// DRAM /////////
      output      [12:0] DRAM_ADDR,
      output      [1:0]  DRAM_BA,
      output             DRAM_CAS_N,
      output             DRAM_CKE,
      output             DRAM_CLK,
      output             DRAM_CS_N,
      inout       [15:0] DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_RAS_N,
      output             DRAM_UDQM,
      output             DRAM_WE_N,

      ///////// FAN /////////
      output             FAN_CTRL,

      ///////// FPGA /////////
      output             FPGA_I2C_SCLK,
      inout              FPGA_I2C_SDAT,

      ///////// GPIO /////////
      inout     [35:0]         GPIO_0,
      inout     [35:0]         GPIO_1,
 

      ///////// HEX0 /////////
      output      [6:0]  HEX0,

      ///////// HEX1 /////////
      output      [6:0]  HEX1,

      ///////// HEX2 /////////
      output      [6:0]  HEX2,

      ///////// HEX3 /////////
      output      [6:0]  HEX3,

      ///////// HEX4 /////////
      output      [6:0]  HEX4,

      ///////// HEX5 /////////
      output      [6:0]  HEX5,

`ifdef ENABLE_HPS
      ///////// HPS /////////
      inout              HPS_CONV_USB_N,
      output      [14:0] HPS_DDR3_ADDR,
      output      [2:0]  HPS_DDR3_BA,
      output             HPS_DDR3_CAS_N,
      output             HPS_DDR3_CKE,
      output             HPS_DDR3_CK_N,
      output             HPS_DDR3_CK_P,
      output             HPS_DDR3_CS_N,
      output      [3:0]  HPS_DDR3_DM,
      inout       [31:0] HPS_DDR3_DQ,
      inout       [3:0]  HPS_DDR3_DQS_N,
      inout       [3:0]  HPS_DDR3_DQS_P,
      output             HPS_DDR3_ODT,
      output             HPS_DDR3_RAS_N,
      output             HPS_DDR3_RESET_N,
      input              HPS_DDR3_RZQ,
      output             HPS_DDR3_WE_N,
      output             HPS_ENET_TX_CLK,
      inout              HPS_ENET_INT_N,
      output             HPS_ENET_MDC,
      inout              HPS_ENET_MDIO,
      input              HPS_ENET_RX_CLK,
      input       [3:0]  HPS_ENET_RX_DATA,
      input              HPS_ENET_RX_DV,
      output      [3:0]  HPS_ENET_TX_DATA,
      output             HPS_ENET_TX_EN,
      inout       [3:0]  HPS_FLASH_DATA,
      output             HPS_FLASH_DCLK,
      output             HPS_FLASH_NCSO,
      inout              HPS_GSENSOR_INT,
      inout              HPS_I2C1_SCLK,
      inout              HPS_I2C1_SDAT,
      inout              HPS_I2C2_SCLK,
      inout              HPS_I2C2_SDAT,
      inout              HPS_I2C_CONTROL,
      inout              HPS_KEY,
      inout              HPS_LED,
      inout              HPS_LTC_GPIO,
      output             HPS_SD_CLK,
      inout              HPS_SD_CMD,
      inout       [3:0]  HPS_SD_DATA,
      output             HPS_SPIM_CLK,
      input              HPS_SPIM_MISO,
      output             HPS_SPIM_MOSI,
      inout              HPS_SPIM_SS,
      input              HPS_UART_RX,
      output             HPS_UART_TX,
      input              HPS_USB_CLKOUT,
      inout       [7:0]  HPS_USB_DATA,
      input              HPS_USB_DIR,
      input              HPS_USB_NXT,
      output             HPS_USB_STP,
`endif /*ENABLE_HPS*/

      ///////// IRDA /////////
      input              IRDA_RXD,
      output             IRDA_TXD,

      ///////// KEY /////////
      input       [3:0]  KEY,

      ///////// LEDR /////////
      output      [9:0]  LEDR,

      ///////// PS2 /////////
      inout              PS2_CLK,
      inout              PS2_CLK2,
      inout              PS2_DAT,
      inout              PS2_DAT2,

      ///////// SW /////////
      input       [9:0]  SW,

      ///////// TD /////////
      input              TD_CLK27,
      input      [7:0]  TD_DATA,
      input             TD_HS,
      output             TD_RESET_N,
      input             TD_VS,

      ///////// VGA /////////
      output      [7:0]  VGA_B,
      output             VGA_BLANK_N,
      output             VGA_CLK,
      output      [7:0]  VGA_G,
      output             VGA_HS,
      output      [7:0]  VGA_R,
      output             VGA_SYNC_N,
      output             VGA_VS
);
//=======================================================
//  REG/WIRE declarations
//=======================================================
// internal wires and registers declaration
wire  [1:0]  fpga_debounced_buttons;
wire  [3:0]  fpga_led_internal;
wire         hps_fpga_reset_n;
 
wire               clk_65;
wire [7:0]         vid_r,vid_g,vid_b;
wire               vid_v_sync ;
wire               vid_h_sync ;
wire               vid_datavalid;

  wire	[29:0]	fpga_internal_led;
  wire		      kernel_clk;
//=======================================================
//  Structural coding
//=======================================================      
assign   VGA_BLANK_N          =     1'b1;
assign   VGA_SYNC_N           =     1'b0;	
assign   VGA_CLK              =     clk_65;
assign  {VGA_B,VGA_G,VGA_R}   =     {vid_b,vid_g,vid_r};
assign   VGA_VS               =     vid_v_sync;
assign   VGA_HS               =     vid_h_sync;
  
// Debounce logic to clean out glitches within 1ms
debounce debounce_inst (
  .clk                                  (CLOCK3_50),
  .reset_n                              (hps_fpga_reset_n),  
  .data_in                              (KEY),
  .data_out                             (fpga_debounced_buttons)
);
 defparam debounce_inst.WIDTH = 2;
 defparam debounce_inst.POLARITY = "LOW";
 defparam debounce_inst.TIMEOUT = 50000;        // at 50Mhz this is a debounce time of 1ms
 defparam debounce_inst.TIMEOUT_WIDTH = 16;     // ceil(log2(TIMEOUT))

 
vga_pll  vga_pll_inst(
			.refclk(CLOCK4_50),   //  refclk.clk
		   .rst(1'b0),      //   reset.reset
		   .outclk_0(clk_65), // outclk0.clk
		   .locked()    //  locked.export
);
//=======================================================
//  Structural coding
//=======================================================

 system u0 (
	.clk_50_clk                                          (CLOCK_50),                                          //                                   clk_50.clk
	.reset_50_reset_n                                    (hps_fpga_reset_n),                                    //                                 reset_50.reset_n
	.kernel_clk_clk                                      (kernel_clk),                                      //                               kernel_clk.clk
	.acl_iface_hps_h2f_reset_reset_n                     (hps_fpga_reset_n),                      //                  acl_iface_hps_h2f_reset.reset_n
	.memory_mem_a                                        (HPS_DDR3_ADDR),                                        //                                   memory.mem_a
	.memory_mem_ba                                       (HPS_DDR3_BA),                                       //                                         .mem_ba
	.memory_mem_ck                                       (HPS_DDR3_CK_P),                                       //                                         .mem_ck
	.memory_mem_ck_n                                     (HPS_DDR3_CK_N),                                     //                                         .mem_ck_n
	.memory_mem_cke                                      (HPS_DDR3_CKE),                                      //                                         .mem_cke
	.memory_mem_cs_n                                     (HPS_DDR3_CS_N),                                     //                                         .mem_cs_n
	.memory_mem_ras_n                                    (HPS_DDR3_RAS_N),                                    //                                         .mem_ras_n
	.memory_mem_cas_n                                    (HPS_DDR3_CAS_N),                                    //                                         .mem_cas_n
	.memory_mem_we_n                                     (HPS_DDR3_WE_N),                                     //                                         .mem_we_n
	.memory_mem_reset_n                                  (HPS_DDR3_RESET_N),                                  //                                         .mem_reset_n
	.memory_mem_dq                                       (HPS_DDR3_DQ),                                       //                                         .mem_dq
	.memory_mem_dqs                                      (HPS_DDR3_DQS_P),                                      //                                         .mem_dqs
	.memory_mem_dqs_n                                    (HPS_DDR3_DQS_N),                                    //                                         .mem_dqs_n
	.memory_mem_odt                                      (HPS_DDR3_ODT),                                      //                                         .mem_odt
	.memory_mem_dm                                       (HPS_DDR3_DM),                                       //                                         .mem_dm
	.memory_oct_rzqin                                    (HPS_DDR3_RZQ),                                    //                                         .oct_rzqin
	.peripheral_hps_io_emac1_inst_TX_CLK                 (HPS_ENET_TX_CLK),                 //                               peripheral.hps_io_emac1_inst_TX_CLK
	.peripheral_hps_io_emac1_inst_TXD0                   (HPS_ENET_TX_DATA[0]),                   //                                         .hps_io_emac1_inst_TXD0
	.peripheral_hps_io_emac1_inst_TXD1                   (HPS_ENET_TX_DATA[1]),                   //                                         .hps_io_emac1_inst_TXD1
	.peripheral_hps_io_emac1_inst_TXD2                   (HPS_ENET_TX_DATA[2]),                   //                                         .hps_io_emac1_inst_TXD2
	.peripheral_hps_io_emac1_inst_TXD3                   (HPS_ENET_TX_DATA[3]),                   //                                         .hps_io_emac1_inst_TXD3
	.peripheral_hps_io_emac1_inst_RXD0                   (HPS_ENET_RX_DATA[0]),                   //                                         .hps_io_emac1_inst_RXD0
	.peripheral_hps_io_emac1_inst_MDIO                   (HPS_ENET_MDIO),                   //                                         .hps_io_emac1_inst_MDIO
	.peripheral_hps_io_emac1_inst_MDC                    (HPS_ENET_MDC),                    //                                         .hps_io_emac1_inst_MDC
	.peripheral_hps_io_emac1_inst_RX_CTL                 (HPS_ENET_RX_DV),                 //                                         .hps_io_emac1_inst_RX_CTL
	.peripheral_hps_io_emac1_inst_TX_CTL                 (HPS_ENET_TX_EN),                 //                                         .hps_io_emac1_inst_TX_CTL
	.peripheral_hps_io_emac1_inst_RX_CLK                 (HPS_ENET_RX_CLK),                 //                                         .hps_io_emac1_inst_RX_CLK
	.peripheral_hps_io_emac1_inst_RXD1                   (HPS_ENET_RX_DATA[1]),                   //                                         .hps_io_emac1_inst_RXD1
	.peripheral_hps_io_emac1_inst_RXD2                   (HPS_ENET_RX_DATA[2]),                   //                                         .hps_io_emac1_inst_RXD2
	.peripheral_hps_io_emac1_inst_RXD3                   (HPS_ENET_RX_DATA[3]),                   //                                         .hps_io_emac1_inst_RXD3
	.peripheral_hps_io_qspi_inst_IO0                     (HPS_FLASH_DATA[0]),                     //                                         .hps_io_qspi_inst_IO0
	.peripheral_hps_io_qspi_inst_IO1                     (HPS_FLASH_DATA[1]),                     //                                         .hps_io_qspi_inst_IO1
	.peripheral_hps_io_qspi_inst_IO2                     (HPS_FLASH_DATA[2]),                     //                                         .hps_io_qspi_inst_IO2
	.peripheral_hps_io_qspi_inst_IO3                     (HPS_FLASH_DATA[3]),                     //                                         .hps_io_qspi_inst_IO3
	.peripheral_hps_io_qspi_inst_SS0                     (HPS_FLASH_NCSO),                     //                                         .hps_io_qspi_inst_SS0
	.peripheral_hps_io_qspi_inst_CLK                     (HPS_FLASH_DCLK),                     //                                         .hps_io_qspi_inst_CLK
	//sd
	.peripheral_hps_io_sdio_inst_CMD                     (HPS_SD_CMD),                     //                                         .hps_io_sdio_inst_CMD
	.peripheral_hps_io_sdio_inst_D0                      (HPS_SD_DATA[0]),                      //                                         .hps_io_sdio_inst_D0
	.peripheral_hps_io_sdio_inst_D1                      (HPS_SD_DATA[1]),                      //                                         .hps_io_sdio_inst_D1
	.peripheral_hps_io_sdio_inst_CLK                     (HPS_SD_CLK),                     //                                         .hps_io_sdio_inst_CLK
	.peripheral_hps_io_sdio_inst_D2                      (HPS_SD_DATA[2]),                      //                                         .hps_io_sdio_inst_D2
	.peripheral_hps_io_sdio_inst_D3                      (HPS_SD_DATA[3]),                      //                                         .hps_io_sdio_inst_D3
	//usb
	.peripheral_hps_io_usb1_inst_D0                      (HPS_USB_DATA[0]),                      //                                         .hps_io_usb1_inst_D0
	.peripheral_hps_io_usb1_inst_D1                      (HPS_USB_DATA[1]),                      //                                         .hps_io_usb1_inst_D1
	.peripheral_hps_io_usb1_inst_D2                      (HPS_USB_DATA[2]),                      //                                         .hps_io_usb1_inst_D2
	.peripheral_hps_io_usb1_inst_D3                      (HPS_USB_DATA[3]),                      //                                         .hps_io_usb1_inst_D3
	.peripheral_hps_io_usb1_inst_D4                      (HPS_USB_DATA[4] ),                      //                                         .hps_io_usb1_inst_D4
	.peripheral_hps_io_usb1_inst_D5                      (HPS_USB_DATA[5]),                      //                                         .hps_io_usb1_inst_D5
	.peripheral_hps_io_usb1_inst_D6                      (HPS_USB_DATA[6]),                      //                                         .hps_io_usb1_inst_D6
	.peripheral_hps_io_usb1_inst_D7                      (HPS_USB_DATA[7]),                      //                                         .hps_io_usb1_inst_D7
	.peripheral_hps_io_usb1_inst_CLK                     (HPS_USB_CLKOUT),                     //                                         .hps_io_usb1_inst_CLK
	.peripheral_hps_io_usb1_inst_STP                     (HPS_USB_STP),                     //                                         .hps_io_usb1_inst_STP
	.peripheral_hps_io_usb1_inst_DIR                     (HPS_USB_DIR),                     //                                         .hps_io_usb1_inst_DIR
	.peripheral_hps_io_usb1_inst_NXT                     (HPS_USB_NXT),                     //                                         .hps_io_usb1_inst_NXT


	.peripheral_hps_io_spim1_inst_CLK                    (HPS_SPIM_CLK),                    //                                         .hps_io_spim1_inst_CLK
	.peripheral_hps_io_spim1_inst_MOSI                   (HPS_SPIM_MOSI),                   //                                         .hps_io_spim1_inst_MOSI
	.peripheral_hps_io_spim1_inst_MISO                   (HPS_SPIM_MISO),                   //                                         .hps_io_spim1_inst_MISO
	.peripheral_hps_io_spim1_inst_SS0                    (HPS_SPIM_SS),                    //                                         .hps_io_spim1_inst_SS0
	.peripheral_hps_io_uart0_inst_RX                     (HPS_UART_RX),                     //                                         .hps_io_uart0_inst_RX
	.peripheral_hps_io_uart0_inst_TX                     (HPS_UART_TX),                     //                                         .hps_io_uart0_inst_TX
	.peripheral_hps_io_i2c1_inst_SDA                     (HPS_I2C2_SDAT),                     //                                         .hps_io_i2c1_inst_SDA
	.peripheral_hps_io_i2c1_inst_SCL                     (HPS_I2C2_SCLK),                     //                                         .hps_io_i2c1_inst_SCL

	.peripheral_hps_io_gpio_inst_GPIO53                  (HPS_LED),                  //                                         .hps_io_gpio_inst_GPIO53

	.acl_iface_led_pio_external_connection_export    (LEDR),        //    led_pio_external_connection.export
	.acl_iface_dipsw_pio_external_connection_export  (SW),  //  dipsw_pio_external_connection.export
	.acl_iface_button_pio_external_connection_export ( fpga_debounced_buttons ), // button_pio_external_connection.export

			  
	//itc
	.acl_iface_alt_vip_itc_0_clocked_video_vid_clk         (~clk_65),         					 	 // alt_vip_itc_0_clocked_video.vid_clk
	.acl_iface_alt_vip_itc_0_clocked_video_vid_data        ({vid_r,vid_g,vid_b}),        		 //                .vid_data
	.acl_iface_alt_vip_itc_0_clocked_video_underflow       (),                           		 //                .underflow
	.acl_iface_alt_vip_itc_0_clocked_video_vid_datavalid   (vid_datavalid),                   //                .vid_datavalid
	.acl_iface_alt_vip_itc_0_clocked_video_vid_v_sync      (vid_v_sync),      					 //                .vid_v_sync
	.acl_iface_alt_vip_itc_0_clocked_video_vid_h_sync      (vid_h_sync),      					 //                .vid_h_sync
	.acl_iface_alt_vip_itc_0_clocked_video_vid_f           (),           							 //                .vid_f
	.acl_iface_alt_vip_itc_0_clocked_video_vid_h           (),           							 //                .vid_h
	.acl_iface_alt_vip_itc_0_clocked_video_vid_v           (),  

);
	
  // module for visualizing the kernel clock with 4 LEDs
  async_counter_30 AC30 (
        .clk 	(kernel_clk),
        .count	(fpga_internal_led)
    );
  assign HEX0[3:0] = ~fpga_internal_led[29:26];  

endmodule



module async_counter_30(clk, count);
  input			clk;
  output 	[29:0]	count;
  reg		[14:0] 	count_a;
  reg           [14:0]  count_b;  

  initial count_a = 15'b0;
  initial count_b = 15'b0;

always @(negedge clk)
	count_a <= count_a + 1'b1;

always @(negedge count_a[14])
	count_b <= count_b + 1'b1;

assign count = {count_b, count_a};

endmodule




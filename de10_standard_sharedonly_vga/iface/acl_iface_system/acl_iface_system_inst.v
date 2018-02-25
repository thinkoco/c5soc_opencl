	acl_iface_system u0 (
		.config_clk_clk                      (<connected-to-config_clk_clk>),                      //       config_clk.clk
		.reset_n                             (<connected-to-reset_n>),                             //     global_reset.reset_n
		.kernel_clk_clk                      (<connected-to-kernel_clk_clk>),                      //       kernel_clk.clk
		.kernel_clk_snoop_clk                (<connected-to-kernel_clk_snoop_clk>),                // kernel_clk_snoop.clk
		.kernel_mem0_waitrequest             (<connected-to-kernel_mem0_waitrequest>),             //      kernel_mem0.waitrequest
		.kernel_mem0_readdata                (<connected-to-kernel_mem0_readdata>),                //                 .readdata
		.kernel_mem0_readdatavalid           (<connected-to-kernel_mem0_readdatavalid>),           //                 .readdatavalid
		.kernel_mem0_burstcount              (<connected-to-kernel_mem0_burstcount>),              //                 .burstcount
		.kernel_mem0_writedata               (<connected-to-kernel_mem0_writedata>),               //                 .writedata
		.kernel_mem0_address                 (<connected-to-kernel_mem0_address>),                 //                 .address
		.kernel_mem0_write                   (<connected-to-kernel_mem0_write>),                   //                 .write
		.kernel_mem0_read                    (<connected-to-kernel_mem0_read>),                    //                 .read
		.kernel_mem0_byteenable              (<connected-to-kernel_mem0_byteenable>),              //                 .byteenable
		.kernel_mem0_debugaccess             (<connected-to-kernel_mem0_debugaccess>),             //                 .debugaccess
		.kernel_reset_reset_n                (<connected-to-kernel_reset_reset_n>),                //     kernel_reset.reset_n
		.memory_mem_a                        (<connected-to-memory_mem_a>),                        //           memory.mem_a
		.memory_mem_ba                       (<connected-to-memory_mem_ba>),                       //                 .mem_ba
		.memory_mem_ck                       (<connected-to-memory_mem_ck>),                       //                 .mem_ck
		.memory_mem_ck_n                     (<connected-to-memory_mem_ck_n>),                     //                 .mem_ck_n
		.memory_mem_cke                      (<connected-to-memory_mem_cke>),                      //                 .mem_cke
		.memory_mem_cs_n                     (<connected-to-memory_mem_cs_n>),                     //                 .mem_cs_n
		.memory_mem_ras_n                    (<connected-to-memory_mem_ras_n>),                    //                 .mem_ras_n
		.memory_mem_cas_n                    (<connected-to-memory_mem_cas_n>),                    //                 .mem_cas_n
		.memory_mem_we_n                     (<connected-to-memory_mem_we_n>),                     //                 .mem_we_n
		.memory_mem_reset_n                  (<connected-to-memory_mem_reset_n>),                  //                 .mem_reset_n
		.memory_mem_dq                       (<connected-to-memory_mem_dq>),                       //                 .mem_dq
		.memory_mem_dqs                      (<connected-to-memory_mem_dqs>),                      //                 .mem_dqs
		.memory_mem_dqs_n                    (<connected-to-memory_mem_dqs_n>),                    //                 .mem_dqs_n
		.memory_mem_odt                      (<connected-to-memory_mem_odt>),                      //                 .mem_odt
		.memory_mem_dm                       (<connected-to-memory_mem_dm>),                       //                 .mem_dm
		.memory_oct_rzqin                    (<connected-to-memory_oct_rzqin>),                    //                 .oct_rzqin
		.peripheral_hps_io_emac1_inst_TX_CLK (<connected-to-peripheral_hps_io_emac1_inst_TX_CLK>), //       peripheral.hps_io_emac1_inst_TX_CLK
		.peripheral_hps_io_emac1_inst_TXD0   (<connected-to-peripheral_hps_io_emac1_inst_TXD0>),   //                 .hps_io_emac1_inst_TXD0
		.peripheral_hps_io_emac1_inst_TXD1   (<connected-to-peripheral_hps_io_emac1_inst_TXD1>),   //                 .hps_io_emac1_inst_TXD1
		.peripheral_hps_io_emac1_inst_TXD2   (<connected-to-peripheral_hps_io_emac1_inst_TXD2>),   //                 .hps_io_emac1_inst_TXD2
		.peripheral_hps_io_emac1_inst_TXD3   (<connected-to-peripheral_hps_io_emac1_inst_TXD3>),   //                 .hps_io_emac1_inst_TXD3
		.peripheral_hps_io_emac1_inst_RXD0   (<connected-to-peripheral_hps_io_emac1_inst_RXD0>),   //                 .hps_io_emac1_inst_RXD0
		.peripheral_hps_io_emac1_inst_MDIO   (<connected-to-peripheral_hps_io_emac1_inst_MDIO>),   //                 .hps_io_emac1_inst_MDIO
		.peripheral_hps_io_emac1_inst_MDC    (<connected-to-peripheral_hps_io_emac1_inst_MDC>),    //                 .hps_io_emac1_inst_MDC
		.peripheral_hps_io_emac1_inst_RX_CTL (<connected-to-peripheral_hps_io_emac1_inst_RX_CTL>), //                 .hps_io_emac1_inst_RX_CTL
		.peripheral_hps_io_emac1_inst_TX_CTL (<connected-to-peripheral_hps_io_emac1_inst_TX_CTL>), //                 .hps_io_emac1_inst_TX_CTL
		.peripheral_hps_io_emac1_inst_RX_CLK (<connected-to-peripheral_hps_io_emac1_inst_RX_CLK>), //                 .hps_io_emac1_inst_RX_CLK
		.peripheral_hps_io_emac1_inst_RXD1   (<connected-to-peripheral_hps_io_emac1_inst_RXD1>),   //                 .hps_io_emac1_inst_RXD1
		.peripheral_hps_io_emac1_inst_RXD2   (<connected-to-peripheral_hps_io_emac1_inst_RXD2>),   //                 .hps_io_emac1_inst_RXD2
		.peripheral_hps_io_emac1_inst_RXD3   (<connected-to-peripheral_hps_io_emac1_inst_RXD3>),   //                 .hps_io_emac1_inst_RXD3
		.peripheral_hps_io_sdio_inst_CMD     (<connected-to-peripheral_hps_io_sdio_inst_CMD>),     //                 .hps_io_sdio_inst_CMD
		.peripheral_hps_io_sdio_inst_D0      (<connected-to-peripheral_hps_io_sdio_inst_D0>),      //                 .hps_io_sdio_inst_D0
		.peripheral_hps_io_sdio_inst_D1      (<connected-to-peripheral_hps_io_sdio_inst_D1>),      //                 .hps_io_sdio_inst_D1
		.peripheral_hps_io_sdio_inst_CLK     (<connected-to-peripheral_hps_io_sdio_inst_CLK>),     //                 .hps_io_sdio_inst_CLK
		.peripheral_hps_io_sdio_inst_D2      (<connected-to-peripheral_hps_io_sdio_inst_D2>),      //                 .hps_io_sdio_inst_D2
		.peripheral_hps_io_sdio_inst_D3      (<connected-to-peripheral_hps_io_sdio_inst_D3>),      //                 .hps_io_sdio_inst_D3
		.peripheral_hps_io_usb1_inst_D0      (<connected-to-peripheral_hps_io_usb1_inst_D0>),      //                 .hps_io_usb1_inst_D0
		.peripheral_hps_io_usb1_inst_D1      (<connected-to-peripheral_hps_io_usb1_inst_D1>),      //                 .hps_io_usb1_inst_D1
		.peripheral_hps_io_usb1_inst_D2      (<connected-to-peripheral_hps_io_usb1_inst_D2>),      //                 .hps_io_usb1_inst_D2
		.peripheral_hps_io_usb1_inst_D3      (<connected-to-peripheral_hps_io_usb1_inst_D3>),      //                 .hps_io_usb1_inst_D3
		.peripheral_hps_io_usb1_inst_D4      (<connected-to-peripheral_hps_io_usb1_inst_D4>),      //                 .hps_io_usb1_inst_D4
		.peripheral_hps_io_usb1_inst_D5      (<connected-to-peripheral_hps_io_usb1_inst_D5>),      //                 .hps_io_usb1_inst_D5
		.peripheral_hps_io_usb1_inst_D6      (<connected-to-peripheral_hps_io_usb1_inst_D6>),      //                 .hps_io_usb1_inst_D6
		.peripheral_hps_io_usb1_inst_D7      (<connected-to-peripheral_hps_io_usb1_inst_D7>),      //                 .hps_io_usb1_inst_D7
		.peripheral_hps_io_usb1_inst_CLK     (<connected-to-peripheral_hps_io_usb1_inst_CLK>),     //                 .hps_io_usb1_inst_CLK
		.peripheral_hps_io_usb1_inst_STP     (<connected-to-peripheral_hps_io_usb1_inst_STP>),     //                 .hps_io_usb1_inst_STP
		.peripheral_hps_io_usb1_inst_DIR     (<connected-to-peripheral_hps_io_usb1_inst_DIR>),     //                 .hps_io_usb1_inst_DIR
		.peripheral_hps_io_usb1_inst_NXT     (<connected-to-peripheral_hps_io_usb1_inst_NXT>),     //                 .hps_io_usb1_inst_NXT
		.peripheral_hps_io_uart0_inst_RX     (<connected-to-peripheral_hps_io_uart0_inst_RX>),     //                 .hps_io_uart0_inst_RX
		.peripheral_hps_io_uart0_inst_TX     (<connected-to-peripheral_hps_io_uart0_inst_TX>),     //                 .hps_io_uart0_inst_TX
		.peripheral_hps_io_i2c1_inst_SDA     (<connected-to-peripheral_hps_io_i2c1_inst_SDA>),     //                 .hps_io_i2c1_inst_SDA
		.peripheral_hps_io_i2c1_inst_SCL     (<connected-to-peripheral_hps_io_i2c1_inst_SCL>),     //                 .hps_io_i2c1_inst_SCL
		.peripheral_hps_io_gpio_inst_GPIO53  (<connected-to-peripheral_hps_io_gpio_inst_GPIO53>)   //                 .hps_io_gpio_inst_GPIO53
	);

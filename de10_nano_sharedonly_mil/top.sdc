# (C) 1992-2018 Intel Corporation.                            
# Intel, the Intel logo, Intel, MegaCore, NIOS II, Quartus and TalkBack words    
# and logos are trademarks of Intel Corporation or its subsidiaries in the U.S.  
# and/or other countries. Other marks and brands may be claimed as the property  
# of others. See Trademarks on intel.com for full list of Intel trademarks or    
# the Trademarks & Brands Names Database (if Intel) or See www.Intel.com/legal (if Altera) 
# Your use of Intel Corporation's design tools, logic functions and other        
# software and tools, and its AMPP partner logic functions, and any output       
# files any of the foregoing (including device programming or simulation         
# files), and any associated documentation or information are expressly subject  
# to the terms and conditions of the Altera Program License Subscription         
# Agreement, Intel MegaCore Function License Agreement, or other applicable      
# license agreement, including, without limitation, that your use is for the     
# sole purpose of programming logic devices manufactured by Intel and sold by    
# Intel or its authorized distributors.  Please refer to the applicable          
# agreement for further details.                                                 

# 50MHz board input clock
create_clock -period 20 [get_ports fpga_clk_50]

# for enhancing USB BlasterII to be reliable, 25MHz
create_clock -name {altera_reserved_tck} -period 40 {altera_reserved_tck}
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdi]
set_input_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tms]
set_output_delay -clock altera_reserved_tck -clock_fall 3 [get_ports altera_reserved_tdo]

# for I2C
create_clock -name {i2c_scl} -period 300 {i2c_scl}

# FPGA IO port constraints
set_false_path -from [get_ports {fpga_button_pio[0]}] -to *
set_false_path -from [get_ports {fpga_button_pio[1]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[0]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[1]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[2]}] -to *
set_false_path -from [get_ports {fpga_dipsw_pio[3]}] -to *
set_false_path -from * -to [get_ports {fpga_led_pio[0]}]
set_false_path -from * -to [get_ports {fpga_led_pio[1]}]
set_false_path -from * -to [get_ports {fpga_led_pio[2]}]
set_false_path -from * -to [get_ports {fpga_led_pio[3]}]

# HPS peripherals port false path setting to workaround the unconstraint path (setting false_path for hps_0 ports will not affect the routing as it is hard silicon)
set_false_path -from * -to [get_ports {hps_emac1_TX_CLK}] 
set_false_path -from * -to [get_ports {hps_emac1_TXD0}] 
set_false_path -from * -to [get_ports {hps_emac1_TXD1}] 
set_false_path -from * -to [get_ports {hps_emac1_TXD2}] 
set_false_path -from * -to [get_ports {hps_emac1_TXD3}] 
set_false_path -from * -to [get_ports {hps_emac1_MDC}] 
set_false_path -from * -to [get_ports {hps_emac1_TX_CTL}] 
set_false_path -from * -to [get_ports {hps_qspi_SS0}] 
set_false_path -from * -to [get_ports {hps_qspi_CLK}] 
set_false_path -from * -to [get_ports {hps_sdio_CLK}] 
set_false_path -from * -to [get_ports {hps_usb1_STP}] 
set_false_path -from * -to [get_ports {hps_spim0_CLK}] 
set_false_path -from * -to [get_ports {hps_spim0_MOSI}] 
set_false_path -from * -to [get_ports {hps_spim0_SS0}] 
set_false_path -from * -to [get_ports {hps_uart0_TX}] 
set_false_path -from * -to [get_ports {hps_can0_TX}] 
set_false_path -from * -to [get_ports {hps_trace_CLK}] 
set_false_path -from * -to [get_ports {hps_trace_D0}] 
set_false_path -from * -to [get_ports {hps_trace_D1}] 
set_false_path -from * -to [get_ports {hps_trace_D2}] 
set_false_path -from * -to [get_ports {hps_trace_D3}] 
set_false_path -from * -to [get_ports {hps_trace_D4}] 
set_false_path -from * -to [get_ports {hps_trace_D5}] 
set_false_path -from * -to [get_ports {hps_trace_D6}] 
set_false_path -from * -to [get_ports {hps_trace_D7}] 

set_false_path -from * -to [get_ports {hps_emac1_MDIO}] 
set_false_path -from * -to [get_ports {hps_qspi_IO0}] 
set_false_path -from * -to [get_ports {hps_qspi_IO1}] 
set_false_path -from * -to [get_ports {hps_qspi_IO2}] 
set_false_path -from * -to [get_ports {hps_qspi_IO3}] 
set_false_path -from * -to [get_ports {hps_sdio_CMD}] 
set_false_path -from * -to [get_ports {hps_sdio_D0}] 
set_false_path -from * -to [get_ports {hps_sdio_D1}] 
set_false_path -from * -to [get_ports {hps_sdio_D2}] 
set_false_path -from * -to [get_ports {hps_sdio_D3}] 
set_false_path -from * -to [get_ports {hps_usb1_D0}] 
set_false_path -from * -to [get_ports {hps_usb1_D1}] 
set_false_path -from * -to [get_ports {hps_usb1_D2}] 
set_false_path -from * -to [get_ports {hps_usb1_D3}] 
set_false_path -from * -to [get_ports {hps_usb1_D4}] 
set_false_path -from * -to [get_ports {hps_usb1_D5}] 
set_false_path -from * -to [get_ports {hps_usb1_D6}] 
set_false_path -from * -to [get_ports {hps_usb1_D7}] 
set_false_path -from * -to [get_ports {hps_i2c0_SDA}] 
set_false_path -from * -to [get_ports {hps_i2c0_SCL}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO09}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO35}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO41}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO42}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO43}] 
set_false_path -from * -to [get_ports {hps_gpio_GPIO44}] 

set_false_path -from [get_ports {hps_emac1_MDIO}] -to *
set_false_path -from [get_ports {hps_qspi_IO0}] -to *
set_false_path -from [get_ports {hps_qspi_IO1}] -to *
set_false_path -from [get_ports {hps_qspi_IO2}] -to *
set_false_path -from [get_ports {hps_qspi_IO3}] -to *
set_false_path -from [get_ports {hps_sdio_CMD}] -to *
set_false_path -from [get_ports {hps_sdio_D0}] -to *
set_false_path -from [get_ports {hps_sdio_D1}] -to *
set_false_path -from [get_ports {hps_sdio_D2}] -to *
set_false_path -from [get_ports {hps_sdio_D3}] -to *
set_false_path -from [get_ports {hps_usb1_D0}] -to *
set_false_path -from [get_ports {hps_usb1_D1}] -to *
set_false_path -from [get_ports {hps_usb1_D2}] -to *
set_false_path -from [get_ports {hps_usb1_D3}] -to *
set_false_path -from [get_ports {hps_usb1_D4}] -to *
set_false_path -from [get_ports {hps_usb1_D5}] -to *
set_false_path -from [get_ports {hps_usb1_D6}] -to *
set_false_path -from [get_ports {hps_usb1_D7}] -to *
set_false_path -from [get_ports {hps_i2c0_SDA}] -to *
set_false_path -from [get_ports {hps_i2c0_SCL}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO09}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO35}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO41}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO42}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO43}] -to *
set_false_path -from [get_ports {hps_gpio_GPIO44}] -to *

set_false_path -from [get_ports {hps_usb1_CLK}] -to *
set_false_path -from [get_ports {hps_usb1_DIR}] -to *
set_false_path -from [get_ports {hps_usb1_NXT}] -to *
set_false_path -from [get_ports {hps_spim0_MISO}] -to *
set_false_path -from [get_ports {hps_uart0_RX}] -to *
set_false_path -from [get_ports {hps_can0_RX}] -to *

set_false_path -from [get_ports {emac_mdio}] -to *
set_false_path -from [get_ports {emac_rx_clk}] -to *
set_false_path -from [get_ports {emac_rx_ctl}] -to *
set_false_path -from [get_ports {emac_rxd[0]}] -to *
set_false_path -from [get_ports {emac_rxd[1]}] -to *
set_false_path -from [get_ports {emac_rxd[2]}] -to *
set_false_path -from [get_ports {emac_rxd[3]}] -to *
set_false_path -from [get_ports {i2c_sda}] -to *
set_false_path -from [get_ports {led[0]}] -to *
set_false_path -from [get_ports {led[1]}] -to *
set_false_path -from [get_ports {led[2]}] -to *
set_false_path -from [get_ports {led[3]}] -to *
set_false_path -from [get_ports {sd_cmd}] -to *
set_false_path -from [get_ports {sd_d[0]}] -to *
set_false_path -from [get_ports {sd_d[1]}] -to *
set_false_path -from [get_ports {sd_d[2]}] -to *
set_false_path -from [get_ports {sd_d[3]}] -to *
set_false_path -from [get_ports {uart_rx}] -to *

set_false_path -from * -to [get_ports {emac_mdc}] 
set_false_path -from * -to [get_ports {emac_mdio}]
set_false_path -from * -to [get_ports {emac_tx_clk}]
set_false_path -from * -to [get_ports {emac_tx_ctl}]
set_false_path -from * -to [get_ports {emac_txd[0]}]
set_false_path -from * -to [get_ports {emac_txd[1]}]
set_false_path -from * -to [get_ports {emac_txd[2]}]
set_false_path -from * -to [get_ports {emac_txd[3]}]
set_false_path -from * -to [get_ports {led[0]}]
set_false_path -from * -to [get_ports {led[1]}]
set_false_path -from * -to [get_ports {led[2]}]
set_false_path -from * -to [get_ports {led[3]}]
set_false_path -from * -to [get_ports {sd_clk}]
set_false_path -from * -to [get_ports {sd_cmd}]
set_false_path -from * -to [get_ports {sd_d[0]}]
set_false_path -from * -to [get_ports {sd_d[1]}]
set_false_path -from * -to [get_ports {sd_d[2]}]
set_false_path -from * -to [get_ports {sd_d[3]}]
set_false_path -from * -to [get_ports {uart_tx}]

# Qsys will synchronize the reset input
set_false_path -from [get_ports fpga_reset_n] -to *

# LED switching will be slow
set_false_path -from * -to [get_ports fpga_led_output[*]]
set_false_path -from {async_counter_30:AC30|count_a[14]} -to *
set_false_path -from {system:the_system|system_acl_iface:acl_iface|system_acl_iface_acl_kernel_clk:acl_kernel_clk|timer:counter|counter2x_a[15]} -to *
set_false_path -from {system:the_system|system_acl_iface:acl_iface|system_acl_iface_acl_kernel_clk:acl_kernel_clk|timer:counter|counter_a[15]} -to *

# fix for stability of FPGA DDR accesses
if {$::quartus(nameofexecutable) == "quartus_fit"} {
  set_min_delay -from system:the_system|system_fpga_sdram:fpga_sdram|altera_mem_if_hard_memory_controller_top_cyclonev:c0|hmc_inst~FF_* 0.5
  set_min_delay -to system:the_system|system_fpga_sdram:fpga_sdram|altera_mem_if_hard_memory_controller_top_cyclonev:c0|hmc_inst~FF_* 1.0
}

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks

#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty


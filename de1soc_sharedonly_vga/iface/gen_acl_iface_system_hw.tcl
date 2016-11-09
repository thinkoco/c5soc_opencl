package require -exact qsys 12.1

# module properties
set_module_property NAME {acl_iface_system_export}
set_module_property DISPLAY_NAME {acl_iface_system_export_display}

# default module properties
set_module_property VERSION {1.0}
set_module_property GROUP {default group}
set_module_property DESCRIPTION {default description}
set_module_property AUTHOR {author}

# Instances and instance parameters
# (disabled instances are intentionally culled)
add_instance global_reset altera_reset_bridge 12.1
set_instance_parameter_value global_reset ACTIVE_LOW_RESET {1}
set_instance_parameter_value global_reset SYNCHRONOUS_EDGES {none}
set_instance_parameter_value global_reset NUM_RESET_OUTPUTS {1}

add_instance pipe_stage_ddr3b_dimm altera_avalon_mm_bridge 12.1
set_instance_parameter_value pipe_stage_ddr3b_dimm DATA_WIDTH {512}
set_instance_parameter_value pipe_stage_ddr3b_dimm SYMBOL_WIDTH {8}
set_instance_parameter_value pipe_stage_ddr3b_dimm ADDRESS_WIDTH {30}
set_instance_parameter_value pipe_stage_ddr3b_dimm ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value pipe_stage_ddr3b_dimm MAX_BURST_SIZE {16}
set_instance_parameter_value pipe_stage_ddr3b_dimm MAX_PENDING_RESPONSES {32}
set_instance_parameter_value pipe_stage_ddr3b_dimm LINEWRAPBURSTS {0}
set_instance_parameter_value pipe_stage_ddr3b_dimm PIPELINE_COMMAND {0}
set_instance_parameter_value pipe_stage_ddr3b_dimm PIPELINE_RESPONSE {0}

add_instance pcie altera_pcie_sv_hip_avmm 12.1
set_instance_parameter_value pcie pcie_qsys {1}
set_instance_parameter_value pcie lane_mask_hwtcl {x4}
set_instance_parameter_value pcie gen123_lane_rate_mode_hwtcl {Gen2 (5.0 Gbps)}
set_instance_parameter_value pcie port_type_hwtcl {Native endpoint}
set_instance_parameter_value pcie rxbuffer_rxreq_hwtcl {Maximum}
set_instance_parameter_value pcie pll_refclk_freq_hwtcl {100 MHz}
set_instance_parameter_value pcie set_pld_clk_x1_625MHz_hwtcl {0}
set_instance_parameter_value pcie in_cvp_mode_hwtcl {1}
set_instance_parameter_value pcie enable_tl_only_sim_hwtcl {0}
set_instance_parameter_value pcie use_atx_pll_hwtcl {0}
set_instance_parameter_value pcie CB_P2A_AVALON_ADDR_B0 {0}
set_instance_parameter_value pcie CB_P2A_AVALON_ADDR_B1 {0}
set_instance_parameter_value pcie CB_P2A_AVALON_ADDR_B2 {0}
set_instance_parameter_value pcie CB_P2A_AVALON_ADDR_B3 {0}
set_instance_parameter_value pcie CB_P2A_AVALON_ADDR_B4 {0}
set_instance_parameter_value pcie CB_P2A_AVALON_ADDR_B5 {0}
set_instance_parameter_value pcie NUM_PREFETCH_MASTERS {1}
set_instance_parameter_value pcie bar0_type_hwtcl {1}
set_instance_parameter_value pcie bar1_type_hwtcl {0}
set_instance_parameter_value pcie bar2_type_hwtcl {0}
set_instance_parameter_value pcie bar3_type_hwtcl {0}
set_instance_parameter_value pcie bar4_type_hwtcl {0}
set_instance_parameter_value pcie bar5_type_hwtcl {0}
set_instance_parameter_value pcie fixed_address_mode {0}
set_instance_parameter_value pcie CB_P2A_FIXED_AVALON_ADDR_B0 {0}
set_instance_parameter_value pcie CB_P2A_FIXED_AVALON_ADDR_B1 {0}
set_instance_parameter_value pcie CB_P2A_FIXED_AVALON_ADDR_B2 {0}
set_instance_parameter_value pcie CB_P2A_FIXED_AVALON_ADDR_B3 {0}
set_instance_parameter_value pcie CB_P2A_FIXED_AVALON_ADDR_B4 {0}
set_instance_parameter_value pcie CB_P2A_FIXED_AVALON_ADDR_B5 {0}
set_instance_parameter_value pcie vendor_id_hwtcl {4466}
set_instance_parameter_value pcie device_id_hwtcl {43776}
set_instance_parameter_value pcie revision_id_hwtcl {1}
set_instance_parameter_value pcie class_code_hwtcl {16711680}
set_instance_parameter_value pcie subsystem_vendor_id_hwtcl {4466}
set_instance_parameter_value pcie subsystem_device_id_hwtcl {4}
set_instance_parameter_value pcie max_payload_size_hwtcl {256}
set_instance_parameter_value pcie extend_tag_field_hwtcl {32}
set_instance_parameter_value pcie completion_timeout_hwtcl {ABCD}
set_instance_parameter_value pcie enable_completion_timeout_disable_hwtcl {1}
set_instance_parameter_value pcie use_aer_hwtcl {0}
set_instance_parameter_value pcie ecrc_check_capable_hwtcl {0}
set_instance_parameter_value pcie ecrc_gen_capable_hwtcl {0}
set_instance_parameter_value pcie use_crc_forwarding_hwtcl {0}
set_instance_parameter_value pcie port_link_number_hwtcl {1}
set_instance_parameter_value pcie dll_active_report_support_hwtcl {0}
set_instance_parameter_value pcie surprise_down_error_support_hwtcl {0}
set_instance_parameter_value pcie slotclkcfg_hwtcl {1}
set_instance_parameter_value pcie msi_multi_message_capable_hwtcl {4}
set_instance_parameter_value pcie msi_64bit_addressing_capable_hwtcl {true}
set_instance_parameter_value pcie msi_masking_capable_hwtcl {false}
set_instance_parameter_value pcie msi_support_hwtcl {true}
set_instance_parameter_value pcie enable_function_msix_support_hwtcl {0}
set_instance_parameter_value pcie msix_table_size_hwtcl {0}
set_instance_parameter_value pcie msix_table_offset_hwtcl {0.0}
set_instance_parameter_value pcie msix_table_bir_hwtcl {0}
set_instance_parameter_value pcie msix_pba_offset_hwtcl {0.0}
set_instance_parameter_value pcie msix_pba_bir_hwtcl {0}
set_instance_parameter_value pcie enable_slot_register_hwtcl {0}
set_instance_parameter_value pcie slot_power_scale_hwtcl {0}
set_instance_parameter_value pcie slot_power_limit_hwtcl {0}
set_instance_parameter_value pcie slot_number_hwtcl {0}
set_instance_parameter_value pcie endpoint_l0_latency_hwtcl {0}
set_instance_parameter_value pcie endpoint_l1_latency_hwtcl {0}
set_instance_parameter_value pcie CG_COMMON_CLOCK_MODE {1}
set_instance_parameter_value pcie avmm_width_hwtcl {64}
set_instance_parameter_value pcie AVALON_ADDR_WIDTH {32}
set_instance_parameter_value pcie CB_PCIE_MODE {0}
set_instance_parameter_value pcie CB_PCIE_RX_LITE {0}
set_instance_parameter_value pcie AST_LITE {0}
set_instance_parameter_value pcie CG_RXM_IRQ_NUM {16}
set_instance_parameter_value pcie bypass_tl {false}
set_instance_parameter_value pcie CG_IMPL_CRA_AV_SLAVE_PORT {1}
set_instance_parameter_value pcie CG_ENABLE_ADVANCED_INTERRUPT {0}
set_instance_parameter_value pcie CG_ENABLE_A2P_INTERRUPT {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_IS_FIXED {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_NUM_ENTRIES {256}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_PASS_THRU_BITS {12}
set_instance_parameter_value pcie BYPASSS_A2P_TRANSLATION {0}
set_instance_parameter_value pcie CB_RP_S_ADDR_WIDTH {32}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_0_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_0_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_1_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_1_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_2_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_2_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_3_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_3_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_4_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_4_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_5_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_5_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_6_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_6_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_7_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_7_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_8_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_8_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_9_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_9_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_10_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_10_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_11_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_11_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_12_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_12_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_13_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_13_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_14_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_14_LOW {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_15_HIGH {0}
set_instance_parameter_value pcie CB_A2P_ADDR_MAP_FIXED_TABLE_15_LOW {0}
set_instance_parameter_value pcie Address Page {0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15}
set_instance_parameter_value pcie PCIe Address 63:32 {0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000}
set_instance_parameter_value pcie PCIe Address 31:0 {0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000}
set_instance_parameter_value pcie RXM_DATA_WIDTH {64}
set_instance_parameter_value pcie RXM_BEN_WIDTH {8}
set_instance_parameter_value pcie CB_TXS_ADDRESS_WIDTH {7}
set_instance_parameter_value pcie use_rx_st_be_hwtcl {0}
set_instance_parameter_value pcie use_ast_parity {0}
set_instance_parameter_value pcie force_hrc {0}
set_instance_parameter_value pcie force_src {0}
set_instance_parameter_value pcie coreclkout_hip_phaseshift_hwtcl {0 ps}
set_instance_parameter_value pcie pldclk_hip_phase_shift_hwtcl {0 ps}
set_instance_parameter_value pcie serial_sim_hwtcl {0}
set_instance_parameter_value pcie hip_reconfig_hwtcl {0}
set_instance_parameter_value pcie vsec_id_hwtcl {40960}
set_instance_parameter_value pcie vsec_rev_hwtcl {0}
set_instance_parameter_value pcie expansion_base_address_register_hwtcl {0}
set_instance_parameter_value pcie io_window_addr_width_hwtcl {0}
set_instance_parameter_value pcie prefetchable_mem_window_addr_width_hwtcl {0}
set_instance_parameter_value pcie advanced_default_parameter_override {0}
set_instance_parameter_value pcie override_rxbuffer_cred_preset {0}
set_instance_parameter_value pcie gen3_rxfreqlock_counter_hwtcl {0}
set_instance_parameter_value pcie advanced_default_hwtcl_bypass_cdc {false}
set_instance_parameter_value pcie advanced_default_hwtcl_enable_rx_buffer_checking {false}
set_instance_parameter_value pcie advanced_default_hwtcl_disable_link_x2_support {false}
set_instance_parameter_value pcie advanced_default_hwtcl_wrong_device_id {disable}
set_instance_parameter_value pcie advanced_default_hwtcl_data_pack_rx {disable}
set_instance_parameter_value pcie advanced_default_hwtcl_ltssm_1ms_timeout {disable}
set_instance_parameter_value pcie advanced_default_hwtcl_ltssm_freqlocked_check {disable}
set_instance_parameter_value pcie advanced_default_hwtcl_deskew_comma {com_deskw}
set_instance_parameter_value pcie advanced_default_hwtcl_device_number {0}
set_instance_parameter_value pcie advanced_default_hwtcl_pipex1_debug_sel {disable}
set_instance_parameter_value pcie advanced_default_hwtcl_pclk_out_sel {pclk}
set_instance_parameter_value pcie advanced_default_hwtcl_no_soft_reset {false}
set_instance_parameter_value pcie advanced_default_hwtcl_maximum_current {0}
set_instance_parameter_value pcie advanced_default_hwtcl_d1_support {false}
set_instance_parameter_value pcie advanced_default_hwtcl_d2_support {false}
set_instance_parameter_value pcie advanced_default_hwtcl_d0_pme {false}
set_instance_parameter_value pcie advanced_default_hwtcl_d1_pme {false}
set_instance_parameter_value pcie advanced_default_hwtcl_d2_pme {false}
set_instance_parameter_value pcie advanced_default_hwtcl_d3_hot_pme {false}
set_instance_parameter_value pcie advanced_default_hwtcl_d3_cold_pme {false}
set_instance_parameter_value pcie advanced_default_hwtcl_low_priority_vc {single_vc}
set_instance_parameter_value pcie advanced_default_hwtcl_disable_snoop_packet {false}
set_instance_parameter_value pcie advanced_default_hwtcl_enable_l1_aspm {false}
set_instance_parameter_value pcie advanced_default_hwtcl_set_l0s {0}
set_instance_parameter_value pcie advanced_default_hwtcl_l1_exit_latency_sameclock {0}
set_instance_parameter_value pcie advanced_default_hwtcl_l1_exit_latency_diffclock {0}
set_instance_parameter_value pcie advanced_default_hwtcl_hot_plug_support {0}
set_instance_parameter_value pcie advanced_default_hwtcl_extended_tag_reset {false}
set_instance_parameter_value pcie advanced_default_hwtcl_no_command_completed {true}
set_instance_parameter_value pcie advanced_default_hwtcl_interrupt_pin {inta}
set_instance_parameter_value pcie advanced_default_hwtcl_bridge_port_vga_enable {false}
set_instance_parameter_value pcie advanced_default_hwtcl_bridge_port_ssid_support {false}
set_instance_parameter_value pcie advanced_default_hwtcl_ssvid {0}
set_instance_parameter_value pcie advanced_default_hwtcl_ssid {0}
set_instance_parameter_value pcie advanced_default_hwtcl_eie_before_nfts_count {4}
set_instance_parameter_value pcie advanced_default_hwtcl_gen2_diffclock_nfts_count {255}
set_instance_parameter_value pcie advanced_default_hwtcl_gen2_sameclock_nfts_count {255}
set_instance_parameter_value pcie advanced_default_hwtcl_l0_exit_latency_sameclock {6}
set_instance_parameter_value pcie advanced_default_hwtcl_l0_exit_latency_diffclock {6}
set_instance_parameter_value pcie advanced_default_hwtcl_atomic_op_routing {false}
set_instance_parameter_value pcie advanced_default_hwtcl_atomic_op_completer_32bit {false}
set_instance_parameter_value pcie advanced_default_hwtcl_atomic_op_completer_64bit {false}
set_instance_parameter_value pcie advanced_default_hwtcl_cas_completer_128bit {false}
set_instance_parameter_value pcie advanced_default_hwtcl_ltr_mechanism {false}
set_instance_parameter_value pcie advanced_default_hwtcl_tph_completer {false}
set_instance_parameter_value pcie advanced_default_hwtcl_extended_format_field {false}
set_instance_parameter_value pcie advanced_default_hwtcl_atomic_malformed {true}
set_instance_parameter_value pcie advanced_default_hwtcl_flr_capability {false}
set_instance_parameter_value pcie advanced_default_hwtcl_enable_adapter_half_rate_mode {false}
set_instance_parameter_value pcie advanced_default_hwtcl_vc0_clk_enable {true}
set_instance_parameter_value pcie advanced_default_hwtcl_register_pipe_signals {false}
set_instance_parameter_value pcie advanced_default_hwtcl_skp_os_gen3_count {0}
set_instance_parameter_value pcie advanced_default_hwtcl_tx_cdc_almost_empty {5}
set_instance_parameter_value pcie advanced_default_hwtcl_rx_l0s_count_idl {0}
set_instance_parameter_value pcie advanced_default_hwtcl_cdc_dummy_insert_limit {11}
set_instance_parameter_value pcie advanced_default_hwtcl_ei_delay_powerdown_count {10}
set_instance_parameter_value pcie advanced_default_hwtcl_skp_os_schedule_count {0}
set_instance_parameter_value pcie advanced_default_hwtcl_fc_init_timer {1024}
set_instance_parameter_value pcie advanced_default_hwtcl_l01_entry_latency {31}
set_instance_parameter_value pcie advanced_default_hwtcl_flow_control_update_count {30}
set_instance_parameter_value pcie advanced_default_hwtcl_flow_control_timeout_count {200}
set_instance_parameter_value pcie advanced_default_hwtcl_retry_buffer_last_active_address {2047}
set_instance_parameter_value pcie advanced_default_hwtcl_reserved_debug {0}

add_instance ddr3a altera_mem_if_ddr3_emif 12.1
set_instance_parameter_value ddr3a MEM_VENDOR {Micron}
set_instance_parameter_value ddr3a MEM_FORMAT {DISCRETE}
set_instance_parameter_value ddr3a RDIMM_CONFIG {0000000000000000}
set_instance_parameter_value ddr3a DISCRETE_FLY_BY {1}
set_instance_parameter_value ddr3a DEVICE_DEPTH {1}
set_instance_parameter_value ddr3a MEM_MIRROR_ADDRESSING {0}
set_instance_parameter_value ddr3a MEM_CLK_FREQ_MAX {666.667}
set_instance_parameter_value ddr3a MEM_ROW_ADDR_WIDTH {14}
set_instance_parameter_value ddr3a MEM_COL_ADDR_WIDTH {10}
set_instance_parameter_value ddr3a MEM_DQ_WIDTH {72}
set_instance_parameter_value ddr3a MEM_DQ_PER_DQS {8}
set_instance_parameter_value ddr3a MEM_BANKADDR_WIDTH {3}
set_instance_parameter_value ddr3a MEM_IF_DM_PINS_EN {1}
set_instance_parameter_value ddr3a MEM_IF_DQSN_EN {1}
set_instance_parameter_value ddr3a MEM_NUMBER_OF_DIMMS {1}
set_instance_parameter_value ddr3a MEM_NUMBER_OF_RANKS_PER_DIMM {1}
set_instance_parameter_value ddr3a MEM_NUMBER_OF_RANKS_PER_DEVICE {1}
set_instance_parameter_value ddr3a MEM_RANK_MULTIPLICATION_FACTOR {1}
set_instance_parameter_value ddr3a MEM_CK_WIDTH {1}
set_instance_parameter_value ddr3a MEM_CS_WIDTH {1}
set_instance_parameter_value ddr3a MEM_CLK_EN_WIDTH {1}
set_instance_parameter_value ddr3a ALTMEMPHY_COMPATIBLE_MODE {0}
set_instance_parameter_value ddr3a NEXTGEN {1}
set_instance_parameter_value ddr3a MEM_IF_BOARD_BASE_DELAY {10}
set_instance_parameter_value ddr3a MEM_IF_SIM_VALID_WINDOW {0}
set_instance_parameter_value ddr3a MEM_GUARANTEED_WRITE_INIT {0}
set_instance_parameter_value ddr3a MEM_VERBOSE {0}
set_instance_parameter_value ddr3a PINGPONGPHY_EN {0}
set_instance_parameter_value ddr3a REFRESH_BURST_VALIDATION {0}
set_instance_parameter_value ddr3a MEM_BL {OTF}
set_instance_parameter_value ddr3a MEM_BT {Sequential}
set_instance_parameter_value ddr3a MEM_ASR {Manual}
set_instance_parameter_value ddr3a MEM_SRT {Normal}
set_instance_parameter_value ddr3a MEM_PD {DLL off}
set_instance_parameter_value ddr3a MEM_DRV_STR {RZQ/6}
set_instance_parameter_value ddr3a MEM_DLL_EN {1}
set_instance_parameter_value ddr3a MEM_RTT_NOM {RZQ/6}
set_instance_parameter_value ddr3a MEM_RTT_WR {Dynamic ODT off}
set_instance_parameter_value ddr3a MEM_WTCL {8}
set_instance_parameter_value ddr3a MEM_ATCL {Disabled}
set_instance_parameter_value ddr3a MEM_TCL {9}
set_instance_parameter_value ddr3a MEM_AUTO_LEVELING_MODE {1}
set_instance_parameter_value ddr3a MEM_USER_LEVELING_MODE {Leveling}
set_instance_parameter_value ddr3a MEM_INIT_EN {0}
set_instance_parameter_value ddr3a MEM_INIT_FILE {}
set_instance_parameter_value ddr3a DAT_DATA_WIDTH {32}
set_instance_parameter_value ddr3a TIMING_TIS {65}
set_instance_parameter_value ddr3a TIMING_TIH {140}
set_instance_parameter_value ddr3a TIMING_TDS {30}
set_instance_parameter_value ddr3a TIMING_TDH {65}
set_instance_parameter_value ddr3a TIMING_TDQSQ {125}
set_instance_parameter_value ddr3a TIMING_TQH {0.38}
set_instance_parameter_value ddr3a TIMING_TDQSCK {255}
set_instance_parameter_value ddr3a TIMING_TDQSCKDS {450}
set_instance_parameter_value ddr3a TIMING_TDQSCKDM {900}
set_instance_parameter_value ddr3a TIMING_TDQSCKDL {1200}
set_instance_parameter_value ddr3a TIMING_TDQSS {0.25}
set_instance_parameter_value ddr3a TIMING_TQSH {0.5}
set_instance_parameter_value ddr3a TIMING_TDSH {0.2}
set_instance_parameter_value ddr3a TIMING_TDSS {0.2}
set_instance_parameter_value ddr3a MEM_TINIT_US {500}
set_instance_parameter_value ddr3a MEM_TMRD_CK {4}
set_instance_parameter_value ddr3a MEM_TRAS_NS {36.0}
set_instance_parameter_value ddr3a MEM_TRCD_NS {13.5}
set_instance_parameter_value ddr3a MEM_TRP_NS {13.5}
set_instance_parameter_value ddr3a MEM_TREFI_US {7.8}
set_instance_parameter_value ddr3a MEM_TRFC_NS {260.0}
set_instance_parameter_value ddr3a CFG_TCCD_NS {2.5}
set_instance_parameter_value ddr3a MEM_TWR_NS {15.0}
set_instance_parameter_value ddr3a MEM_TWTR {5}
set_instance_parameter_value ddr3a MEM_TFAW_NS {30.0}
set_instance_parameter_value ddr3a MEM_TRRD_NS {6.0}
set_instance_parameter_value ddr3a MEM_TRTP_NS {7.5}
set_instance_parameter_value ddr3a RATE {Quarter}
set_instance_parameter_value ddr3a MEM_CLK_FREQ {666.6667}
set_instance_parameter_value ddr3a USE_MEM_CLK_FREQ {0}
set_instance_parameter_value ddr3a FORCE_DQS_TRACKING {DISABLED}
set_instance_parameter_value ddr3a FORCE_SHADOW_REGS {AUTO}
set_instance_parameter_value ddr3a MRS_MIRROR_PING_PONG_ATSO {0}
set_instance_parameter_value ddr3a PARSE_FRIENDLY_DEVICE_FAMILY_PARAM_VALID {0}
set_instance_parameter_value ddr3a PARSE_FRIENDLY_DEVICE_FAMILY_PARAM {}
set_instance_parameter_value ddr3a DEVICE_FAMILY_PARAM {}
set_instance_parameter_value ddr3a SPEED_GRADE {2}
set_instance_parameter_value ddr3a IS_ES_DEVICE {0}
set_instance_parameter_value ddr3a DISABLE_CHILD_MESSAGING {0}
set_instance_parameter_value ddr3a HARD_EMIF {0}
set_instance_parameter_value ddr3a HHP_HPS {0}
set_instance_parameter_value ddr3a HHP_HPS_VERIFICATION {0}
set_instance_parameter_value ddr3a HHP_HPS_SIMULATION {0}
set_instance_parameter_value ddr3a HPS_PROTOCOL {DEFAULT}
set_instance_parameter_value ddr3a CUT_NEW_FAMILY_TIMING {1}
set_instance_parameter_value ddr3a POWER_OF_TWO_BUS {1}
set_instance_parameter_value ddr3a SOPC_COMPAT_RESET {0}
set_instance_parameter_value ddr3a AVL_MAX_SIZE {16}
set_instance_parameter_value ddr3a BYTE_ENABLE {1}
set_instance_parameter_value ddr3a ENABLE_CTRL_AVALON_INTERFACE {1}
set_instance_parameter_value ddr3a CTL_DEEP_POWERDN_EN {0}
set_instance_parameter_value ddr3a CTL_SELF_REFRESH_EN {0}
set_instance_parameter_value ddr3a AUTO_POWERDN_EN {0}
set_instance_parameter_value ddr3a AUTO_PD_CYCLES {0}
set_instance_parameter_value ddr3a CTL_USR_REFRESH_EN {0}
set_instance_parameter_value ddr3a CTL_AUTOPCH_EN {0}
set_instance_parameter_value ddr3a CTL_ZQCAL_EN {0}
set_instance_parameter_value ddr3a ADDR_ORDER {0}
set_instance_parameter_value ddr3a CTL_LOOK_AHEAD_DEPTH {8}
set_instance_parameter_value ddr3a CONTROLLER_LATENCY {5}
set_instance_parameter_value ddr3a CFG_REORDER_DATA {1}
set_instance_parameter_value ddr3a STARVE_LIMIT {10}
set_instance_parameter_value ddr3a CTL_CSR_ENABLED {0}
set_instance_parameter_value ddr3a CTL_CSR_CONNECTION {INTERNAL_JTAG}
set_instance_parameter_value ddr3a CTL_ECC_ENABLED {0}
set_instance_parameter_value ddr3a CTL_HRB_ENABLED {0}
set_instance_parameter_value ddr3a CTL_ECC_AUTO_CORRECTION_ENABLED {0}
set_instance_parameter_value ddr3a MULTICAST_EN {0}
set_instance_parameter_value ddr3a CTL_DYNAMIC_BANK_ALLOCATION {0}
set_instance_parameter_value ddr3a CTL_DYNAMIC_BANK_NUM {4}
set_instance_parameter_value ddr3a DEBUG_MODE {0}
set_instance_parameter_value ddr3a ENABLE_BURST_MERGE {0}
set_instance_parameter_value ddr3a CTL_ENABLE_BURST_INTERRUPT {1}
set_instance_parameter_value ddr3a CTL_ENABLE_BURST_TERMINATE {1}
set_instance_parameter_value ddr3a LOCAL_ID_WIDTH {8}
set_instance_parameter_value ddr3a WRBUFFER_ADDR_WIDTH {6}
set_instance_parameter_value ddr3a MAX_PENDING_WR_CMD {8}
set_instance_parameter_value ddr3a MAX_PENDING_RD_CMD {16}
set_instance_parameter_value ddr3a USE_MM_ADAPTOR {1}
set_instance_parameter_value ddr3a USE_AXI_ADAPTOR {0}
set_instance_parameter_value ddr3a HCX_COMPAT_MODE {0}
set_instance_parameter_value ddr3a CTL_CMD_QUEUE_DEPTH {8}
set_instance_parameter_value ddr3a CTL_CSR_READ_ONLY {1}
set_instance_parameter_value ddr3a CFG_DATA_REORDERING_TYPE {INTER_BANK}
set_instance_parameter_value ddr3a NUM_OF_PORTS {1}
set_instance_parameter_value ddr3a ENABLE_BONDING {0}
set_instance_parameter_value ddr3a ENABLE_USER_ECC {0}
set_instance_parameter_value ddr3a AVL_DATA_WIDTH_PORT {32 32 32 32 32 32}
set_instance_parameter_value ddr3a PRIORITY_PORT {1 1 1 1 1 1}
set_instance_parameter_value ddr3a WEIGHT_PORT {0 0 0 0 0 0}
set_instance_parameter_value ddr3a CPORT_TYPE_PORT {Bidirectional Bidirectional Bidirectional Bidirectional Bidirectional Bidirectional}
set_instance_parameter_value ddr3a ENABLE_EMIT_BFM_MASTER {0}
set_instance_parameter_value ddr3a FORCE_SEQUENCER_TCL_DEBUG_MODE {0}
set_instance_parameter_value ddr3a ENABLE_SEQUENCER_MARGINING_ON_BY_DEFAULT {0}
set_instance_parameter_value ddr3a REF_CLK_FREQ {166.666666}
set_instance_parameter_value ddr3a REF_CLK_FREQ_PARAM_VALID {0}
set_instance_parameter_value ddr3a REF_CLK_FREQ_MIN_PARAM {0.0}
set_instance_parameter_value ddr3a REF_CLK_FREQ_MAX_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_DR_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_DR_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_DR_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_DR_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_DR_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_DR_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_MEM_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_MEM_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_MEM_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_MEM_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_MEM_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_MEM_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_AFI_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_AFI_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_AFI_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_WRITE_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_WRITE_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_WRITE_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_WRITE_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_WRITE_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_WRITE_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_ADDR_CMD_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_ADDR_CMD_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_ADDR_CMD_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_ADDR_CMD_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_ADDR_CMD_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_ADDR_CMD_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_HALF_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_AFI_HALF_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_AFI_HALF_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_HALF_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_AFI_HALF_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_HALF_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_NIOS_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_NIOS_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_NIOS_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_NIOS_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_NIOS_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_NIOS_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_CONFIG_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_CONFIG_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_CONFIG_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_CONFIG_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_CONFIG_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_CONFIG_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_P2C_READ_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_P2C_READ_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_P2C_READ_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_P2C_READ_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_P2C_READ_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_P2C_READ_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_C2P_WRITE_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_C2P_WRITE_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_C2P_WRITE_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_C2P_WRITE_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_C2P_WRITE_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_C2P_WRITE_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_HR_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_HR_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_HR_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_HR_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_HR_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_HR_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_PHY_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3a PLL_AFI_PHY_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_AFI_PHY_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_PHY_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3a PLL_AFI_PHY_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3a PLL_AFI_PHY_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3a PLL_CLK_PARAM_VALID {0}
set_instance_parameter_value ddr3a ENABLE_EXTRA_REPORTING {0}
set_instance_parameter_value ddr3a NUM_EXTRA_REPORT_PATH {10}
set_instance_parameter_value ddr3a ENABLE_ISS_PROBES {0}
set_instance_parameter_value ddr3a CALIB_REG_WIDTH {8}
set_instance_parameter_value ddr3a USE_SEQUENCER_BFM {0}
set_instance_parameter_value ddr3a DEFAULT_FAST_SIM_MODEL {1}
set_instance_parameter_value ddr3a PLL_SHARING_MODE {None}
set_instance_parameter_value ddr3a NUM_PLL_SHARING_INTERFACES {1}
set_instance_parameter_value ddr3a EXPORT_AFI_HALF_CLK {0}
set_instance_parameter_value ddr3a ABSTRACT_REAL_COMPARE_TEST {0}
set_instance_parameter_value ddr3a INCLUDE_BOARD_DELAY_MODEL {0}
set_instance_parameter_value ddr3a INCLUDE_MULTIRANK_BOARD_DELAY_MODEL {0}
set_instance_parameter_value ddr3a USE_FAKE_PHY {0}
set_instance_parameter_value ddr3a FORCE_MAX_LATENCY_COUNT_WIDTH {0}
set_instance_parameter_value ddr3a ENABLE_NON_DESTRUCTIVE_CALIB {0}
set_instance_parameter_value ddr3a EXTRA_SETTINGS {}
set_instance_parameter_value ddr3a MEM_DEVICE {MISSING_MODEL}
set_instance_parameter_value ddr3a FORCE_SYNTHESIS_LANGUAGE {}
set_instance_parameter_value ddr3a FORCED_NUM_WRITE_FR_CYCLE_SHIFTS {0}
set_instance_parameter_value ddr3a SEQUENCER_TYPE {NIOS}
set_instance_parameter_value ddr3a ADVERTIZE_SEQUENCER_SW_BUILD_FILES {0}
set_instance_parameter_value ddr3a FORCED_NON_LDC_ADDR_CMD_MEM_CK_INVERT {0}
set_instance_parameter_value ddr3a PHY_ONLY {0}
set_instance_parameter_value ddr3a SEQ_MODE {0}
set_instance_parameter_value ddr3a ADVANCED_CK_PHASES {0}
set_instance_parameter_value ddr3a COMMAND_PHASE {0.0}
set_instance_parameter_value ddr3a MEM_CK_PHASE {0.0}
set_instance_parameter_value ddr3a P2C_READ_CLOCK_ADD_PHASE {0.0}
set_instance_parameter_value ddr3a C2P_WRITE_CLOCK_ADD_PHASE {0.0}
set_instance_parameter_value ddr3a ACV_PHY_CLK_ADD_FR_PHASE {0.0}
set_instance_parameter_value ddr3a MEM_VOLTAGE {1.35V DDR3L}
set_instance_parameter_value ddr3a PLL_LOCATION {Top_Bottom}
set_instance_parameter_value ddr3a SKIP_MEM_INIT {1}
set_instance_parameter_value ddr3a READ_DQ_DQS_CLOCK_SOURCE {INVERTED_DQS_BUS}
set_instance_parameter_value ddr3a DQ_INPUT_REG_USE_CLKN {0}
set_instance_parameter_value ddr3a DQS_DQSN_MODE {DIFFERENTIAL}
set_instance_parameter_value ddr3a AFI_DEBUG_INFO_WIDTH {32}
set_instance_parameter_value ddr3a CALIBRATION_MODE {Skip}
set_instance_parameter_value ddr3a NIOS_ROM_DATA_WIDTH {32}
set_instance_parameter_value ddr3a READ_FIFO_SIZE {8}
set_instance_parameter_value ddr3a PHY_CSR_ENABLED {0}
set_instance_parameter_value ddr3a PHY_CSR_CONNECTION {INTERNAL_JTAG}
set_instance_parameter_value ddr3a USER_DEBUG_LEVEL {0}
set_instance_parameter_value ddr3a TIMING_BOARD_DERATE_METHOD {AUTO}
set_instance_parameter_value ddr3a TIMING_BOARD_CK_CKN_SLEW_RATE {2.0}
set_instance_parameter_value ddr3a TIMING_BOARD_AC_SLEW_RATE {1.0}
set_instance_parameter_value ddr3a TIMING_BOARD_DQS_DQSN_SLEW_RATE {2.0}
set_instance_parameter_value ddr3a TIMING_BOARD_DQ_SLEW_RATE {1.0}
set_instance_parameter_value ddr3a TIMING_BOARD_TIS {0.0}
set_instance_parameter_value ddr3a TIMING_BOARD_TIH {0.0}
set_instance_parameter_value ddr3a TIMING_BOARD_TDS {0.0}
set_instance_parameter_value ddr3a TIMING_BOARD_TDH {0.0}
set_instance_parameter_value ddr3a TIMING_BOARD_ISI_METHOD {AUTO}
set_instance_parameter_value ddr3a TIMING_BOARD_AC_EYE_REDUCTION_SU {0.0}
set_instance_parameter_value ddr3a TIMING_BOARD_AC_EYE_REDUCTION_H {0.0}
set_instance_parameter_value ddr3a TIMING_BOARD_DQ_EYE_REDUCTION {0.0}
set_instance_parameter_value ddr3a TIMING_BOARD_DELTA_DQS_ARRIVAL_TIME {0.0}
set_instance_parameter_value ddr3a PACKAGE_DESKEW {1}
set_instance_parameter_value ddr3a AC_PACKAGE_DESKEW {1}
set_instance_parameter_value ddr3a TIMING_BOARD_MAX_CK_DELAY {0.56}
set_instance_parameter_value ddr3a TIMING_BOARD_MAX_DQS_DELAY {0.25}
set_instance_parameter_value ddr3a TIMING_BOARD_SKEW_CKDQS_DIMM_MIN {0.125}
set_instance_parameter_value ddr3a TIMING_BOARD_SKEW_CKDQS_DIMM_MAX {0.45}
set_instance_parameter_value ddr3a TIMING_BOARD_SKEW_BETWEEN_DIMMS {0.05}
set_instance_parameter_value ddr3a TIMING_BOARD_SKEW_WITHIN_DQS {0.15}
set_instance_parameter_value ddr3a TIMING_BOARD_SKEW_BETWEEN_DQS {0.17}
set_instance_parameter_value ddr3a TIMING_BOARD_DQ_TO_DQS_SKEW {0.0}
set_instance_parameter_value ddr3a TIMING_BOARD_AC_SKEW {0.1}
set_instance_parameter_value ddr3a TIMING_BOARD_AC_TO_CK_SKEW {-0.05}
set_instance_parameter_value ddr3a ENABLE_EXPORT_SEQ_DEBUG_BRIDGE {0}
set_instance_parameter_value ddr3a CORE_DEBUG_CONNECTION {EXPORT}
set_instance_parameter_value ddr3a ADD_EXTERNAL_SEQ_DEBUG_NIOS {0}
set_instance_parameter_value ddr3a ADD_EFFICIENCY_MONITOR {0}
set_instance_parameter_value ddr3a ENABLE_ABS_RAM_MEM_INIT {0}
set_instance_parameter_value ddr3a ABS_RAM_MEM_INIT_FILENAME {meminit}
set_instance_parameter_value ddr3a DLL_SHARING_MODE {None}
set_instance_parameter_value ddr3a NUM_DLL_SHARING_INTERFACES {1}
set_instance_parameter_value ddr3a OCT_SHARING_MODE {None}
set_instance_parameter_value ddr3a NUM_OCT_SHARING_INTERFACES {1}

add_instance alt_xcvr_reconfig_0 alt_xcvr_reconfig 12.1
set_instance_parameter_value alt_xcvr_reconfig_0 number_of_reconfig_interfaces {5}
set_instance_parameter_value alt_xcvr_reconfig_0 gui_split_sizes {}
set_instance_parameter_value alt_xcvr_reconfig_0 enable_offset {1}
set_instance_parameter_value alt_xcvr_reconfig_0 enable_dcd {0}
set_instance_parameter_value alt_xcvr_reconfig_0 enable_dcd_power_up {1}
set_instance_parameter_value alt_xcvr_reconfig_0 enable_analog {1}
set_instance_parameter_value alt_xcvr_reconfig_0 enable_eyemon {0}
set_instance_parameter_value alt_xcvr_reconfig_0 enable_dfe {0}
set_instance_parameter_value alt_xcvr_reconfig_0 enable_adce {0}
set_instance_parameter_value alt_xcvr_reconfig_0 enable_mif {0}
set_instance_parameter_value alt_xcvr_reconfig_0 gui_enable_pll {0}
set_instance_parameter_value alt_xcvr_reconfig_0 gui_cal_status_port {0}

add_instance ddr3b altera_mem_if_ddr3_emif 12.1
set_instance_parameter_value ddr3b MEM_VENDOR {Micron}
set_instance_parameter_value ddr3b MEM_FORMAT {DISCRETE}
set_instance_parameter_value ddr3b RDIMM_CONFIG {0000000000000000}
set_instance_parameter_value ddr3b DISCRETE_FLY_BY {1}
set_instance_parameter_value ddr3b DEVICE_DEPTH {1}
set_instance_parameter_value ddr3b MEM_MIRROR_ADDRESSING {0}
set_instance_parameter_value ddr3b MEM_CLK_FREQ_MAX {666.667}
set_instance_parameter_value ddr3b MEM_ROW_ADDR_WIDTH {14}
set_instance_parameter_value ddr3b MEM_COL_ADDR_WIDTH {10}
set_instance_parameter_value ddr3b MEM_DQ_WIDTH {72}
set_instance_parameter_value ddr3b MEM_DQ_PER_DQS {8}
set_instance_parameter_value ddr3b MEM_BANKADDR_WIDTH {3}
set_instance_parameter_value ddr3b MEM_IF_DM_PINS_EN {1}
set_instance_parameter_value ddr3b MEM_IF_DQSN_EN {1}
set_instance_parameter_value ddr3b MEM_NUMBER_OF_DIMMS {1}
set_instance_parameter_value ddr3b MEM_NUMBER_OF_RANKS_PER_DIMM {1}
set_instance_parameter_value ddr3b MEM_NUMBER_OF_RANKS_PER_DEVICE {1}
set_instance_parameter_value ddr3b MEM_RANK_MULTIPLICATION_FACTOR {1}
set_instance_parameter_value ddr3b MEM_CK_WIDTH {1}
set_instance_parameter_value ddr3b MEM_CS_WIDTH {1}
set_instance_parameter_value ddr3b MEM_CLK_EN_WIDTH {1}
set_instance_parameter_value ddr3b ALTMEMPHY_COMPATIBLE_MODE {0}
set_instance_parameter_value ddr3b NEXTGEN {1}
set_instance_parameter_value ddr3b MEM_IF_BOARD_BASE_DELAY {10}
set_instance_parameter_value ddr3b MEM_IF_SIM_VALID_WINDOW {0}
set_instance_parameter_value ddr3b MEM_GUARANTEED_WRITE_INIT {0}
set_instance_parameter_value ddr3b MEM_VERBOSE {0}
set_instance_parameter_value ddr3b PINGPONGPHY_EN {0}
set_instance_parameter_value ddr3b REFRESH_BURST_VALIDATION {0}
set_instance_parameter_value ddr3b MEM_BL {OTF}
set_instance_parameter_value ddr3b MEM_BT {Sequential}
set_instance_parameter_value ddr3b MEM_ASR {Manual}
set_instance_parameter_value ddr3b MEM_SRT {Normal}
set_instance_parameter_value ddr3b MEM_PD {DLL off}
set_instance_parameter_value ddr3b MEM_DRV_STR {RZQ/6}
set_instance_parameter_value ddr3b MEM_DLL_EN {1}
set_instance_parameter_value ddr3b MEM_RTT_NOM {RZQ/6}
set_instance_parameter_value ddr3b MEM_RTT_WR {Dynamic ODT off}
set_instance_parameter_value ddr3b MEM_WTCL {8}
set_instance_parameter_value ddr3b MEM_ATCL {Disabled}
set_instance_parameter_value ddr3b MEM_TCL {9}
set_instance_parameter_value ddr3b MEM_AUTO_LEVELING_MODE {1}
set_instance_parameter_value ddr3b MEM_USER_LEVELING_MODE {Leveling}
set_instance_parameter_value ddr3b MEM_INIT_EN {0}
set_instance_parameter_value ddr3b MEM_INIT_FILE {}
set_instance_parameter_value ddr3b DAT_DATA_WIDTH {32}
set_instance_parameter_value ddr3b TIMING_TIS {65}
set_instance_parameter_value ddr3b TIMING_TIH {140}
set_instance_parameter_value ddr3b TIMING_TDS {30}
set_instance_parameter_value ddr3b TIMING_TDH {65}
set_instance_parameter_value ddr3b TIMING_TDQSQ {125}
set_instance_parameter_value ddr3b TIMING_TQH {0.38}
set_instance_parameter_value ddr3b TIMING_TDQSCK {255}
set_instance_parameter_value ddr3b TIMING_TDQSCKDS {450}
set_instance_parameter_value ddr3b TIMING_TDQSCKDM {900}
set_instance_parameter_value ddr3b TIMING_TDQSCKDL {1200}
set_instance_parameter_value ddr3b TIMING_TDQSS {0.25}
set_instance_parameter_value ddr3b TIMING_TQSH {0.5}
set_instance_parameter_value ddr3b TIMING_TDSH {0.2}
set_instance_parameter_value ddr3b TIMING_TDSS {0.2}
set_instance_parameter_value ddr3b MEM_TINIT_US {500}
set_instance_parameter_value ddr3b MEM_TMRD_CK {4}
set_instance_parameter_value ddr3b MEM_TRAS_NS {36.0}
set_instance_parameter_value ddr3b MEM_TRCD_NS {13.5}
set_instance_parameter_value ddr3b MEM_TRP_NS {13.5}
set_instance_parameter_value ddr3b MEM_TREFI_US {7.8}
set_instance_parameter_value ddr3b MEM_TRFC_NS {260.0}
set_instance_parameter_value ddr3b CFG_TCCD_NS {2.5}
set_instance_parameter_value ddr3b MEM_TWR_NS {15.0}
set_instance_parameter_value ddr3b MEM_TWTR {5}
set_instance_parameter_value ddr3b MEM_TFAW_NS {30.0}
set_instance_parameter_value ddr3b MEM_TRRD_NS {6.0}
set_instance_parameter_value ddr3b MEM_TRTP_NS {7.5}
set_instance_parameter_value ddr3b RATE {Quarter}
set_instance_parameter_value ddr3b MEM_CLK_FREQ {666.6667}
set_instance_parameter_value ddr3b USE_MEM_CLK_FREQ {0}
set_instance_parameter_value ddr3b FORCE_DQS_TRACKING {DISABLED}
set_instance_parameter_value ddr3b FORCE_SHADOW_REGS {AUTO}
set_instance_parameter_value ddr3b MRS_MIRROR_PING_PONG_ATSO {0}
set_instance_parameter_value ddr3b PARSE_FRIENDLY_DEVICE_FAMILY_PARAM_VALID {0}
set_instance_parameter_value ddr3b PARSE_FRIENDLY_DEVICE_FAMILY_PARAM {}
set_instance_parameter_value ddr3b DEVICE_FAMILY_PARAM {}
set_instance_parameter_value ddr3b SPEED_GRADE {2}
set_instance_parameter_value ddr3b IS_ES_DEVICE {0}
set_instance_parameter_value ddr3b DISABLE_CHILD_MESSAGING {0}
set_instance_parameter_value ddr3b HARD_EMIF {0}
set_instance_parameter_value ddr3b HHP_HPS {0}
set_instance_parameter_value ddr3b HHP_HPS_VERIFICATION {0}
set_instance_parameter_value ddr3b HHP_HPS_SIMULATION {0}
set_instance_parameter_value ddr3b HPS_PROTOCOL {DEFAULT}
set_instance_parameter_value ddr3b CUT_NEW_FAMILY_TIMING {1}
set_instance_parameter_value ddr3b POWER_OF_TWO_BUS {1}
set_instance_parameter_value ddr3b SOPC_COMPAT_RESET {0}
set_instance_parameter_value ddr3b AVL_MAX_SIZE {16}
set_instance_parameter_value ddr3b BYTE_ENABLE {1}
set_instance_parameter_value ddr3b ENABLE_CTRL_AVALON_INTERFACE {1}
set_instance_parameter_value ddr3b CTL_DEEP_POWERDN_EN {0}
set_instance_parameter_value ddr3b CTL_SELF_REFRESH_EN {0}
set_instance_parameter_value ddr3b AUTO_POWERDN_EN {0}
set_instance_parameter_value ddr3b AUTO_PD_CYCLES {0}
set_instance_parameter_value ddr3b CTL_USR_REFRESH_EN {0}
set_instance_parameter_value ddr3b CTL_AUTOPCH_EN {0}
set_instance_parameter_value ddr3b CTL_ZQCAL_EN {0}
set_instance_parameter_value ddr3b ADDR_ORDER {0}
set_instance_parameter_value ddr3b CTL_LOOK_AHEAD_DEPTH {8}
set_instance_parameter_value ddr3b CONTROLLER_LATENCY {5}
set_instance_parameter_value ddr3b CFG_REORDER_DATA {1}
set_instance_parameter_value ddr3b STARVE_LIMIT {10}
set_instance_parameter_value ddr3b CTL_CSR_ENABLED {0}
set_instance_parameter_value ddr3b CTL_CSR_CONNECTION {INTERNAL_JTAG}
set_instance_parameter_value ddr3b CTL_ECC_ENABLED {0}
set_instance_parameter_value ddr3b CTL_HRB_ENABLED {0}
set_instance_parameter_value ddr3b CTL_ECC_AUTO_CORRECTION_ENABLED {0}
set_instance_parameter_value ddr3b MULTICAST_EN {0}
set_instance_parameter_value ddr3b CTL_DYNAMIC_BANK_ALLOCATION {0}
set_instance_parameter_value ddr3b CTL_DYNAMIC_BANK_NUM {4}
set_instance_parameter_value ddr3b DEBUG_MODE {0}
set_instance_parameter_value ddr3b ENABLE_BURST_MERGE {0}
set_instance_parameter_value ddr3b CTL_ENABLE_BURST_INTERRUPT {1}
set_instance_parameter_value ddr3b CTL_ENABLE_BURST_TERMINATE {1}
set_instance_parameter_value ddr3b LOCAL_ID_WIDTH {8}
set_instance_parameter_value ddr3b WRBUFFER_ADDR_WIDTH {6}
set_instance_parameter_value ddr3b MAX_PENDING_WR_CMD {8}
set_instance_parameter_value ddr3b MAX_PENDING_RD_CMD {16}
set_instance_parameter_value ddr3b USE_MM_ADAPTOR {1}
set_instance_parameter_value ddr3b USE_AXI_ADAPTOR {0}
set_instance_parameter_value ddr3b HCX_COMPAT_MODE {0}
set_instance_parameter_value ddr3b CTL_CMD_QUEUE_DEPTH {8}
set_instance_parameter_value ddr3b CTL_CSR_READ_ONLY {1}
set_instance_parameter_value ddr3b CFG_DATA_REORDERING_TYPE {INTER_BANK}
set_instance_parameter_value ddr3b NUM_OF_PORTS {1}
set_instance_parameter_value ddr3b ENABLE_BONDING {0}
set_instance_parameter_value ddr3b ENABLE_USER_ECC {0}
set_instance_parameter_value ddr3b AVL_DATA_WIDTH_PORT {32 32 32 32 32 32}
set_instance_parameter_value ddr3b PRIORITY_PORT {1 1 1 1 1 1}
set_instance_parameter_value ddr3b WEIGHT_PORT {0 0 0 0 0 0}
set_instance_parameter_value ddr3b CPORT_TYPE_PORT {Bidirectional Bidirectional Bidirectional Bidirectional Bidirectional Bidirectional}
set_instance_parameter_value ddr3b ENABLE_EMIT_BFM_MASTER {0}
set_instance_parameter_value ddr3b FORCE_SEQUENCER_TCL_DEBUG_MODE {0}
set_instance_parameter_value ddr3b ENABLE_SEQUENCER_MARGINING_ON_BY_DEFAULT {0}
set_instance_parameter_value ddr3b REF_CLK_FREQ {166.666666}
set_instance_parameter_value ddr3b REF_CLK_FREQ_PARAM_VALID {0}
set_instance_parameter_value ddr3b REF_CLK_FREQ_MIN_PARAM {0.0}
set_instance_parameter_value ddr3b REF_CLK_FREQ_MAX_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_DR_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_DR_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_DR_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_DR_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_DR_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_DR_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_MEM_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_MEM_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_MEM_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_MEM_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_MEM_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_MEM_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_AFI_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_AFI_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_AFI_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_WRITE_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_WRITE_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_WRITE_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_WRITE_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_WRITE_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_WRITE_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_ADDR_CMD_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_ADDR_CMD_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_ADDR_CMD_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_ADDR_CMD_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_ADDR_CMD_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_ADDR_CMD_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_HALF_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_AFI_HALF_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_AFI_HALF_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_HALF_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_AFI_HALF_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_HALF_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_NIOS_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_NIOS_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_NIOS_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_NIOS_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_NIOS_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_NIOS_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_CONFIG_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_CONFIG_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_CONFIG_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_CONFIG_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_CONFIG_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_CONFIG_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_P2C_READ_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_P2C_READ_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_P2C_READ_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_P2C_READ_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_P2C_READ_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_P2C_READ_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_C2P_WRITE_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_C2P_WRITE_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_C2P_WRITE_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_C2P_WRITE_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_C2P_WRITE_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_C2P_WRITE_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_HR_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_HR_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_HR_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_HR_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_HR_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_HR_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_PHY_CLK_FREQ_PARAM {0.0}
set_instance_parameter_value ddr3b PLL_AFI_PHY_CLK_FREQ_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_AFI_PHY_CLK_PHASE_PS_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_PHY_CLK_PHASE_PS_SIM_STR_PARAM {}
set_instance_parameter_value ddr3b PLL_AFI_PHY_CLK_MULT_PARAM {0}
set_instance_parameter_value ddr3b PLL_AFI_PHY_CLK_DIV_PARAM {0}
set_instance_parameter_value ddr3b PLL_CLK_PARAM_VALID {0}
set_instance_parameter_value ddr3b ENABLE_EXTRA_REPORTING {0}
set_instance_parameter_value ddr3b NUM_EXTRA_REPORT_PATH {10}
set_instance_parameter_value ddr3b ENABLE_ISS_PROBES {0}
set_instance_parameter_value ddr3b CALIB_REG_WIDTH {8}
set_instance_parameter_value ddr3b USE_SEQUENCER_BFM {0}
set_instance_parameter_value ddr3b DEFAULT_FAST_SIM_MODEL {1}
set_instance_parameter_value ddr3b PLL_SHARING_MODE {None}
set_instance_parameter_value ddr3b NUM_PLL_SHARING_INTERFACES {1}
set_instance_parameter_value ddr3b EXPORT_AFI_HALF_CLK {0}
set_instance_parameter_value ddr3b ABSTRACT_REAL_COMPARE_TEST {0}
set_instance_parameter_value ddr3b INCLUDE_BOARD_DELAY_MODEL {0}
set_instance_parameter_value ddr3b INCLUDE_MULTIRANK_BOARD_DELAY_MODEL {0}
set_instance_parameter_value ddr3b USE_FAKE_PHY {0}
set_instance_parameter_value ddr3b FORCE_MAX_LATENCY_COUNT_WIDTH {0}
set_instance_parameter_value ddr3b ENABLE_NON_DESTRUCTIVE_CALIB {0}
set_instance_parameter_value ddr3b EXTRA_SETTINGS {}
set_instance_parameter_value ddr3b MEM_DEVICE {MISSING_MODEL}
set_instance_parameter_value ddr3b FORCE_SYNTHESIS_LANGUAGE {}
set_instance_parameter_value ddr3b FORCED_NUM_WRITE_FR_CYCLE_SHIFTS {0}
set_instance_parameter_value ddr3b SEQUENCER_TYPE {NIOS}
set_instance_parameter_value ddr3b ADVERTIZE_SEQUENCER_SW_BUILD_FILES {0}
set_instance_parameter_value ddr3b FORCED_NON_LDC_ADDR_CMD_MEM_CK_INVERT {0}
set_instance_parameter_value ddr3b PHY_ONLY {0}
set_instance_parameter_value ddr3b SEQ_MODE {0}
set_instance_parameter_value ddr3b ADVANCED_CK_PHASES {0}
set_instance_parameter_value ddr3b COMMAND_PHASE {0.0}
set_instance_parameter_value ddr3b MEM_CK_PHASE {0.0}
set_instance_parameter_value ddr3b P2C_READ_CLOCK_ADD_PHASE {0.0}
set_instance_parameter_value ddr3b C2P_WRITE_CLOCK_ADD_PHASE {0.0}
set_instance_parameter_value ddr3b ACV_PHY_CLK_ADD_FR_PHASE {0.0}
set_instance_parameter_value ddr3b MEM_VOLTAGE {1.35V DDR3L}
set_instance_parameter_value ddr3b PLL_LOCATION {Top_Bottom}
set_instance_parameter_value ddr3b SKIP_MEM_INIT {1}
set_instance_parameter_value ddr3b READ_DQ_DQS_CLOCK_SOURCE {INVERTED_DQS_BUS}
set_instance_parameter_value ddr3b DQ_INPUT_REG_USE_CLKN {0}
set_instance_parameter_value ddr3b DQS_DQSN_MODE {DIFFERENTIAL}
set_instance_parameter_value ddr3b AFI_DEBUG_INFO_WIDTH {32}
set_instance_parameter_value ddr3b CALIBRATION_MODE {Skip}
set_instance_parameter_value ddr3b NIOS_ROM_DATA_WIDTH {32}
set_instance_parameter_value ddr3b READ_FIFO_SIZE {8}
set_instance_parameter_value ddr3b PHY_CSR_ENABLED {0}
set_instance_parameter_value ddr3b PHY_CSR_CONNECTION {INTERNAL_JTAG}
set_instance_parameter_value ddr3b USER_DEBUG_LEVEL {0}
set_instance_parameter_value ddr3b TIMING_BOARD_DERATE_METHOD {AUTO}
set_instance_parameter_value ddr3b TIMING_BOARD_CK_CKN_SLEW_RATE {2.0}
set_instance_parameter_value ddr3b TIMING_BOARD_AC_SLEW_RATE {1.0}
set_instance_parameter_value ddr3b TIMING_BOARD_DQS_DQSN_SLEW_RATE {2.0}
set_instance_parameter_value ddr3b TIMING_BOARD_DQ_SLEW_RATE {1.0}
set_instance_parameter_value ddr3b TIMING_BOARD_TIS {0.0}
set_instance_parameter_value ddr3b TIMING_BOARD_TIH {0.0}
set_instance_parameter_value ddr3b TIMING_BOARD_TDS {0.0}
set_instance_parameter_value ddr3b TIMING_BOARD_TDH {0.0}
set_instance_parameter_value ddr3b TIMING_BOARD_ISI_METHOD {AUTO}
set_instance_parameter_value ddr3b TIMING_BOARD_AC_EYE_REDUCTION_SU {0.0}
set_instance_parameter_value ddr3b TIMING_BOARD_AC_EYE_REDUCTION_H {0.0}
set_instance_parameter_value ddr3b TIMING_BOARD_DQ_EYE_REDUCTION {0.0}
set_instance_parameter_value ddr3b TIMING_BOARD_DELTA_DQS_ARRIVAL_TIME {0.0}
set_instance_parameter_value ddr3b PACKAGE_DESKEW {1}
set_instance_parameter_value ddr3b AC_PACKAGE_DESKEW {1}
set_instance_parameter_value ddr3b TIMING_BOARD_MAX_CK_DELAY {0.56}
set_instance_parameter_value ddr3b TIMING_BOARD_MAX_DQS_DELAY {0.25}
set_instance_parameter_value ddr3b TIMING_BOARD_SKEW_CKDQS_DIMM_MIN {0.125}
set_instance_parameter_value ddr3b TIMING_BOARD_SKEW_CKDQS_DIMM_MAX {0.45}
set_instance_parameter_value ddr3b TIMING_BOARD_SKEW_BETWEEN_DIMMS {0.05}
set_instance_parameter_value ddr3b TIMING_BOARD_SKEW_WITHIN_DQS {0.15}
set_instance_parameter_value ddr3b TIMING_BOARD_SKEW_BETWEEN_DQS {0.17}
set_instance_parameter_value ddr3b TIMING_BOARD_DQ_TO_DQS_SKEW {0.0}
set_instance_parameter_value ddr3b TIMING_BOARD_AC_SKEW {0.1}
set_instance_parameter_value ddr3b TIMING_BOARD_AC_TO_CK_SKEW {-0.05}
set_instance_parameter_value ddr3b ENABLE_EXPORT_SEQ_DEBUG_BRIDGE {0}
set_instance_parameter_value ddr3b CORE_DEBUG_CONNECTION {EXPORT}
set_instance_parameter_value ddr3b ADD_EXTERNAL_SEQ_DEBUG_NIOS {0}
set_instance_parameter_value ddr3b ADD_EFFICIENCY_MONITOR {0}
set_instance_parameter_value ddr3b ENABLE_ABS_RAM_MEM_INIT {0}
set_instance_parameter_value ddr3b ABS_RAM_MEM_INIT_FILENAME {meminit}
set_instance_parameter_value ddr3b DLL_SHARING_MODE {None}
set_instance_parameter_value ddr3b NUM_DLL_SHARING_INTERFACES {1}
set_instance_parameter_value ddr3b OCT_SHARING_MODE {None}
set_instance_parameter_value ddr3b NUM_OCT_SHARING_INTERFACES {1}

add_instance pipe_stage_ddr3a_dimm altera_avalon_mm_bridge 12.1
set_instance_parameter_value pipe_stage_ddr3a_dimm DATA_WIDTH {512}
set_instance_parameter_value pipe_stage_ddr3a_dimm SYMBOL_WIDTH {8}
set_instance_parameter_value pipe_stage_ddr3a_dimm ADDRESS_WIDTH {30}
set_instance_parameter_value pipe_stage_ddr3a_dimm ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value pipe_stage_ddr3a_dimm MAX_BURST_SIZE {16}
set_instance_parameter_value pipe_stage_ddr3a_dimm MAX_PENDING_RESPONSES {32}
set_instance_parameter_value pipe_stage_ddr3a_dimm LINEWRAPBURSTS {0}
set_instance_parameter_value pipe_stage_ddr3a_dimm PIPELINE_COMMAND {1}
set_instance_parameter_value pipe_stage_ddr3a_dimm PIPELINE_RESPONSE {1}

add_instance config_clk altera_clock_bridge 12.1
set_instance_parameter_value config_clk EXPLICIT_CLOCK_RATE {0.0}
set_instance_parameter_value config_clk NUM_CLOCK_OUTPUTS {1}

add_instance clock_cross_dma_to_pcie altera_avalon_mm_clock_crossing_bridge 12.1
set_instance_parameter_value clock_cross_dma_to_pcie DATA_WIDTH {512}
set_instance_parameter_value clock_cross_dma_to_pcie SYMBOL_WIDTH {8}
set_instance_parameter_value clock_cross_dma_to_pcie ADDRESS_WIDTH {20}
set_instance_parameter_value clock_cross_dma_to_pcie ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value clock_cross_dma_to_pcie MAX_BURST_SIZE {16}
set_instance_parameter_value clock_cross_dma_to_pcie COMMAND_FIFO_DEPTH {16}
set_instance_parameter_value clock_cross_dma_to_pcie RESPONSE_FIFO_DEPTH {64}
set_instance_parameter_value clock_cross_dma_to_pcie MASTER_SYNC_DEPTH {2}
set_instance_parameter_value clock_cross_dma_to_pcie SLAVE_SYNC_DEPTH {2}

add_instance temperature_pll altera_pll 12.1
set_instance_parameter_value temperature_pll gui_device_speed_grade {2}
set_instance_parameter_value temperature_pll gui_pll_mode {Integer-N PLL}
set_instance_parameter_value temperature_pll gui_reference_clock_frequency {100.0}
set_instance_parameter_value temperature_pll gui_channel_spacing {0.0}
set_instance_parameter_value temperature_pll gui_operation_mode {direct}
set_instance_parameter_value temperature_pll gui_feedback_clock {Global Clock}
set_instance_parameter_value temperature_pll gui_fractional_cout {32}
set_instance_parameter_value temperature_pll gui_dsm_out_sel {1st_order}
set_instance_parameter_value temperature_pll gui_use_locked {1}
set_instance_parameter_value temperature_pll gui_en_adv_params {0}
set_instance_parameter_value temperature_pll gui_number_of_clocks {1}
set_instance_parameter_value temperature_pll gui_multiply_factor {1}
set_instance_parameter_value temperature_pll gui_frac_multiply_factor {1.0}
set_instance_parameter_value temperature_pll gui_divide_factor_n {1}
set_instance_parameter_value temperature_pll gui_output_clock_frequency0 {80.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c0 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency0 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units0 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift0 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg0 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift0 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle0 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency1 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c1 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency1 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units1 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift1 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg1 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift1 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle1 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency2 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c2 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency2 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units2 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift2 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg2 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift2 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle2 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency3 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c3 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency3 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units3 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift3 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg3 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift3 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle3 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency4 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c4 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency4 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units4 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift4 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg4 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift4 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle4 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency5 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c5 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency5 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units5 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift5 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg5 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift5 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle5 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency6 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c6 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency6 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units6 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift6 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg6 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift6 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle6 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency7 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c7 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency7 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units7 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift7 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg7 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift7 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle7 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency8 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c8 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency8 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units8 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift8 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg8 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift8 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle8 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency9 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c9 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency9 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units9 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift9 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg9 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift9 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle9 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency10 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c10 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency10 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units10 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift10 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg10 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift10 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle10 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency11 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c11 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency11 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units11 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift11 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg11 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift11 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle11 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency12 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c12 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency12 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units12 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift12 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg12 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift12 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle12 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency13 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c13 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency13 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units13 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift13 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg13 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift13 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle13 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency14 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c14 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency14 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units14 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift14 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg14 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift14 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle14 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency15 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c15 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency15 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units15 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift15 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg15 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift15 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle15 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency16 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c16 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency16 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units16 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift16 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg16 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift16 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle16 {50}
set_instance_parameter_value temperature_pll gui_output_clock_frequency17 {100.0}
set_instance_parameter_value temperature_pll gui_divide_factor_c17 {1}
set_instance_parameter_value temperature_pll gui_actual_output_clock_frequency17 {0 MHz}
set_instance_parameter_value temperature_pll gui_ps_units17 {ps}
set_instance_parameter_value temperature_pll gui_phase_shift17 {0}
set_instance_parameter_value temperature_pll gui_phase_shift_deg17 {0}
set_instance_parameter_value temperature_pll gui_actual_phase_shift17 {0}
set_instance_parameter_value temperature_pll gui_duty_cycle17 {50}
set_instance_parameter_value temperature_pll gui_pll_auto_reset {Off}
set_instance_parameter_value temperature_pll gui_pll_bandwidth_preset {Auto}
set_instance_parameter_value temperature_pll gui_en_reconf {0}
set_instance_parameter_value temperature_pll gui_en_dps_ports {0}
set_instance_parameter_value temperature_pll gui_en_phout_ports {0}
set_instance_parameter_value temperature_pll gui_mif_generate {0}
set_instance_parameter_value temperature_pll gui_enable_mif_dps {0}
set_instance_parameter_value temperature_pll gui_dps_cntr {C0}
set_instance_parameter_value temperature_pll gui_dps_num {1}
set_instance_parameter_value temperature_pll gui_dps_dir {Positive}
set_instance_parameter_value temperature_pll gui_refclk_switch {0}
set_instance_parameter_value temperature_pll gui_refclk1_frequency {100.0}
set_instance_parameter_value temperature_pll gui_switchover_mode {Automatic Switchover}
set_instance_parameter_value temperature_pll gui_switchover_delay {0}
set_instance_parameter_value temperature_pll gui_active_clk {0}
set_instance_parameter_value temperature_pll gui_clk_bad {0}
set_instance_parameter_value temperature_pll gui_enable_cascade_out {0}
set_instance_parameter_value temperature_pll gui_enable_cascade_in {0}
set_instance_parameter_value temperature_pll gui_pll_cascading_mode {Create an adjpllin signal to connect with an upstream PLL}

add_instance temperature_0 temperature 10.0

add_instance acl_kernel_clk acl_kernel_clk 1.0
set_instance_parameter_value acl_kernel_clk REF_CLK_RATE {166.6666666}

add_instance kernel_interface acl_kernel_interface 1.0

add_instance dma_0 acl_dma 1.0
set_instance_parameter_value dma_0 BYTE_ADDR_WIDTH {32}
set_instance_parameter_value dma_0 DATA_WIDTH {512}
set_instance_parameter_value dma_0 BURST_SIZE {16}

add_instance pipe_stage_host_ctrl altera_avalon_mm_bridge 12.1
set_instance_parameter_value pipe_stage_host_ctrl DATA_WIDTH {32}
set_instance_parameter_value pipe_stage_host_ctrl SYMBOL_WIDTH {8}
set_instance_parameter_value pipe_stage_host_ctrl ADDRESS_WIDTH {18}
set_instance_parameter_value pipe_stage_host_ctrl ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value pipe_stage_host_ctrl MAX_BURST_SIZE {1}
set_instance_parameter_value pipe_stage_host_ctrl MAX_PENDING_RESPONSES {1}
set_instance_parameter_value pipe_stage_host_ctrl LINEWRAPBURSTS {0}
set_instance_parameter_value pipe_stage_host_ctrl PIPELINE_COMMAND {1}
set_instance_parameter_value pipe_stage_host_ctrl PIPELINE_RESPONSE {1}

add_instance clock_cross_kernel_mem_0 altera_avalon_mm_clock_crossing_bridge 12.1
set_instance_parameter_value clock_cross_kernel_mem_0 DATA_WIDTH {512}
set_instance_parameter_value clock_cross_kernel_mem_0 SYMBOL_WIDTH {8}
set_instance_parameter_value clock_cross_kernel_mem_0 ADDRESS_WIDTH {30}
set_instance_parameter_value clock_cross_kernel_mem_0 ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value clock_cross_kernel_mem_0 MAX_BURST_SIZE {16}
set_instance_parameter_value clock_cross_kernel_mem_0 COMMAND_FIFO_DEPTH {64}
set_instance_parameter_value clock_cross_kernel_mem_0 RESPONSE_FIFO_DEPTH {512}
set_instance_parameter_value clock_cross_kernel_mem_0 MASTER_SYNC_DEPTH {2}
set_instance_parameter_value clock_cross_kernel_mem_0 SLAVE_SYNC_DEPTH {2}

add_instance clock_cross_kernel_mem_1 altera_avalon_mm_clock_crossing_bridge 12.1
set_instance_parameter_value clock_cross_kernel_mem_1 DATA_WIDTH {512}
set_instance_parameter_value clock_cross_kernel_mem_1 SYMBOL_WIDTH {8}
set_instance_parameter_value clock_cross_kernel_mem_1 ADDRESS_WIDTH {30}
set_instance_parameter_value clock_cross_kernel_mem_1 ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value clock_cross_kernel_mem_1 MAX_BURST_SIZE {16}
set_instance_parameter_value clock_cross_kernel_mem_1 COMMAND_FIFO_DEPTH {64}
set_instance_parameter_value clock_cross_kernel_mem_1 RESPONSE_FIFO_DEPTH {512}
set_instance_parameter_value clock_cross_kernel_mem_1 MASTER_SYNC_DEPTH {2}
set_instance_parameter_value clock_cross_kernel_mem_1 SLAVE_SYNC_DEPTH {2}

add_instance pipe_stage_ddr3a_iface altera_avalon_mm_bridge 12.1
set_instance_parameter_value pipe_stage_ddr3a_iface DATA_WIDTH {512}
set_instance_parameter_value pipe_stage_ddr3a_iface SYMBOL_WIDTH {8}
set_instance_parameter_value pipe_stage_ddr3a_iface ADDRESS_WIDTH {30}
set_instance_parameter_value pipe_stage_ddr3a_iface ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value pipe_stage_ddr3a_iface MAX_BURST_SIZE {16}
set_instance_parameter_value pipe_stage_ddr3a_iface MAX_PENDING_RESPONSES {32}
set_instance_parameter_value pipe_stage_ddr3a_iface LINEWRAPBURSTS {0}
set_instance_parameter_value pipe_stage_ddr3a_iface PIPELINE_COMMAND {1}
set_instance_parameter_value pipe_stage_ddr3a_iface PIPELINE_RESPONSE {1}

add_instance em_pc_0 altera_avalon_em_pc 12.1
set_instance_parameter_value em_pc_0 EMPC_AV_BURSTCOUNT_WIDTH {1}
set_instance_parameter_value em_pc_0 EMPC_AV_DATA_WIDTH {512}
set_instance_parameter_value em_pc_0 EMPC_AV_POW2_DATA_WIDTH {512}
set_instance_parameter_value em_pc_0 EMPC_AV_ADDRESS_WIDTH {24}
set_instance_parameter_value em_pc_0 EMPC_AV_SYMBOL_WIDTH {8}
set_instance_parameter_value em_pc_0 EMPC_COUNT_WIDTH {32}
set_instance_parameter_value em_pc_0 EMPC_CSR_CONNECTION {EXPORT}
set_instance_parameter_value em_pc_0 EMPC_MAX_READ_TRANSACTIONS {32}

add_instance em_pc_1 altera_avalon_em_pc 12.1
set_instance_parameter_value em_pc_1 EMPC_AV_BURSTCOUNT_WIDTH {1}
set_instance_parameter_value em_pc_1 EMPC_AV_DATA_WIDTH {512}
set_instance_parameter_value em_pc_1 EMPC_AV_POW2_DATA_WIDTH {512}
set_instance_parameter_value em_pc_1 EMPC_AV_ADDRESS_WIDTH {24}
set_instance_parameter_value em_pc_1 EMPC_AV_SYMBOL_WIDTH {8}
set_instance_parameter_value em_pc_1 EMPC_COUNT_WIDTH {32}
set_instance_parameter_value em_pc_1 EMPC_CSR_CONNECTION {EXPORT}
set_instance_parameter_value em_pc_1 EMPC_MAX_READ_TRANSACTIONS {32}

add_instance clock_cross_dma_to_ddr3a altera_avalon_mm_clock_crossing_bridge 12.1
set_instance_parameter_value clock_cross_dma_to_ddr3a DATA_WIDTH {512}
set_instance_parameter_value clock_cross_dma_to_ddr3a SYMBOL_WIDTH {8}
set_instance_parameter_value clock_cross_dma_to_ddr3a ADDRESS_WIDTH {30}
set_instance_parameter_value clock_cross_dma_to_ddr3a ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value clock_cross_dma_to_ddr3a MAX_BURST_SIZE {16}
set_instance_parameter_value clock_cross_dma_to_ddr3a COMMAND_FIFO_DEPTH {16}
set_instance_parameter_value clock_cross_dma_to_ddr3a RESPONSE_FIFO_DEPTH {64}
set_instance_parameter_value clock_cross_dma_to_ddr3a MASTER_SYNC_DEPTH {2}
set_instance_parameter_value clock_cross_dma_to_ddr3a SLAVE_SYNC_DEPTH {2}

add_instance kernel_clk clock_source 12.1
set_instance_parameter_value kernel_clk clockFrequency {50000000.0}
set_instance_parameter_value kernel_clk clockFrequencyKnown {0}
set_instance_parameter_value kernel_clk resetSynchronousEdges {DEASSERT}

add_instance acl_memory_bank_divider_0 acl_memory_bank_divider 1.0
set_instance_parameter_value acl_memory_bank_divider_0 NUM_BANKS {2}
set_instance_parameter_value acl_memory_bank_divider_0 DATA_WIDTH {512}
set_instance_parameter_value acl_memory_bank_divider_0 ADDRESS_WIDTH {31}
set_instance_parameter_value acl_memory_bank_divider_0 BURST_SIZE {16}
set_instance_parameter_value acl_memory_bank_divider_0 MAX_PENDING_READS {64}

add_instance pipe_stage_txs altera_avalon_mm_bridge 12.1
set_instance_parameter_value pipe_stage_txs DATA_WIDTH {128}
set_instance_parameter_value pipe_stage_txs SYMBOL_WIDTH {8}
set_instance_parameter_value pipe_stage_txs ADDRESS_WIDTH {20}
set_instance_parameter_value pipe_stage_txs ADDRESS_UNITS {SYMBOLS}
set_instance_parameter_value pipe_stage_txs MAX_BURST_SIZE {64}
set_instance_parameter_value pipe_stage_txs MAX_PENDING_RESPONSES {12}
set_instance_parameter_value pipe_stage_txs LINEWRAPBURSTS {0}
set_instance_parameter_value pipe_stage_txs PIPELINE_COMMAND {1}
set_instance_parameter_value pipe_stage_txs PIPELINE_RESPONSE {1}

add_instance reset_counter sw_reset 10.0
set_instance_parameter_value reset_counter WIDTH {8}
set_instance_parameter_value reset_counter LOG2_RESET_CYCLES {10}

add_instance reset_controller_pcie altera_reset_controller 12.1
set_instance_parameter_value reset_controller_pcie NUM_RESET_INPUTS {1}
set_instance_parameter_value reset_controller_pcie OUTPUT_RESET_SYNC_EDGES {deassert}
set_instance_parameter_value reset_controller_pcie SYNC_DEPTH {2}

add_instance reset_controller_ddr3b altera_reset_controller 12.1
set_instance_parameter_value reset_controller_ddr3b NUM_RESET_INPUTS {1}
set_instance_parameter_value reset_controller_ddr3b OUTPUT_RESET_SYNC_EDGES {deassert}
set_instance_parameter_value reset_controller_ddr3b SYNC_DEPTH {2}

add_instance reset_controller_ddr3a altera_reset_controller 12.1
set_instance_parameter_value reset_controller_ddr3a NUM_RESET_INPUTS {1}
set_instance_parameter_value reset_controller_ddr3a OUTPUT_RESET_SYNC_EDGES {deassert}
set_instance_parameter_value reset_controller_ddr3a SYNC_DEPTH {2}

add_instance npor_export altera_reset_bridge 12.1
set_instance_parameter_value npor_export ACTIVE_LOW_RESET {1}
set_instance_parameter_value npor_export SYNCHRONOUS_EDGES {none}
set_instance_parameter_value npor_export NUM_RESET_OUTPUTS {1}

# connections and connection parameters
add_connection pcie.reconfig_to_xcvr alt_xcvr_reconfig_0.reconfig_to_xcvr conduit
set_connection_parameter_value pcie.reconfig_to_xcvr/alt_xcvr_reconfig_0.reconfig_to_xcvr endPort {}
set_connection_parameter_value pcie.reconfig_to_xcvr/alt_xcvr_reconfig_0.reconfig_to_xcvr endPortLSB {0}
set_connection_parameter_value pcie.reconfig_to_xcvr/alt_xcvr_reconfig_0.reconfig_to_xcvr startPort {}
set_connection_parameter_value pcie.reconfig_to_xcvr/alt_xcvr_reconfig_0.reconfig_to_xcvr startPortLSB {0}
set_connection_parameter_value pcie.reconfig_to_xcvr/alt_xcvr_reconfig_0.reconfig_to_xcvr width {0}

add_connection alt_xcvr_reconfig_0.reconfig_from_xcvr pcie.reconfig_from_xcvr conduit
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie.reconfig_from_xcvr endPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie.reconfig_from_xcvr endPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie.reconfig_from_xcvr startPort {}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie.reconfig_from_xcvr startPortLSB {0}
set_connection_parameter_value alt_xcvr_reconfig_0.reconfig_from_xcvr/pcie.reconfig_from_xcvr width {0}

add_connection ddr3b.afi_clk pipe_stage_ddr3b_dimm.clk clock

add_connection pipe_stage_ddr3a_dimm.m0 ddr3a.avl avalon
set_connection_parameter_value pipe_stage_ddr3a_dimm.m0/ddr3a.avl arbitrationPriority {1}
set_connection_parameter_value pipe_stage_ddr3a_dimm.m0/ddr3a.avl baseAddress {0x0000}

add_connection ddr3a.afi_clk pipe_stage_ddr3a_dimm.clk clock

add_connection pipe_stage_ddr3b_dimm.m0 ddr3b.avl avalon
set_connection_parameter_value pipe_stage_ddr3b_dimm.m0/ddr3b.avl arbitrationPriority {1}
set_connection_parameter_value pipe_stage_ddr3b_dimm.m0/ddr3b.avl baseAddress {0x0000}

add_connection config_clk.out_clk alt_xcvr_reconfig_0.mgmt_clk_clk clock

add_connection pcie.coreclkout clock_cross_dma_to_pcie.m0_clk clock

add_connection ddr3b.afi_clk clock_cross_dma_to_pcie.s0_clk clock

add_connection config_clk.out_clk temperature_pll.refclk clock

add_connection temperature_pll.outclk0 temperature_0.clk clock

add_connection pipe_stage_host_ctrl.m0 temperature_0.s avalon
set_connection_parameter_value pipe_stage_host_ctrl.m0/temperature_0.s arbitrationPriority {1}
set_connection_parameter_value pipe_stage_host_ctrl.m0/temperature_0.s baseAddress {0xcff0}

add_connection pipe_stage_host_ctrl.m0 acl_kernel_clk.ctrl avalon
set_connection_parameter_value pipe_stage_host_ctrl.m0/acl_kernel_clk.ctrl arbitrationPriority {1}
set_connection_parameter_value pipe_stage_host_ctrl.m0/acl_kernel_clk.ctrl baseAddress {0xc000}

add_connection pipe_stage_host_ctrl.m0 kernel_interface.kernel_cntrl avalon
set_connection_parameter_value pipe_stage_host_ctrl.m0/kernel_interface.kernel_cntrl arbitrationPriority {1}
set_connection_parameter_value pipe_stage_host_ctrl.m0/kernel_interface.kernel_cntrl baseAddress {0x4000}

add_connection pipe_stage_host_ctrl.m0 dma_0.csr avalon
set_connection_parameter_value pipe_stage_host_ctrl.m0/dma_0.csr arbitrationPriority {1}
set_connection_parameter_value pipe_stage_host_ctrl.m0/dma_0.csr baseAddress {0xc800}

add_connection dma_0.m clock_cross_dma_to_pcie.s0 avalon
set_connection_parameter_value dma_0.m/clock_cross_dma_to_pcie.s0 arbitrationPriority {1}
set_connection_parameter_value dma_0.m/clock_cross_dma_to_pcie.s0 baseAddress {0x80000000}

add_connection config_clk.out_clk acl_kernel_clk.clk clock

add_connection acl_kernel_clk.kernel_clk kernel_interface.kernel_clk clock

add_connection pcie.RxmIrq kernel_interface.kernel_irq_to_host interrupt
set_connection_parameter_value pcie.RxmIrq/kernel_interface.kernel_irq_to_host irqNumber {0}

add_connection pcie.RxmIrq dma_0.dma_irq interrupt
set_connection_parameter_value pcie.RxmIrq/dma_0.dma_irq irqNumber {1}

add_connection pcie.coreclkout kernel_interface.clk clock

add_connection ddr3b.afi_clk dma_0.clk clock

add_connection pcie.coreclkout pipe_stage_host_ctrl.clk clock

add_connection pipe_stage_host_ctrl.m0 pcie.Cra avalon
set_connection_parameter_value pipe_stage_host_ctrl.m0/pcie.Cra arbitrationPriority {1}
set_connection_parameter_value pipe_stage_host_ctrl.m0/pcie.Cra baseAddress {0x0000}

add_connection ddr3a.afi_clk pipe_stage_ddr3a_iface.clk clock

add_connection pipe_stage_ddr3a_iface.m0 pipe_stage_ddr3a_dimm.s0 avalon
set_connection_parameter_value pipe_stage_ddr3a_iface.m0/pipe_stage_ddr3a_dimm.s0 arbitrationPriority {1}
set_connection_parameter_value pipe_stage_ddr3a_iface.m0/pipe_stage_ddr3a_dimm.s0 baseAddress {0x0000}

add_connection clock_cross_kernel_mem_0.m0 em_pc_0.avl_in avalon
set_connection_parameter_value clock_cross_kernel_mem_0.m0/em_pc_0.avl_in arbitrationPriority {1}
set_connection_parameter_value clock_cross_kernel_mem_0.m0/em_pc_0.avl_in baseAddress {0x0000}

add_connection em_pc_0.avl_out pipe_stage_ddr3a_iface.s0 avalon
set_connection_parameter_value em_pc_0.avl_out/pipe_stage_ddr3a_iface.s0 arbitrationPriority {1}
set_connection_parameter_value em_pc_0.avl_out/pipe_stage_ddr3a_iface.s0 baseAddress {0x0000}

add_connection em_pc_1.avl_out pipe_stage_ddr3b_dimm.s0 avalon
set_connection_parameter_value em_pc_1.avl_out/pipe_stage_ddr3b_dimm.s0 arbitrationPriority {1}
set_connection_parameter_value em_pc_1.avl_out/pipe_stage_ddr3b_dimm.s0 baseAddress {0x0000}

add_connection acl_kernel_clk.kernel_clk clock_cross_kernel_mem_0.s0_clk clock

add_connection acl_kernel_clk.kernel_clk clock_cross_kernel_mem_1.s0_clk clock

add_connection ddr3a.afi_clk clock_cross_kernel_mem_0.m0_clk clock

add_connection ddr3b.afi_clk clock_cross_kernel_mem_1.m0_clk clock

add_connection clock_cross_kernel_mem_1.m0 em_pc_1.avl_in avalon
set_connection_parameter_value clock_cross_kernel_mem_1.m0/em_pc_1.avl_in arbitrationPriority {1}
set_connection_parameter_value clock_cross_kernel_mem_1.m0/em_pc_1.avl_in baseAddress {0x0000}

add_connection ddr3a.afi_clk em_pc_0.avl_clk clock

add_connection ddr3b.afi_clk em_pc_1.avl_clk clock

add_connection pipe_stage_host_ctrl.m0 em_pc_0.em_csr avalon
set_connection_parameter_value pipe_stage_host_ctrl.m0/em_pc_0.em_csr arbitrationPriority {1}
set_connection_parameter_value pipe_stage_host_ctrl.m0/em_pc_0.em_csr baseAddress {0x00020000}

add_connection pipe_stage_host_ctrl.m0 em_pc_1.em_csr avalon
set_connection_parameter_value pipe_stage_host_ctrl.m0/em_pc_1.em_csr arbitrationPriority {1}
set_connection_parameter_value pipe_stage_host_ctrl.m0/em_pc_1.em_csr baseAddress {0x00024000}

add_connection clock_cross_dma_to_ddr3a.m0 pipe_stage_ddr3a_iface.s0 avalon
set_connection_parameter_value clock_cross_dma_to_ddr3a.m0/pipe_stage_ddr3a_iface.s0 arbitrationPriority {1}
set_connection_parameter_value clock_cross_dma_to_ddr3a.m0/pipe_stage_ddr3a_iface.s0 baseAddress {0x0000}

add_connection acl_kernel_clk.kernel_clk kernel_clk.clk_in clock

add_connection kernel_interface.kernel_reset kernel_clk.clk_in_reset reset

add_connection pipe_stage_host_ctrl.m0 dma_0.s_nondma avalon
set_connection_parameter_value pipe_stage_host_ctrl.m0/dma_0.s_nondma arbitrationPriority {1}
set_connection_parameter_value pipe_stage_host_ctrl.m0/dma_0.s_nondma baseAddress {0x00010000}

add_connection pcie.Rxm_BAR0 pipe_stage_host_ctrl.s0 avalon
set_connection_parameter_value pcie.Rxm_BAR0/pipe_stage_host_ctrl.s0 arbitrationPriority {1}
set_connection_parameter_value pcie.Rxm_BAR0/pipe_stage_host_ctrl.s0 baseAddress {0x0000}

add_connection kernel_interface.kernel_reset clock_cross_kernel_mem_1.s0_reset reset

add_connection kernel_interface.kernel_reset clock_cross_kernel_mem_0.s0_reset reset

add_connection ddr3b.afi_clk acl_memory_bank_divider_0.clk clock

add_connection acl_kernel_clk.kernel_clk acl_memory_bank_divider_0.kernel_clk clock

add_connection kernel_interface.kernel_reset acl_memory_bank_divider_0.kernel_reset reset

add_connection dma_0.m acl_memory_bank_divider_0.s avalon
set_connection_parameter_value dma_0.m/acl_memory_bank_divider_0.s arbitrationPriority {1}
set_connection_parameter_value dma_0.m/acl_memory_bank_divider_0.s baseAddress {0x0000}

add_connection acl_memory_bank_divider_0.bank1 clock_cross_dma_to_ddr3a.s0 avalon
set_connection_parameter_value acl_memory_bank_divider_0.bank1/clock_cross_dma_to_ddr3a.s0 arbitrationPriority {1}
set_connection_parameter_value acl_memory_bank_divider_0.bank1/clock_cross_dma_to_ddr3a.s0 baseAddress {0x0000}

add_connection acl_memory_bank_divider_0.bank2 pipe_stage_ddr3b_dimm.s0 avalon
set_connection_parameter_value acl_memory_bank_divider_0.bank2/pipe_stage_ddr3b_dimm.s0 arbitrationPriority {1}
set_connection_parameter_value acl_memory_bank_divider_0.bank2/pipe_stage_ddr3b_dimm.s0 baseAddress {0x0000}

add_connection kernel_interface.acl_bsp_memorg_host acl_memory_bank_divider_0.acl_bsp_memorg_host conduit
set_connection_parameter_value kernel_interface.acl_bsp_memorg_host/acl_memory_bank_divider_0.acl_bsp_memorg_host endPort {}
set_connection_parameter_value kernel_interface.acl_bsp_memorg_host/acl_memory_bank_divider_0.acl_bsp_memorg_host endPortLSB {0}
set_connection_parameter_value kernel_interface.acl_bsp_memorg_host/acl_memory_bank_divider_0.acl_bsp_memorg_host startPort {}
set_connection_parameter_value kernel_interface.acl_bsp_memorg_host/acl_memory_bank_divider_0.acl_bsp_memorg_host startPortLSB {0}
set_connection_parameter_value kernel_interface.acl_bsp_memorg_host/acl_memory_bank_divider_0.acl_bsp_memorg_host width {0}

add_connection clock_cross_dma_to_pcie.m0 pipe_stage_txs.s0 avalon
set_connection_parameter_value clock_cross_dma_to_pcie.m0/pipe_stage_txs.s0 arbitrationPriority {1}
set_connection_parameter_value clock_cross_dma_to_pcie.m0/pipe_stage_txs.s0 baseAddress {0x0000}

add_connection pcie.coreclkout pipe_stage_txs.clk clock

add_connection pipe_stage_txs.m0 pcie.Txs avalon
set_connection_parameter_value pipe_stage_txs.m0/pcie.Txs arbitrationPriority {1}
set_connection_parameter_value pipe_stage_txs.m0/pcie.Txs baseAddress {0x0000}

add_connection config_clk.out_clk reset_counter.clk clock

add_connection global_reset.out_reset reset_counter.clk_reset reset

add_connection reset_counter.sw_reset alt_xcvr_reconfig_0.mgmt_rst_reset reset

add_connection reset_counter.sw_reset clock_cross_dma_to_pcie.s0_reset reset

add_connection reset_counter.sw_reset temperature_pll.reset reset

add_connection reset_counter.sw_reset temperature_0.clk_reset reset

add_connection reset_counter.sw_reset acl_kernel_clk.reset reset

add_connection reset_counter.sw_reset ddr3a.global_reset reset

add_connection reset_counter.sw_reset ddr3a.soft_reset reset

add_connection reset_counter.sw_reset ddr3b.global_reset reset

add_connection reset_counter.sw_reset ddr3b.soft_reset reset

add_connection pcie.coreclkout reset_controller_pcie.clk clock

add_connection ddr3a.afi_clk reset_controller_ddr3a.clk clock

add_connection ddr3b.afi_clk reset_controller_ddr3b.clk clock

add_connection reset_counter.sw_reset reset_controller_pcie.reset_in0 reset

add_connection reset_counter.sw_reset reset_controller_ddr3b.reset_in0 reset

add_connection reset_counter.sw_reset reset_controller_ddr3a.reset_in0 reset

add_connection reset_controller_pcie.reset_out pipe_stage_host_ctrl.reset reset

add_connection reset_controller_pcie.reset_out pipe_stage_txs.reset reset

add_connection reset_controller_pcie.reset_out clock_cross_dma_to_pcie.m0_reset reset

add_connection reset_controller_pcie.reset_out kernel_interface.reset reset

add_connection reset_controller_pcie.reset_out kernel_interface.sw_reset_in reset

add_connection reset_controller_ddr3b.reset_out dma_0.reset reset

add_connection reset_controller_ddr3b.reset_out acl_memory_bank_divider_0.reset reset

add_connection ddr3b.afi_clk clock_cross_dma_to_ddr3a.s0_clk clock

add_connection ddr3a.afi_clk clock_cross_dma_to_ddr3a.m0_clk clock

add_connection reset_controller_ddr3a.reset_out clock_cross_dma_to_ddr3a.m0_reset reset

add_connection reset_controller_ddr3b.reset_out clock_cross_dma_to_ddr3a.s0_reset reset

add_connection reset_controller_ddr3a.reset_out pipe_stage_ddr3a_iface.reset reset

add_connection reset_controller_ddr3a.reset_out pipe_stage_ddr3a_dimm.reset reset

add_connection reset_controller_ddr3b.reset_out pipe_stage_ddr3b_dimm.reset reset

add_connection reset_controller_ddr3a.reset_out em_pc_0.avl_reset_n reset

add_connection reset_controller_ddr3b.reset_out em_pc_1.avl_reset_n reset

add_connection kernel_interface.sw_reset_export clock_cross_kernel_mem_0.m0_reset reset

add_connection kernel_interface.sw_reset_export clock_cross_kernel_mem_1.m0_reset reset

add_connection pcie.nreset_status reset_counter.clk_reset reset

add_connection reset_counter.sw_reset npor_export.in_reset reset

# exported interfaces
add_interface global_reset reset sink
set_interface_property global_reset EXPORT_OF global_reset.in_reset
add_interface pcie_refclk clock sink
set_interface_property pcie_refclk EXPORT_OF pcie.refclk
add_interface pcie_hip_serial conduit end
set_interface_property pcie_hip_serial EXPORT_OF pcie.hip_serial
add_interface pcie_npor conduit end
set_interface_property pcie_npor EXPORT_OF pcie.npor
add_interface ddr3a conduit end
set_interface_property ddr3a EXPORT_OF ddr3a.memory
add_interface octa conduit end
set_interface_property octa EXPORT_OF ddr3a.oct
add_interface ddr3a_pll_ref clock sink
set_interface_property ddr3a_pll_ref EXPORT_OF ddr3a.pll_ref_clk
add_interface ddr3b conduit end
set_interface_property ddr3b EXPORT_OF ddr3b.memory
add_interface octb conduit end
set_interface_property octb EXPORT_OF ddr3b.oct
add_interface ddr3b_pll_ref clock sink
set_interface_property ddr3b_pll_ref EXPORT_OF ddr3b.pll_ref_clk
add_interface pcie_hip_ctrl conduit end
set_interface_property pcie_hip_ctrl EXPORT_OF pcie.hip_ctrl
add_interface config_clk clock sink
set_interface_property config_clk EXPORT_OF config_clk.in_clk
add_interface acl_internal_memorg_kernel conduit end
set_interface_property acl_internal_memorg_kernel EXPORT_OF kernel_interface.acl_bsp_memorg_kernel
add_interface kernel_clk2x clock source
set_interface_property kernel_clk2x EXPORT_OF acl_kernel_clk.kernel_clk2x
add_interface kernel_pll_refclk clock sink
set_interface_property kernel_pll_refclk EXPORT_OF acl_kernel_clk.pll_refclk
add_interface kernel_cra avalon master
set_interface_property kernel_cra EXPORT_OF kernel_interface.kernel_cra
add_interface kernel_irq interrupt receiver
set_interface_property kernel_irq EXPORT_OF kernel_interface.kernel_irq_from_kernel
add_interface kernel_mem0 avalon slave
set_interface_property kernel_mem0 EXPORT_OF clock_cross_kernel_mem_0.s0
add_interface kernel_mem1 avalon slave
set_interface_property kernel_mem1 EXPORT_OF clock_cross_kernel_mem_1.s0
add_interface acl_internal_snoop avalon_source source
set_interface_property acl_internal_snoop EXPORT_OF acl_memory_bank_divider_0.acl_bsp_snoop
add_interface kernel_clk clock source
set_interface_property kernel_clk EXPORT_OF kernel_clk.clk
add_interface kernel_reset reset source
set_interface_property kernel_reset EXPORT_OF kernel_clk.clk_reset
add_interface pcie_npor_out reset source
set_interface_property pcie_npor_out EXPORT_OF npor_export.out_reset

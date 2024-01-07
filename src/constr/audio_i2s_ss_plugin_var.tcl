
	# subsystem local structure to store available config: format [odd==Config even==value] \
	# e.g ss_router param list is 		   [list CONFIG.NUM_SI <> CONFIG.NUM_MI <>]
	variable ss_xgui_varlist [list]

	# GLOBAL VAR DECLARATION AND ASSIGNMENT
	variable var_c_placeholder         [list]

	# CONSOLE DEBUG MESSAGE PRINTING ENABLEMENT
	variable var_debug_en [list]
	set var_debug_en      0

	# EXDES PORTS INFORMATION CONTAINER
	variable vary_attr_pinlist [list]
	variable pin_cmd
	array set pin_cmd {
		ACLK                 {-dir I -type CLK}
		ARESETN              {-dir I -type RST}
		reset                {-dir I -type RST}
		S_AXI                {-mode slave -vlnv xilinx.com:interface:aximm_rtl:1.0}
		axis_audio_in        {-mode slave -vlnv xilinx.com:interface:axis_rtl:1.0}
		aud_acr_cts_in       {-dir I -from 19 -to 0}
		aud_acr_n_in         {-dir I -from 19 -to 0}
		aud_acr_valid_in     {-dir I}
		hdmi_clk             {-dir I -type CLK}
		aud_mclk             {-dir I -type CLK}
		ref_clk              {-dir I -type CLK}
		axis_audio_out       {-mode master -vlnv xilinx.com:interface:axis_rtl:1.0}
		aud_acr_cts_out      {-dir O -from 19 -to 0}
		aud_acr_n_out        {-dir O -from 19 -to 0}
		aud_acr_valid_out    {-dir O}
		audio_clk            {-dir O -type CLK}
		i2s_rx_lrclk         {-dir O}
		i2s_rx_sclk          {-dir O}
		i2s_rx_sdata         {-dir I}
		i2s_rx_intr          {-dir O -type intr}
		i2s_tx_lrclk         {-dir O}
		i2s_tx_sclk          {-dir O}
		i2s_tx_sdata         {-dir O}
		i2s_tx_intr          {-dir O -type intr}
	}

	# FOR PORT CONFIGURABILITY
	# example declaration
	# variable config_port_s_axi_cpu_aclk
	# array set config_port_s_axi_cpu_aclk {
	# 	CONFIG.ASSOCIATED_BUSIF			{S_AXI_CPU_IN}
	# 	CONFIG.ASSOCIATED_RESET			{s_axi_cpu_aresetn}
	# }
	# ** not applicable for hier


	## VAR TO KEEP BLOCK NAME WITH GENERATION CMD \
		new (HIP): when define block_cmd's block name, do exclude any numbering for permutated blocks \
		example: for xlslice_<1/2/3/...>, define it as xlslice_

	## bmak: rtl ref module gen flow is required for rtl - NEW
	## bmak: hier gen flow is required for wrapper - NEW

	variable block_cmd
	array set block_cmd {
		axi_interconnect        {-type ip -vlnv xilinx.com:ip:axi_interconnect}
		axis_data_fifo          {-type ip -vlnv xilinx.com:ip:axis_data_fifo}
		axi_gpio                {-type ip -vlnv xilinx.com:ip:axi_gpio}
		audio_clock_recovery    {-type ip -vlnv xilinx.com:ip:audio_clock_recovery_unit}
		i2s_transmitter         {-type ip -vlnv xilinx.com:ip:i2s_transmitter}
		i2s_receiver            {-type ip -vlnv xilinx.com:ip:i2s_receiver}
		rst_processor__M        {-type ip -vlnv xilinx.com:ip:proc_sys_reset}
		xlconstant              {-type ip -vlnv xilinx.com:ip:xlconstant}
		xlconcat                {-type ip -vlnv xilinx.com:ip:xlconcat}
		xlslice                 {-type ip -vlnv xilinx.com:ip:xlslice}
		hdmi_acr_ctrl           {-type module -reference hdmi_acr_ctrl}
	}

	# FOR BLOCK CONFIGURABILITY
	# example coding
	# variable config_util_vector_logic
	# array set config_util_vector_logic {
	# 	CONFIG.C_SIZE		{1}
	# 	CONFIG.C_OPERATION	{$C_OPERATION}
	# }

	variable config_axi_interconnect
	variable config_axis_data_fifo
	variable config_axi_gpio
	variable config_xlconstant0
	variable config_xlconstant1
	variable config_xlconstant2
	variable config_xlconstant3
	variable config_xlslice0
	variable config_xlslice1
	variable config_xlconcat0
	variable config_rst_processor_0_100M

	if {[array exist config_axi_interconnect]} {
		array unset config_axi_interconnect
	}
	array set config_axi_interconnect {
		CONFIG.NUM_MI              {5}
	}

	if {[array exist config_axi_gpio]} {
		array unset config_axi_gpio
	}
	array set config_axi_gpio {
        CONFIG.C_ALL_OUTPUTS       {1}
        CONFIG.C_GPIO_WIDTH        {1}
	}

	if {[array exist config_axis_data_fifo]} {
		array unset config_axis_data_fifo
	}
	array set _data_fifo {
		CONFIG.FIFO_DEPTH          {64}
		CONFIG.IS_ACLK_ASYNC       {1}
		CONFIG.TDATA_NUM_BYTES     {5}
	}

    if {[array exist config_xlconstant0]} {
        array unset config_xlconstant0
    }
    array set config_xlconstant0 {
        CONFIG.CONST_VAL           {1}
        CONFIG.CONST_WIDTH         {1}
    }

    if {[array exist config_xlconstant1]} {
        array unset config_xlconstant1
    }
    array set config_xlconstant1 {
        CONFIG.CONST_VAL           {0}
        CONFIG.CONST_WIDTH         {12}
    }

    if {[array exist config_xlconstant2]} {
        array unset config_xlconstant2
    }
    array set config_xlconstant2 {
        CONFIG.CONST_VAL           {0}
        CONFIG.CONST_WIDTH         {20}
    }

    if {[array exist config_xlconstant3]} {
        array unset config_xlconstant3
    }
    array set config_xlconstant3 {
        CONFIG.CONST_VAL           {0}
        CONFIG.CONST_WIDTH         {1}
    }

    if {[array exist config_rst_processor_0_100M]} {
        array unset config_rst_processor_0_100M
    }
    array set config_rst_processor_0_100M {
        CONFIG.RESET_BOARD_INTERFACE     {Custom}
    }

    if {[array exist config_xlslice0]} {
        array unset config_xlslice0
    }
    array set config_xlslice0 {
        CONFIG.DIN_FROM {39}
        CONFIG.DIN_TO {20}
        CONFIG.DIN_WIDTH {40}
        CONFIG.DOUT_WIDTH {20}
    }

    if {[array exist config_xlslice1]} {
        array unset config_xlslice1
    }
    array set config_xlslice1 {
        CONFIG.DIN_FROM {19}
        CONFIG.DIN_TO {0}
        CONFIG.DIN_WIDTH {40}
        CONFIG.DOUT_WIDTH {20}
    }


    if {[array exist config_xlconcat0]} {
        array unset config_xlconcat0
    }
    array set config_xlconcat0 {
	    CONFIG.NUM_PORTS {2}
    }

	## UPDATE_BD - NEW 25Nov2014 - needed for HIP
	## VARS TO CONFIGURE THE AXI-LITE ADDR MAPPING
	## assumption: top has only 1 axi-lite interconnect to control all the axi-lite traffic within the HIP
	## pending development: multilevel HIP use case that involve child HIP
	variable top_addr_axi_lite_space NA
	variable top_addr_axi_mm_space NA
	variable cur_addr_space NA
	variable addr_reg_index 0
	variable addr_reg_index_axi_mm 20
	variable config_addr_mapping_axi_lite
	variable config_addr_mapping_axi_mm


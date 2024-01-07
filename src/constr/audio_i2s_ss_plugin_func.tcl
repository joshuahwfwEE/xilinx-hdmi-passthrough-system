
# Sourcing helper functions
# set srcFile [get_files ss_plugin_util.tcl]
# source $srcFile

# source ./ss_plugin_util.tcl
source ${srcIpDir}/exdes/bd/framework/ss_plugin_util.tcl

# BELOW ARE ALL SD SPECIFIC FUNCTIONS

    # NOT APPLICABLE FOR EXDES. Just for HIP generation
    # proc to remap params, manipulate params and return post generation param [optional] list that required for data structures generation
    proc ss_param_assignment {varlist} {

        # fix and do not change
        variable ss_xgui_varlist
        set ss_xgui_varlist $varlist

        ############################## Developer define start here ############################

        # internal use variable
        variable var_c_placeholder
        variable var_debug_en

        # remapping the ss_xgui_varlist into usable variable within this proc
        set var_c_include_hdcp_1_4 [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_INCLUDE_HDCP_1_4] + 1]]
        set var_c_include_hdcp_2_2 [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_INCLUDE_HDCP_2_2] + 1]]
        set var_c_max_bits_per_component [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_MAX_BITS_PER_COMPONENT] + 1]]
        set var_c_input_pixels_per_clock [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_INPUT_PIXELS_PER_CLOCK] + 1]]
        set var_c_addr_width [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_ADDR_WIDTH] + 1]]
        set var_c_hysteresis [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_HYSTERESIS_LEVEL] + 1]]
        set var_c_vid_interface [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_VID_INTERFACE] + 1]]
        set var_c_include_low_reso_vid [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_INCLUDE_LOW_RESO_VID] + 1]]
        set var_c_include_yuv420_sup [lindex $ss_xgui_varlist [expr [lsearch $ss_xgui_varlist CONFIG.C_INCLUDE_YUV420_SUP] + 1]]

        # enable debug mode (Developer define required value: 0 - disable; 1 - enable)
        set var_debug_en 0

        # initialize and assign internal use variables - NA

        # print debug msg -  variable with its value
        if {$var_debug_en == 1} {
            puts "DBG_MSG - data structure - ss_param_assignment:"
            puts "include_hdcp_1_4           =  $var_c_include_hdcp_1_4"
            puts "include_hdcp_2_2           =  $var_c_include_hdcp_2_2"
            puts "max_bits_per_component     =  $var_c_max_bits_per_component"
            puts "input_pixels_per_clock     =  $var_c_input_pixels_per_clock"
            puts "addr_width                 =  $var_c_addr_width"
            puts "hysteresis                 =  $var_c_hysteresis"
            puts "vid_interface              =  $var_c_vid_interface"
            puts "include_low_reso_vid       =  $var_c_include_low_reso_vid"
            puts "include_yuv420_sup         =  $var_c_include_yuv420_sup"
            puts ""
        }

        ############################## Developer define end here ############################

    }

    # FOR UPDATE_BOUNDARY USAGE
    # proc to generate the bdry pins data struc that will be used for subsystem generation
    proc get_bdry_pinlist {var_connect var_topology {upvar_num 1}} {
        upvar $upvar_num $var_connect var_con
        upvar $upvar_num $var_topology var_topo

        # only define variables that needed in this proc
        variable ss_connect
        variable ss_topology

        ############################## Developer define start here ############################

        # insert required variable to be used in this proc
        variable var_c_placeholder
        variable var_debug_en

        variable pin_cmd

        # reset the data structure and assign topology
        rst_data_struc ss_connect 1
        set ss_topology audio_ss_topo

        # ss_connect(<topology>,bdry,pinlist) [<all boundary pins for one topology>]
        set ss_connect($ss_topology,bdry,pinlist) [list ACLK ARESETN reset \
                                                        S00_AXI axis_audio_in aud_acr_cts_in \
                                                        aud_acr_n_in aud_acr_valid_in hdmi_clk \
                                                        aud_mclk ref_clk axis_audio_out \
                                                        aud_acr_cts_out aud_acr_n_out aud_acr_valid_out \
                                                        audio_clk i2s_rx_lrclk \
                                                        i2s_rx_sclk i2s_rx_sdata i2s_rx_intr \
                                                        i2s_tx_lrclk i2s_tx_sclk i2s_tx_sdata \
                                                        i2s_tx_intr]

        # display debug msg
        if {$var_debug_en == 1} {
            puts "DBG_MSG - data structure - get_bdry_pinlist: [set ss_connect($ss_topology,bdry,pinlist)]"
            puts ""
        }

        ############################## Developer define end here #############################

        # transfer the result from local namespace var into common namespace var
        array set var_con  [array get ss_connect]
        set var_topo $ss_topology

    }

    # NOT APPLICABLE FOR EXDES. Just for HIP generation
    # proc to manipulate the config port table for all configurable boundary ports
    proc config_obj_port_property {tobe_config_obj_port tobe_config_obj_port_path} {

        variable ss_xgui_varlist

        ############################## Developer define start here ############################
        variable var_c_placeholder
        variable var_debug_en

        ## ** not applicable for hier

    }

    # FOR UPDATE_BD USAGE
    # proc to generate the leaf objs data struc that will be used for subsystem generation
    proc get_leaf_blocks {var_connect var_topology {upvar_num 1} {shadow_copy 1}} {
        upvar $upvar_num $var_connect var_con
        upvar $upvar_num $var_topology var_topo

        ############################## Developer define start here ############################
        # only define variables that needed in this proc
        variable var_c_placeholder
        variable var_debug_en

        # reset the data structure and assign topology
        # rst_data_struc ss_connect 1
        set ss_topology audio_ss_topo

        # ss_connect(<topology>,leaf) [<all the needed leaf object per topology>]   -- bug, cannot use common word
        set ss_connect($ss_topology,leaf) [list axi_interconnect axis_data_fifo axi_gpio \
                                                audio_clock_recovery i2s_transmitter i2s_receiver \
                                                rst_processor_0_100M xlconcat0\
                                                xlconstant0 xlconstant1 xlconstant2 xlconstant3 \
                                                xlslice0 xlslice1 hdmi_acr_ctrl]
        # display debug msg
        if {$var_debug_en == 1} {
            puts "DBG_MSG - data structure - get_leaf_blocks: [set ss_connect($ss_topology,leaf)]"
            puts ""
        }

        ############################## Developer define end here #############################

        # transfer the result from local namespace var into common namespace var
        array set var_con  [array get ss_connect]
        set var_topo $ss_topology

    }

    # proc to generate the source2target and net data strucs that will be used for subsystem generation
    proc get_ss_connectivity {var_connect var_topology {upvar_num 1}} {
        upvar $upvar_num $var_connect var_con
        upvar $upvar_num $var_topology var_topo
        variable ss_connect
        variable ss_topology

        ############################## Developer define start here ############################

        # only define variables that needed in this proc
        variable var_c_placeholder
        variable var_debug_en

        # reset the data structure and assign topology
        # rst_data_struc ss_connect 1
        set ss_topology audio_ss_topo
        set source_objs [list]
        set ss_connect($ss_topology,sourceIsInterfacePin) [list]

        lappend source_objs bdry_in
        set ss_connect($ss_topology,source2target,bdry_in,S00_AXI)           [list axi_interconnect   S00_AXI]
        set ss_connect($ss_topology,source2target,bdry_in,ACLK)              [list axi_interconnect       ACLK \
                                                                                   hdmi_acr_ctrl          axi_aclk \
                                                                                   axis_data_fifo         m_axis_aclk \
                                                                                   axi_gpio               s_axi_aclk \
                                                                                   i2s_receiver           m_axis_aud_aclk \
                                                                                   i2s_receiver           s_axi_ctrl_aclk \
                                                                                   i2s_transmitter        s_axis_aud_aclk \
                                                                                   i2s_transmitter        s_axi_ctrl_aclk \
                                                                                   audio_clock_recovery   acr_clk \
                                                                                   audio_clock_recovery   s_axi_ctrl_aclk]
        set ss_connect($ss_topology,source2target,bdry_in,ARESETN)           [list axi_interconnect       ARESETN \
                                                                                   hdmi_acr_ctrl          axi_aresetn \
                                                                                   axi_gpio               s_axi_aresetn \
                                                                                   i2s_receiver           m_axis_aud_aresetn \
                                                                                   i2s_receiver           s_axi_ctrl_aresetn \
                                                                                   i2s_transmitter        s_axis_aud_aresetn \
                                                                                   i2s_transmitter        s_axi_ctrl_aresetn \
                                                                                   audio_clock_recovery   acr_resetn \
                                                                                   audio_clock_recovery   s_axi_ctrl_aresetn]

        set ss_connect($ss_topology,source2target,bdry_in,aud_acr_cts_in)    [list audio_clock_recovery      acr_cts_in]
        set ss_connect($ss_topology,source2target,bdry_in,aud_acr_n_in)      [list audio_clock_recovery      acr_n_in]
        set ss_connect($ss_topology,source2target,bdry_in,aud_acr_valid_in)  [list audio_clock_recovery      acr_valid_in]
        set ss_connect($ss_topology,source2target,bdry_in,hdmi_clk)          [list hdmi_acr_ctrl             hdmi_clk]

        # i2s added
        set ss_connect($ss_topology,source2target,bdry_in,axis_audio_in)     [list i2s_transmitter           s_axis_aud]
        set ss_connect($ss_topology,source2target,bdry_in,i2s_rx_sdata)      [list i2s_receiver              sdata_0_in]
        set ss_connect($ss_topology,source2target,bdry_in,ref_clk)           [list audio_clock_recovery      ref_clk]
        set ss_connect($ss_topology,source2target,bdry_in,reset)             [list rst_processor_0_100M      ext_reset_in]
        set ss_connect($ss_topology,source2target,bdry_in,aud_mclk)          [list axis_data_fifo            s_axis_aclk \
                                                                                   hdmi_acr_ctrl             aud_clk \
                                                                                   i2s_receiver              aud_mclk \
                                                                                   i2s_transmitter           aud_mclk \
                                                                                   rst_processor_0_100M      slowest_sync_clk \
                                                                                   audio_clock_recovery      aud_mclk]

        for {set i 0} {$i < 5} {incr i} {
            if {$i == 0} {
                set ss_connect($ss_topology,source2target,bdry_in,ACLK)    [concat [set ss_connect($ss_topology,source2target,bdry_in,ACLK)] \
                                                                                        axi_interconnect   S0${i}_ACLK \
                                                                                        axi_interconnect   M0${i}_ACLK]
                set ss_connect($ss_topology,source2target,bdry_in,ARESETN) [concat [set ss_connect($ss_topology,source2target,bdry_in,ARESETN)] \
                                                                                        axi_interconnect   S0${i}_ARESETN \
                                                                                        axi_interconnect   M0${i}_ARESETN]
            }
            if {$i != 0} {
                set ss_connect($ss_topology,source2target,bdry_in,ACLK)     [concat [set ss_connect($ss_topology,source2target,bdry_in,ACLK)] \
                                                                                         axi_interconnect   M0${i}_ACLK]
                set ss_connect($ss_topology,source2target,bdry_in,ARESETN)  [concat [set ss_connect($ss_topology,source2target,bdry_in,ARESETN)] \
                                                                                         axi_interconnect   M0${i}_ARESETN]
            }
        }

        lappend source_objs axi_interconnect
        set ss_connect($ss_topology,source2target,axi_interconnect,M00_AXI)         [list axi_gpio               S_AXI]
        set ss_connect($ss_topology,source2target,axi_interconnect,M01_AXI)         [list hdmi_acr_ctrl          axi]
        set ss_connect($ss_topology,source2target,axi_interconnect,M02_AXI)         [list audio_clock_recovery   s_axi_ctrl]
        set ss_connect($ss_topology,source2target,axi_interconnect,M03_AXI)         [list i2s_receiver           s_axi_ctrl]
        set ss_connect($ss_topology,source2target,axi_interconnect,M04_AXI)         [list i2s_transmitter        s_axi_ctrl]

        lappend source_objs i2s_receiver
        set ss_connect($ss_topology,source2target,i2s_receiver,irq)                 [list bdry_out               i2s_rx_intr]
        set ss_connect($ss_topology,source2target,i2s_receiver,lrclk_out)           [list bdry_out               i2s_rx_lrclk]
        set ss_connect($ss_topology,source2target,i2s_receiver,sclk_out)            [list bdry_out               i2s_rx_sclk]
        set ss_connect($ss_topology,source2target,i2s_receiver,m_axis_aud)          [list bdry_out               axis_audio_out]

        lappend source_objs i2s_transmitter
        set ss_connect($ss_topology,source2target,i2s_transmitter,sdata_0_out)      [list bdry_out               i2s_tx_sdata]
        set ss_connect($ss_topology,source2target,i2s_transmitter,irq)              [list bdry_out               i2s_tx_intr]
        set ss_connect($ss_topology,source2target,i2s_transmitter,lrclk_out)        [list bdry_out               i2s_tx_lrclk]
        set ss_connect($ss_topology,source2target,i2s_transmitter,sclk_out)         [list bdry_out               i2s_tx_sclk]

        lappend source_objs audio_clock_recovery
        set ss_connect($ss_topology,source2target,audio_clock_recovery,aud_clk_out) [list bdry_out               audio_clk]

        lappend source_objs hdmi_acr_ctrl
        set ss_connect($ss_topology,source2target,hdmi_acr_ctrl,aud_acr_cts_out)    [list xlconcat0              In1]
        set ss_connect($ss_topology,source2target,hdmi_acr_ctrl,aud_acr_n_out)      [list xlconcat0              In0]
        set ss_connect($ss_topology,source2target,hdmi_acr_ctrl,aud_acr_valid_out)  [list axis_data_fifo         s_axis_tvalid]

        lappend source_objs xlconcat0
        set ss_connect($ss_topology,source2target,xlconcat0,dout)                   [list axis_data_fifo         s_axis_tdata]

        lappend source_objs axis_data_fifo
        set ss_connect($ss_topology,source2target,axis_data_fifo,m_axis_tvalid)     [list bdry_out               aud_acr_valid_out]
        set ss_connect($ss_topology,source2target,axis_data_fifo,m_axis_tdata)      [list xlslice0               Din \
                                                                                          xlslice1               Din]

        lappend source_objs xlslice0
        set ss_connect($ss_topology,source2target,xlslice0,Dout)                    [list bdry_out               aud_acr_cts_out]

        lappend source_objs xlslice1
        set ss_connect($ss_topology,source2target,xlslice1,Dout)                    [list bdry_out               aud_acr_n_out]

        lappend source_objs xlconstant0
        set ss_connect($ss_topology,source2target,xlconstant0,Dout)                 [list hdmi_acr_ctrl          pll_lock_in \
                                                                                          audio_clock_recovery   ref_clk_resetn]

        lappend source_objs xlconstant1
        set ss_connect($ss_topology,source2target,xlconstant1,Dout)                 [list audio_clock_recovery   fifo_datacount_in]

        lappend source_objs xlconstant2
        set ss_connect($ss_topology,source2target,xlconstant2,Dout)                 [list hdmi_acr_ctrl          aud_acr_cts_in \
                                                                                          hdmi_acr_ctrl          aud_acr_n_in]

        lappend source_objs xlconstant3
        set ss_connect($ss_topology,source2target,xlconstant3,Dout)                 [list hdmi_acr_ctrl          aud_acr_valid_in]

        lappend source_objs rst_processor_0_100M
        set ss_connect($ss_topology,source2target,rst_processor_0_100M,peripheral_aresetn)      [list axis_data_fifo              s_axis_aresetn]

        set ss_connect($ss_topology,source2target,rst_processor_0_100M,peripheral_reset)        [list i2s_receiver                aud_mrst \
                                                                                                      i2s_transmitter             aud_mrst \
                                                                                                      audio_clock_recovery        aud_mrst]

		lappend source_objs axi_gpio
        set ss_connect($ss_topology,source2target,axi_gpio,gpio_io_o)               [list rst_processor_0_100M   aux_reset_in]

        ## remove any numbering exist in the interface signal name for the source list e,g S01_AXI, S02_AXI,...S0*_AXI will be tagged as S_AXI
        set ss_connect($ss_topology,sourceIsInterfacePin) [list S_AXI axis_audio_in M_AXI axis_audio_out m_axis_aud]

        set ss_connect($ss_topology,source) $source_objs
        generate_net_list $var_debug_en $source_objs
        ############################## Developer define end here ############################

        # transfer the result from local namespace var into common namespace var
        array set var_con  [array get ss_connect]
        set var_topo $ss_topology

    }

    # proc to manipulate the config table for all leaf objects - DEFINE BY SUBSYSTEM DEVELOPER \
        - before going this proc, make sure the set_ss_param_varlist proc ocmpleted
    proc config_obj_property {tobe_config_obj tobe_config_obj_path} {

        variable ss_xgui_varlist

        ############################## Developer define start here ############################
        # only define variables that needed in this proc
        variable var_c_placeholder
        variable var_debug_en

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

        switch -regexp -matchvar varlist -- $tobe_config_obj {
                ^axi_interconnect    {
                                      ::ss_common::go_config $tobe_config_obj_path config_axi_interconnect
                                    }
                ^rst_processor_0_100M {
                                      ::ss_common::go_config $tobe_config_obj_path config_rst_processor_0_100M
                                    }
                ^xlconcat0          {
                                      ::ss_common::go_config $tobe_config_obj_path config_xlconcat0
                                    }
                ^xlslice0           {
                                        set config_xlslice0(CONFIG.DIN_FROM) 39
                                        set config_xlslice0(CONFIG.DIN_TO) 20
                                        set config_xlslice0(CONFIG.DIN_WIDTH) 40
                                        set config_xlslice0(CONFIG.DOUT_WIDTH) 20
                                        ::ss_common::go_config $tobe_config_obj_path config_xlslice0
                                    }
                ^xlslice1           {
                                        set config_xlslice1(CONFIG.DIN_FROM) 19
                                        set config_xlslice1(CONFIG.DIN_TO) 0
                                        set config_xlslice1(CONFIG.DIN_WIDTH) 40
                                        set config_xlslice1(CONFIG.DOUT_WIDTH) 20
                                        ::ss_common::go_config $tobe_config_obj_path config_xlslice1
                                    }
                ^xlconstant0        {
                                        set config_xlconstant0(CONFIG.CONST_VAL) 1
                                        set config_xlconstant0(CONFIG.CONST_WIDTH) 1
                                        ::ss_common::go_config $tobe_config_obj_path config_xlconstant0
                                    }

                ^xlconstant1        {
                                        set config_xlconstant1(CONFIG.CONST_VAL) 0
                                        set config_xlconstant1(CONFIG.CONST_WIDTH) 12
                                        ::ss_common::go_config $tobe_config_obj_path config_xlconstant1
                                    }

                ^xlconstant2        {
                                        set config_xlconstant2(CONFIG.CONST_VAL) 0
                                        set config_xlconstant2(CONFIG.CONST_WIDTH) 20
                                        ::ss_common::go_config $tobe_config_obj_path config_xlconstant2
                                    }

                ^xlconstant3        {
                                        set config_xlconstant3(CONFIG.CONST_VAL) 0
                                        set config_xlconstant3(CONFIG.CONST_WIDTH) 1
                                        ::ss_common::go_config $tobe_config_obj_path config_xlconstant3
                                    }
                ^axi_gpio           {
                                        set config_axi_gpio(CONFIG.C_ALL_OUTPUTS) 1
                                        set config_axi_gpio(CONFIG.C_GPIO_WIDTH) 1
                                        ::ss_common::go_config $tobe_config_obj_path config_axi_gpio
                                    }

                ^axis_data_fifo     {
                                        set config_axis_data_fifo(CONFIG.FIFO_DEPTH) 64
                                        set config_axis_data_fifo(CONFIG.IS_ACLK_ASYNC) 1
                                        set config_axis_data_fifo(CONFIG.TDATA_NUM_BYTES) 5
                                        ::ss_common::go_config $tobe_config_obj_path config_axis_data_fifo
                                    }
        }

        ############################## Developer define end here ############################

    }

    # NOT APPLICABLE FOR EXDES. Just for HIP generation
    proc config_pin_property {ss_pin_name} {

        # placeholder

    }

    # TBD for EXDEES
    # new for HIP - 25Nov2014 - proc to configure the axi-lite address mapping
    # 16 Dec 2015 - Obsolete and use tool auto address assignment
    proc assign_address_properties {} {

        ############################## Developer define start here ############################
        variable var_c_placeholder
        variable var_debug_en

        variable top_addr_axi_lite_space
        variable top_addr_axi_mm_space
        variable cur_addr_space
        variable addr_reg_index
        variable addr_reg_index_axi_mm

        variable config_addr_mapping_axi_lite
        variable config_addr_mapping_axi_mm


        ## format listing per line: leaf_object<space>AXILITE_PORT<space>addr_range<space>addr_base
        set config_addr_mapping_axi_lite [list  v_hdmi_tx   S_AXI   64k 0x10000 \
                                                v_tc        ctrl    64k 0x20000]


            # set config_addr_mapping_axi_mm [list \
            #   axi_vdma    Data_S2MM       1G  0x80000000 \
            #   axi_vdma    Data_MM2S       1G  0x80000000 \
            #   v_deinterlacer  Data_m_axi_gmem     1G  0x80000000 \
            # ]

            ## axi-mm address mapping - only needed in full-fledged
            ## ::ss_common::get_top_addr_space_axi_mm top_addr_axi_mm_space cur_addr_space
            ## ::ss_common::go_assign_address_axi_mm top_addr_axi_mm_space cur_addr_space config_addr_mapping_axi_mm addr_reg_index_axi_mm

        ## axi-lite address space mapping - needed in both topologies
        ::ss_common::get_top_addr_space top_addr_axi_lite_space cur_addr_space
        ::ss_common::go_assign_address top_addr_axi_lite_space cur_addr_space config_addr_mapping_axi_lite addr_reg_index

        ############################## Developer define end here ############################

    }


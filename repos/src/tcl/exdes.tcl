
################################################################
# This is a generated script based on design: exdes
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2022.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source exdes_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# cec, hdmi_rx_detect, aud_pat_gen, hdmi_acr_ctrl

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcvu19p-fsva3824-2-e
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name exdes

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_uartlite:2.0\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:v_hdmi_rx_ss:3.2\
xilinx.com:ip:v_hdmi_tx_ss:3.2\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:vid_phy_controller:2.2\
xilinx.com:ip:axi_vdma:6.3\
xilinx.com:ip:axis_subset_converter:1.1\
xilinx.com:ip:ddr4:2.2\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:v_tpg:8.2\
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:axi_iic:2.1\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:microblaze:11.0\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:lmb_bram_if_cntlr:4.0\
xilinx.com:ip:lmb_v10:3.0\
xilinx.com:ip:blk_mem_gen:8.4\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
cec\
hdmi_rx_detect\
aud_pat_gen\
hdmi_acr_ctrl\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: microblaze_0_local_memory
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB

  create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB


  # Create pins
  create_bd_pin -dir I -type clk SYS_CLK
  create_bd_pin -dir I -type rst SYS_Rst

  # Create instance: dlmb_bram_if_cntlr, and set properties
  set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $dlmb_bram_if_cntlr


  # Create instance: dlmb_v10, and set properties
  set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

  # Create instance: ilmb_bram_if_cntlr, and set properties
  set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
  set_property CONFIG.C_ECC {0} $ilmb_bram_if_cntlr


  # Create instance: ilmb_v10, and set properties
  set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

  # Create instance: lmb_bram, and set properties
  set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
  set_property -dict [list \
    CONFIG.EN_SAFETY_CKT {true} \
    CONFIG.Enable_32bit_Address {true} \
    CONFIG.Enable_B {Use_ENB_Pin} \
    CONFIG.Memory_Type {True_Dual_Port_RAM} \
    CONFIG.Port_B_Clock {100} \
    CONFIG.Port_B_Enable_Rate {100} \
    CONFIG.Port_B_Write_Rate {50} \
    CONFIG.Read_Width_A {32} \
    CONFIG.Read_Width_B {32} \
    CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
    CONFIG.Register_PortB_Output_of_Memory_Primitives {false} \
    CONFIG.Use_RSTA_Pin {true} \
    CONFIG.Use_RSTB_Pin {true} \
    CONFIG.Write_Width_A {32} \
    CONFIG.Write_Width_B {32} \
    CONFIG.use_bram_block {BRAM_Controller} \
  ] $lmb_bram


  # Create interface connections
  connect_bd_intf_net -intf_net dlmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
  connect_bd_intf_net -intf_net ilmb_bram_if_cntlr_BRAM_PORT [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]
  connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
  connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]

  # Create port connections
  connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins SYS_CLK] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: zynq_us_ss_0
proc create_hier_cell_zynq_us_ss_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_zynq_us_ss_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 IIC

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M01_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M02_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M05_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M06_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M08_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M09_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M10_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M11_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M12_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M13_AXI


  # Create pins
  create_bd_pin -dir O -from 0 -to 0 -type rst aresetn_100M
  create_bd_pin -dir O -from 0 -to 0 aresetn_300M
  create_bd_pin -dir I -type clk clk1
  create_bd_pin -dir I -type clk clk2
  create_bd_pin -dir I hdmi_rx_irq
  create_bd_pin -dir I hdmi_tx_irq
  create_bd_pin -dir I vphy_irq

  # Create instance: axi_intc_0, and set properties
  set axi_intc_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc_0 ]

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0 ]
  set_property -dict [list \
    CONFIG.M05_HAS_REGSLICE {4} \
    CONFIG.NUM_MI {14} \
  ] $axi_interconnect_0


  # Create instance: fmch_axi_iic, and set properties
  set fmch_axi_iic [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_iic:2.1 fmch_axi_iic ]
  set_property -dict [list \
    CONFIG.IIC_BOARD_INTERFACE {Custom} \
    CONFIG.USE_BOARD_FLOW {true} \
  ] $fmch_axi_iic


  # Create instance: mdm_1, and set properties
  set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]
  set_property -dict [list \
    CONFIG.C_ADDR_SIZE {32} \
    CONFIG.C_DBG_MEM_ACCESS {0} \
    CONFIG.C_DBG_REG_ACCESS {1} \
    CONFIG.C_JTAG_CHAIN {2} \
    CONFIG.C_M_AXI_ADDR_WIDTH {32} \
    CONFIG.C_S_AXI_ADDR_WIDTH {5} \
    CONFIG.C_USE_CROSS_TRIGGER {0} \
    CONFIG.C_USE_UART {1} \
  ] $mdm_1


  # Create instance: microblaze_0, and set properties
  set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]
  set_property -dict [list \
    CONFIG.C_DEBUG_ENABLED {1} \
    CONFIG.C_D_AXI {1} \
    CONFIG.C_D_LMB {1} \
    CONFIG.C_I_LMB {1} \
  ] $microblaze_0


  # Create instance: microblaze_0_local_memory
  create_hier_cell_microblaze_0_local_memory $hier_obj microblaze_0_local_memory

  # Create instance: rst_processor_1_100M, and set properties
  set rst_processor_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processor_1_100M ]

  # Create instance: rst_processor_1_300M, and set properties
  set rst_processor_1_300M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_processor_1_300M ]

  # Create instance: xlconcat0, and set properties
  set xlconcat0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat0 ]
  set_property CONFIG.NUM_PORTS {4} $xlconcat0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M09_AXI] [get_bd_intf_pins axi_interconnect_0/M09_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M12_AXI] [get_bd_intf_pins axi_interconnect_0/M12_AXI]
  connect_bd_intf_net -intf_net axi_intc_0_interrupt [get_bd_intf_pins axi_intc_0/interrupt] [get_bd_intf_pins microblaze_0/INTERRUPT]
  connect_bd_intf_net -intf_net axi_interconnect_0_M03_AXI [get_bd_intf_pins axi_interconnect_0/M03_AXI] [get_bd_intf_pins mdm_1/S_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M07_AXI [get_bd_intf_pins axi_intc_0/s_axi] [get_bd_intf_pins axi_interconnect_0/M07_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M10_AXI [get_bd_intf_pins M10_AXI] [get_bd_intf_pins axi_interconnect_0/M10_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M11_AXI [get_bd_intf_pins M11_AXI] [get_bd_intf_pins axi_interconnect_0/M11_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M13_AXI [get_bd_intf_pins M13_AXI] [get_bd_intf_pins axi_interconnect_0/M13_AXI]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_0_M00_AXI [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_interconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_0_M01_AXI [get_bd_intf_pins M01_AXI] [get_bd_intf_pins axi_interconnect_0/M01_AXI]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_0_M02_AXI [get_bd_intf_pins M02_AXI] [get_bd_intf_pins axi_interconnect_0/M02_AXI]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_0_M04_AXI [get_bd_intf_pins axi_interconnect_0/M04_AXI] [get_bd_intf_pins fmch_axi_iic/S_AXI]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_0_M05_AXI [get_bd_intf_pins M05_AXI] [get_bd_intf_pins axi_interconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_0_M06_AXI [get_bd_intf_pins M06_AXI] [get_bd_intf_pins axi_interconnect_0/M06_AXI]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_0_M08_AXI [get_bd_intf_pins M08_AXI] [get_bd_intf_pins axi_interconnect_0/M08_AXI]
  connect_bd_intf_net -intf_net intf_net_fmch_axi_iic_IIC [get_bd_intf_pins IIC] [get_bd_intf_pins fmch_axi_iic/IIC]
  connect_bd_intf_net -intf_net mdm_1_MBDEBUG_0 [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
  connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins axi_interconnect_0/S00_AXI] [get_bd_intf_pins microblaze_0/M_AXI_DP]
  connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
  connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]

  # Create port connections
  connect_bd_net -net mdm_1_Debug_SYS_Rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_processor_1_100M/mb_debug_sys_rst]
  connect_bd_net -net mdm_1_Interrupt [get_bd_pins mdm_1/Interrupt] [get_bd_pins xlconcat0/In3]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins clk1] [get_bd_pins axi_intc_0/s_axi_aclk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/M01_ACLK] [get_bd_pins axi_interconnect_0/M02_ACLK] [get_bd_pins axi_interconnect_0/M03_ACLK] [get_bd_pins axi_interconnect_0/M04_ACLK] [get_bd_pins axi_interconnect_0/M06_ACLK] [get_bd_pins axi_interconnect_0/M07_ACLK] [get_bd_pins axi_interconnect_0/M09_ACLK] [get_bd_pins axi_interconnect_0/M10_ACLK] [get_bd_pins axi_interconnect_0/M11_ACLK] [get_bd_pins axi_interconnect_0/M13_ACLK] [get_bd_pins axi_interconnect_0/S00_ACLK] [get_bd_pins fmch_axi_iic/s_axi_aclk] [get_bd_pins mdm_1/S_AXI_ACLK] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_local_memory/SYS_CLK] [get_bd_pins rst_processor_1_100M/slowest_sync_clk]
  connect_bd_net -net net_bdry_in_hdmi_rx_irq [get_bd_pins hdmi_rx_irq] [get_bd_pins xlconcat0/In1]
  connect_bd_net -net net_bdry_in_hdmi_tx_irq [get_bd_pins hdmi_tx_irq] [get_bd_pins xlconcat0/In2]
  connect_bd_net -net net_bdry_in_vphy_irq [get_bd_pins vphy_irq] [get_bd_pins xlconcat0/In0]
  connect_bd_net -net net_rst_processor_1_100M_interconnect_aresetn [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins rst_processor_1_100M/interconnect_aresetn]
  connect_bd_net -net net_rst_processor_1_100M_peripheral_aresetn [get_bd_pins aresetn_100M] [get_bd_pins axi_intc_0/s_axi_aresetn] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/M01_ARESETN] [get_bd_pins axi_interconnect_0/M02_ARESETN] [get_bd_pins axi_interconnect_0/M03_ARESETN] [get_bd_pins axi_interconnect_0/M04_ARESETN] [get_bd_pins axi_interconnect_0/M06_ARESETN] [get_bd_pins axi_interconnect_0/M07_ARESETN] [get_bd_pins axi_interconnect_0/M09_ARESETN] [get_bd_pins axi_interconnect_0/M10_ARESETN] [get_bd_pins axi_interconnect_0/M11_ARESETN] [get_bd_pins axi_interconnect_0/M13_ARESETN] [get_bd_pins axi_interconnect_0/S00_ARESETN] [get_bd_pins fmch_axi_iic/s_axi_aresetn] [get_bd_pins mdm_1/S_AXI_ARESETN] [get_bd_pins rst_processor_1_100M/peripheral_aresetn]
  connect_bd_net -net net_rst_processor_1_300M_interconnect_aresetn [get_bd_pins axi_interconnect_0/M05_ARESETN] [get_bd_pins axi_interconnect_0/M08_ARESETN] [get_bd_pins axi_interconnect_0/M12_ARESETN] [get_bd_pins rst_processor_1_300M/interconnect_aresetn]
  connect_bd_net -net net_rst_processor_1_300M_peripheral_aresetn [get_bd_pins aresetn_300M] [get_bd_pins rst_processor_1_300M/peripheral_aresetn]
  connect_bd_net -net net_zynq_us_pl_clk1 [get_bd_pins clk2] [get_bd_pins axi_interconnect_0/M05_ACLK] [get_bd_pins axi_interconnect_0/M08_ACLK] [get_bd_pins axi_interconnect_0/M12_ACLK] [get_bd_pins rst_processor_1_300M/slowest_sync_clk]
  connect_bd_net -net rst_processor_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_processor_1_100M/bus_struct_reset]
  connect_bd_net -net rst_processor_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_processor_1_100M/mb_reset]
  connect_bd_net -net xlconcat0_dout [get_bd_pins axi_intc_0/intr] [get_bd_pins xlconcat0/dout]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins rst_processor_1_100M/aux_reset_in] [get_bd_pins rst_processor_1_100M/dcm_locked] [get_bd_pins rst_processor_1_100M/ext_reset_in] [get_bd_pins rst_processor_1_300M/aux_reset_in] [get_bd_pins rst_processor_1_300M/dcm_locked] [get_bd_pins rst_processor_1_300M/ext_reset_in] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: v_tpg_ss_0
proc create_hier_cell_v_tpg_ss_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_v_tpg_ss_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_GPIO

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_TPG

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis_video

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis_video


  # Create pins
  create_bd_pin -dir I -type clk ap_clk
  create_bd_pin -dir I -type rst m_axi_aresetn

  # Create instance: axi_gpio, and set properties
  set axi_gpio [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
  ] $axi_gpio


  # Create instance: v_tpg, and set properties
  set v_tpg [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_tpg:8.2 v_tpg ]
  set_property -dict [list \
    CONFIG.COLOR_SWEEP {0} \
    CONFIG.DISPLAY_PORT {0} \
    CONFIG.FOREGROUND {0} \
    CONFIG.HAS_AXI4S_SLAVE {1} \
    CONFIG.MAX_DATA_WIDTH {8} \
    CONFIG.MAX_ROWS {4096} \
    CONFIG.RAMP {0} \
    CONFIG.SAMPLES_PER_CLOCK {2} \
    CONFIG.SOLID_COLOR {0} \
    CONFIG.ZONE_PLATE {0} \
  ] $v_tpg


  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_bdry_in_S_AXI_GPIO [get_bd_intf_pins S_AXI_GPIO] [get_bd_intf_pins axi_gpio/S_AXI]
  connect_bd_intf_net -intf_net intf_net_bdry_in_S_AXI_TPG [get_bd_intf_pins S_AXI_TPG] [get_bd_intf_pins v_tpg/s_axi_CTRL]
  connect_bd_intf_net -intf_net s_axis_video_1 [get_bd_intf_pins s_axis_video] [get_bd_intf_pins v_tpg/s_axis_video]
  connect_bd_intf_net -intf_net v_tpg_m_axis_video [get_bd_intf_pins m_axis_video] [get_bd_intf_pins v_tpg/m_axis_video]

  # Create port connections
  connect_bd_net -net net_axi_gpio_gpio_io_o [get_bd_pins axi_gpio/gpio_io_o] [get_bd_pins v_tpg/ap_rst_n]
  connect_bd_net -net net_bdry_in_ap_clk [get_bd_pins ap_clk] [get_bd_pins axi_gpio/s_axi_aclk] [get_bd_pins v_tpg/ap_clk]
  connect_bd_net -net net_bdry_in_m_axi_aresetn [get_bd_pins m_axi_aresetn] [get_bd_pins axi_gpio/s_axi_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: audio_ss_0
proc create_hier_cell_audio_ss_0 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_audio_ss_0() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 axis_audio_in

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 axis_audio_out


  # Create pins
  create_bd_pin -dir I -type clk ACLK
  create_bd_pin -dir I -type rst ARESETN
  create_bd_pin -dir I -from 19 -to 0 aud_acr_cts_in
  create_bd_pin -dir O -from 19 -to 0 aud_acr_cts_out
  create_bd_pin -dir I -from 19 -to 0 aud_acr_n_in
  create_bd_pin -dir O -from 19 -to 0 aud_acr_n_out
  create_bd_pin -dir I aud_acr_valid_in
  create_bd_pin -dir O aud_acr_valid_out
  create_bd_pin -dir O -type rst aud_rstn
  create_bd_pin -dir O -type clk audio_clk
  create_bd_pin -dir I -type clk hdmi_clk
  create_bd_pin -dir O locked
  create_bd_pin -dir O -from 0 -to 0 -type rst peripheral_aresetn

  # Create instance: aud_pat_gen, and set properties
  set block_name aud_pat_gen
  set block_cell_name aud_pat_gen
  if { [catch {set aud_pat_gen [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $aud_pat_gen eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
  set_property CONFIG.NUM_MI {3} $axi_interconnect


  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
  set_property -dict [list \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.USE_DYN_RECONFIG {true} \
  ] $clk_wiz


  # Create instance: hdmi_acr_ctrl, and set properties
  set block_name hdmi_acr_ctrl
  set block_cell_name hdmi_acr_ctrl
  if { [catch {set hdmi_acr_ctrl [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $hdmi_acr_ctrl eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: rst_audio_ss_0_100M, and set properties
  set rst_audio_ss_0_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_audio_ss_0_100M ]

  # Create interface connections
  connect_bd_intf_net -intf_net intf_net_aud_pat_gen_axis_audio_out [get_bd_intf_pins axis_audio_out] [get_bd_intf_pins aud_pat_gen/axis_audio_out]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_M00_AXI [get_bd_intf_pins aud_pat_gen/axi] [get_bd_intf_pins axi_interconnect/M00_AXI]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_M01_AXI [get_bd_intf_pins axi_interconnect/M01_AXI] [get_bd_intf_pins hdmi_acr_ctrl/axi]
  connect_bd_intf_net -intf_net intf_net_axi_interconnect_M02_AXI [get_bd_intf_pins axi_interconnect/M02_AXI] [get_bd_intf_pins clk_wiz/s_axi_lite]
  connect_bd_intf_net -intf_net intf_net_bdry_in_S00_AXI [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect/S00_AXI]
  connect_bd_intf_net -intf_net intf_net_bdry_in_axis_audio_in [get_bd_intf_pins axis_audio_in] [get_bd_intf_pins aud_pat_gen/axis_audio_in]

  # Create port connections
  connect_bd_net -net microblaze_0_Clk [get_bd_pins audio_clk] [get_bd_pins aud_pat_gen/aud_clk] [get_bd_pins aud_pat_gen/axis_clk] [get_bd_pins clk_wiz/clk_out1] [get_bd_pins hdmi_acr_ctrl/aud_clk] [get_bd_pins rst_audio_ss_0_100M/slowest_sync_clk]
  connect_bd_net -net net_bdry_in_ACLK [get_bd_pins ACLK] [get_bd_pins aud_pat_gen/axi_aclk] [get_bd_pins axi_interconnect/ACLK] [get_bd_pins axi_interconnect/M00_ACLK] [get_bd_pins axi_interconnect/M01_ACLK] [get_bd_pins axi_interconnect/M02_ACLK] [get_bd_pins axi_interconnect/S00_ACLK] [get_bd_pins clk_wiz/clk_in1] [get_bd_pins clk_wiz/s_axi_aclk] [get_bd_pins hdmi_acr_ctrl/axi_aclk]
  connect_bd_net -net net_bdry_in_ARESETN [get_bd_pins ARESETN] [get_bd_pins aud_pat_gen/axi_aresetn] [get_bd_pins axi_interconnect/ARESETN] [get_bd_pins axi_interconnect/M00_ARESETN] [get_bd_pins axi_interconnect/M01_ARESETN] [get_bd_pins axi_interconnect/M02_ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN] [get_bd_pins clk_wiz/s_axi_aresetn] [get_bd_pins hdmi_acr_ctrl/axi_aresetn] [get_bd_pins rst_audio_ss_0_100M/ext_reset_in]
  connect_bd_net -net net_bdry_in_aud_acr_cts_in [get_bd_pins aud_acr_cts_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_cts_in]
  connect_bd_net -net net_bdry_in_aud_acr_n_in [get_bd_pins aud_acr_n_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_n_in]
  connect_bd_net -net net_bdry_in_aud_acr_valid_in [get_bd_pins aud_acr_valid_in] [get_bd_pins hdmi_acr_ctrl/aud_acr_valid_in]
  connect_bd_net -net net_bdry_in_hdmi_clk [get_bd_pins hdmi_clk] [get_bd_pins hdmi_acr_ctrl/hdmi_clk]
  connect_bd_net -net net_clk_wiz_locked [get_bd_pins locked] [get_bd_pins clk_wiz/locked] [get_bd_pins hdmi_acr_ctrl/pll_lock_in]
  connect_bd_net -net net_hdmi_acr_ctrl_aud_acr_cts_out [get_bd_pins aud_acr_cts_out] [get_bd_pins hdmi_acr_ctrl/aud_acr_cts_out]
  connect_bd_net -net net_hdmi_acr_ctrl_aud_acr_n_out [get_bd_pins aud_acr_n_out] [get_bd_pins hdmi_acr_ctrl/aud_acr_n_out]
  connect_bd_net -net net_hdmi_acr_ctrl_aud_acr_valid_out [get_bd_pins aud_acr_valid_out] [get_bd_pins hdmi_acr_ctrl/aud_acr_valid_out]
  connect_bd_net -net net_hdmi_acr_ctrl_aud_resetn_out [get_bd_pins aud_rstn] [get_bd_pins aud_pat_gen/axis_resetn] [get_bd_pins hdmi_acr_ctrl/aud_resetn_out]
  connect_bd_net -net rst_audio_ss_0_100M_peripheral_aresetn [get_bd_pins peripheral_aresetn] [get_bd_pins rst_audio_ss_0_100M/peripheral_aresetn]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: VDMA_SYS
proc create_hier_cell_VDMA_SYS { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_VDMA_SYS() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C0_DDR4

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C0_SYS_CLK_0

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 M_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S02_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S_AXI_LITE


  # Create pins
  create_bd_pin -dir I -type clk aclk
  create_bd_pin -dir I -type rst aresetn
  create_bd_pin -dir I -type rst axi_resetn
  create_bd_pin -dir O -type clk c0_ddr4_ui_clk
  create_bd_pin -dir O c0_init_calib_complete
  create_bd_pin -dir O -from 0 -to 0 ddr4ht3_refclk_en_n
  create_bd_pin -dir I -type clk s_axi_lite_aclk
  create_bd_pin -dir O tlast_o
  create_bd_pin -dir O -from 0 -to 0 tuser_o
  create_bd_pin -dir O tvalid_o

  # Create instance: axi_vdma_0, and set properties
  set axi_vdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vdma:6.3 axi_vdma_0 ]
  set_property -dict [list \
    CONFIG.c_m_axi_mm2s_data_width {128} \
    CONFIG.c_m_axi_s2mm_data_width {128} \
    CONFIG.c_m_axis_mm2s_tdata_width {64} \
    CONFIG.c_mm2s_linebuffer_depth {512} \
    CONFIG.c_mm2s_max_burst_length {64} \
    CONFIG.c_s2mm_linebuffer_depth {4096} \
    CONFIG.c_s2mm_max_burst_length {64} \
  ] $axi_vdma_0


  # Create instance: axis_subset_converter_0, and set properties
  set axis_subset_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_0 ]
  set_property -dict [list \
    CONFIG.M_HAS_TLAST {1} \
    CONFIG.M_TDATA_NUM_BYTES {8} \
    CONFIG.M_TUSER_WIDTH {1} \
    CONFIG.S_HAS_TLAST {1} \
    CONFIG.S_TDATA_NUM_BYTES {6} \
    CONFIG.S_TUSER_WIDTH {1} \
    CONFIG.TDATA_REMAP {8'b00000000,tdata[47:40],tdata[39:32],tdata[31:24],8'b00000000,tdata[23:16],tdata[15:8],tdata[7:0]} \
    CONFIG.TLAST_REMAP {tlast[0]} \
    CONFIG.TUSER_REMAP {tuser[0:0]} \
  ] $axis_subset_converter_0


  # Create instance: axis_subset_converter_1, and set properties
  set axis_subset_converter_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axis_subset_converter:1.1 axis_subset_converter_1 ]
  set_property -dict [list \
    CONFIG.M_HAS_TLAST {1} \
    CONFIG.M_HAS_TREADY {1} \
    CONFIG.M_TDATA_NUM_BYTES {6} \
    CONFIG.M_TUSER_WIDTH {1} \
    CONFIG.S_HAS_TLAST {1} \
    CONFIG.S_HAS_TREADY {1} \
    CONFIG.S_TDATA_NUM_BYTES {8} \
    CONFIG.S_TUSER_WIDTH {1} \
    CONFIG.TDATA_REMAP {tdata[55:48],tdata[47:40],tdata[39:32],tdata[23:16],tdata[15:8],tdata[7:0]} \
    CONFIG.TKEEP_REMAP {tkeep[5:0]} \
    CONFIG.TLAST_REMAP {tlast[0]} \
    CONFIG.TUSER_REMAP {tuser[0:0]} \
  ] $axis_subset_converter_1


  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:ddr4:2.2 ddr4_0 ]
  set_property -dict [list \
    CONFIG.C0.CKE_WIDTH {2} \
    CONFIG.C0.CS_WIDTH {2} \
    CONFIG.C0.DDR4_AxiAddressWidth {33} \
    CONFIG.C0.DDR4_AxiDataWidth {512} \
    CONFIG.C0.DDR4_AxiIDWidth {1} \
    CONFIG.C0.DDR4_CasLatency {11} \
    CONFIG.C0.DDR4_CasWriteLatency {9} \
    CONFIG.C0.DDR4_DataMask {NO_DM_NO_DBI} \
    CONFIG.C0.DDR4_DataWidth {72} \
    CONFIG.C0.DDR4_EN_PARITY {true} \
    CONFIG.C0.DDR4_InputClockPeriod {5000} \
    CONFIG.C0.DDR4_MemoryPart {MTA18ASF1G72PDZ-2G1} \
    CONFIG.C0.DDR4_MemoryType {RDIMMs} \
    CONFIG.C0.DDR4_TimePeriod {1250} \
    CONFIG.C0.ODT_WIDTH {2} \
  ] $ddr4_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.NUM_CLKS {3} \
    CONFIG.NUM_MI {2} \
    CONFIG.NUM_SI {3} \
  ] $smartconnect_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {1} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_1


  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_1 [get_bd_intf_pins C0_SYS_CLK_0] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXIS] [get_bd_intf_pins axis_subset_converter_1/M_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets Conn1]
  connect_bd_intf_net -intf_net S02_AXI_1 [get_bd_intf_pins S02_AXI] [get_bd_intf_pins smartconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net S_AXIS_1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_subset_converter_0/S_AXIS]
  connect_bd_intf_net -intf_net S_AXI_LITE_1 [get_bd_intf_pins S_AXI_LITE] [get_bd_intf_pins axi_vdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXIS_MM2S [get_bd_intf_pins axi_vdma_0/M_AXIS_MM2S] [get_bd_intf_pins axis_subset_converter_1/S_AXIS]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_MM2S [get_bd_intf_pins axi_vdma_0/M_AXI_MM2S] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_vdma_0_M_AXI_S2MM [get_bd_intf_pins axi_vdma_0/M_AXI_S2MM] [get_bd_intf_pins smartconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_pins C0_DDR4] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI_CTRL] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]

  # Create port connections
  connect_bd_net -net axi_resetn_1 [get_bd_pins axi_resetn] [get_bd_pins axi_vdma_0/axi_resetn]
  connect_bd_net -net axi_vdma_0_s_axis_s2mm_tready [get_bd_pins axi_vdma_0/s_axis_s2mm_tready] [get_bd_pins axis_subset_converter_0/m_axis_tready]
  connect_bd_net -net axis_subset_converter_0_m_axis_tdata [get_bd_pins axi_vdma_0/s_axis_s2mm_tdata] [get_bd_pins axis_subset_converter_0/m_axis_tdata]
  connect_bd_net -net axis_subset_converter_0_m_axis_tlast [get_bd_pins tlast_o] [get_bd_pins axi_vdma_0/s_axis_s2mm_tlast] [get_bd_pins axis_subset_converter_0/m_axis_tlast]
  connect_bd_net -net axis_subset_converter_0_m_axis_tuser [get_bd_pins tuser_o] [get_bd_pins axi_vdma_0/s_axis_s2mm_tuser] [get_bd_pins axis_subset_converter_0/m_axis_tuser]
  connect_bd_net -net axis_subset_converter_0_m_axis_tvalid [get_bd_pins tvalid_o] [get_bd_pins axi_vdma_0/s_axis_s2mm_tvalid] [get_bd_pins axis_subset_converter_0/m_axis_tvalid]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins c0_ddr4_ui_clk] [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk2]
  connect_bd_net -net ddr4_0_c0_init_calib_complete [get_bd_pins c0_init_calib_complete] [get_bd_pins ddr4_0/c0_init_calib_complete]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets ddr4_0_c0_init_calib_complete]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins aclk] [get_bd_pins axi_vdma_0/m_axi_mm2s_aclk] [get_bd_pins axi_vdma_0/m_axi_s2mm_aclk] [get_bd_pins axi_vdma_0/m_axis_mm2s_aclk] [get_bd_pins axi_vdma_0/s_axis_s2mm_aclk] [get_bd_pins axis_subset_converter_0/aclk] [get_bd_pins axis_subset_converter_1/aclk] [get_bd_pins smartconnect_0/aclk1]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins aresetn] [get_bd_pins axis_subset_converter_0/aresetn] [get_bd_pins axis_subset_converter_1/aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins s_axi_lite_aclk] [get_bd_pins axi_vdma_0/s_axi_lite_aclk] [get_bd_pins smartconnect_0/aclk]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins proc_sys_reset_0/peripheral_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins ddr4ht3_refclk_en_n] [get_bd_pins ddr4_0/sys_rst] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set C0_DDR4 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C0_DDR4 ]

  set C0_SYS_CLK_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 C0_SYS_CLK_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $C0_SYS_CLK_0

  set CLK_IN1_D [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN1_D ]

  set HDMI_CTL [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 HDMI_CTL ]

  set RX_DDC_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 RX_DDC_OUT ]

  set TX_DDC_OUT [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:iic_rtl:1.0 TX_DDC_OUT ]

  set UART [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 UART ]


  # Create ports
  set HDMI_RX_CLK_N_IN [ create_bd_port -dir I HDMI_RX_CLK_N_IN ]
  set HDMI_RX_CLK_P_IN [ create_bd_port -dir I HDMI_RX_CLK_P_IN ]
  set HDMI_RX_DAT_N_IN [ create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_N_IN ]
  set HDMI_RX_DAT_P_IN [ create_bd_port -dir I -from 2 -to 0 HDMI_RX_DAT_P_IN ]
  set HDMI_Si5324C_LOL_IN [ create_bd_port -dir I HDMI_Si5324C_LOL_IN ]
  set HDMI_TX_CLK_N_OUT [ create_bd_port -dir O HDMI_TX_CLK_N_OUT ]
  set HDMI_TX_CLK_P_OUT [ create_bd_port -dir O HDMI_TX_CLK_P_OUT ]
  set HDMI_TX_DAT_N_OUT [ create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_N_OUT ]
  set HDMI_TX_DAT_P_OUT [ create_bd_port -dir O -from 2 -to 0 HDMI_TX_DAT_P_OUT ]
  set RX_DET_IN [ create_bd_port -dir I RX_DET_IN ]
  set RX_HPD_OUT [ create_bd_port -dir O RX_HPD_OUT ]
  set RX_REFCLK_N_OUT [ create_bd_port -dir O RX_REFCLK_N_OUT ]
  set RX_REFCLK_P_OUT [ create_bd_port -dir O RX_REFCLK_P_OUT ]
  set TX_EN_OUT [ create_bd_port -dir O -from 0 -to 0 TX_EN_OUT ]
  set TX_HPD_IN [ create_bd_port -dir I TX_HPD_IN ]
  set TX_REFCLK_N_IN [ create_bd_port -dir I TX_REFCLK_N_IN ]
  set TX_REFCLK_P_IN [ create_bd_port -dir I TX_REFCLK_P_IN ]
  set cec [ create_bd_port -dir O cec ]
  set ddr4ht3_refclk_en_n [ create_bd_port -dir O -from 0 -to 0 ddr4ht3_refclk_en_n ]

  # Create instance: VDMA_SYS
  create_hier_cell_VDMA_SYS [current_bd_instance .] VDMA_SYS

  # Create instance: audio_ss_0
  create_hier_cell_audio_ss_0 [current_bd_instance .] audio_ss_0

  # Create instance: axi_uartlite_0, and set properties
  set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]

  # Create instance: cec_0, and set properties
  set block_name cec
  set block_cell_name cec_0
  if { [catch {set cec_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $cec_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT2_JITTER {94.862} \
    CONFIG.CLKOUT2_PHASE_ERROR {87.180} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {300.000} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
    CONFIG.NUM_OUT_CLKS {2} \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $clk_wiz_0


  # Create instance: hdmi_rx_detect_0, and set properties
  set block_name hdmi_rx_detect
  set block_cell_name hdmi_rx_detect_0
  if { [catch {set hdmi_rx_detect_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $hdmi_rx_detect_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {MIX} \
    CONFIG.C_NUM_MONITOR_SLOTS {3} \
    CONFIG.C_NUM_OF_PROBES {3} \
    CONFIG.C_PROBE2_TYPE {0} \
    CONFIG.C_SLOT {0} \
    CONFIG.C_SLOT_0_APC_EN {0} \
    CONFIG.C_SLOT_0_AXIS_TDATA_WIDTH {48} \
    CONFIG.C_SLOT_0_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_0_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_0_TYPE {0} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_1_TYPE {0} \
    CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_2_TYPE {0} \
    CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_3_TYPE {0} \
    CONFIG.C_SLOT_4_APC_EN {0} \
    CONFIG.C_SLOT_4_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_4_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_4_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_4_TYPE {0} \
    CONFIG.C_SLOT_5_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
  ] $system_ila_0


  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property CONFIG.C_MON_TYPE {NATIVE} $system_ila_1


  # Create instance: system_ila_2, and set properties
  set system_ila_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_2 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {INTERFACE} \
    CONFIG.C_NUM_MONITOR_SLOTS {2} \
    CONFIG.C_SLOT_0_APC_EN {0} \
    CONFIG.C_SLOT_0_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_0_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
    CONFIG.C_SLOT_1_APC_EN {0} \
    CONFIG.C_SLOT_1_AXI_DATA_SEL {1} \
    CONFIG.C_SLOT_1_AXI_TRIG_SEL {1} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
  ] $system_ila_2


  # Create instance: v_hdmi_rx_ss, and set properties
  set v_hdmi_rx_ss [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_rx_ss:3.2 v_hdmi_rx_ss ]
  set_property -dict [list \
    CONFIG.C_ADDR_WIDTH {10} \
    CONFIG.C_ADD_MARK_DBG {0} \
    CONFIG.C_CD_INVERT {true} \
    CONFIG.C_EDID_RAM_SIZE {256} \
    CONFIG.C_EXDES_TX_PLL_SELECTION {6} \
    CONFIG.C_HDMI_FAST_SWITCH {true} \
    CONFIG.C_HPD_INVERT {false} \
    CONFIG.C_INCLUDE_HDCP_1_4 {false} \
    CONFIG.C_INCLUDE_HDCP_2_2 {false} \
    CONFIG.C_INCLUDE_LOW_RESO_VID {false} \
    CONFIG.C_INCLUDE_YUV420_SUP {false} \
    CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
    CONFIG.C_MAX_BITS_PER_COMPONENT {8} \
    CONFIG.C_VALIDATION_ENABLE {false} \
    CONFIG.C_VID_INTERFACE {0} \
  ] $v_hdmi_rx_ss


  # Create instance: v_hdmi_tx_ss, and set properties
  set v_hdmi_tx_ss [ create_bd_cell -type ip -vlnv xilinx.com:ip:v_hdmi_tx_ss:3.2 v_hdmi_tx_ss ]
  set_property -dict [list \
    CONFIG.C_ADDR_WIDTH {10} \
    CONFIG.C_ADD_MARK_DBG {0} \
    CONFIG.C_EXDES_AXILITE_FREQ {100} \
    CONFIG.C_EXDES_NIDRU {true} \
    CONFIG.C_EXDES_RX_PLL_SELECTION {0} \
    CONFIG.C_EXDES_TOPOLOGY {0} \
    CONFIG.C_EXDES_TX_PLL_SELECTION {6} \
    CONFIG.C_HDMI_FAST_SWITCH {true} \
    CONFIG.C_HPD_INVERT {false} \
    CONFIG.C_HYSTERESIS_LEVEL {12} \
    CONFIG.C_INCLUDE_HDCP_1_4 {false} \
    CONFIG.C_INCLUDE_HDCP_2_2 {false} \
    CONFIG.C_INCLUDE_LOW_RESO_VID {false} \
    CONFIG.C_INCLUDE_YUV420_SUP {false} \
    CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
    CONFIG.C_MAX_BITS_PER_COMPONENT {8} \
    CONFIG.C_VALIDATION_ENABLE {false} \
    CONFIG.C_VIDEO_MASK_ENABLE {1} \
    CONFIG.C_VID_INTERFACE {0} \
  ] $v_hdmi_tx_ss


  # Create instance: v_tpg_ss_0
  create_hier_cell_v_tpg_ss_0 [current_bd_instance .] v_tpg_ss_0

  # Create instance: vcc_const, and set properties
  set vcc_const [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 vcc_const ]
  set_property CONFIG.CONST_VAL {1} $vcc_const


  # Create instance: vid_phy_controller, and set properties
  set vid_phy_controller [ create_bd_cell -type ip -vlnv xilinx.com:ip:vid_phy_controller:2.2 vid_phy_controller ]
  set_property -dict [list \
    CONFIG.CHANNEL_ENABLE {X0Y8 X0Y9 X0Y10} \
    CONFIG.CHANNEL_SITE {X0Y8} \
    CONFIG.C_FOR_UPGRADE_ARCHITECTURE {zynquplus} \
    CONFIG.C_FOR_UPGRADE_DEVICE {xczu7ev} \
    CONFIG.C_FOR_UPGRADE_PACKAGE {ffvc1156} \
    CONFIG.C_FOR_UPGRADE_PART {xczu7ev-ffvc1156-2-e} \
    CONFIG.C_FOR_UPGRADE_SPEEDGRADE {-2} \
    CONFIG.C_INPUT_PIXELS_PER_CLOCK {2} \
    CONFIG.C_INT_HDMI_VER_CMPTBLE {3} \
    CONFIG.C_NIDRU {false} \
    CONFIG.C_RX_PLL_SELECTION {0} \
    CONFIG.C_RX_REFCLK_SEL {0} \
    CONFIG.C_Rx_Protocol {HDMI} \
    CONFIG.C_TX_PLL_SELECTION {6} \
    CONFIG.C_TX_REFCLK_SEL {1} \
    CONFIG.C_Tx_Protocol {HDMI} \
    CONFIG.C_Txrefclk_Rdy_Invert {true} \
    CONFIG.C_Use_Oddr_for_Tmds_Clkout {true} \
    CONFIG.C_vid_phy_rx_axi4s_ch_INT_TDATA_WIDTH {20} \
    CONFIG.C_vid_phy_rx_axi4s_ch_TDATA_WIDTH {20} \
    CONFIG.C_vid_phy_rx_axi4s_ch_TUSER_WIDTH {1} \
    CONFIG.C_vid_phy_tx_axi4s_ch_INT_TDATA_WIDTH {20} \
    CONFIG.C_vid_phy_tx_axi4s_ch_TDATA_WIDTH {20} \
    CONFIG.C_vid_phy_tx_axi4s_ch_TUSER_WIDTH {1} \
    CONFIG.Rx_GT_Line_Rate {5.94} \
    CONFIG.Rx_GT_Ref_Clock_Freq {297} \
    CONFIG.Transceiver {GTYE4} \
    CONFIG.Tx_GT_Line_Rate {5.94} \
    CONFIG.Tx_GT_Ref_Clock_Freq {297} \
  ] $vid_phy_controller


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {1} $xlconstant_0


  # Create instance: zynq_us_ss_0
  create_hier_cell_zynq_us_ss_0 [current_bd_instance .] zynq_us_ss_0

  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_1 [get_bd_intf_ports C0_SYS_CLK_0] [get_bd_intf_pins VDMA_SYS/C0_SYS_CLK_0]
  connect_bd_intf_net -intf_net CLK_IN1_D_1 [get_bd_intf_ports CLK_IN1_D] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports UART] [get_bd_intf_pins axi_uartlite_0/UART]
  connect_bd_intf_net -intf_net ddr4_0_C0_DDR4 [get_bd_intf_ports C0_DDR4] [get_bd_intf_pins VDMA_SYS/C0_DDR4]
  connect_bd_intf_net -intf_net intf_net_audio_ss_0_axis_audio_out [get_bd_intf_pins audio_ss_0/axis_audio_out] [get_bd_intf_pins v_hdmi_tx_ss/AUDIO_IN]
connect_bd_intf_net -intf_net [get_bd_intf_nets intf_net_audio_ss_0_axis_audio_out] [get_bd_intf_pins system_ila_2/SLOT_0_AXIS] [get_bd_intf_pins v_hdmi_tx_ss/AUDIO_IN]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets intf_net_audio_ss_0_axis_audio_out]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_rx_ss_AUDIO_OUT [get_bd_intf_pins audio_ss_0/axis_audio_in] [get_bd_intf_pins v_hdmi_rx_ss/AUDIO_OUT]
connect_bd_intf_net -intf_net [get_bd_intf_nets intf_net_v_hdmi_rx_ss_AUDIO_OUT] [get_bd_intf_pins system_ila_2/SLOT_1_AXIS] [get_bd_intf_pins v_hdmi_rx_ss/AUDIO_OUT]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets intf_net_v_hdmi_rx_ss_AUDIO_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_rx_ss_DDC_OUT [get_bd_intf_ports RX_DDC_OUT] [get_bd_intf_pins v_hdmi_rx_ss/DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_DDC_OUT [get_bd_intf_ports TX_DDC_OUT] [get_bd_intf_pins v_hdmi_tx_ss/DDC_OUT]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA0_OUT [get_bd_intf_pins v_hdmi_tx_ss/LINK_DATA0_OUT] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA1_OUT [get_bd_intf_pins v_hdmi_tx_ss/LINK_DATA1_OUT] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_v_hdmi_tx_ss_LINK_DATA2_OUT [get_bd_intf_pins v_hdmi_tx_ss/LINK_DATA2_OUT] [get_bd_intf_pins vid_phy_controller/vid_phy_tx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_v_tpg_ss_0_m_axis_video [get_bd_intf_pins v_hdmi_tx_ss/VIDEO_IN] [get_bd_intf_pins v_tpg_ss_0/m_axis_video]
connect_bd_intf_net -intf_net [get_bd_intf_nets intf_net_v_tpg_ss_0_m_axis_video] [get_bd_intf_pins system_ila_0/SLOT_1_AXIS] [get_bd_intf_pins v_hdmi_tx_ss/VIDEO_IN]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch0 [get_bd_intf_pins v_hdmi_rx_ss/LINK_DATA0_IN] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch0]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch1 [get_bd_intf_pins v_hdmi_rx_ss/LINK_DATA1_IN] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch1]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_rx_axi4s_ch2 [get_bd_intf_pins v_hdmi_rx_ss/LINK_DATA2_IN] [get_bd_intf_pins vid_phy_controller/vid_phy_rx_axi4s_ch2]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_rx [get_bd_intf_pins v_hdmi_rx_ss/SB_STATUS_IN] [get_bd_intf_pins vid_phy_controller/vid_phy_status_sb_rx]
  connect_bd_intf_net -intf_net intf_net_vid_phy_controller_vid_phy_status_sb_tx [get_bd_intf_pins v_hdmi_tx_ss/SB_STATUS_IN] [get_bd_intf_pins vid_phy_controller/vid_phy_status_sb_tx]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_IIC [get_bd_intf_ports HDMI_CTL] [get_bd_intf_pins zynq_us_ss_0/IIC]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M00_AXI [get_bd_intf_pins vid_phy_controller/vid_phy_axi4lite] [get_bd_intf_pins zynq_us_ss_0/M00_AXI]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M01_AXI [get_bd_intf_pins v_hdmi_rx_ss/S_AXI_CPU_IN] [get_bd_intf_pins zynq_us_ss_0/M01_AXI]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M02_AXI [get_bd_intf_pins v_hdmi_tx_ss/S_AXI_CPU_IN] [get_bd_intf_pins zynq_us_ss_0/M02_AXI]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M05_AXI [get_bd_intf_pins v_tpg_ss_0/S_AXI_TPG] [get_bd_intf_pins zynq_us_ss_0/M05_AXI]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M06_AXI [get_bd_intf_pins audio_ss_0/S00_AXI] [get_bd_intf_pins zynq_us_ss_0/M06_AXI]
  connect_bd_intf_net -intf_net intf_net_zynq_us_ss_0_M08_AXI [get_bd_intf_pins v_tpg_ss_0/S_AXI_GPIO] [get_bd_intf_pins zynq_us_ss_0/M08_AXI]
  connect_bd_intf_net -intf_net s_axis_video_1 [get_bd_intf_pins VDMA_SYS/M_AXIS] [get_bd_intf_pins v_tpg_ss_0/s_axis_video]
connect_bd_intf_net -intf_net [get_bd_intf_nets s_axis_video_1] [get_bd_intf_pins VDMA_SYS/M_AXIS] [get_bd_intf_pins system_ila_0/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net v_hdmi_rx_ss_VIDEO_OUT [get_bd_intf_pins VDMA_SYS/S_AXIS] [get_bd_intf_pins v_hdmi_rx_ss/VIDEO_OUT]
connect_bd_intf_net -intf_net [get_bd_intf_nets v_hdmi_rx_ss_VIDEO_OUT] [get_bd_intf_pins VDMA_SYS/S_AXIS] [get_bd_intf_pins system_ila_0/SLOT_2_AXIS]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets v_hdmi_rx_ss_VIDEO_OUT]
  connect_bd_intf_net -intf_net zynq_us_ss_0_M09_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins zynq_us_ss_0/M09_AXI]
  connect_bd_intf_net -intf_net zynq_us_ss_0_M10_AXI [get_bd_intf_pins VDMA_SYS/S_AXI_LITE] [get_bd_intf_pins zynq_us_ss_0/M10_AXI]
  connect_bd_intf_net -intf_net zynq_us_ss_0_M11_AXI [get_bd_intf_pins VDMA_SYS/S02_AXI] [get_bd_intf_pins zynq_us_ss_0/M11_AXI]

  # Create port connections
  connect_bd_net -net HDMI_RX_CLK_N_IN_1 [get_bd_ports HDMI_RX_CLK_N_IN] [get_bd_pins vid_phy_controller/mgtrefclk0_pad_n_in]
  connect_bd_net -net HDMI_RX_CLK_P_IN_1 [get_bd_ports HDMI_RX_CLK_P_IN] [get_bd_pins vid_phy_controller/mgtrefclk0_pad_p_in]
  connect_bd_net -net TX_REFCLK_N_IN_1 [get_bd_ports TX_REFCLK_N_IN] [get_bd_pins vid_phy_controller/mgtrefclk1_pad_n_in]
  connect_bd_net -net TX_REFCLK_P_IN_1 [get_bd_ports TX_REFCLK_P_IN] [get_bd_pins vid_phy_controller/mgtrefclk1_pad_p_in]
  connect_bd_net -net VDMA_SYS_c0_init_calib_complete [get_bd_pins VDMA_SYS/c0_init_calib_complete] [get_bd_pins system_ila_1/probe0]
  connect_bd_net -net VDMA_SYS_ddr4ht3_refclk_en_n [get_bd_ports ddr4ht3_refclk_en_n] [get_bd_pins VDMA_SYS/ddr4ht3_refclk_en_n]
  connect_bd_net -net VDMA_SYS_tlast_o [get_bd_pins VDMA_SYS/tlast_o] [get_bd_pins hdmi_rx_detect_0/s_axis_tlast]
  connect_bd_net -net VDMA_SYS_tuser_o [get_bd_pins VDMA_SYS/tuser_o] [get_bd_pins hdmi_rx_detect_0/s_axis_tuser]
  connect_bd_net -net VDMA_SYS_tvalid_o [get_bd_pins VDMA_SYS/tvalid_o] [get_bd_pins hdmi_rx_detect_0/s_axis_tvalid]
  connect_bd_net -net audio_ss_0_peripheral_aresetn [get_bd_pins audio_ss_0/peripheral_aresetn] [get_bd_pins system_ila_2/resetn]
  connect_bd_net -net cec_0_cec_out [get_bd_ports cec] [get_bd_pins cec_0/cec_out]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins VDMA_SYS/c0_ddr4_ui_clk] [get_bd_pins system_ila_1/clk]
  connect_bd_net -net hdmi_rx_detect_0_o_col_cnt [get_bd_pins hdmi_rx_detect_0/o_col_cnt] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net hdmi_rx_detect_0_o_row_cnt [get_bd_pins hdmi_rx_detect_0/o_row_cnt] [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net microblaze_0_Clk [get_bd_pins audio_ss_0/audio_clk] [get_bd_pins system_ila_2/clk] [get_bd_pins v_hdmi_rx_ss/s_axis_audio_aclk] [get_bd_pins v_hdmi_tx_ss/s_axis_audio_aclk]
  connect_bd_net -net net_audio_ss_0_aud_acr_cts_out [get_bd_pins audio_ss_0/aud_acr_cts_out] [get_bd_pins v_hdmi_tx_ss/acr_cts]
  connect_bd_net -net net_audio_ss_0_aud_acr_n_out [get_bd_pins audio_ss_0/aud_acr_n_out] [get_bd_pins v_hdmi_tx_ss/acr_n]
  connect_bd_net -net net_audio_ss_0_aud_acr_valid_out [get_bd_pins audio_ss_0/aud_acr_valid_out] [get_bd_pins v_hdmi_tx_ss/acr_valid]
  connect_bd_net -net net_audio_ss_0_aud_rstn [get_bd_pins audio_ss_0/aud_rstn] [get_bd_pins v_hdmi_rx_ss/s_axis_audio_aresetn] [get_bd_pins v_hdmi_tx_ss/s_axis_audio_aresetn]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_N_IN [get_bd_ports HDMI_RX_DAT_N_IN] [get_bd_pins vid_phy_controller/phy_rxn_in]
  connect_bd_net -net net_bdry_in_HDMI_RX_DAT_P_IN [get_bd_ports HDMI_RX_DAT_P_IN] [get_bd_pins vid_phy_controller/phy_rxp_in]
  connect_bd_net -net net_bdry_in_IDT_8T49N241_LOL_IN [get_bd_ports HDMI_Si5324C_LOL_IN] [get_bd_pins vid_phy_controller/tx_refclk_rdy]
  connect_bd_net -net net_bdry_in_RX_DET_IN [get_bd_ports RX_DET_IN] [get_bd_pins v_hdmi_rx_ss/cable_detect]
  connect_bd_net -net net_bdry_in_TX_HPD_IN [get_bd_ports TX_HPD_IN] [get_bd_pins v_hdmi_tx_ss/hpd]
  connect_bd_net -net net_v_hdmi_rx_ss_acr_cts [get_bd_pins audio_ss_0/aud_acr_cts_in] [get_bd_pins v_hdmi_rx_ss/acr_cts]
  connect_bd_net -net net_v_hdmi_rx_ss_acr_n [get_bd_pins audio_ss_0/aud_acr_n_in] [get_bd_pins v_hdmi_rx_ss/acr_n]
  connect_bd_net -net net_v_hdmi_rx_ss_acr_valid [get_bd_pins audio_ss_0/aud_acr_valid_in] [get_bd_pins v_hdmi_rx_ss/acr_valid]
  connect_bd_net -net net_v_hdmi_rx_ss_fid [get_bd_pins v_hdmi_rx_ss/fid] [get_bd_pins v_hdmi_tx_ss/fid]
  connect_bd_net -net net_v_hdmi_rx_ss_hpd [get_bd_ports RX_HPD_OUT] [get_bd_pins v_hdmi_rx_ss/hpd]
  connect_bd_net -net net_v_hdmi_rx_ss_irq [get_bd_pins v_hdmi_rx_ss/irq] [get_bd_pins zynq_us_ss_0/hdmi_rx_irq]
  connect_bd_net -net net_v_hdmi_tx_ss_irq [get_bd_pins v_hdmi_tx_ss/irq] [get_bd_pins zynq_us_ss_0/hdmi_tx_irq]
  connect_bd_net -net net_vcc_const_dout [get_bd_ports TX_EN_OUT] [get_bd_pins vcc_const/dout] [get_bd_pins vid_phy_controller/vid_phy_rx_axi4s_aresetn] [get_bd_pins vid_phy_controller/vid_phy_tx_axi4s_aresetn]
  connect_bd_net -net net_vid_phy_controller_irq [get_bd_pins vid_phy_controller/irq] [get_bd_pins zynq_us_ss_0/vphy_irq]
  connect_bd_net -net net_vid_phy_controller_phy_txn_out [get_bd_ports HDMI_TX_DAT_N_OUT] [get_bd_pins vid_phy_controller/phy_txn_out]
  connect_bd_net -net net_vid_phy_controller_phy_txp_out [get_bd_ports HDMI_TX_DAT_P_OUT] [get_bd_pins vid_phy_controller/phy_txp_out]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_n [get_bd_ports RX_REFCLK_N_OUT] [get_bd_pins vid_phy_controller/rx_tmds_clk_n]
  connect_bd_net -net net_vid_phy_controller_rx_tmds_clk_p [get_bd_ports RX_REFCLK_P_OUT] [get_bd_pins vid_phy_controller/rx_tmds_clk_p]
  connect_bd_net -net net_vid_phy_controller_rx_video_clk [get_bd_pins v_hdmi_rx_ss/video_clk] [get_bd_pins vid_phy_controller/rx_video_clk]
  connect_bd_net -net net_vid_phy_controller_rxoutclk [get_bd_pins v_hdmi_rx_ss/link_clk] [get_bd_pins vid_phy_controller/rxoutclk] [get_bd_pins vid_phy_controller/vid_phy_rx_axi4s_aclk]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk [get_bd_pins audio_ss_0/hdmi_clk] [get_bd_pins vid_phy_controller/tx_tmds_clk]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_n [get_bd_ports HDMI_TX_CLK_N_OUT] [get_bd_pins vid_phy_controller/tx_tmds_clk_n]
  connect_bd_net -net net_vid_phy_controller_tx_tmds_clk_p [get_bd_ports HDMI_TX_CLK_P_OUT] [get_bd_pins vid_phy_controller/tx_tmds_clk_p]
  connect_bd_net -net net_vid_phy_controller_tx_video_clk [get_bd_pins v_hdmi_tx_ss/video_clk] [get_bd_pins vid_phy_controller/tx_video_clk]
  connect_bd_net -net net_vid_phy_controller_txoutclk [get_bd_pins v_hdmi_tx_ss/link_clk] [get_bd_pins vid_phy_controller/txoutclk] [get_bd_pins vid_phy_controller/vid_phy_tx_axi4s_aclk]
  connect_bd_net -net net_zynq_us_ss_0_clk_out2 [get_bd_pins VDMA_SYS/aclk] [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins hdmi_rx_detect_0/ACLK] [get_bd_pins system_ila_0/clk] [get_bd_pins v_hdmi_rx_ss/s_axis_video_aclk] [get_bd_pins v_hdmi_tx_ss/s_axis_video_aclk] [get_bd_pins v_tpg_ss_0/ap_clk] [get_bd_pins zynq_us_ss_0/clk2]
  connect_bd_net -net net_zynq_us_ss_0_dcm_locked [get_bd_pins VDMA_SYS/aresetn] [get_bd_pins hdmi_rx_detect_0/ARESETN] [get_bd_pins system_ila_0/resetn] [get_bd_pins v_hdmi_rx_ss/s_axis_video_aresetn] [get_bd_pins v_hdmi_tx_ss/s_axis_video_aresetn] [get_bd_pins v_tpg_ss_0/m_axi_aresetn] [get_bd_pins zynq_us_ss_0/aresetn_300M]
  connect_bd_net -net net_zynq_us_ss_0_peripheral_aresetn [get_bd_pins VDMA_SYS/axi_resetn] [get_bd_pins audio_ss_0/ARESETN] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins v_hdmi_rx_ss/s_axi_cpu_aresetn] [get_bd_pins v_hdmi_tx_ss/s_axi_cpu_aresetn] [get_bd_pins vid_phy_controller/vid_phy_axi4lite_aresetn] [get_bd_pins vid_phy_controller/vid_phy_sb_aresetn] [get_bd_pins zynq_us_ss_0/aresetn_100M]
  connect_bd_net -net net_zynq_us_ss_0_s_axi_aclk [get_bd_pins VDMA_SYS/s_axi_lite_aclk] [get_bd_pins audio_ss_0/ACLK] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins cec_0/cec_clk_in] [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins v_hdmi_rx_ss/s_axi_cpu_aclk] [get_bd_pins v_hdmi_tx_ss/s_axi_cpu_aclk] [get_bd_pins vid_phy_controller/drpclk] [get_bd_pins vid_phy_controller/vid_phy_axi4lite_aclk] [get_bd_pins vid_phy_controller/vid_phy_sb_aclk] [get_bd_pins zynq_us_ss_0/clk1]
  connect_bd_net -net o_frame_cnt [get_bd_pins hdmi_rx_detect_0/o_frame_cnt] [get_bd_pins system_ila_0/probe2]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets o_frame_cnt]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins cec_0/rst_n] [get_bd_pins xlconstant_0/dout]

  # Create address segments
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces VDMA_SYS/axi_vdma_0/Data_MM2S] [get_bd_addr_segs VDMA_SYS/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces VDMA_SYS/axi_vdma_0/Data_S2MM] [get_bd_addr_segs VDMA_SYS/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x40020000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs audio_ss_0/aud_pat_gen/axi/reg0] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs v_tpg_ss_0/axi_gpio/S_AXI/Reg] -force
  assign_bd_address -offset 0x41200000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs zynq_us_ss_0/axi_intc_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x40600000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A60000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs VDMA_SYS/axi_vdma_0/S_AXI_LITE/Reg] -force
  assign_bd_address -offset 0x44A10000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs audio_ss_0/clk_wiz/s_axi_lite/Reg] -force
  assign_bd_address -offset 0x80000000 -range 0x80000000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs VDMA_SYS/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x10000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs VDMA_SYS/ddr4_0/C0_DDR4_MEMORY_MAP_CTRL/C0_REG] -force
  assign_bd_address -offset 0x00000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs zynq_us_ss_0/microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] -force
  assign_bd_address -offset 0x40800000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs zynq_us_ss_0/fmch_axi_iic/S_AXI/Reg] -force
  assign_bd_address -offset 0x40100000 -range 0x00100000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs audio_ss_0/hdmi_acr_ctrl/axi/reg0] -force
  assign_bd_address -offset 0x41400000 -range 0x00001000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs zynq_us_ss_0/mdm_1/S_AXI/Reg] -force
  assign_bd_address -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs v_hdmi_rx_ss/S_AXI_CPU_IN/Reg] -force
  assign_bd_address -offset 0x44A20000 -range 0x00020000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs v_hdmi_tx_ss/S_AXI_CPU_IN/Reg] -force
  assign_bd_address -offset 0x44A40000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs v_tpg_ss_0/v_tpg/s_axi_CTRL/Reg] -force
  assign_bd_address -offset 0x44A50000 -range 0x00010000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Data] [get_bd_addr_segs vid_phy_controller/vid_phy_axi4lite/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces zynq_us_ss_0/microblaze_0/Instruction] [get_bd_addr_segs zynq_us_ss_0/microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x10000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces VDMA_SYS/axi_vdma_0/Data_MM2S] [get_bd_addr_segs VDMA_SYS/ddr4_0/C0_DDR4_MEMORY_MAP_CTRL/C0_REG]
  exclude_bd_addr_seg -offset 0x10000000 -range 0x00100000 -target_address_space [get_bd_addr_spaces VDMA_SYS/axi_vdma_0/Data_S2MM] [get_bd_addr_segs VDMA_SYS/ddr4_0/C0_DDR4_MEMORY_MAP_CTRL/C0_REG]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""



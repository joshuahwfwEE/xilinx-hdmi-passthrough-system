hdmi_mgb2_v11 project:  

story:   
using xilinx hdmirx1.4/2.0 subsystem ip and xilinx hdmitx1.4/2.0 ip and xilinx video phy controller and memory storge system and the others ip 
to implement a hdmi passthrough system on synopsys haps connect daughter card hdmi_mgb2_v11.  
this repos conatin a hdmi vdma+ddr4 passthrough project  

you can see Multimedia User Guide (UG1449) to look for which is suitable for you as the solution.  


all project can depart or remix into following project that is already developed and tested well: 
project and usage content:  
1 hdmi_mgb2_v11:
1. hdmi tx_only project: use tpg and xilinx hdmi1.4/2.0 tx subsystem and video phy controller for output the video stream   
2. hdmi rx_only project: use video phy controller and xilinx hdmi1.4/2.0 tx subsystem to receive input hdmi video data and convert into axi stream
   
1 hdmi_mgb2_v11 + 1 ddr4_ht3:   
4. hdmi rx+vdma+ddr4 project: add extra add extra video dma and ddr4 as the storage system on hdmi rx_only project  
5. hdmi passthrough project: combine rx and tx feature,  rx can receive the input video stream and analysis the infomation and use this infomation for tx's configuration  
6. hdmi vdma+ddr4 passthrough project : similar to hdmi passthrough project, add extra video dma and ddr4 as the video buffer.   

2 hdmi_mgb2_v11 + 1 ddr4_ht3:   
7. hdmi tx_only+oversampling to hdmi rx+dru+vdma+ddr4: combine tx_only with oversampling project and rx+dru+vdma+ddr4 project and verify the lowest pixel clk is 12.375M/s  
8. hdmi rx+vdma+ddr4 to hdmi_tx_only: in order to seperate the video controller, combine tx_only project and rx+vdma+ddr4 project to verify the maximum capability.

capability:  
rx only and rx+vdma+ddr4: support up to 3840x2160@30fhz resolution's video.  
rx only+dru and and rx+vdma+ddr4+dru: support up to 3840x2160@30fhz resolution's video and low to pixel clk is 12.375M/s.  
tx only: support up to 3840x2160@60fhz resolution's video.  
tx_only+oversampling: support up to 3840x2160@60fhz resolution's video and low to 3840x2160@2fhz (support lowest pixel clk is 12.375M/s).  
passthrough project and vdma+ddr4 passthrough project: support up to 3840x2160@30fhz resolution's video and support 32 bit 2 channel with 48k sample rate for passsthrough AES3 foramt audio data.  




to be updated and check:
rx replicate hpd issue in 3840x2160@60fps will happen at:  
video format rgb888  
video format yuv422

but not happen at 3840x2160@60fps in yuv420:  
--------------------------------------
---  HDMI SS + VPhy Example v5.4   ---
---  (c) 2018 by Xilinx, Inc.      ---
--------------------------------------
Build Jan 18 2024 - 10:05:49
--------------------------------------
VDMA S2MM Starting
the S2MM0 status is = 10001!!
the S2MM0 status is = 10000!!
MM2S frameBuffer_start_rd!
the MM2S status is = 10001!!
the MM2S status is = 10000!!
---------------------------------
stop VDMA s2mm
RX stream is up
reset VDMA s2mm
stop VDMA mm2s
reset VDMA mm2s
restart vdma
VideoMode:171
S2MM frameBuffer_start_wr!
the S2MM0 status is = 10001!!
MM2S frameBuffer_start_rd!
the MM2S status is = 10001!!

---------------------
---   MAIN MENU   ---
---------------------
i - Info
       => Shows information about the HDMI RX stream, HDMI TX stream,
          GT transceivers and PLL settings.
c - Colorbar
       => Displays the colorbar on the source output.
r - Resolution
       => Change the video resolution of the colorbar.
f - Frame rate
       => Change the frame rate of the colorbar.
d - Color depth
       => Change the color depth of the colorbar.
s - Color space
       => Change the color space of the colorbar.
p - Pass-through
       => Passes the sink input to source output.
z - GT & HDMI TX/RX log
       => Shows log information for GT & HDMI TX/RX.
e - Edid
       => Display and set edid.
a - Audio
       => Audio options.
v - Video
       => Video pattern options.
m - Set HDMI Mode
n - Set DVI Mode
w - Reset VDMA buffer


TX stream is up
--------
Pass-Through :
        Color Format:             YUV_420
        Color Depth:              8
        Pixels Per Clock:         2
        Mode:                     Progressive
        DSC Status:               Uncompressed
        Frame Rate:               60Hz
        Resolution:               3840x2160@60Hz
        Pixel Clock:              594000 kHz
--------

assume is cause by not support custom mode, => checked, video mode is independent to video format    
1. need to check rx's highest supported pixel clk.
2. need to check what cause rx issue replicate hpd signal.
3. check if support hdmi2.0 in edid, because 1.4 is not support 3840x2160@60fhz due to its bandwidth limit.
4. dynmaic_config_VDMA(): if rx receive video infomation doesn't exist at video_timing_table, need to add it maunally(try to add 3840x2160@60fhz cvt and 3840x2160@60fhz cvtrb)
5. add DRU feature and oversampling feature at 1 hdmi_mgb2_v11 + 1 ddr4_ht3: 


240123: solved the issue of missing parameter in axi_subset_converter while generate the block design  
        solved the issue of design's wrapper mistmatch in creat_proj.tcl




hardware setup:   
1 hdmi_mgb2_v11 at ht3_a24, ddr_ht3 8g at ht3_a15,a16,a17  
hdmi_mgb2 j1 connect to mgb2 am221  

program process:  
open hasp100-runtime bat: drives/C/Synopsys/protocomp-rtR-2020.12-SP1/bin/confprosh.bat  
cd C:\HAPS100_1F\02_confpro_scripts  
confprosh  
source 00_configure.tcl  
source 01_jtag_start.tcl  
connect_hw_server  
open_hw_target -xvc_url localhost:65137  

source 02_jtag_close.tcl



other vision of hdmi vdma passthrough project:  
dual board: 1 board as rx+vdma+ddr4  
            1 board as tx_only and rx receive data bypass to tx output  
            
add feature:  rx data recovery feature
              tx oversmpaling feature

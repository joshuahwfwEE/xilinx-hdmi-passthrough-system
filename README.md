hdmi_mgb2_v11 project:  

story:   
using xilinx hdmirx1.4/2.0 subsystem ip and xilinx hdmitx1.4/2.0 ip and xilinx video phy controller and memory storge system  
to implement a hdmi passthrough system on synopsys haps connect daughter card hdmi_mgb2_v11.  

this repos conatin a hdmi vdma+ddr4 passthrough project which is used for receive hdmi input stream and write to memory sytem and then read stream out to hdmi output   
this is one of a video solution in Xilinx Multimedia User Guide (UG1449), you can see more solution there.    
all project can depart or remix into following project that is already developed and tested well:  

available projects and usage content:  

1 hdmi_mgb2_v11:
1. hdmi tx_only : use tpg and xilinx hdmi1.4/2.0 tx subsystem and video phy controller for output the video stream   
2. hdmi rx_only : use video phy controller and xilinx hdmi1.4/2.0 tx subsystem to receive input hdmi video data and convert into axi stream  
   
1 hdmi_mgb2_v11 + 1 ddr4_ht3:   
4. hdmi rx+vdma+ddr4 : add extra add extra video dma and ddr4 as the storage system on hdmi rx_only project  
5. hdmi passthrough : combine rx and tx feature,  rx can receive the input video stream and analysis the infomation and use this infomation for tx's configuration  
6. hdmi vdma+ddr4 passthrough  : similar to hdmi passthrough project, add extra video dma and ddr4 as the video buffer.   

2 hdmi_mgb2_v11 + 1 ddr4_ht3:   
7. hdmi tx_only+oversampling to hdmi rx+dru+vdma+ddr4: combine tx_only with oversampling project and rx+dru+vdma+ddr4 project and verify the lowest pixel clk is 12.375M/s  
8. hdmi rx+vdma+ddr4 to hdmi_tx_only: in order to seperate the video controller, combine tx_only project and rx+vdma+ddr4 project to verify the maximum capability.

capability:  
rx only and rx+vdma+ddr4: support up to 3840x2160@30fhz rgb888 resolution's video.  
rx only+dru and and rx+vdma+ddr4+dru: support up to 3840x2160@30fhz rgb888 resolution's video and low to pixel clk is 12.375M/s.  
tx only: support up to 3840x2160@60fhz rgb888 resolution's video.  
tx_only+oversampling: support up to 3840x2160@60fhz resolution's video and low to 3840x2160@2fhz (support lowest pixel clk is 12.375M/s).  
passthrough project and vdma+ddr4 passthrough project: support up to 3840x2160@30fhz resolution's video and support 32 bit 2 channel with 48k sample rate for passsthrough AES3 foramt audio data.  
 
other vision of hdmi vdma passthrough project:  
dual board: 1 board as rx+vdma+ddr4  
            1 board as tx_only and rx receive data bypass to tx output  
            
add feature:  rx data recovery feature
              tx oversmpaling feature
#################################################################################################################   
hardware setup:   
1 hdmi_mgb2_v11 at ht3_a24, ddr_ht3 8g at ht3_a15,a16,a17  
hdmi_mgb2 j1 connect to mgb2 am221  

program process:  
open hasp100-runtime bat: drives/C/Synopsys/protocomp-rtR-2020.12-SP1/bin/confprosh.bat  
cd C:\HAPS100_1F\02_confpro_scripts  
confprosh                                // enter confprosh  
source 00_configure.tcl                  // program bit file and setting configuraions to fpga   
source 01_jtag_start.tcl                 // open jtag channel  
connect_hw_server                        // connect hw server  
open_hw_target -xvc_url localhost:65137  // connect hw target  
source 02_jtag_close.tcl                 // close jtag channel  





#################################################################################################################    

in HDMI1.4: maximum support pixel clk is 340MHz  
the maximum bandwidth: 340MHz*10bit（10bit encode）*3（3 data lanes）= 10.2Gbps  
according HDMI is using 8b/10b，it need to discont 20% of original bandwidth，hence 10.2Gbps can support maximum bandwidth is: 10.2*0.8= 8.1Gbps  

under HDMI1.4, 3840x2160@60fps yuv420 can be supported because the bandwidth: 4400*2250*8bit*60fps=4.752Gbps can meet the requirement.  
if stream up, you can see the folowing message: ...  

TX stream is up  
Pass-Through :  
        Color Format:             YUV_420  
        Color Depth:              8  
        Pixels Per Clock:         2  
        Mode:                     Progressive  
        DSC Status:               Uncompressed  
        Frame Rate:               60Hz  
        Resolution:               3840x2160@60Hz  
        Pixel Clock:              594000 kHz  

VPHY LOG:    
GT init start  
GT init done  
RX frequency event  
RX timer event  
RX DRU disable  
CPLL reconfig done  
GT RX reconfig start  
GT RX reconfig done  
CPLL lock  
RX reset done  
RX MMCM reconfig done  
RX MMCM lock  
TX frequency event  
TX timer event  
TX MMCM reconfig done  
QPLL reconfig done  
GT TX reconfig start  
GT TX reconfig done  
TX MMCM lock  
QPLL lock  
TX reset done  
TX alignment done  

HDMI TX log:   
Initializing HDMI TX core....  
Initializing VTC core....  
Reset HDMI TX Subsystem....  
TX cable is connected....  
TX Audio Unmuted  
TX Set Stream  
TX Stream Start  
TX Audio Unmuted  
TX Set Audio Channels (0)  
TX Stream is Up  


HDMI RX log:    
Initializing HDMI RX core....  
Reset HDMI RX Subsystem....  
RX cable is connected....  
RX TMDS reference clock change  
RX Stream Init  
RX mode changed to HDMI  
RX Stream Start  
RX Stream is Up  

#################################################################################################################  

however, RX replicate asserting HPD signal issue in 3840x2160@60fps will happen at:  
video format: rgb888, yuv422 under hdmi1.4 protocal  

problem is solved after bening asserted call back function:   	   
XV_HdmiRxSs_SetCallback(&HdmiRxSs, XV_HDMIRXSS_HANDLER_DDC, RxDdcCallback, (void *)&HdmiRxSs);
it can receive the hdmi2.0 video due to DDC callback active, it might make DDC channel(i2c) give a correct response to source side after it read the edid of xilinx hdmi,
instead of asserting incorrectly hpd signal to source  

#################################################################################################################  

question1: how to calculate the bandwidth that can be suitable for your source video'stream  
sol:  
in HDMI2.0: maximum support pixel clk is 600MHz  
the maximum bandwidth: 600MHz*10bit（10bit encode）*3（3 data lanes）= 18Gbps   
according HDMI is using 8b/10b，it need to discont 20% of original bandwidth，hence 18Gbps can support maximum bandwidth is: 18*0.8= 14.4Gbps  

if you need to receive a video stream with 3840x2160@60fps, bpc=8, format is rgb888 =>  
required bandwidth: 4400*2250*24bit*60fps=14.256Gbps.   
hence only HDMI2.0 or higher HDMI protocal can support the necessary bandwidth.    
 
 










#################################################################################################################   
updating work log:  
240123: solved the issue of missing parameter in axi_subset_converter while generate the block design  
        solved the issue of design's wrapper mistmatch in creat_proj.tcl  
240202: solved the issue in hdmi rx keep assereting reduplicated hpd to the source when source output 4k@60fhz rgb888 in application: Passthrough_Microblaze_1   
240214: add DRU feature and oversampling feature at hdmi vdma+ddr4 passthrough project          








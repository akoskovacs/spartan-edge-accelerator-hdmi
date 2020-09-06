// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun Sep  6 02:34:49 2020
// Host        : LAPTOP-7905C5JA running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/Devel/Xilinx/hdmi/hdmi.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7s15ftgb196-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(c0, c1, in_clk)
/* synthesis syn_black_box black_box_pad_pin="c0,c1,in_clk" */;
  output c0;
  output c1;
  input in_clk;
endmodule

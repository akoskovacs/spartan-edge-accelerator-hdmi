`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/04/2020 11:35:31 PM
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module top
(
  input CLK_100MHZ,

  // HDMI output
  output [2:0] HDMI_TX,
  output [2:0] HDMI_TX_N,
  output HDMI_CLK,
  output HDMI_CLK_N,
  output reg LED[1:0],
  inout HDMI_SDA,
  inout HDMI_SCL,
  input HDMI_HPD,
  input HDMI_CEC
);

wire clk_pixel_x5;
wire clk_pixel;
//wire clk_audio;
//hdmi_pll hdmi_pll(.inclk0(CLK_48MHZ), .c0(clk_pixel), .c1(clk_pixel_x5), .c2(clk_audio));
clk_wiz_0 hdmi_pll(
    .in_clk(CLK_100MHZ),
    .c0(clk_pixel),
    .c1(clk_pixel_x5));
    
localparam AUDIO_BIT_WIDTH = 16;
localparam AUDIO_RATE = 48000;
localparam WAVE_RATE = 480;

logic [AUDIO_BIT_WIDTH-1:0] audio_sample_word;
logic [AUDIO_BIT_WIDTH-1:0] audio_sample_word_dampened; // This is to avoid giving you a heart attack -- it'll be really loud if it uses the full dynamic range.
assign audio_sample_word_dampened = audio_sample_word >> 9;

//sawtooth #(.BIT_WIDTH(AUDIO_BIT_WIDTH), .SAMPLE_RATE(AUDIO_RATE), .WAVE_RATE(WAVE_RATE)) sawtooth (.clk_audio(clk_audio), .level(audio_sample_word));

logic [23:0] rgb;
logic [9:0] cx, cy;
hdmi #(.VIDEO_ID_CODE(1), .DDRIO(0)) hdmi(
    .clk_pixel_x10(clk_pixel_x5),
    .clk_pixel(clk_pixel),
    .clk_audio(clk_audio),
    .rgb(rgb),
    .audio_sample_word('{audio_sample_word_dampened, audio_sample_word_dampened}),
    .tmds_p(HDMI_TX),
    .tmds_clock_p(HDMI_CLK),
    .tmds_n(HDMI_TX_N),
    .tmds_clock_n(HDMI_CLK_N),
    .cx(cx),
    .cy(cy));

logic [7:0] character = 8'h30;
logic [5:0] prevcy = 6'd0;
always @(posedge clk_pixel)
begin
    if (cy == 10'd0)
    begin
        character <= 8'h30;
        prevcy <= 6'd0;
    end
    else if (prevcy != cy[9:4])
    begin
        character <= character + 8'h01;
        prevcy <= cy[9:4];
    end
end

reg[32:0] counter = 0;
always @(posedge clk_pixel_x5)
begin
    if (counter > 32'd15_000_000) begin
        counter <= 0;
        LED[0] <= ~LED[0];
    end else begin
        counter += 1;
    end
end

reg[32:0] pixel_cnt = 0;
always @(posedge clk_pixel)
begin
    if (pixel_cnt > 32'd15_000_000) begin
        pixel_cnt <= 0;
        LED[1] <= ~LED[1];
    end else begin
        pixel_cnt += 1;
    end
end

console console(
    .clk_pixel(clk_pixel),
    .codepoint(character),
    .attribute({cx[9], cy[8:6], cx[8:5]}),
    .cx(cx),
    .cy(cy),
    .rgb(rgb));
endmodule
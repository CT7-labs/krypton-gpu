module Krypton_Top (
    input i_Clk,
    output o_VGA_HSync,
    output o_VGA_VSync,
    output o_VGA_Red_0,
    output o_VGA_Red_1,
    output o_VGA_Red_2,
    output o_VGA_Grn_0,
    output o_VGA_Grn_1,
    output o_VGA_Grn_2,
    output o_VGA_Blu_0,
    output o_VGA_Blu_1,
    output o_VGA_Blu_2);

wire w_activeVideo;
wire [14:0] w_pixelAddress;
wire [8:0] w_color;
wire [9:0] w_HSync_Counter;
wire [9:0] w_VSync_Counter;

Krypton_Syncgen sync_gen (
    .i_Clk(i_Clk),
    .o_HSync(o_VGA_HSync),
    .o_VSync(o_VGA_VSync),
    .o_activeVideo(w_activeVideo),
    .o_HSync_Counter(w_HSync_Counter),
    .o_VSync_Counter(w_VSync_Counter));

Krypton_Video video_gen (
    .i_Clk(i_Clk),
    .i_HCounter(w_HSync_Counter),
    .i_VCounter(w_VSync_Counter),
    .o_color(w_color));

assign o_VGA_Red_2 = w_color[8] & w_activeVideo;
assign o_VGA_Red_1 = w_color[7] & w_activeVideo;
assign o_VGA_Red_0 = w_color[6] & w_activeVideo;
assign o_VGA_Grn_2 = w_color[5] & w_activeVideo;
assign o_VGA_Grn_1 = w_color[4] & w_activeVideo;
assign o_VGA_Grn_0 = w_color[3] & w_activeVideo;
assign o_VGA_Blu_2 = w_color[2] & w_activeVideo;
assign o_VGA_Blu_1 = w_color[1] & w_activeVideo;
assign o_VGA_Blu_0 = w_color[0] & w_activeVideo;
// subtract 1 from pixelAddress to present what it would actually look like

endmodule
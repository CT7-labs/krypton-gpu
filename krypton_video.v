module Krypton_Video (
    input           i_Clk,
    input   [9:0]   i_HCounter,
    input   [9:0]   i_VCounter,
    output  [8:0]   o_color);

// 80x60 columns and rows
parameter COLUMNS = 80;
parameter ROWS = 60;

// position figure out-ing
wire [9:0] w_HCounter = i_HCounter[9:0] - 3; // some pixels on the far left were appearing on the far right
wire [9:0] w_VCounter = i_VCounter[9:0];

// getting column and row position
wire [6:0] w_col = w_HCounter[9:3];
wire [6:0] w_row = w_VCounter[9:3];

// getting position within the 8x8 tile
wire [2:0] w_char_x = w_HCounter[2:0];
wire [2:0] w_char_y = w_VCounter[2:0];

// color defining
reg [8:0] r_color_off = 9'b000010111;
reg [8:0] r_color_on = 9'b111111111;

// character buffer instantiation
wire [12:0] w_char_buffer_index = (w_row * COLUMNS) + w_col;
wire [7:0] w_tile_index;
wire [7:0] w_tile_slice;

Character_Buffer char_buffer (
    .i_sys_clk(i_Clk),
    .i_wr_adr(0),
    .i_rd_adr(w_char_buffer_index),
    .i_wr_en(0),
    .i_data(0),
    .o_data(w_tile_index[7:0]));

Character_ROM char_rom (
    .i_sys_clk(i_Clk),
    .i_wr_adr(0),
    .i_rd_adr({w_tile_index * 8 + w_char_y}),
    .i_wr_en(0),
    .i_data(0),
    .o_data(w_tile_slice[7:0]));

assign o_color = (w_tile_slice[7 - (w_char_x - 2)]) ? r_color_on : r_color_off;

endmodule
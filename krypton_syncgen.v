module Krypton_Syncgen (
    input           i_Clk,
    output reg      o_HSync,
    output reg      o_VSync,
    output reg      o_activeVideo,
    output [9:0]    o_HSync_Counter,
    output [9:0]    o_VSync_Counter);

// VGA timing parameters
parameter H_VISIBLE_AREA = 640;
parameter H_FRONT_PORCH = 16;
parameter H_SYNC_PULSE = 96;
parameter H_BACK_PORCH = 48;

parameter V_VISIBLE_AREA = 480;
parameter V_FRONT_PORCH = 10;
parameter V_SYNC_PULSE = 2;
parameter V_BACK_PORCH = 33;

parameter H_TOTAL = H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;
parameter V_TOTAL = V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

// counter registers
reg [9:0] r_HSync_Counter;
reg [9:0] r_VSync_Counter;
assign o_HSync_Counter = r_HSync_Counter;
assign o_VSync_Counter = r_VSync_Counter;

reg r_HBlank;
reg r_VBlank;

// logic "loop"
always @(posedge i_Clk) begin
    // HSync + VSync counters
    r_HSync_Counter <= r_HSync_Counter + 1;

    if (r_HSync_Counter == H_TOTAL - 1) begin
        r_HSync_Counter <= 0;

        if (r_VSync_Counter == V_TOTAL - 1) begin
            r_VSync_Counter <= 0;
        end else begin
            r_VSync_Counter <= r_VSync_Counter + 1;
        end
    end

    // determining HBlanking signal
    if (r_HSync_Counter > H_VISIBLE_AREA) begin
        r_HBlank <= 1;
    end else begin
        r_HBlank <= 0;
    end

    // determining VBlanking signal
    if (r_VSync_Counter > V_VISIBLE_AREA) begin
        r_VBlank <= 1;
    end else begin
        r_VBlank <= 0;
    end

    // determining activeVideo signal
    if (~r_HBlank && ~r_VBlank) begin
        o_activeVideo <= 1;
    end else begin
        o_activeVideo <= 0;
    end

    // HSync + VSync pulse generation
    if (r_HSync_Counter > H_VISIBLE_AREA + H_FRONT_PORCH && r_HSync_Counter < H_VISIBLE_AREA + H_FRONT_PORCH + H_SYNC_PULSE) begin
        o_HSync <= 0;
    end else begin
        o_HSync <= 1;
    end

    if (r_VSync_Counter > V_VISIBLE_AREA + V_FRONT_PORCH && r_VSync_Counter < V_VISIBLE_AREA + V_FRONT_PORCH + V_SYNC_PULSE) begin
        o_VSync <= 0;
    end else begin
        o_VSync <= 1;
    end

end

endmodule

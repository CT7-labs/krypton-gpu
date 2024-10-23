module Character_ROM #(parameter ADDR_WIDTH = 11, DATA_WIDTH = 8, DEPTH = 2048)(
    input i_sys_clk,
    input [ADDR_WIDTH-1:0] i_wr_adr,
    input [ADDR_WIDTH-1:0] i_rd_adr,
    input i_wr_en,
    input [DATA_WIDTH-1:0] i_data,
    output reg [DATA_WIDTH-1:0] o_data
    );
    
    reg [DATA_WIDTH-1:0] memory_array [0:DEPTH-1] /* synthesis syn_ramstyle="block_ram" */;
    
    initial begin
        $readmemh("char_rom.ini", memory_array);
    end

    always @(posedge i_sys_clk) begin
        if(i_wr_en) begin
            memory_array[i_wr_adr] <= i_data;
        end

        o_data <= memory_array[i_rd_adr];
    end // End always
    
endmodule
module Character_Buffer #(parameter ADDR_WIDTH = 13, DATA_WIDTH = 8, DEPTH = 4800)(
    input i_sys_clk,
    input [ADDR_WIDTH-1:0] i_wr_adr,
    input [ADDR_WIDTH-1:0] i_rd_adr,
    input i_wr_en,
    input [DATA_WIDTH-1:0] i_data,
    output reg [DATA_WIDTH-1:0] o_data
    );
    
    reg [DATA_WIDTH-1:0] memory_array [0:DEPTH-1] /* synthesis syn_ramstyle="block_ram" */;
    
    initial begin
        $readmemh("char_buffer.ini", memory_array);

    end

    always @(posedge i_sys_clk) begin
        if(i_wr_en) begin
            memory_array[i_wr_adr] <= i_data;
        end

        if (i_rd_adr < DEPTH) // just so the pattern doesn't repeat across the whole screen
            o_data <= memory_array[i_rd_adr];
        else
            o_data <= 0;
    end // End always
    
endmodule
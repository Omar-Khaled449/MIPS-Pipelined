module DataMemory #(
    parameter MEM_WIDTH = 8,
    parameter WORD_WIDTH = 32,
    parameter MEM_DEPTH = 1024,
    parameter ADDR_SIZE = 32
) (
    input clk, MemRead, MemWrite,
    input [ADDR_SIZE-1:0] address,
    input [WORD_WIDTH-1:0] write_data,
    output reg [WORD_WIDTH-1:0] read_data
);
    
    reg [MEM_WIDTH-1:0] Data [0:MEM_DEPTH-1];

    always @(posedge clk) begin
        if(MemWrite) begin
            Data[address] <= write_data[31:24];
            Data[address+1] <= write_data[23:16];
            Data[address+2] <= write_data[15:8];
            Data[address+3] <= write_data[7:0];
        end
        if(MemRead)
            read_data <= {Data[address], Data[address+1], Data[address+2], Data[address+3]};
    end
    
endmodule
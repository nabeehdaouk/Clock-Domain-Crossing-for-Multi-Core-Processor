module top_level(
    input clk,          //Clock driving design
    input resetn,        //Global reset
    input cpu_en,
    input [31:0] w_instruction,
    input w_enable,
    input [10:0] w_adrs,
    output carry,
    output [31:0] result
    
);
    wire [31:0] instruction_fetch; 
    wire [31:0] mem_store_data;
    wire read_mem_ir;
    wire read_mem_str;
    wire [10:0] mem_radrs_ir;
    wire [10:0] mem_radrs_ld;
    wire [31:0] mem_wdata;
    wire [10:0] mem_w_adrs;
    wire [10:0] mem_wadrs;
    wire write_mem;
    wire [31:0] mem_data_in;
    wire mem_w_en;
    
    
    wire gated_cpu_clk;
 

    assign gated_cpu_clk= cpu_en ? clk : 1'b0;
    assign mem_data_in = cpu_en ? mem_wdata : w_instruction;
    assign mem_w_adrs = cpu_en ? mem_wadrs : w_adrs;
    assign mem_w_en = cpu_en ? write_mem : w_enable;
 
    cpu cpu_instance(
        .clk(gated_cpu_clk),
        .resetn(resetn),
        .instruction_fetch(instruction_fetch),
        .mem_store_data(mem_store_data),
        .read_mem_ir(read_mem_ir),
        .read_mem_str(read_mem_str),
        .write_mem(write_mem),
        .carry(carry),
        .result(result),
        .mem_wdata(mem_wdata),
        .mem_wadrs(mem_wadrs),
        .mem_radrs_ld(mem_radrs_ld),
        .mem_radrs_ir(mem_radrs_ir)
    );
    
     memory memory_instance(
         .clk(clk),
         .resetn(resetn),
         .w_adrs(mem_w_adrs),
         .r_adrs1(mem_radrs_ir), //port 1 used for Instructions
         .r_adrs2(mem_radrs_ld), //port 2 used for store
         .data_in(mem_data_in),
         .w_en(mem_w_en),
         .r_en1(read_mem_ir),
         .r_en2(read_mem_str),
         .data_out1(instruction_fetch),
         .data_out2(mem_store_data)
     );
     
endmodule
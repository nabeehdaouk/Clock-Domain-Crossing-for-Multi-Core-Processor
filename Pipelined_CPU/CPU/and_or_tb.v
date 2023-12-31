module and_or_tb();
    
    reg clk;
    reg resetn;        //Global reset
    reg cpu_en;
    reg [31:0] w_instruction;
    reg w_enable;
    reg [10:0] w_adrs;
    wire carry;
    wire [31:0]result;
    
    top_level top_level_instance(
        .clk(clk),
        .resetn(resetn),
        .cpu_en(cpu_en),
        .w_instruction(w_instruction),
        .w_enable(w_enable),
        .w_adrs(w_adrs),
        .carry(carry),
        .result(result)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        
        //Reset
        clk = 0;
        resetn = 0;
        cpu_en = 1;
        w_instruction = 32'h0000_0000;
        w_enable = 0;
        
        //Add instrction
        #10
        w_adrs = 1;
        resetn = 1;
        cpu_en = 0;
        w_enable = 1;
        w_instruction = 32'b111_00_000_0_0_0_00000_00011_0_00000_01111; //LOAD MEM15 REG_A_3
        
        //Add instrction
        #10
        w_adrs = 2;
        w_instruction = 32'b111_00_000_0_0_0_00101_00101_0_00000_10001; //LOAD MEM16 REG_A_7
        
        //Add instrction
        #10
        w_adrs = 7;
        w_instruction = 32'b001_00_000_0_0_0_00000_00011_0_00000_00101; //OR REGA_3 REGB_7
        
        //Add instruction
        #10
        w_adrs = 8;
        w_instruction = 32'b010_00_000_0_0_0_00000_00011_0_00000_00101; //AND REGA_3 REGA_7
         
        //Add instruction
        #10
        w_adrs = 9;
        w_instruction = 32'b001_00_000_1_0_1_11111_00000_0_01010_10101; //AND REGB_31 341
        
        //Add values in mem
        #10
        w_adrs = 15;
        w_instruction = 32'hFFFF_0000;
        
        #10
        w_adrs = 17;
        w_instruction = 32'hAAAA_AAAA;        
        
        //Start
        #10
        cpu_en = 1;
        w_enable = 0;

        #305
        $stop();    
    
    end
    
endmodule
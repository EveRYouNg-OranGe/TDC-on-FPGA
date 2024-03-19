
`include "define.v"

module tdc (input clk,
            input rst,
            input start,
            input stop,
            output [7:0] fine_out,     //synthesis keep
            output [15:0] coarse_out); //synthesis keep
    
    // wire	ext_rst;		// extenal reset
    wire    tdc_clk;        // 200M
    wire    sys_clk;        // 100M
    wire    sys_rst;        // reset signal after synchronization
    reg     hit;            // Marking of time between start signal and stop signal
    
    wire [`NUM_STAGES-1:0] fine_signal;
    // reg  [7:0]              fine_data;
    // reg  [15:0]             coarse_data;
    
    // assign fine_out   = fine_data;
    // assign coarse_out = coarse_data;
    
    reg start_prev, stop_prev;
    
    always @(posedge start or posedge stop) begin
        start_prev <= start;
        stop_prev  <= stop;
    end
    
    always @* begin
        if (start && !start_prev) begin
            hit <= 1'b1;
        end
            if (stop && !stop_prev) begin
                hit <= 1'b0;
            end
    end
    
    // clock and reset module
    clk_with_rst clk_rst_inst(
    .clk_in(clk),
    .rst(rst),
    .clk0_out(tdc_clk),
    .clk1_out(sys_clk),
    .sys_rst(sys_rst)
    );
    
    // coarse counter module
    tdc_coarse coarse_inst(
    .clk(tdc_clk),
    .rst(sys_rst),
    .hit(hit),
    .count(coarse_out)
    );
    
    // fine counter module
    tdc_fine fine_inst(
    .clk(tdc_clk),
    .hit(~hit),
    .parity(),
    .fine_out(fine_signal)
    );
    
    // fine decoder module
    tdc_decoder decoder_inst(
    .fine_in(fine_signal),
    .fine_data(fine_out)
    );
    
endmodule

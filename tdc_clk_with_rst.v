
/**
 * @description: system clock with reset curcuit
 * @parameters:
 *      clk0_out: tdc clk
 *      clk1_out: system clk
 *      sys_rst : system reset
 */
module clk_with_rst (input clk_in,
                     input rst,
                     output clk0_out,
                     output clk1_out,       //synthesis keep
                     output reg sys_rst);
    
    wire    pll_lock;           // pll locked
    wire    rst_and_lock;       // rst & pll_lock
    reg     syn;                
    
    pll u_pll(
    .refclk     (clk_in),
    .reset      (rst),
    .extlock    (pll_lock),
    .clk0_out   (clk0_out),
    .clk1_out   (clk1_out)
    );
    
    assign rst_and_lock = rst & pll_lock;
    
    // Synchronous reset circuit
    always@(posedge clk1_out or negedge rst_and_lock) begin
        if (!rst_and_lock)begin
            syn     <= 1'b0;
            sys_rst <= 1'b0;
        end
        else begin
            syn     <= 1'b1;
            sys_rst <= syn;
        end
    end
    
    
    
endmodule

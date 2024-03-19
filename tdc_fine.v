/**
 * @description:
 *          DS300 datasheet:
 *      mslice: ...
 */
`include "define.v"

module tdc_fine (input clk,
                 input rst,
                 input hit,
                 input start_store,
                 input stop_store,
                 output reg parity,                 //synthesis keep
                 output reg [`NUM_STAGES-1:0] start_out,
                 output reg [`NUM_STAGES-1:0] stop_out
                 );
    
    /* ip test: prevent insufficient pads */
    // wire [NUM_STAGES:0] mqa_out; //synthesis keep
    
    // MSLICE ripple
    localparam WIDTH_MQ = `NUM_STAGES * 2;
    // when clk posedge q output
    wire [`NUM_STAGES-1:0] mqa;         // mslice flip-flop q0 output bus
    wire [`NUM_STAGES-1:0] mqb;         // mslice flip-flop q1 output bus
    // output directly
    wire [`NUM_STAGES-1:0] mc;          // delay line outputs, lut4 carry output set
    
    /**
     * @description: The first mslice that the signal enters
     */
    EG_PHY_MSLICE #(
    // a[0] to fx[1:0] and fco
    .MODE("RIPPLE"),
    .ALUTYPE("ADD"),  // to be override by INIT_LUT*
    .INIT_LUT0(16'b0000000000001010),   // a[0] = > fx[0]
    .INIT_LUT1(16'b1111111111111111),   // fx[0] = > fx[1] = > fco
    .MSFXMUX("ON"),
    // fx[1:0] to q[1:0]
    .REG0_REGSET("RESET"),
    .REG0_SD("FX"),
    .REG1_REGSET("RESET"),
    .REG1_SD("FX"),
    .CLKMUX("CLK"),
    .CEMUX("1"),
    .SRMUX("0"),
    // others
    .TESTMODE("OFF")
    ) um0 (
    .a({1'b0, hit}),
    .q({mqb[0],mqa[0]}),
    .fco(mc[0]),
    //.ce(start_store | stop_store),
    //.sr(rst),
    .clk(clk)
    );
    genvar mi;
    generate for (mi = 1; mi<`NUM_STAGES; mi = mi+1) begin : M_CARRY
    EG_PHY_MSLICE #(
    // fci to fx[1:0] and fco
    .MODE("RIPPLE"),
    .ALUTYPE("ADD"),  // to be override by INIT_LUT*
    .INIT_LUT0(16'b1111111111111111),   // fci = > fx[0]
    .INIT_LUT1(16'b1111111111111111),   // fx[0] = > fx[1] = > fco
    .MSFXMUX("ON"),
    // fx[1:0] to q[1:0]
    .REG0_REGSET("RESET"),
    .REG0_SD("FX"),
    .REG1_REGSET("RESET"),
    .REG1_SD("FX"),
    .CLKMUX("CLK"),
    .CEMUX("1"),
    .SRMUX("0"),
    // others
    .TESTMODE("OFF")
    ) um1
    (
    .q({mqb[mi],mqa[mi]}),
    .fco(mc[mi]),
    .fci(mc[mi-1]),
    //.ce(start_store | stop_store),
    //.sr(rst),
    .clk(clk)
    );
    end // M_CARRY
    endgenerate
    
    /* get parity */
    // reg [WIDTH_MQ-1:0] mq_reg;
    // always @(posedge start_store or posedge stop_store) begin
    //     mq_reg = {mqb,mqa};
    //     parity = ^mq_reg;
    // end
    always @(*) begin
        parity = 1'b1;
    end

    // mqa output when clk posedge 
    always @(posedge start_store or posedge rst) begin
        if (rst) begin
            start_out <= 'd0;
        end
        else if (start_store) begin
            start_out <= mqa[`NUM_STAGES-1:0];
        end
    end
    always @(posedge stop_store or posedge rst) begin
        if (rst) begin
            stop_out <= 'd0;
        end
        else if (stop_store) begin
            stop_out <= mqa[`NUM_STAGES-1:0];
        end
    end
    // assign fine_out = mqa[`NUM_STAGES-1:0];
    
endmodule

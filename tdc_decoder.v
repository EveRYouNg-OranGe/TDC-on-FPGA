
`include "define.v"

module tdc_decoder(
    input [`NUM_STAGES-1:0] fine_in,
    input shift,
    output [7:0] fine_out
);

reg [7:0] fine_data;
integer i;

wire [`NUM_STAGES-1:0] fine;

assign fine = fine_in;

always @(fine)
begin
    fine_data = 8'hff;
    if(shift)begin
        for(i=0;i<`NUM_STAGES -20; i = i + 1'b1)
        begin
            if(fine[i] & ~fine[i+1] & ~fine[i+2] & ~fine[i+3] & ~fine[i+4])
            begin
                fine_data = i + 1;
            end
        end
    end
    else begin
        for(i=0;i<`NUM_STAGES -20; i = i + 1'b1)
        begin
            if(~fine[i] & fine[i+1] & fine[i+2] & fine[i+3] & fine[i+4])
            begin
                fine_data = i + 1;
            end
        end
    end
end

assign fine_out = fine_data;

endmodule

/*  
-- decoder can be optimized like this:
    -- "Count leading symbol" function inspired by the post by Ulf Samuelsson
    -- http://www.velocityreviews.com/forums/t25846-p4-how-to-count-zeros-in-registers.html
    --
    -- The idea is to use a divide-and-conquer approach to process a 2^N bit number.
    -- We split the number in two equal halves of 2^(N-1) bits:
    --   MMMMLLLL
    -- then, we check if all bits of MMMM are of the counted symbol.
    -- If it is,
    --      then the number of leading symbols is 2^(N-1) + CLS(LLLL)
    -- If it is not,
    --      then the number of leading symbols is CLS(MMMM)
    -- Recursion stops with CLS(0) = 0 and CLS(1) = 1.
    --
    -- If at least one bit of the input is not the symbol, we never propagate a carry
    -- and the additions can be replaced by OR's, giving the result bit per bit.
    -- We assume here an implicit LSB with a !symbol value, and work with inputs
    -- widths that are a power of 2 minus one.
*/

/* Abandoned case */
/**
 * how to get the boundary between 0 and 1:
 *  00000001010111111111  [Assumed value]
 *  11111110101000000000  [Negation]
 *  11111111010100000000  [Inv right shift by 1 bit]
 *  11111111101010000000  [Inv right shift by 2 bits]
 *  ->
 *  00000001010111111111  &
 *  11111111010100000000  &
 *  11111111101010000000  ->
 *  00000001000000000000  ['inv 1 bit' & 'inv 2 bits' & 'source']
 */

// module tdc_decoder (input [`NUM_STAGES-1:0] fine_in,
//                     output reg state,
//                     output reg [7:0] fine_data);
    
//     // data registers
//     reg [`NUM_STAGES-1:0] fine;
//     reg [`NUM_STAGES-1:0] fine_inv;
//     reg [`NUM_STAGES-1:0] inv_shift_1bit;
//     reg [`NUM_STAGES-1:0] inv_shift_2bit;
//     reg [`NUM_STAGES-1:0] fine_dest;
//     parameter   busy = 1'b1,
//                 idle = 1'b0;
    
//     integer i;
//     always @(*) begin
//         fine_data = 8'hFF; // Default value if no 1 is found
//         state = busy;
//         // deposit input data
//         fine     = fine_in;
//         fine_inv = ~fine;
//         // get the boundary
//         inv_shift_1bit = {1'b0, fine_inv[`NUM_STAGES-1:1]};
//         inv_shift_2bit = {1'b0, inv_shift_1bit[`NUM_STAGES-1:1]};
//         fine_dest       = fine & inv_shift_1bit & inv_shift_2bit;
//         // decode the destination
//         begin : check
//             for (i = 0; i < `NUM_STAGES; i = i + 1) begin
//                 if (fine_dest[i] == 1'b1) begin
//                     fine_data = i;
//                     disable check;
//                 end
//             end
//         end
//         state = idle;
//     end
    
// endmodule
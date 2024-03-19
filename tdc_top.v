`include "define.v"

module tdc (input clk,
			input reset,
			input hit,
            // output parity,
			output [31:0] time_out);
    
    // reg  [8:0] cnt = 9'd0;
    wire  clk_tdc;
    wire  clk_sys;
    
    wire [`NUM_STAGES-1:0] start_out;
    wire [`NUM_STAGES-1:0] stop_out;
    // reg     hit   = 0;
    
    wire    start_store;
    wire    stop_store;
    wire [7:0] start_data;        //synthesis keep
    wire [7:0] stop_data;        //synthesis keep
    wire [7:0] coarse_data;
	//wire [31:0] time_data;

	fine_trigger_filter filter_inst(
		.clk(clk_tdc),
		.rst(reset),
		.trigger(hit),
		.pos_pulse(start_store),
		.neg_pulse(stop_store)
	);
    
    tdc_fine fine_inst(
    .clk(clk_tdc),
    .rst(reset),
    .hit(hit),
    .start_store(start_store),
    .stop_store(stop_store),
    // .parity(parity),    //synthesis keep
    .start_out(start_out),
    .stop_out(stop_out)
    );
    
    tdc_decoder start_decoder_inst(
    .fine_in(start_out),
    .shift(1'b1),
    .fine_out(start_data)
    );
    tdc_decoder stop_decoder_inst(
    .fine_in(stop_out),
    .shift(1'b0),
    .fine_out(stop_data)
    );
    
    pll pll_inst(
    .refclk     (clk),
    .reset      (1'b0),
    .extlock    (),
    .clk0_out   (clk_tdc),
    .clk1_out   (clk_sys)
    );
    
    tdc_coarse coarse_inst(
    .clk(clk_tdc),
    .rst(reset),
    .hit(hit),
    .store(stop_store),
    .count(coarse_data)
    );

	tdc_data_processor processor_inst(
	.fine_start_data(start_data),
	.fine_stop_data(stop_data),
	.coarse_data(coarse_data),
	.time_data(time_out)
	);
    

	/* Counting clock signals */
	/* DEBUG 
    always @(posedge clk_sys)
    begin
        cnt <= cnt + 1;
    end
    always @(posedge clk_sys)
    begin
        if (cnt == 9'd5)
            reset <= 1'b1;
        else
            reset <= 1'b0;
    end
	*/
    
    /* Mark the time between the start and stop signals with a higher clock */
	/* DEBUG 
    always @(posedge clk_sys)
    begin
        if (cnt == 9'd7)
            hit <= 1'b1;
        else if (cnt == 9'd10)
            hit <= 1'b0;
    end
	*/
    
endmodule

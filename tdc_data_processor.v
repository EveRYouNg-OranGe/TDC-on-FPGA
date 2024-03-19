`include "define.v"

module tdc_data_processor (
	input [7:0] fine_start_data,
	input [7:0]	fine_stop_data,
	input [7:0] coarse_data,
	output	[31:0]	time_data
);

	assign time_data = coarse_data*`COARSE_CLK + (fine_start_data-fine_stop_data)*65;
	
endmodule
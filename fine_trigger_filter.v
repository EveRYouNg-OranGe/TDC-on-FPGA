module fine_trigger_filter (input clk,
                            input rst,
                            input trigger,
                            output pos_pulse,
                            output neg_pulse);
							
    reg     trigger_n 	= 0;
    reg     trigger_2n 	= 0;
    
    /* Here you can know that these two sets of signals are delay signals for start and stop,
     with a delay of one or two clk_s cycle */
    always @(posedge clk)
    begin
        if (rst) begin
            trigger_n 	 <= 0;
            trigger_2n	 <= 0;
        end
        else begin
            trigger_n 	 <= trigger;
            trigger_2n	 <= trigger_n;
        end
    end
    
    assign pos_pulse = (trigger_n&(!trigger_2n));
    assign neg_pulse  = (trigger_2n&(!trigger_n));
    
endmodule


/**
 * @description: Coarse counter
 *               Two counters counting simultaneously, select the stable counting result
 * @parameters:
 *      clk_in : 200Mhz ~ 5ns
 */
module tdc_coarse(input clk,
                  input rst,
                  input hit,
                  input store,
                  output [7:0] count //synthesis keep
                  );
    
    reg [7:0] counter      = 8'd0;
    reg [7:0] counter_n    = 8'd0;
    reg [7:0] count_value  = 8'd0;

    /**
     * @description: coarse counter triggered by rising edge
     */
    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 8'd0;
        else if(hit)
            counter <= counter_n;
    end
    always @(*) begin
        counter_n = counter + 8'd1;
    end	
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            count_value <= 8'd0;
        else if(store) 
            count_value <= counter;
    end

    assign count = count_value;
    
endmodule

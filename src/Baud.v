module Baud(clk,rst,baud_tick);

parameter BAUD = 9600 ;
parameter FREQUENCY = 100000000 ;

localparam FINAL = (FREQUENCY / (BAUD)) ;

input clk,rst ;
output reg baud_tick ;

reg [19:0]counter ;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        counter <= 0 ;
        baud_tick <=0 ;
    end
    else if(counter == FINAL-1) begin
        counter <= 0 ;
        baud_tick <= 1 ;
    end
    else begin
        counter <= counter + 1 ;
        baud_tick <= 0 ;
    end
end

endmodule


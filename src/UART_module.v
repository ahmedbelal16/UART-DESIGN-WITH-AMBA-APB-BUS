module UART_module (PRESETn,PCLK,rx_en,rx_rst,tx_en,tx_rst,tx_data,
            tx_busy,tx_done,rx_busy,rx_done,rx_error,rx_data,baud_tick,RX,TX);

parameter START_BIT = 0 ;
parameter END_BIT= 1 ;

//CLK and RESET
input PRESETn,PCLK ;

//UART -----> APB SLAVE
input rx_en,rx_rst,tx_en,tx_rst ;
input [7:0] tx_data ;

//APB SLAVE -----> UART
output reg tx_busy,tx_done,rx_busy,rx_done,rx_error ;
output reg [7:0] rx_data;

//BAUD CLK
input baud_tick ;

//UART INPUT
input RX ;

//UART OUTPUT
output reg TX ;

reg [9:0] tx_reg ;
reg [3:0] tx_counter ;
reg [9:0] rx_reg ;
reg [3:0] rx_counter ;

/*Always Block that give the tx_data from APB SLAVE -----> the UART
,and only updated when the tx_busy is LOW ,also add the START and END_BIT bits */
always @(posedge PCLK or negedge PRESETn) begin
        if (~PRESETn)
            tx_reg <= 0;
        else if (tx_rst)
            tx_reg <= 0;
        else if (~tx_busy)
            tx_reg <= {1'b0,tx_data,1'b1} ;
end


always @(posedge PCLK or negedge PRESETn) begin
    if(~PRESETn) begin 
        TX <= 1 ;
        tx_counter <= 9 ;
        tx_busy <= 0 ;
        tx_done <= 0 ;
    end
    else if(tx_rst) begin 
        TX <= 1 ;
        tx_counter <= 9 ;
        tx_busy <= 0 ;
        tx_done <= 0 ;
    end
    else begin
        if (tx_en & baud_tick) begin
            TX <= tx_reg[tx_counter] ;
            tx_counter <= tx_counter - 1 ;
            
            if (tx_counter == 0) begin
                tx_busy <= 0 ;
                tx_done <= 1 ;
                tx_counter <= 9 ;
            end
            else begin
                tx_busy <= 1 ;
                tx_done <= 0 ;
            end
        end
    end 
end

/*Always Block that give the rx_data from UART -----> APB SLAVE
,and only updated when the rx_done is LOW ,also remove the START and END_BIT bits */
always @(posedge PCLK or negedge PRESETn) begin
    if(~PRESETn) begin
        rx_counter <= 9;
        rx_busy <= 0 ;
        rx_done <= 0 ;
        rx_reg <= 0 ;
    end
    else if(rx_rst) begin
        rx_counter <= 9;
        rx_busy <= 0 ;
        rx_done <= 0 ;
        rx_reg <= 0 ;
    end
    else begin
        if (rx_en & baud_tick & !rx_done) begin
            rx_counter <= rx_counter - 1 ;
            rx_reg[rx_counter] <= RX ;

            if (rx_counter == 0) begin
                rx_busy <= 0 ;
                rx_done <= 1 ;
                rx_data <= rx_reg [8:1] ;
                rx_counter <= 9 ;
            end
            else
                rx_busy <= 1 ;
                // rx_done <= 0 ;

        end
    end 
end

//PRESET that reset all the outputs and the rx_error signal
always @(posedge PCLK or negedge PRESETn) begin
    if (~PRESETn) begin
        rx_error <= 0 ;
    end
    else if (rx_done && (rx_reg[0] != 1'b1 || rx_reg[9] != 1'b0))
        rx_error <= 1 ;
    else
        rx_error <= 0 ;
end
    
endmodule




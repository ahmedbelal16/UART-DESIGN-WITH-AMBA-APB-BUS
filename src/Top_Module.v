module UART_APB_Top (PCLK,PRESETn,PSEL,PENABLE,PWRITE,PADDR,
                    PWDATA,PRDATA,PREADY,RX,TX);

input  PCLK ;           // System clock
input  PRESETn ;        // Active-low reset

// APB interface
input PSEL,PENABLE,PWRITE ;
input [31:0] PADDR ;
input [31:0] PWDATA ;
output [31:0] PRDATA ;
output       PREADY ;

// UART pins
input  RX ;   // UART receive pin
output TX ;  // UART transmit pin

// Internal wires
wire rx_en, rx_rst, tx_en, tx_rst;
wire [7:0] tx_data;
wire [7:0] rx_data;
wire tx_busy, tx_done, rx_busy, rx_done, rx_error;

// Baud clock
wire BCLK;

    // Instantiate Baud generator
    Baud baud_gen (
        .clk(PCLK),
        .rst(PRESETn),
        .BCLK(BCLK)
    );

    // Instantiate UART
    UART_module uart_inst (
        .PRESETn(PRESETn),
        .PCLK(PCLK),
        .rx_en(rx_en),
        .rx_rst(rx_rst),
        .tx_en(tx_en),
        .tx_rst(tx_rst),
        .tx_data(tx_data),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_busy(rx_busy),
        .rx_done(rx_done),
        .rx_error(rx_error),
        .rx_data(rx_data),
        .BCLK(BCLK),
        .RX(RX),
        .TX(TX)
    );

    // Instantiate APB Slave
    APB_Slave apb_slave (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PADDR(PADDR),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),

        // UART -> APB
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx_busy(rx_busy),
        .rx_done(rx_done),
        .rx_error(rx_error),
        .rx_data(rx_data),

        // APB -> UART
        .rx_en(rx_en),
        .rx_rst(rx_rst),
        .tx_en(tx_en),
        .tx_rst(tx_rst),
        .tx_data(tx_data)
    );

endmodule


module Project_TB();

parameter IDLE = 2'b00 ;
parameter SETUP = 2'b01 ;
parameter ACCESS = 2'b10 ;
parameter ADDR_CTRL_REG = 32'h00000000 ;
parameter ADDR_STATS_REG = 32'h00000001 ;
parameter ADDR_TX_REG = 32'h00000002 ;
parameter ADDR_RX_REG = 32'h00000003 ;

reg PCLK,PRESETn,PSEL,PENABLE,PWRITE ;
reg [31:0] PADDR,PWDATA ;
reg RX ;

wire [31:0] PRDATA;
wire PREADY ;
wire TX ;

UART_APB_Top tb (PCLK,PRESETn,PSEL,PENABLE,PWRITE,PADDR,
                PWDATA,PRDATA,PREADY,RX,TX);

initial begin
    PCLK = 0 ;
    forever begin
        #5 PCLK = ~PCLK ;
    end
end

initial begin
    //RESET HIGH
    PRESETn = 0;
    PSEL    = 0;
    PWRITE  = 0;
    PENABLE = 0;
    PADDR   = 0;
    PWDATA  = 0;
    @(negedge PCLK);

    //RESER LOW
    PRESETn = 1;
    @(negedge PCLK);

    //MAKE rx_rst & tx_rst HIGH (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000006;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO CTRL_REG REGISTER (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

//============================================================
// TX TESTING
//============================================================

    //MAKE rx_rst & tx_rst HIGH (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000006;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO CTRL_REG REGISTER (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    //MAKE tx_en HIGH (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000008;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO UART (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);
    
    //UPLOAD THE DATA TO TX_DATA REGISTER (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000002;
    PWDATA = 32'h00000091;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO UART (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    //THE SHIFT PROCESS TO GET TX OUT OF UART
    repeat (10417 * 10) @(negedge PCLK);

    //MAKE rx_en HIGH (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000008;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO UART (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    //ANOTHER UPLOAD FOR DATA TO TX_DATA REGISTER (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000002;
    PWDATA = 32'h00000034;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO UART (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    //THE SHIFT PROCESS TO GET TX OUT OF UART
    repeat (10417 * 10) @(negedge PCLK);

//============================================================
// RX TESTING
//============================================================

    //MAKE rx_rst & tx_rst HIGH (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000006;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO CTRL_REG REGISTER (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    //MAKE rx_en HIGH (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000001;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO UART (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    // Now drive RX line manually to send one byte (e.g. 0xA5 = 1010_0101)
    // Start bit (0)
    RX = 0;
    repeat (10417) @(negedge PCLK);   // 1 bit time

    // Data bits LSB first
    RX = 1; repeat (10417) @(negedge PCLK);  // bit0
    RX = 0; repeat (10417) @(negedge PCLK);  // bit1
    RX = 1; repeat (10417) @(negedge PCLK);  // bit2
    RX = 0; repeat (10417) @(negedge PCLK);  // bit3
    RX = 0; repeat (10417) @(negedge PCLK);  // bit4
    RX = 1; repeat (10417) @(negedge PCLK);  // bit5
    RX = 0; repeat (10417) @(negedge PCLK);  // bit6
    RX = 1; repeat (10417) @(negedge PCLK);  // bit7

    // Stop bit (1)
    RX = 1;

    // Wait for UART to finish
    repeat (10417*2) @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO UART (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    // Now read RX register from APB (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 0;                  // READ
    PENABLE = 0;
    PADDR = 32'h00000003;        // RX register
    @(negedge PCLK);

    // PENABLE HIGH TO READ (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    // PSEL LOW (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

//============================================================
// RX ERROR TESTING
//============================================================

    //MAKE rx_rst & tx_rst HIGH (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000006;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO CTRL_REG REGISTER (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    //MAKE rx_en HIGH (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 1;
    PENABLE = 0;
    PADDR = 32'h00000000;
    PWDATA = 32'h00000001;
    @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO UART (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    // Now drive RX line manually to send one byte (e.g. 0xA5 = 1010_0101)
    // Start bit (0)
    RX = 0;
    repeat (10417) @(negedge PCLK);   // 1 bit time

    // Data bits LSB first
    RX = 1; repeat (10417) @(negedge PCLK);  // bit0
    RX = 0; repeat (10417) @(negedge PCLK);  // bit1
    RX = 1; repeat (10417) @(negedge PCLK);  // bit2
    RX = 0; repeat (10417) @(negedge PCLK);  // bit3
    RX = 0; repeat (10417) @(negedge PCLK);  // bit4
    RX = 1; repeat (10417) @(negedge PCLK);  // bit5
    RX = 0; repeat (10417) @(negedge PCLK);  // bit6
    RX = 1; repeat (10417) @(negedge PCLK);  // bit7

    // Stop bit (1)
    RX = 0;

    // Wait for UART to finish
    repeat (10417) @(negedge PCLK);

    //PENABLE HIGH TO UPLOAD THE DATA TO UART (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);

    //PSEL LOW TO RETURN TO IDLE (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);

    // Now read RX register from APB (IDLE ---> SETUP)
    PSEL = 1;
    PWRITE = 0;                  // READ
    PENABLE = 0;
    PADDR = 32'h00000003;        // RX register
    @(negedge PCLK);
    
    // PENABLE HIGH TO READ (SETUP ---> ACCESS)
    PENABLE = 1;
    @(negedge PCLK);
    
    // PSEL LOW (ACCESS ---> IDLE)
    PSEL = 0;
    @(negedge PCLK);
    


$stop;
end

endmodule
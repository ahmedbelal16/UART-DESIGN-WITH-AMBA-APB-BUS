module APB_Slave(PCLK,PRESETn,PSEL,PENABLE,PWRITE,PADDR,PWDATA,PRDATA,PREADY
                ,tx_busy,tx_done,rx_busy,rx_done,rx_error,rx_data,rx_en
                ,rx_rst,tx_en,tx_rst,tx_data);

parameter IDLE = 2'b00 ;
parameter SETUP = 2'b01 ;
parameter ACCESS = 2'b10 ;
parameter ADDR_CTRL_REG = 32'h00000000 ;
parameter ADDR_STATS_REG = 32'h00000001 ;
parameter ADDR_TX_REG = 32'h00000002 ;
parameter ADDR_RX_REG = 32'h00000003 ;

//MASTER -----> APB SLAVE
input PCLK,PRESETn,PSEL,PENABLE,PWRITE ;
input [31:0] PADDR,PWDATA ;

//APB SLAVE -----> MASTER
output reg [31:0] PRDATA;
output reg PREADY ;

//UART -----> APB SLAVE
input tx_busy,tx_done,rx_busy,rx_done,rx_error ;
input [7:0] rx_data;

//APB SLAVE -----> UART
output rx_en,rx_rst,tx_en,tx_rst ;
output [7:0] tx_data ;

//REGISTERS VALUES
reg [31:0] CTRL_REG,STATS_REG,TX_DATA,RX_DATA ;

//CS & NS
reg [1:0] cs,ns ;

always @(posedge PCLK or negedge PRESETn) begin
    if (~PRESETn)
        cs <= IDLE ;
    else 
        cs <= ns ;
end

//NEXT STATE LOGIC
always @(*) begin
    
    case (cs)
        IDLE: begin
            if (PSEL)
                ns = SETUP ;
            else
                ns = IDLE ;
        end
    
        SETUP: begin
            if (PSEL & PENABLE)
                ns = ACCESS ;
            else
                ns = SETUP ;
        end
        
        ACCESS: begin
            if (PSEL & PREADY)
                ns = SETUP ;
            else if (~PSEL)
                ns = IDLE ;
            else
                ns = ACCESS ;
        end

    endcase
end

//OUTPUT LOGIC
always @(posedge PCLK or negedge PRESETn) begin

    if(~PRESETn) begin
        CTRL_REG <= 0;
        TX_DATA  <= 0;
        PREADY   <= 0;
        PRDATA   <= 0;
    end
    else begin
        case (cs)

            IDLE: begin
                PRDATA <= 0 ;
                PREADY <= 0 ;
            end

            SETUP: begin
                PRDATA <= 0 ;
                PREADY <= 0 ;
            end

            ACCESS: begin
                if (PWRITE) begin
                    if (PENABLE) begin
                        PREADY <= 1 ;

                        //to choose which regisiter will take the Write data
                        if (PADDR == ADDR_CTRL_REG) begin
                            CTRL_REG <= PWDATA ;
                        end
                        else begin
                            TX_DATA <= PWDATA ;
                        end
                    end
                    else
                        PREADY <= 0 ;
                end
                else begin

                    if (PENABLE) begin
                        PREADY <= 1 ;

                        if (PADDR == ADDR_RX_REG)
                            PRDATA <= RX_DATA ;
                        else
                            PRDATA <= STATS_REG ;
                    end
                    else begin
                        PREADY <= 0 ;
                    end

                end
            end
        endcase
    end
end


//CTRL_REG SIGNALS
    assign rx_en = CTRL_REG[0] ;
    assign rx_rst = CTRL_REG[1] ;
    assign tx_rst = CTRL_REG[2] ;
    assign tx_en = CTRL_REG[3] ;

//TX_REG SIGNALS
    assign tx_data = TX_DATA ;

//STATS_REG SIGNALS
always @(posedge PCLK or negedge PRESETn) begin
    if (~PRESETn)
        STATS_REG <= 0 ;
    else begin
        STATS_REG[0] <= tx_busy ;
        STATS_REG[1] <= tx_done ;
        STATS_REG[2] <= rx_busy ;
        STATS_REG[3] <= rx_done ;
        STATS_REG[4] <= rx_error ;
        STATS_REG[31:5] <= 0 ;
    end
end

//RX_REG SIGNALS
always @(posedge PCLK or negedge PRESETn) begin
    if(~PRESETn)
        RX_DATA <= 0 ;
    else if(rx_done) begin
        RX_DATA[7:0] <= rx_data ;
    end
end

endmodule


vlib work
vlog APB_Master.v 
vlog Baud.v 
vlog UART_module.v 
vlog Top_Module.v 
vlog Project_TB.v
vsim -voptargs=+acc work.Project_TB
add wave -position insertpoint  \
sim:/Project_TB/PCLK \
sim:/Project_TB/PRESETn \
sim:/Project_TB/PSEL \
sim:/Project_TB/PENABLE \
sim:/Project_TB/PWRITE \
sim:/Project_TB/PADDR \
sim:/Project_TB/PWDATA \
sim:/Project_TB/RX \
sim:/Project_TB/PRDATA \
sim:/Project_TB/PREADY \
sim:/Project_TB/TX
add wave -position insertpoint  \
sim:/Project_TB/tb/tx_en \
sim:/Project_TB/tb/tx_rst \
sim:/Project_TB/tb/tx_data \
sim:/Project_TB/tb/tx_busy \
sim:/Project_TB/tb/tx_done
add wave -position insertpoint  \
sim:/Project_TB/tb/apb_slave/CTRL_REG \
sim:/Project_TB/tb/apb_slave/STATS_REG \
sim:/Project_TB/tb/apb_slave/TX_DATA \
sim:/Project_TB/tb/apb_slave/RX_DATA \
sim:/Project_TB/tb/apb_slave/cs \
sim:/Project_TB/tb/apb_slave/ns
add wave -position insertpoint  \
sim:/Project_TB/tb/rx_en \
sim:/Project_TB/tb/rx_rst \
sim:/Project_TB/tb/rx_data \
sim:/Project_TB/tb/rx_busy \
sim:/Project_TB/tb/rx_done \
sim:/Project_TB/tb/rx_error
add wave -position insertpoint  \
sim:/Project_TB/tb/uart_inst/tx_reg \
sim:/Project_TB/tb/uart_inst/tx_counter \
sim:/Project_TB/tb/uart_inst/rx_reg \
sim:/Project_TB/tb/uart_inst/rx_counter
add wave -position insertpoint  \
sim:/Project_TB/tb/BCLK
run -all
#quit -sim

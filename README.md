# 🛰️ UART with AMBA APB Bus Interface (FPGA)

📌 **Project Overview**  
Welcome to the **UART with AMBA APB Bus Project** — a custom IP core developed in **Verilog HDL**, designed to integrate a **Universal Asynchronous Receiver-Transmitter (UART)** with an **AMBA APB (Advanced Peripheral Bus) interface**.  
The design enables reliable serial communication (TX/RX) while being memory-mapped and easily configurable as part of a **System-on-Chip (SoC)**.  

---

## 🎯 Features
- ✅ **UART Transmitter** with start & stop bits, busy/done signaling  
- ✅ **UART Receiver** with error detection for invalid frames  
- ✅ **APB Slave Interface** with control & status registers (IDLE → SETUP → ACCESS protocol)  
- ✅ **Baud Rate Generator** for accurate bit timing (default: 9600 baud @ 100 MHz system clock)  
- ✅ Testbench & simulation using **QuestaSim** 🧪  
- ✅ RTL linting with **QuestaLint** for clean code ✅  
- ✅ FPGA synthesis and implementation flow with **Vivado** 📦  

---

## 📂 File Structure
> Update repo links as needed when you upload.  

| Path | Description |
|---|---|
| [**UART Module**](https://github.com/ahmedbelal16/UART-DESIGN-WITH-AMBA-APB-BUS/blob/main/src/UART_module.v) | UART core (transmitter, receiver, error detection) |
| [**APB Slave Module**](https://github.com/ahmedbelal16/UART-DESIGN-WITH-AMBA-APB-BUS/blob/main/src/APB_Master.v) | APB slave interface (register decode, control/status logic) |
| [**Baud Module**](https://github.com/ahmedbelal16/UART-DESIGN-WITH-AMBA-APB-BUS/blob/main/src/Baud.v) | Baud rate generator (9600 baud default) |
| [**Top Module.v**](https://github.com/ahmedbelal16/UART-DESIGN-WITH-AMBA-APB-BUS/blob/main/src/Top_Module.v) | Top-level wrapper integrating UART, APB, and Baud |
| [**Test Bench**](https://github.com/ahmedbelal16/UART-DESIGN-WITH-AMBA-APB-BUS/blob/main/dv/Project_TB.v) | Testbench verifying UART + APB communication |
| [**Run File**](https://github.com/ahmedbelal16/UART-DESIGN-WITH-AMBA-APB-BUS/blob/main/dv/NTI.do) | QuestaSim automation script (compile, simulate, waveforms) |
| [**Constraints File**](https://github.com/ahmedbelal16/UART-DESIGN-WITH-AMBA-APB-BUS/blob/main/dv/Constraint_UART_APB.xdc) | Clock constraints |
| [**Project Report**](https://github.com/ahmedbelal16/UART-DESIGN-WITH-AMBA-APB-BUS/blob/main/docs/Project%20Report.pdf) | Final report with design explanation, waveforms, lint, and synthesis results |

---

## 🛠️ Implementation Details

### 🖥️ UART Module
- **Transmitter:** Loads data with start (0) and stop (1) bits, shifts out serially with correct timing.  
- **Receiver:** Detects start bit, samples 8 data bits, validates stop bit, asserts `rx_done` when complete.  
- **Error Detection:** Flags invalid frames (e.g., missing stop bit).  
- **Status Signals:** `tx_busy`, `tx_done`, `rx_busy`, `rx_done`, `rx_error`.  

### 📦 APB Slave
- Provides **memory-mapped registers**:  
  - `CTRL_REG`: Enable/reset signals for TX/RX  
  - `STATS_REG`: Flags for busy/done/error  
  - `TX_DATA`: Data to transmit  
  - `RX_DATA`: Received data  
- Fully compliant with **APB3 protocol** (IDLE, SETUP, ACCESS).  

### ⏱️ Baud Generator
- Divides the system clock (100 MHz) to generate a **baud tick** for UART.  
- Default: 9600 baud → tick every 10417 cycles.  

### 🔗 Top Module
- Integrates APB Slave, UART, and Baud generator into a **single IP block**.  
- Provides external **RX/TX pins** and APB interface for SoC integration.  

---

## 🔍 Debugging & Testing
- ✅ Functional simulation in **QuestaSim** with a testbench driving APB reads/writes and UART RX/TX.  
- ✅ Waveforms confirm proper serial transmission, reception, and error handling.  
- ✅ **QuestaLint** reports clean RTL with no critical issues.  
- ✅ FPGA flow verified in **Vivado** (synthesis + implementation).  

---

## 📊 Results Summary
- **UART TX/RX** works with busy/done signaling.  
- **Error detection** verified for invalid stop bits.  
- **APB compliance** validated with testbench sequences.  
- **Baud generator** accurately drives communication timing.  
- **Implementation** achieved with no timing violations.  

---

## 🏁 Conclusion
This project demonstrates the complete design of a **UART IP core with APB interface**, from **RTL coding and simulation** to **linting, FPGA synthesis, and testing**.  
The design can be reused as a SoC peripheral, supporting reliable serial communication and standard AMBA APB bus connectivity. 🚀  

---

## 🧑‍💻 Designed By
- **Ahmed Belal** 

---

## ⭐ Final Note
If you found this project useful, please ⭐ star the repository and share it!  
Feedback and suggestions are welcome — let’s keep learning and building amazing digital designs together. 💡  

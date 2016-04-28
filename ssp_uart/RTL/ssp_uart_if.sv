
`ifndef SSP_UART_IF__SV
`define SSP_UART_IF__SV

`timescale 1ns / 1ps

/**
 * @brief SSP_UART Interface.
 * This interface is used to program the deice.
 * Modports:
 * <ul>
 *  <li> bfm - bus functional model - has bfm_cb clking block </li>
 *  <li> mon - passive monitor - has mon_cb clking block</li>
 * </ul>
 *
 * @param clk bit - input clock
 */
interface ssp_uart_if (input logic clk);
    
    //inputs
    logic  Rst_sig;                    // System Reset
    logic  Clk_sig;                    // System Clock
    logic  SSP_SSEL_sig;               // SSP Slave Select
    logic  SSP_SCK_sig;                // Synchronous Serial Port Serial Clock
    logic  [2:0] SSP_RA_sig;           // SSP Register Address
    logic  SSP_WnR_sig;                // SSP Command
    logic  SSP_En_sig;                 // SSP Start Data Transfer Phase (Bits 11:0)
    logic  SSP_EOC_sig;                // SSP End-Of-Cycle (Bit 0)
    logic  [11:0] SSP_DI_sig;          // SSP Data In
    logic  RxD_232_sig;                // RS-232 Mode RxD
    logic  xCTS_sig;                   // RS-232 Mode CTS (Okay-To-Send)
    logic  RxD_485_sig;                // RS-485 Mode RxD

    //outputs
    logic  [11:0] SSP_DO_sig;          // SSP Data Out
    logic  TxD_232_sig;                // RS-232 Mode TxD
    logic  xRTS_sig;                   // RS-232 Mode RTS (Ready-To-Receive)
    logic  TxD_485_sig;                // RS-485 Mode TxD
    logic  xDE_sig;                    // RS-485 Mode Transceiver Drive Enable
    logic  IRQ_sig;                    // Interrupt Request
    logic  TxIdle_sig;
    logic  RxIdle_sig;

    logic  usr_0;
endinterface: ssp_uart_if

`endif


`timescale 1 ns / 1 ns

module hdl_top;


   // ----------------------------------------------------------------
   // -- Signal Declarations
   // ----------------------------------------------------------------
   //wire clk;
   //wire rst;

   wire Rst;                    
   wire Clk;                    
   wire SSP_SSEL;               
   wire SSP_SCK;               
   wire [2:0] SSP_RA;         
   wire SSP_WnR;                
   wire SSP_En;             
   wire SSP_EOC;             
   wire [11:0] SSP_DI;          
   wire RxD_232;                
   wire xCTS;                   
   wire RxD_485;                
   wire [11:0] SSP_DO;   //reg   
   wire TxD_232;                
   wire xRTS; //reg              
   wire TxD_485;                
   wire xDE;                    
   wire IRQ;  //reg
   wire TxIdle;
   wire RxIdle;

   // ----------------------------------------------------------------
   // -- Component Instantiations
   // ----------------------------------------------------------------
   ssp_uart_if ssp_uart_cfg_if_i(.clk(clk));

   assign Rst 	 	= ssp_uart_cfg_if_i.Rst_sig;                    
   assign Clk		= ssp_uart_cfg_if_i.Clk_sig;                    
   assign SSP_SSEL	= ssp_uart_cfg_if_i.SSP_SSEL_sig;               
   assign SSP_SCK	= ssp_uart_cfg_if_i.SSP_SCK_sig;               
   assign SSP_RA	= ssp_uart_cfg_if_i.SSP_RA_sig;         
   assign SSP_WnR	= ssp_uart_cfg_if_i.SSP_WnR_sig;                
   assign SSP_En	= ssp_uart_cfg_if_i.SSP_En_sig;             
   assign SSP_EOC	= ssp_uart_cfg_if_i.SSP_EOC_sig;             
   assign SSP_DI	= ssp_uart_cfg_if_i.SSP_DI_sig;          
   assign RxD_232	= ssp_uart_cfg_if_i.RxD_232_sig;                
   assign xCTS		= ssp_uart_cfg_if_i.xCTS_sig;                   
   assign RxD_485	= ssp_uart_cfg_if_i.RxD_485_sig;                


   // ----------------------------------------------------------------
   // -- DUT (Design Under Test)
   // ----------------------------------------------------------------

   SSP_UART ssp_uart(
    .Rst(Rst),			// System Reset
    .Clk(Clk),			// System Clock
    .SSP_SSEL(SSP_SSEL),	// SSP Slave Select
    .SSP_SCK(SSP_SCK),		// Synchronous Serial Port Serial Clock
    .SSP_RA(SSP_RA),		// SSP Register Address
    .SSP_WnR(SSP_WnR),		// SSP Command
    .SSP_En(SSP_En),		// SSP Start Data Transfer Phase (Bits 11:0)
    .SSP_EOC(SSP_EOC),		// SSP End-Of-Cycle (Bit 0)
    .SSP_DI(SSP_DI),		// SSP Data In
    .RxD_232(RxD_232),		// RS-232 Mode RxD
    .xCTS(xCTS),		// RS-232 Mode CTS (Okay-To-Send)
    .RxD_485(RxD_485),		// RS-485 Mode RxD
    .SSP_DO(SSP_DO),		// SSP Data Out
    .TxD_232(TxD_232),		// RS-232 Mode TxD
    .xRTS(xRTS),		// RS-232 Mode RTS (Ready-To-Receive)
    .TxD_485(TxD_485),		// RS-485 Mode TxD
    .xDE(xDE),			// RS-485 Mode Transceiver Drive Enable
    .IRQ(IRQ),			// Interrupt Request
    .TxIdle(TxIdle),
    .RxIdle(RxIdle)
);

   function void get_interface(output virtual ssp_uart_if ssp_uart_vif);
       ssp_uart_vif = ssp_uart_cfg_if_i;
   endfunction


endmodule


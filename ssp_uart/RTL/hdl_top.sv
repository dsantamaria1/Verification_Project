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
   ssp_uart_if ssp_uart_cfg_if_i(.clk(Clk));

   //inputs
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

   assign ssp_uart_cfg_if_i.SSP_DO_sig	= SSP_DO;
   assign ssp_uart_cfg_if_i.TxD_232_sig	= TxD_232;
   assign ssp_uart_cfg_if_i.xRTS_sig	= xRTS;
   assign ssp_uart_cfg_if_i.TxD_485_sig	= TxD_485;
   assign ssp_uart_cfg_if_i.xDE_sig	= xDE;
   assign ssp_uart_cfg_if_i.IRQ_sig	= IRQ;
   assign ssp_uart_cfg_if_i.TxIdle_sig	= TxIdle;
   assign ssp_uart_cfg_if_i.RxIdle_sig	= RxIdle;
   
   assign ssp_uart_cfg_if_i.usr_0	= ssp_uart.USR[0];
   assign ssp_uart_cfg_if_i.tcnt	= ssp_uart.TFCnt;
   assign ssp_uart_cfg_if_i.rcnt	= ssp_uart.RFCnt;
   assign ssp_uart_cfg_if_i.iTFE	= ssp_uart.iTFE;
   assign ssp_uart_cfg_if_i.iTHE	= ssp_uart.iTHE;
   assign ssp_uart_cfg_if_i.iRHF	= ssp_uart.iRHF;
   assign ssp_uart_cfg_if_i.iRTO	= ssp_uart.iRTO;

   assign ssp_uart_cfg_if_i.IE		= ssp_uart.IE;
   assign ssp_uart_cfg_if_i.TS		= ssp_uart.TS;
   assign ssp_uart_cfg_if_i.RS		= ssp_uart.RS;
   assign ssp_uart_cfg_if_i.TFThr	= ssp_uart.TFThr;
   assign ssp_uart_cfg_if_i.RFThr	= ssp_uart.RFThr;
   assign ssp_uart_cfg_if_i.T_FF	= ssp_uart.TF_FF;
   assign ssp_uart_cfg_if_i.R_FF	= ssp_uart.RF_FF;
   assign ssp_uart_cfg_if_i.TFC		= ssp_uart.TFC;
   assign ssp_uart_cfg_if_i.RFC		= ssp_uart.RFC;

   
   assign ssp_uart_cfg_if_i.TFW		= ssp_uart.HLD;
   assign ssp_uart_cfg_if_i.RERR	= ssp_uart.RERR;
   assign ssp_uart_cfg_if_i.RRDY	= ssp_uart.RRDY;
   assign ssp_uart_cfg_if_i.TRDY	= ssp_uart.TRDY;
   assign ssp_uart_cfg_if_i.CTSi	= ssp_uart.CTSi;
   assign ssp_uart_cfg_if_i.RTSi	= ssp_uart.RTSi;
   assign ssp_uart_cfg_if_i.MD		= ssp_uart.MD;
   assign ssp_uart_cfg_if_i.RTO		= ssp_uart.RTO;
   // ----------------------------------------------------------------
   // -- DUT (Design Under Test)
   // ----------------------------------------------------------------

   SSP_UART #(
             	.pTF_Depth(0),
		.pRF_Depth(0)
	     ) ssp_uart(
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


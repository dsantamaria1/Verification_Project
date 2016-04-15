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

   // ----------------------------------------------------------------
   // -- Clock
   // ----------------------------------------------------------------
   clock_driver u_clock(
     .clk(clk),
     .rst(rst));

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
//tmp     .clk(clk),
//tmp     .rst(rst)
);


   pcounter_if pcounter_cfg_if_i(.clk(clk));

   // Input to the design
   assign dut.cfg_enable_sig = pcounter_cfg_if_i.cfg_enable_sig;
   assign dut.cfg_rd_wr_sig  = pcounter_cfg_if_i.cfg_rd_wr_sig;
   assign dut.cfg_addr_sig   = pcounter_cfg_if_i.cfg_addr_sig;
   assign dut.cfg_wdata_sig  = pcounter_cfg_if_i.cfg_wdata_sig;

   // Output from  the design

   //
   // 
   // 

   function void get_interface(output virtual pcounter_if pc_vif);
       pc_vif = pcounter_cfg_if_i;
   endfunction


endmodule


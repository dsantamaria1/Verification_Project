
/**
 * @brief Testbench Top
 * This is module is the top level testbench for the ssp_uart DUT.
 *
 * This top level module instantiates the top of the HDL  (hdl_top),
 *
 * It runs the This top level module instantiates the DUT (ssp_uart),
 *
 */

`timescale 1 ns / 1 ns

module tb_top ();


`define UCR 3'b000
`define USR 3'b001
`define TDR 3'b010
`define RDR 3'b011
`define SPR 3'b100

`define WRITE 1'b1
`define READ 1'b0

`define UCR_RST 12'h000
`define USR_RST 12'h000
`define RDR_RST 12'h000
`define TDR_RST 12'h000
`define SPR_RST 12'h000

`include "Sim/tests.sv"
  int i = 0;
  int status = 0;
  int test = -1;
  logic clk = 0;
  logic sclk = 0;
  logic rst = 1;
  logic [2:0] ssp_ra = 0;
  logic ssp_wnr = 0;
  logic [11:0] ssp_di = 12'h0;
  logic [11:0] ssp_do = 12'h0;
  logic ssp_eoc = 0;
  logic ssp_ssel = 0;
  logic ssp_en = 0;
  logic rxd_232 = 0;
  logic xcts = 0;
  logic rxd_485 = 0;

  hdl_top     hdl_top_i();

  config_item   c1; 
  virtual ssp_uart_if      ssp_uart_vif ;
  uart_reg_rw uart_reg_rw_;
  uart_reg_init uart_reg_init_;
  tfifo_clear tfifo_clear_;
  rfifo_clear rfifo_clear_;

 /**
   * @brief initialize the ssp_uart interface
   *
   * @param none
   * @return void
   */


  function void initialize_ssp_uart_if();
       hdl_top_i.get_interface(ssp_uart_vif);
  endfunction


  // TB Top Process
  //connected clk to DUT
  always begin
    #5 clk = ~clk;
    ssp_uart_vif.Clk_sig = clk;
  end
  
  always begin 
    #15 sclk = ~sclk;
    ssp_uart_vif.SSP_SCK_sig = sclk;
  end


  initial begin
    $timeformat(-9, 0, " ns", 5); // show time in ns
    initialize_ssp_uart_if();
    #0; //initialize reset to 1 at beginning of simulation
    init_ssp_uart();
 
    status = $value$plusargs("test=%d", test); 
    
    case(test)
      0: begin 
    	   uart_reg_rw_ = new(ssp_uart_vif);
    	   uart_reg_rw_.run();
         end
      1: begin 
    	   uart_reg_init_ = new(ssp_uart_vif);
    	   uart_reg_init_.run();
         end
      2: begin 
    	   tfifo_clear_ = new(ssp_uart_vif);
    	   tfifo_clear_.run();
         end
      3: begin 
    	   rfifo_clear_ = new(ssp_uart_vif);
    	   rfifo_clear_.run();
         end
      //4: begin 
      //   end

      default: 	begin 
	       	  $display("********************");
	       	  $display("********************");
	       	  $display("Invalid test chosen. test = %0d", test);
	       	  $display("********************");
	       	  $display("********************");
		end
    endcase 
  
    #500;
    $finish();
  end


  task ssp_uart_reset();
    ssp_uart_vif.Rst_sig = 1;
    
    repeat(10) begin
      @(negedge ssp_uart_vif.Clk_sig);
    end

    ssp_uart_vif.Rst_sig = 0;
  endtask

  task init_ssp_uart();
    ssp_uart_vif.Clk_sig 	= clk;
    ssp_uart_vif.SSP_SCK_sig 	= sclk;
    ssp_uart_vif.SSP_SSEL_sig 	= ssp_ssel;
    ssp_uart_vif.SSP_RA_sig 	= ssp_ra;
    ssp_uart_vif.SSP_WnR_sig 	= ssp_wnr;
    ssp_uart_vif.SSP_En_sig 	= ssp_en;
    ssp_uart_vif.SSP_EOC_sig 	= ssp_eoc;
    ssp_uart_vif.SSP_DI_sig 	= ssp_di;
    ssp_uart_vif.RxD_232_sig 	= rxd_232;
    ssp_uart_vif.xCTS_sig 	= xcts;
    ssp_uart_vif.RxD_485_sig 	= rxd_485;

    // bring SSP_UART out of reset
    ssp_uart_reset();
  endtask


    // Dump waves
  initial begin
    $vcdplusfile("ssp_uart.dump.vpd");
    $vcdpluson(0, tb_top); 
    $vcdplusmemon(); 
  end

endmodule : tb_top

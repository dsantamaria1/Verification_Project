
class test_base;

  int i = 0;
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

  config_item   c1; 
  virtual ssp_uart_if      ssp_uart_vif ;
 
  function new(virtual ssp_uart_if ssp_uart_vif);
    this.ssp_uart_vif = ssp_uart_vif;
  endfunction: new
 /**
   * @brief drives the transaction on the hardware
   *
   * @param config_item seq - the item to be driven
   * @return void
   */
  
  task drive_transaction(config_item  item); 
    ssp_uart_vif.SSP_WnR_sig 	= item.get_SSP_WnR();
    ssp_uart_vif.SSP_DI_sig 	= item.get_SSP_DI();
    ssp_uart_vif.SSP_RA_sig 	= item.get_SSP_RA();
    ssp_uart_vif.SSP_SSEL_sig 	= item.get_SSP_SSEL();
    ssp_uart_vif.SSP_EOC_sig 	= item.get_SSP_EOC();
    ssp_uart_vif.SSP_En_sig 	= item.get_SSP_En();
    ssp_uart_vif.RxD_232_sig	= item.get_RxD_232();
    $display("driving transaction at time: %0t", $time);
    item.print();
  endtask

  function checkExpectedValue(logic [11:0] expected, logic [11:0] actual);
    if(actual !== expected) begin // using != instead of !== results in true
	$display("ERROR @ time %0t: Data read was incorrect. Expected = %0h, Actual = %0h", $time, expected, actual);
    end
    else begin
	$display("SUCCESS!: Data read was correct. Expected = %0h, Actual = %0h", expected, actual);
    end
  endfunction 

endclass: test_base


class TFIFO_base extends test_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

  task enableInterrupt;
      //enable interrupt
      c1 = new(ssp_uart_vif);
      ssp_di = 'h100;
      c1.set_SSP_RA(`UCR);
      c1.set_SSP_DI(ssp_di);
      c1.set_SSP_WnR(`WRITE);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1); 

      repeat(10) begin
        @(negedge ssp_uart_vif.Clk_sig);
      end
  endtask: enableInterrupt


  task clearTFifoInterrupts;
      c1 = new(ssp_uart_vif);
      ssp_di = 'h02;
      ssp_en = 1'b1;
      c1.set_SSP_RA(`USR);
      c1.set_SSP_DI(ssp_di);
      c1.set_SSP_WnR(`WRITE);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1);

      // wait for USR[0] to toggle to clear iTFE/iTHE
      @(posedge ssp_uart_vif.usr_0);

      c1.set_SSP_En(ssp_en);
      drive_transaction(c1); 
       
      repeat(256) begin
        @(negedge ssp_uart_vif.Clk_sig);
      end
  endtask: clearTFifoInterrupts


  task populateTFIFO(int numTransactions);
      //Write data to TDR to go into Transmit FIFO
      c1 = new(ssp_uart_vif);
      ssp_di = 'h0E1;
      c1.set_SSP_RA(`TDR);
      c1.set_SSP_DI(ssp_di);
      c1.set_SSP_WnR(`WRITE);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1);
      repeat(6) begin
        @(negedge ssp_uart_vif.Clk_sig);
      end
      
      // Call task drive_transaction with config_item c1 as argument
      for(i=0; i < numTransactions; i++) begin
        ssp_di++;
        c1.set_SSP_DI(ssp_di);
        drive_transaction(c1);
        repeat(6) begin
          @(negedge ssp_uart_vif.Clk_sig);
        end
      end

  endtask: populateTFIFO
  

  task clearTFIFO();
      // clear fifo 
      ssp_di = 'h800; //TFC is bit 11
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`TDR);
      c1.set_SSP_WnR(`WRITE);
      c1.set_SSP_DI(ssp_di);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      
      drive_transaction(c1);
      repeat(6) begin
        @(negedge ssp_uart_vif.Clk_sig);
      end

  endtask: clearTFIFO

endclass: TFIFO_base




class RFIFO_base extends test_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

  task clearFifoInterrupts;
      c1 = new(ssp_uart_vif);
      ssp_di = 'h02;
      ssp_en = 1'b1;
      c1.set_SSP_RA(`USR);
      c1.set_SSP_DI(ssp_di);
      c1.set_SSP_WnR(`WRITE);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1);

      // wait for USR[0] to toggle to clear iTFE/iTHE
      @(posedge ssp_uart_vif.usr_0);

      c1.set_SSP_En(ssp_en);
      drive_transaction(c1); 
       
      repeat(256) begin
        @(negedge ssp_uart_vif.Clk_sig);
      end
  endtask: clearFifoInterrupts


  task enableInterrupt;
      //enable interrupt
      c1 = new(ssp_uart_vif);
      ssp_di = 'h100;
      c1.set_SSP_RA(`UCR);
      c1.set_SSP_DI(ssp_di);
      c1.set_SSP_WnR(`WRITE);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1); 

      repeat(10) begin
        @(negedge ssp_uart_vif.Clk_sig);
      end
  endtask: enableInterrupt


  task clearRFIFO();
      ssp_di = 'h400; //RFC is bit 10
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`TDR);
      c1.set_SSP_WnR(`WRITE);
      c1.set_SSP_DI(ssp_di);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1);
      repeat(10) begin
        @(negedge ssp_uart_vif.Clk_sig);
      end
  endtask: clearRFIFO


  task populateRFIFO(int numTransactions);
      int j =0;     
      for(i=0; i<numTransactions; i++) begin
        rxd_232 = 1;
        c1 = new(ssp_uart_vif);
        c1.set_RxD_232(rxd_232);
        drive_transaction(c1);

        repeat(5) begin
          @(negedge ssp_uart_vif.SSP_SCK_sig);
        end

        //send start bit
        rxd_232 = 0;
        $display("rxd_232 = %0h", rxd_232);
        c1.set_RxD_232(rxd_232);
        drive_transaction(c1);
        
        repeat(10) begin
          @(negedge ssp_uart_vif.SSP_SCK_sig);
        end
        
        for(j=0; j<8; j++) begin
          rxd_232 = $urandom();
          $display("rxd_232 = %0h", rxd_232);
          c1.set_RxD_232(rxd_232);
          drive_transaction(c1);
          repeat(64) begin
            @(negedge ssp_uart_vif.Clk_sig);
          end
        end 

        //send stop bit
        rxd_232 = 1;
        $display("rxd_232 = %0h", rxd_232);
        c1.set_RxD_232(rxd_232);
        drive_transaction(c1);
        
        repeat(10) begin
          @(negedge ssp_uart_vif.SSP_SCK_sig);
        end

     end// for

  endtask: populateRFIFO
  

endclass: RFIFO_base





class uart_reg_rw extends test_base;

    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new
    
    task run();
      ssp_di = 'hDED;
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;
      ssp_en = 1'b1;
      
      // Create a new config_item object and assign to variable c1
      c1 = new(ssp_uart_vif);
      // Set addr to 0 (UCR) and data to 12'hDED for c1
      c1.set_SSP_RA(`UCR);
      c1.set_SSP_DI(ssp_di);
      c1.set_SSP_WnR(`WRITE);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);

      // Call task drive_transaction with config_item c1 as argument
      drive_transaction(c1);
      
      // read data back and compare (need to wait for 2 negedges for register to latch value);
      @(negedge ssp_uart_vif.Clk_sig);
      @(negedge ssp_uart_vif.Clk_sig);
      
      ssp_do = c1.get_SSP_DO();
      c1.set_SSP_WnR(`READ);

      checkExpectedValue(ssp_di, ssp_do);
      #100; 
    endtask

endclass: uart_reg_rw


class uart_reg_init extends test_base;
    
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();

      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`UCR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      checkExpectedValue(`UCR_RST, ssp_do);

      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`USR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      checkExpectedValue(`USR_RST, ssp_do);
      
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`TDR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      checkExpectedValue(`TDR_RST, ssp_do);
      
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`RDR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      checkExpectedValue(`RDR_RST, ssp_do);
      
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`SPR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      checkExpectedValue(`SPR_RST, ssp_do);
   
      #100; 
    endtask: run

endclass: uart_reg_init



//////// Put data in Transmit FIFO //////////////
class tfifo_clear extends TFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new
        
    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;

      clearTFifoInterrupts();

      populateTFIFO(6);
      
      //Stop writing to TDR
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA('h7);
      c1.set_SSP_WnR(`READ);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1);
     
      
      clearTFIFO();
      #5us;

      //TODO: check that fifo was cleared 
    endtask: run

endclass:tfifo_clear





class the_interrupt extends TFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;

      clearTFifoInterrupts();
      enableInterrupt();

      populateTFIFO(9);
      #150;
 
      c1.set_SSP_WnR(`READ);
      drive_transaction(c1);

      $display("waiting on tfifo cnt to be less than half @ time: %0t", $time);
      wait(ssp_uart_vif.tcnt < 'h8);
      #20us;

      //TODO: Check that iTHE and IRQ go high
      //TODO: De-assert interrupt by reading USR or 
      //      by filling FIFO above the Half Empty mark
    endtask: run

endclass: the_interrupt



class tfe_interrupt extends TFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;
 
      clearTFifoInterrupts();

      enableInterrupt();

      populateTFIFO(3);
     
      //read out data from TFIFO for interrupt to trigger
      c1.set_SSP_WnR(`READ);
      drive_transaction(c1);

      #20us;

      //TODO: Check that iTFE and IRQ go high (also that TxIDLE is asserted)
      //TODO: De-assert interrupt by reading USR or 
      //      by writing to tFIFO
    endtask: run

endclass: tfe_interrupt




//////// Put data in Receive FIFO //////////////
class rfifo_clear extends RFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_uart_reset();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;

      clearFifoInterrupts();
     
      populateRFIFO(2);
      clearRFIFO();
  
      #500;
    endtask: run
endclass: rfifo_clear




//////// Put data in Receive FIFO //////////////
class rhf_interrupt extends RFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_uart_reset();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;
      
      clearFifoInterrupts();
      enableInterrupt();
      populateRFIFO(8);
  
      #500;
      //TODO: Check that iRHF and IRQ are asserted
    endtask: run
endclass: rhf_interrupt




class interrupt_disable extends TFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;
      ssp_en = 1'b1;
 
      clearTFifoInterrupts();

      populateTFIFO(3);
     
      //read out data from TFIFO for interrupt to trigger
      c1.set_SSP_WnR(`READ);
      drive_transaction(c1);

      #20us;

      //TODO: Check that iTFE and IRQ never go high (also that TxIDLE is asserted)
    endtask: run

endclass: interrupt_disable


class receiveFifoStatus extends RFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new
    rand logic [3:0] numTransactions = 'h0;
    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;
      ssp_en = 1'b1;
 
      clearFifoInterrupts();

      this.randomize();
      $display("numTransactions being sent = %0d @ time: %0t",numTransactions, $time);
      populateRFIFO(numTransactions);
     
      #20us; 
    endtask: run
endclass: receiveFifoStatus


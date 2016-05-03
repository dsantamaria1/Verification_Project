
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
  task waitN_ClkCycles(int n);
      repeat(n) begin
        @(negedge ssp_uart_vif.Clk_sig);
      end
  endtask 

  task waitN_SlowClkCycles(int n);
      repeat(n) begin
        @(negedge ssp_uart_vif.SSP_SCK_sig);
      end
  endtask 

 
  task checkStatus(logic [3:0] numTransactions, logic [1:0] status, logic [7:0] threshold);

     if(numTransactions == 0) begin
	assert(status==0) $info("Case 0: Status = %0h", status); else $error("Status is incorrect! Expected = 0 Actual = %0h", status);
     end
     else if ((numTransactions>0) && (numTransactions < threshold)) begin
	assert(status==1) $info("Case 1: Status = %0h", status); else $error("Status is incorrect! Expected = 1 Actual = %0h", status);
     end
     else if ((numTransactions >= threshold) && (numTransactions<'hF)) begin
	assert(status==2) $info("Case 2: Status = %0h", status); else $error("Status is incorrect! Expected = 2 Actual = %0h", status);
     end
     else if (numTransactions === 'hF) begin
	assert(status==3) $info("Case 3: Status = %0h", status); else $error("Status is incorrect! Expected = 3 Actual = %0h @ time: %0t", status, $time);
     end
     else begin
	//$display("ERROR!!!!!!!!!!!! numTransactions = %0d Threshold = %0h", numTransactions, threshold);
	assert(1) $error("Invalid number of transactions sent! numTransactions = %0d Threshold = %0h", numTransactions, threshold);
     end
  endtask: checkStatus


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



  task clearFifoInterrupts;
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;

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

  function checkExpectedValue(logic [11:0] expected, logic [11:0] actual, logic [2:0] addr);
    if(actual !== expected) begin // using != instead of !== results in true
	$display("ERROR @ time %0t: Data read was incorrect. Expected = %0h, Actual = %0h for address = %0h", $time, expected, actual, addr);
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


  task populateTFIFO(int numTransactions);
      //Write data to TDR to go into Transmit FIFO
      
      if(numTransactions == 15) begin
         numTransactions = 16; //add extra transaction
      end
      c1 = new(ssp_uart_vif);
      ssp_di = 'h0E1;
      // Call task drive_transaction with config_item c1 as argument
      for(i=0; i < numTransactions; i++) begin
        c1.set_SSP_RA(`TDR);
        c1.set_SSP_DI(ssp_di);
        c1.set_SSP_WnR(`WRITE);
        c1.set_SSP_SSEL(ssp_ssel);
        c1.set_SSP_EOC(ssp_eoc);
        drive_transaction(c1);
 
        //waitN_ClkCycles(5);
        waitN_SlowClkCycles(2);
        ssp_di++;
      end

      // Need to send extra Xaction to fill fifo because 
      // transmission begins draining FIFO when it is half full
        c1.set_SSP_RA(`TDR);
        c1.set_SSP_DI(ssp_di);
        c1.set_SSP_WnR(`WRITE);
        c1.set_SSP_SSEL(ssp_ssel);
        c1.set_SSP_EOC(ssp_eoc);
        drive_transaction(c1);
 
        waitN_SlowClkCycles(2);
        
      waitN_SlowClkCycles(1); //Sync TCnt and TS

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
      if(numTransactions == 15) begin
         numTransactions = 16; //add extra transaction to fill up
      end

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
  

  task createTimeOut();
      int j =0;     
      for(i=0; i<1; i++) begin
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
        rxd_232 = 'bx;
        $display("rxd_232 = %0h", rxd_232);
        c1.set_RxD_232(rxd_232);
        drive_transaction(c1);
        
        repeat(10) begin
          @(negedge ssp_uart_vif.SSP_SCK_sig);
        end

     end// for

  endtask: createTimeOut

endclass: RFIFO_base





class uart_reg_rw extends test_base;

    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new
    
    task run();
      ssp_di = 'h2ED;
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

      checkExpectedValue(ssp_di, ssp_do, `UCR);
      #100; 
    endtask

endclass: uart_reg_rw


class uart_reg_init extends test_base;
    
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_uart_reset();
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`UCR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      drive_transaction(c1);
      waitN_ClkCycles(5);
      checkExpectedValue(`UCR_RST, ssp_do, `UCR);

      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`USR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      drive_transaction(c1);
      waitN_ClkCycles(5);
      checkExpectedValue(`USR_RST, ssp_do, `USR);
      
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`TDR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      drive_transaction(c1);
      waitN_ClkCycles(5);
      checkExpectedValue(`TDR_RST, ssp_do, `TDR);
      
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`RDR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      drive_transaction(c1);
      waitN_ClkCycles(5);
      checkExpectedValue(`RDR_RST, ssp_do, `RDR);
      
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA(`SPR);
      c1.set_SSP_WnR(`READ);
      ssp_do = c1.get_SSP_DO();
      drive_transaction(c1);
      waitN_ClkCycles(5);
      checkExpectedValue(`SPR_RST, ssp_do, `SPR);
   
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

      //clearFifoInterrupts();

      populateTFIFO(6);
      
      //Stop writing to TDR
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA('h7);
      c1.set_SSP_WnR(`READ);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1);
     
      assert(ssp_uart_vif.tcnt > 0) $info("FIFO has data! tcnt = %0h", ssp_uart_vif.tcnt); else $error("Transmit FIFO was not populated! tcnt = %0h", ssp_uart_vif.tcnt);
      clearTFIFO();

      waitN_ClkCycles(10);
      assert(ssp_uart_vif.tcnt === 0) $info("FIFO was cleared! tcnt = %0h", ssp_uart_vif.tcnt); else $error("Transmit FIFO was not cleared! tcnt = %0h", ssp_uart_vif.tcnt);
    endtask: run

endclass:tfifo_clear





class the_interrupt extends TFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;

      //clearFifoInterrupts();
      enableInterrupt();

      populateTFIFO(9);
      #150;
 
      c1.set_SSP_WnR(`READ);
      drive_transaction(c1);

      $display("waiting on tfifo cnt to be less than half @ time: %0t", $time);
      wait(ssp_uart_vif.tcnt < 'h8);

      @(posedge ssp_uart_vif.iTHE);
      @(posedge ssp_uart_vif.IRQ_sig);
      waitN_ClkCycles(10);

      assert(ssp_uart_vif.IRQ_sig === 1) $info("IRQ was asserted! IRQ  = %0h", ssp_uart_vif.IRQ_sig); else $error("Interrupt was not generated by IRQ! IRQ = %0h", ssp_uart_vif.IRQ_sig);
      assert(ssp_uart_vif.iRTO === 0) $info("iRTO! iRTO = %0h", ssp_uart_vif.iRTO); else $error("Interrupt was generated by iRTO! iRTO = %0h", ssp_uart_vif.iRTO);
      assert(ssp_uart_vif.iRHF === 0) $info("iRHF = %0h", ssp_uart_vif.iRHF); else $error("Interrupt was generated by iRHF! iRHF = %0h", ssp_uart_vif.iRHF);
      assert(ssp_uart_vif.iTFE === 0) $info("iTFE! iTFE = %0h", ssp_uart_vif.iTFE); else $error("Interrupt was generated by iTFE! iTFE = %0h", ssp_uart_vif.iTFE);
      assert(ssp_uart_vif.iTHE === 1) $info("iTHE was asserted! iTHE = %0h", ssp_uart_vif.iTHE); else $error("Interrupt was not generated by iTHE! iTHE = %0h", ssp_uart_vif.iTHE);
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
 
      //clearFifoInterrupts();

      enableInterrupt();

      populateTFIFO(3);
     
      //read out data from TFIFO for interrupt to trigger
      c1.set_SSP_WnR(`READ);
      drive_transaction(c1);

      @(posedge ssp_uart_vif.iTFE);
      @(posedge ssp_uart_vif.IRQ_sig);
      waitN_ClkCycles(10);

      assert(ssp_uart_vif.IRQ_sig === 1) $info("IRQ was asserted! IRQ  = %0h", ssp_uart_vif.IRQ_sig); else $error("Interrupt was not generated by IRQ! IRQ = %0h", ssp_uart_vif.IRQ_sig);
      assert(ssp_uart_vif.iRTO === 0) $info("iRTO! iRTO = %0h", ssp_uart_vif.iRTO); else $error("Interrupt was generated by iRTO! iRTO = %0h", ssp_uart_vif.iRTO);
      assert(ssp_uart_vif.iRHF === 0) $info("iRHF = %0h", ssp_uart_vif.iRHF); else $error("Interrupt was generated by iRHF! iRHF = %0h", ssp_uart_vif.iRHF);
      assert(ssp_uart_vif.iTFE === 1) $info("iTFE was asserted! iTFE = %0h", ssp_uart_vif.iTFE); else $error("Interrupt was not generated by iTFE! iTFE = %0h", ssp_uart_vif.iTFE);
      assert(ssp_uart_vif.iTHE === 0) $info("iTHE! iTHE = %0h", ssp_uart_vif.iTHE); else $error("Interrupt was generated by iTHE! iTHE = %0h", ssp_uart_vif.iTHE);

      //TODO: De-assert interrupt by reading USR or 
      //      by writing to tFIFO
    endtask: run

endclass: tfe_interrupt



class transmitFifoStatus extends TFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new
    rand logic [3:0] numTransactions = 'h0;

    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;
      ssp_en = 1'b1;
 
      //clearFifoInterrupts();

      this.randomize();
      populateTFIFO(numTransactions);
      
      //Stop writing to TDR
      c1 = new(ssp_uart_vif);
      c1.set_SSP_RA('h7);
      c1.set_SSP_WnR(`READ);
      c1.set_SSP_SSEL(ssp_ssel);
      c1.set_SSP_EOC(ssp_eoc);
      drive_transaction(c1);
     
      $display("numTransactions being sent = %0d @ time: %0t",numTransactions, $time);
      if(numTransactions === 15)
        wait(ssp_uart_vif.T_FF == 1);
      else if(numTransactions > 8 && numTransactions < 15) 
	wait(ssp_uart_vif.tcnt > 8);
      else
      	wait(ssp_uart_vif.tcnt == numTransactions);

      $display("TS = %0b @ time: %0t", ssp_uart_vif.TS, $time);
      waitN_SlowClkCycles(1); //Let TCnt propagate to TS
      checkStatus(numTransactions, ssp_uart_vif.TS, ssp_uart_vif.TFThr);
     
      #100;
    endtask: run
endclass: transmitFifoStatus




//////// Put data in Receive FIFO //////////////
class rfifo_clear extends RFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;

      //clearFifoInterrupts();
     
      populateRFIFO(2);
      assert(ssp_uart_vif.rcnt > 0) $info("FIFO has data! rcnt = %0h", ssp_uart_vif.rcnt); else $error("Receive FIFO was not populated! rcnt = %0h", ssp_uart_vif.rcnt);
      clearRFIFO();
      
      waitN_ClkCycles(10);
      assert(ssp_uart_vif.rcnt === 0) $info("FIFO was cleared! rcnt = %0h", ssp_uart_vif.rcnt); else $error("Receive FIFO was not cleared! rcnt = %0h", ssp_uart_vif.rcnt);
      
    endtask: run
endclass: rfifo_clear




//////// Put data in Receive FIFO //////////////
class rhf_interrupt extends RFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new

    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;
      
      //clearFifoInterrupts();
      enableInterrupt();
      populateRFIFO(8);
  
      $display("waiting for interrupt @ time: %0t", $time);
      wait(ssp_uart_vif.iRHF == 1);
      wait(ssp_uart_vif.IRQ_sig == 1);
      waitN_ClkCycles(10);

      assert(ssp_uart_vif.IRQ_sig === 1) $info("IRQ was asserted! IRQ  = %0h", ssp_uart_vif.IRQ_sig); else $error("Interrupt was not generated by IRQ! IRQ = %0h", ssp_uart_vif.IRQ_sig);
      assert(ssp_uart_vif.iRTO === 0) $info("iRTO = %0h", ssp_uart_vif.iRTO); else $error("Interrupt was generated by iRTO! iRTO = %0h", ssp_uart_vif.iRTO);
      assert(ssp_uart_vif.iRHF === 1) $info("iRHF was asserted! iRHF = %0h", ssp_uart_vif.iRHF); else $error("Interrupt was not generated by iRHFi! iRHF = %0h", ssp_uart_vif.iRHF);
      assert(ssp_uart_vif.iTFE === 0) $info("iTFE! iTFE = %0h", ssp_uart_vif.iTFE); else $error("Interrupt was generated by iTFE! iTFE = %0h", ssp_uart_vif.iTFE);
      assert(ssp_uart_vif.iTHE === 0) $info("iTHE! iTHE = %0h", ssp_uart_vif.iTHE); else $error("Interrupt was generated by iTHE! iTHE = %0h", ssp_uart_vif.iTHE);

      //TODO: De-assert interrupt
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
 
      //clearFifoInterrupts();

      populateTFIFO(3);
     
      //read out data from TFIFO for interrupt to trigger
      c1.set_SSP_WnR(`READ);
      drive_transaction(c1);

      $display("waiting for FIFO to drain @ time: %0t", $time);
      wait(ssp_uart_vif.tcnt === 0);
      waitN_ClkCycles(3);
      assert(ssp_uart_vif.iTFE & ~ssp_uart_vif.IE & ~ssp_uart_vif.IRQ_sig)
		$info("IRQ was disabled! ssp_uart_vif.iTFE = %0h ssp_uart_vif.IE = %0h ssp_uart_vif.IRQ_sig = %0h", ssp_uart_vif.iTFE, ssp_uart_vif.IE, ssp_uart_vif.IRQ_sig); else
		$error("IRQ was asserted! ssp_uart_vif.iTFE = %0h ssp_uart_vif.IE = %0h ssp_uart_vif.IRQ_sig = %0h", ssp_uart_vif.iTFE, ssp_uart_vif.IE, ssp_uart_vif.IRQ_sig);
      
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
 
      //clearFifoInterrupts();

      this.randomize();
      populateRFIFO(numTransactions);
     
      $display("numTransactions being sent = %0d @ time: %0t",numTransactions, $time);
      if(numTransactions === 15)
        wait(ssp_uart_vif.R_FF == 1);
      else if(numTransactions > 8 && numTransactions < 15) 
	wait(ssp_uart_vif.rcnt > 8);
      else
      	wait(ssp_uart_vif.rcnt == numTransactions);

      checkStatus(numTransactions, ssp_uart_vif.RS, ssp_uart_vif.RFThr);
      #1us; 
    endtask: run
endclass: receiveFifoStatus




class createTimeOut extends RFIFO_base;
    function new(virtual ssp_uart_if ssp_uart_vif);
      super.new(ssp_uart_vif);
    endfunction: new
    task run();
      ssp_eoc = 1'b1;
      ssp_ssel = 1'b1;
      ssp_en = 1'b1;
 
      //clearFifoInterrupts();
      enableInterrupt();
      createTimeOut();
      
      @(posedge ssp_uart_vif.iRTO);
      @(posedge ssp_uart_vif.IRQ_sig);
      waitN_ClkCycles(10);

      assert(ssp_uart_vif.IRQ_sig === 1) $info("IRQ was asserted! IRQ  = %0h", ssp_uart_vif.IRQ_sig); else $error("Interrupt was not generated by IRQ! IRQ = %0h", ssp_uart_vif.IRQ_sig);
      assert(ssp_uart_vif.iRTO === 1) $info("iRTO was asserted! iRTO = %0h", ssp_uart_vif.iRTO); else $error("Interrupt was not generated by iRTOi! iRTO = %0h", ssp_uart_vif.iRTO);
      assert(ssp_uart_vif.iRHF === 0) $info("iRHF = %0h", ssp_uart_vif.iRHF); else $error("Interrupt was generated by iRHF! iRHF = %0h", ssp_uart_vif.iRHF);
      assert(ssp_uart_vif.iTFE === 0) $info("iTFE! iTFE = %0h", ssp_uart_vif.iTFE); else $error("Interrupt was generated by iTFE! iTFE = %0h", ssp_uart_vif.iTFE);
      assert(ssp_uart_vif.iTHE === 0) $info("iTHE! iTHE = %0h", ssp_uart_vif.iTHE); else $error("Interrupt was generated by iTHE! iTHE = %0h", ssp_uart_vif.iTHE);

      //TODO: De-assert interrupt
    endtask: run
endclass: createTimeOut

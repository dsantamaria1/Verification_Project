
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

  logic clk;
  logic rst;

  hdl_top     hdl_top_i();

  //config_item   c1; 
  //TODO: change pcounter_if to ssp_if in module and filelist
  virtual ssp_uart_if      ssp_uart_vif ;

 /**
   * @brief initialize the ssp_uart interface
   *
   * @param none
   * @return void
   */


  function void initialize_ssp_uart_if();
       hdl_top_i.get_interface(ssp_uart_vif);
  endfunction


 /**
   * @brief drives the transaction on the hardware
   *
   * @param config_item seq - the item to be driven
   * @return void
   */


  //dsm_temp task drive_transaction(config_item  item); 
  // sets the enable sig and drives the data
  // and addr values on the interface
  // It resets the enable sig after one clock
  // cycle

  //dsm_temp  pc_vif.cfg_enable_sig = 1;
  //dsm_temp  pc_vif.cfg_rd_wr_sig = 0;
  //dsm_temp  pc_vif.cfg_addr_sig = item.get_addr();
  //dsm_temp  pc_vif.cfg_wdata_sig = item.get_data();
  //dsm_temp 
  //dsm_temp  @(posedge pc_vif.clk_sig);
  //dsm_temp  //dsm_tmp
  //dsm_temp  @(posedge pc_vif.clk_sig);
  //dsm_temp  pc_vif.cfg_enable_sig = 0;


  //dsm_temp endtask

 /**
   * @brief checks if the counteroutput is of a given value
   *
   * @param int val - the value that is expected
   * @return int 
   */

  function int xcheck_dut (int val);
    //dsm_temp if ($root.tb_top.hdl_top_i.dut.counter_o_sig != val) begin
    //dsm_temp   $display("----------------------------------");
    //dsm_temp   $display("(%t) Consistency Check Failed", $time());;
    //dsm_temp   $display("----------------------------------");
    //dsm_temp   $finish();
    //dsm_temp end
    //dsm_temp else
    //dsm_temp   $display("----------------------------------");
    //dsm_temp   $display("(%t) Consistency Check passed", $time());;
    //dsm_temp   $display("----------------------------------");
    //dsm_temp   return(0);
  endfunction
     

  // TB Top Process
  initial begin
    $timeformat(-9, 0, " ns", 5); // show time in ns
    initialize_ssp_uart_if();
    #500; 
 
    // Fixme: Lab1 -Begin
    //dsm_temp  // Create a new config_item object and assign to variable c1
    //dsm_temp  c1 = new();
    //dsm_temp  // Set addr to 0 and data to 1 for c1
    //dsm_temp  c1.set_addr(3'h0);
    //dsm_temp  c1.set_data(10'h1);

    //dsm_temp  // Call method print for c1
    //dsm_temp  c1.print();
    //dsm_temp  // Call task drive_transaction with config_item c1 as argument
    //dsm_temp  drive_transaction(c1);

    // Fixme: Lab1 -End

    #500; 

    // Fixme: Lab1 -Begin
    //dsm_temp  // Create a new config_item object and assign to variable c1
    //dsm_temp  c1 = new();
    //dsm_temp  // Set addr to 3 and data to 3 for c1
    //dsm_temp  c1.set_addr(3'h3);
    //dsm_temp  c1.set_data(10'h3);
    //dsm_temp  // Call method print for c1
    //dsm_temp  c1.print();
    //dsm_temp  // Call task drive_transaction with config_item c1 as argument
    //dsm_temp  drive_transaction(c1);

    // Fixme: Lab1 -End

    #500; 

    $finish();

  end

    // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);
  end

endmodule : tb_top

/**
 * @brief cfg Item Class.
 *
 * The cfg item Class  is a transaction class that
 * creates pkts for controlling the pcounter. It has
 * two additional members:
 *  *
 * <ul>
 * <li> m_addr : address of the register being programmed
 * <li> m_data : data value for the register
 *  </ul>
 * <br>
 *
 *
 * @class cfg_item
 *
 */

class config_item;


  // Define input variables for SSP_UART transaction
  logic Rst;
  logic Clk;
  logic SSP_SSEL;
  logic SSP_SCK;
  logic [2:0] SSP_RA;
  logic SSP_WnR;
  logic SSP_En;
  logic SSP_EOC;
  logic [11:0] SSP_DI;
  logic RxD_232;
  logic xCTS;
  logic RxD_485;
  logic [11:0] SSP_DO;
  logic TxD_232;                
  logic xRTS;
  logic TxD_485;                
  logic xDE;
  logic IRQ;
  logic TxIdle; 
  logic RxIdle;

  virtual ssp_uart_if      ssp_uart_vif ;

  /**
   * @brief Constructor
   * Method to construct the config_item class
   * Initializes all variables to a default value
   */

  function new(virtual ssp_uart_if ssp_uart_vif);
      logic Rst = 1;
      logic Clk = 0;
      logic SSP_SSEL = 0;
      logic SSP_SCK = 0;
      logic [2:0] SSP_RA = 0;
      logic SSP_WnR = 0;
      logic SSP_En = 0;
      logic SSP_EOC = 0;
      logic [11:0] SSP_DI = 0;
      logic RxD_= 0;
      logic xCTS = 0;
      logic [11:0] SSP_DO = 0;
      logic TxD_= 0;                
      logic xRTS = 0;
      logic xDE = 0;
      logic IRQ = 0;
      logic TxIdle = 0; 
      logic RxIdle = 0;
      
      this.ssp_uart_vif = ssp_uart_vif;
  endfunction: new


  //--------------------------------------------------------
  // function set_rst();
  //--------------------------------------------------------
  function void set_rst(int i1);
      Rst = i1;
  endfunction: set_rst
  
  
  //--------------------------------------------------------
  // function set_clk();
  //--------------------------------------------------------
  function void set_clk(int i1);
      Clk = i1;
  endfunction: set_clk
  
  
  //--------------------------------------------------------
  // function set_SSP_SSEL();
  //--------------------------------------------------------
  function void set_SSP_SSEL(int i1);
      SSP_SSEL = i1;
  endfunction: set_SSP_SSEL
  
  
  //--------------------------------------------------------
  // function set_SSP_SCK();
  //--------------------------------------------------------
  function void set_SSP_SCK(int i1);
      SSP_SCK = i1;
  endfunction: set_SSP_SCK
  
  
  //--------------------------------------------------------
  // function set_SSP_RA();
  //--------------------------------------------------------
  function void set_SSP_RA(int i1);
      SSP_RA = i1;
  endfunction: set_SSP_RA
  
  
  //--------------------------------------------------------
  // function set_SSP_WnR();
  //--------------------------------------------------------
  function void set_SSP_WnR(int i1);
      SSP_WnR = i1;
  endfunction: set_SSP_WnR
  
  
  //--------------------------------------------------------
  // function set_SSP_En();
  //--------------------------------------------------------
  function void set_SSP_En(int i1);
      SSP_En = i1;
  endfunction: set_SSP_En
  
  
  //--------------------------------------------------------
  // function set_SSP_EOC();
  //--------------------------------------------------------
  function void set_SSP_EOC(int i1);
      SSP_EOC = i1;
  endfunction: set_SSP_EOC
  
  
  //--------------------------------------------------------
  // function set_SSP_DI();
  //--------------------------------------------------------
  function void set_SSP_DI(int i1);
      SSP_DI = i1;
  endfunction: set_SSP_DI
  
  
  //--------------------------------------------------------
  // function set_RxD_232();
  //--------------------------------------------------------
  function void set_RxD_232(int i1);
      RxD_232 = i1;
  endfunction: set_RxD_232
  
  
  //--------------------------------------------------------
  // function set_xCTS();
  //--------------------------------------------------------
  function void set_xCTS(int i1);
      xCTS = i1;
  endfunction: set_xCTS
  
  
  //--------------------------------------------------------
  // function set_RxD_485();
  //--------------------------------------------------------
  function void set_RxD_485(int i1);
      RxD_485 = i1;
  endfunction: set_RxD_485
  
  
  //--------------------------------------------------------
  // function set_SSP_DO();
  //--------------------------------------------------------
  function void set_SSP_DO(int i1);
      SSP_DO = i1;
  endfunction: set_SSP_DO
  
  
  //--------------------------------------------------------
  // function set_TxD_232();
  //--------------------------------------------------------
  function void set_TxD_232(int i1);
      TxD_232 = i1;
  endfunction: set_TxD_232
  
  //--------------------------------------------------------
  // function set_xRTS();
  //--------------------------------------------------------
  function void set_xRTS(int i1);
      xRTS = i1;
  endfunction: set_xRTS


  //--------------------------------------------------------
  // function set_TxD_485();
  //--------------------------------------------------------
  function void set_TxD_485(int i1);
      TxD_485 = i1;
  endfunction: set_TxD_485
  
  
  //--------------------------------------------------------
  // function set_xDE();
  //--------------------------------------------------------
  function void set_xDE(int i1);
      xDE = i1;
  endfunction: set_xDE
  
  
  //--------------------------------------------------------
  // function set_IRQ();
  //--------------------------------------------------------
  function void set_IRQ(int i1);
      IRQ = i1;
  endfunction: set_IRQ
  
  
  //--------------------------------------------------------
  // function set_TxIdle();
  //--------------------------------------------------------
  function void set_TxIdle(int i1);
      TxIdle = i1;
  endfunction: set_TxIdle
  
  
  //--------------------------------------------------------
  // function set_RxIdle();
  //--------------------------------------------------------
  function void set_RxIdle(int i1);
      RxIdle = i1;
  endfunction: set_RxIdle
  
  
  //--------------------------------------------------------
  // function get_rst();
  //--------------------------------------------------------
  function logic get_rst();
      return Rst;
  endfunction: get_rst
  
  
  //--------------------------------------------------------
  // function get_clk();
  //--------------------------------------------------------
  function logic get_clk();
      return Clk;
  endfunction: get_clk
  
  
  //--------------------------------------------------------
  // function get_SSP_SSEL();
  //--------------------------------------------------------
  function logic get_SSP_SSEL();
      return SSP_SSEL;
  endfunction: get_SSP_SSEL
  
  
  //--------------------------------------------------------
  // function get_SSP_SCK();
  //--------------------------------------------------------
  function logic get_SSP_SCK();
      return SSP_SCK;
  endfunction: get_SSP_SCK
  
  
  //--------------------------------------------------------
  // function get_SSP_RA();
  //--------------------------------------------------------
  function logic [2:0] get_SSP_RA();
      return SSP_RA;
  endfunction: get_SSP_RA
  
  
  //--------------------------------------------------------
  // function get_SSP_WnR();
  //--------------------------------------------------------
  function logic get_SSP_WnR();
      return SSP_WnR;
  endfunction: get_SSP_WnR
  
  
  //--------------------------------------------------------
  // function get_SSP_En();
  //--------------------------------------------------------
  function logic get_SSP_En();
      return SSP_En;
  endfunction: get_SSP_En
  
  
  //--------------------------------------------------------
  // function get_SSP_EOC();
  //--------------------------------------------------------
  function logic get_SSP_EOC();
      return SSP_EOC;
  endfunction: get_SSP_EOC
  
  
  //--------------------------------------------------------
  // function get_SSP_DI();
  //--------------------------------------------------------
  function logic [11:0] get_SSP_DI();
      return SSP_DI;
  endfunction: get_SSP_DI
  
  
  //--------------------------------------------------------
  // function get_RxD_232();
  //--------------------------------------------------------
  function logic get_RxD_232();
      return RxD_232;
  endfunction: get_RxD_232
  
  
  //--------------------------------------------------------
  // function get_xCTS();
  //--------------------------------------------------------
  function logic get_xCTS();
      return xCTS;
  endfunction: get_xCTS
  
  
  //--------------------------------------------------------
  // function get_RxD_485();
  //--------------------------------------------------------
  function logic get_RxD_485();
      return RxD_485;
  endfunction: get_RxD_485
  
  
  //--------------------------------------------------------
  // function get_SSP_DO();
  //--------------------------------------------------------
  function logic [11:0] get_SSP_DO();
      return ssp_uart_vif.SSP_DO_sig;
  endfunction: get_SSP_DO
  
  
  //--------------------------------------------------------
  // function get_TxD_232();
  //--------------------------------------------------------
  function logic get_TxD_232();
      return ssp_uart_vif.TxD_232_sig;
  endfunction: get_TxD_232
  
  //--------------------------------------------------------
  // function get_xRTS();
  //--------------------------------------------------------
  function logic get_xRTS();
      return ssp_uart_vif.xRTS_sig;
  endfunction: get_xRTS
  
  
  //--------------------------------------------------------
  // function get_TxD_485();
  //--------------------------------------------------------
  function logic get_TxD_485();
      return ssp_uart_vif.TxD_485_sig;
  endfunction: get_TxD_485
  
  
  //--------------------------------------------------------
  // function get_xDE();
  //--------------------------------------------------------
  function logic get_xDE();
      return ssp_uart_vif.xDE_sig;
  endfunction: get_xDE
  
  
  //--------------------------------------------------------
  // function get_IRQ();
  //--------------------------------------------------------
  function logic get_IRQ();
      return ssp_uart_vif.IRQ_sig;
  endfunction: get_IRQ
  
  
  //--------------------------------------------------------
  // function get_TxIdle();
  //--------------------------------------------------------
  function logic get_TxIdle();
      return ssp_uart_vif.TxIdle_sig;
  endfunction: get_TxIdle
  
  
  //--------------------------------------------------------
  // function get_RxIdle();
  //--------------------------------------------------------
  function logic get_RxIdle();
      return ssp_uart_vif.RxIdle_sig;
  endfunction: get_RxIdle

  extern function void print();

endclass
//--------------------------------------------------------
// function print();
//--------------------------------------------------------

function void config_item::print();

    $display("Printing the pkt contents");
    $display("--- SSP_RA --- %3h", get_SSP_RA());
    $display("--- SSP_DI --- %3h", get_SSP_DI());
    $display("--- R/W --- %3d", get_SSP_WnR());

endfunction


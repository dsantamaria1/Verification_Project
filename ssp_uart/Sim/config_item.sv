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



/**
   * @brief Constructor
   * Method to construct the config_item class
   * Initializes all variables to a default value
   */

  function new();
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
      logic RxD_= 0;
      logic [11:0] SSP_DO = 0;
      logic TxD_= 0;                
      logic xRTS = 0;
      logic TxD_= 0;                
      logic xDE = 0;
      logic IRQ = 0;
      logic TxIdle = 0; 
      logic RxIdle = 0;
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
function void get_rst(int i1);
    return Rst;
endfunction: get_rst


//--------------------------------------------------------
// function get_clk();
//--------------------------------------------------------
function void get_clk(int i1);
    return Clk;
endfunction: get_clk


//--------------------------------------------------------
// function get_SSP_SSEL();
//--------------------------------------------------------
function void get_SSP_SSEL(int i1);
    return SSP_SSEL;
endfunction: get_SSP_SSEL


//--------------------------------------------------------
// function get_SSP_SCK();
//--------------------------------------------------------
function void get_SSP_SCK(int i1);
    return SSP_SCK;
endfunction: get_SSP_SCK


//--------------------------------------------------------
// function get_SSP_RA();
//--------------------------------------------------------
function void get_SSP_RA(int i1);
    return SSP_RA;
endfunction: get_SSP_RA


//--------------------------------------------------------
// function get_SSP_WnR();
//--------------------------------------------------------
function void get_SSP_WnR(int i1);
    return SSP_WnR;
endfunction: get_SSP_WnR


//--------------------------------------------------------
// function get_SSP_En();
//--------------------------------------------------------
function void get_SSP_En(int i1);
    return SSP_En;
endfunction: get_SSP_En


//--------------------------------------------------------
// function get_SSP_EOC();
//--------------------------------------------------------
function void get_SSP_EOC(int i1);
    return SP_EOC;
endfunction: get_SSP_EOC


//--------------------------------------------------------
// function get_SSP_DI();
//--------------------------------------------------------
function void get_SSP_DI(int i1);
    return SSP_DI;
endfunction: get_SSP_DI


//--------------------------------------------------------
// function get_RxD_232();
//--------------------------------------------------------
function void get_RxD_232(int i1);
    return RxD_232;
endfunction: get_RxD_232


//--------------------------------------------------------
// function get_xCTS();
//--------------------------------------------------------
function void get_xCTS(int i1);
    return xCTS;
endfunction: get_xCTS


//--------------------------------------------------------
// function get_RxD_485();
//--------------------------------------------------------
function void get_RxD_485(int i1);
    return RxD_485;
endfunction: get_RxD_485


//--------------------------------------------------------
// function get_SSP_DO();
//--------------------------------------------------------
function void get_SSP_DO(int i1);
    return SSP_DO;
endfunction: get_SSP_DO


//--------------------------------------------------------
// function get_TxD_232();
//--------------------------------------------------------
function void get_TxD_232(int i1);
    return TxD_232;
endfunction: get_TxD_232

//--------------------------------------------------------
// function get_xRTS();
//--------------------------------------------------------
function void get_xRTS(int i1);
    return xRTS;
endfunction: get_xRTS


//--------------------------------------------------------
// function get_TxD_485();
//--------------------------------------------------------
function void get_TxD_485(int i1);
    return TxD_485;
endfunction: get_TxD_485


//--------------------------------------------------------
// function get_xDE();
//--------------------------------------------------------
function void get_xDE(int i1);
    return xDE;
endfunction: get_xDE


//--------------------------------------------------------
// function get_IRQ();
//--------------------------------------------------------
function void get_IRQ(int i1);
    return IRQ;
endfunction: get_IRQ


//--------------------------------------------------------
// function get_TxIdle();
//--------------------------------------------------------
function void get_TxIdle(int i1);
    return TxIdle;
endfunction: get_TxIdle


//--------------------------------------------------------
// function get_RxIdle();
//--------------------------------------------------------
function void get_RxIdle(int i1);
    return RxIdle;
endfunction: get_RxIdle


//--------------------------------------------------------
// function print();
//--------------------------------------------------------

function void config_item::print();

    $display("Printing the pkt contents");
    $display("---Pkt Id --- %3d", get_id());
    $display("---Addr   --- %3d", get_addr());
    $display("---Value  --- %3d", get_data());

endfunction


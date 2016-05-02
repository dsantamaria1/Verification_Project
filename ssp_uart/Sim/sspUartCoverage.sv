class sspUartCov;
  virtual ssp_uart_if ssp_uart_vif;

  function new(virtual ssp_uart_if ssp_uart_vif);
    this.ssp_uart_vif = ssp_uart_vif;
    this.TFIFO = new();
    this.RFIFO = new();
    this.TDR = new();
    this.RDR = new();
    this.USR = new();
    this.UCR = new();
  endfunction 

  covergroup TFIFO @(posedge ssp_uart_vif.Clk_sig);
    //clear: coverpoint ssp_uart_vif.TFC{
    //  bins cleared = {1};
    //}
  endgroup

  covergroup RFIFO @(posedge ssp_uart_vif.Clk_sig);
    //clear: coverpoint ssp_uart_vif.RFC{
    //  bins cleared = {1};
    //}
  endgroup
  
  covergroup TDR @(posedge ssp_uart_vif.Clk_sig);
    TFC: coverpoint ssp_uart_vif.TFC{
      bins cleared = {1};
    }
  
    RFC: coverpoint ssp_uart_vif.RFC{
      bins cleared = {1};
    }
  
    TFW: coverpoint ssp_uart_vif.TFW{
      bins cleared = {1};
    }
  
  endgroup
  
  covergroup RDR @(posedge ssp_uart_vif.Clk_sig);
    RTO: coverpoint ssp_uart_vif.RTO{
      bins enabled = {1};
    }
  
    RERR: coverpoint ssp_uart_vif.RERR{
      bins errOccurred = {1};
    }
  
    RRDY: coverpoint ssp_uart_vif.RRDY{
      bins ready = {1};
    }
  
    TRDY: coverpoint ssp_uart_vif.TRDY{
      bins ready = {1};
    }
  
  endgroup
  
  covergroup USR @(posedge ssp_uart_vif.Clk_sig);
    iTFE: coverpoint ssp_uart_vif.iTFE{
      bins TFIFO_Empty = {1};
    }

    iTHE: coverpoint ssp_uart_vif.iTHE{
      bins TFIFO_HalfEmpty = {1};
    }

    iRHF: coverpoint ssp_uart_vif.iRHF{
      bins RFIFO_HalfFull = {1};
    }

    iRTO: coverpoint ssp_uart_vif.iRTO{
      bins ReceiveTimeOut = {1};
    }

    RFIFO_Status: coverpoint ssp_uart_vif.RS{
      bins Full = {'b11};
      bins gThanRFThr = {'b10};
      bins lThanRFThr = {'b01};
      bins Empty = {'b00};
    }

    TFIFO_Status: coverpoint ssp_uart_vif.TS{
      bins Full = {'b11};
      bins gThanTFThr = {'b10};
      bins lThanTFThr = {'b01};
      bins Empty = {'b00};
    }

    CTSi: coverpoint ssp_uart_vif.CTSi{
      bins clear = {1};
    }

    RTSi: coverpoint ssp_uart_vif.RTSi{
      bins req = {1};
    }

    MD: coverpoint ssp_uart_vif.MD{
      bins RS485wLoopback = {'b11};
      bins RS485woLoopback = {'b10};
      bins RS232wFlow = {'b01};
      bins RS232woFlow = {'b00};
    }

  endgroup

  covergroup UCR @(posedge ssp_uart_vif.Clk_sig);
    IE: coverpoint ssp_uart_vif.IE{ 
      bins enabled = {1};
    }

    MD: coverpoint ssp_uart_vif.MD{
      bins RS485wLoopback = {'b11};
      bins RS485woLoopback = {'b10};
      bins RS232wFlow = {'b01};
      bins RS232woFlow = {'b00};
    }

  endgroup
endclass: sspUartCov

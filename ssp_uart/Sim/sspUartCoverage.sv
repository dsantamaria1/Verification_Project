class sspUartCov;
  virtual ssp_uart_if ssp_uart_vif;

  function new(virtual ssp_uart_if ssp_uart_vif);
    this.ssp_uart_vif = ssp_uart_vif;
  endfunction 

  covergroup TFIFO @(posedge ssp_uart_vif.Clk_sig);
    clear: coverpoint ssp_uart_vif.TFC{
      bins cleared = {1};
    }
  endgroup
endclass: sspUartCov

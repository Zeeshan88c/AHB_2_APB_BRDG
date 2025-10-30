interface ahb_2_apb_intf (input HCLK, input HRESET,input PCLK,input PCLKen,input PRESETn);

  logic [31:0] HADDR;
  logic        HWRITE;
  logic [1:0]  HTRANS;
  logic [2:0]  HSIZE;
  logic [2:0]  HBURST;
  logic [3:0]  HPROT;
  logic [63:0] HWDATA;
  logic [63:0] HRDATA;
  logic        HREADY;
  logic        HRESP;
  
  logic [31:0] PADDR;      
  logic        PSEL;       
  logic        PENABLE;
  logic [2:0]  PPROT;
  logic [3:0]  PSTRB;    
  logic        PWRITE;     
  logic [31:0] PWDATA;     
  logic [31:0] PRDATA;     
  logic        PREADY;     
  logic        PSLVERR;    


endinterface

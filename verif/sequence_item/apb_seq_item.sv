////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : apb_seq_item.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  sequence item for APB Slave
////////////////////////////////////////////////////////////////////////////////

class apb_seq_item extends uvm_sequence_item;

  // constructor
function new(string name = "apb_seq_item");
  super.new(name);
endfunction 
 // transaction fields
  bit [31:0] PADDR;      
  bit        PSEL;       
  bit        PENABLE;
  bit [2:0]  PPROT;
  bit [3:0]  PSTRB;    
  bit        PWRITE;     
  bit [31:0] PWDATA;     
  bit [31:0] PRDATA;     
  bit        PREADY;     
  bit        PSLVERR;  

  // ============================
  // Automation Macros
  // ============================
  `uvm_object_utils_begin(apb_seq_item);

   `uvm_field_int(PADDR,UVM_ALL_ON + UVM_DEC)
   `uvm_field_int(PWRITE,UVM_ALL_ON+ UVM_DEC)
   `uvm_field_int(PENABLE,UVM_ALL_ON + UVM_DEC)
   `uvm_field_int(PPROT,UVM_ALL_ON + UVM_DEC)
   `uvm_field_int(PSTRB,UVM_ALL_ON + UVM_DEC)
   `uvm_field_int(PWDATA,UVM_ALL_ON + UVM_DEC)
   `uvm_field_int(PRDATA,UVM_ALL_ON + UVM_HEX)
   `uvm_field_int(PREADY,UVM_ALL_ON + UVM_DEC)
   `uvm_field_int(PSLVERR,UVM_ALL_ON + UVM_DEC)

  `uvm_object_utils_end

  // ==============================================================================================
  // Custom display function
  // ==============================================================================================
 virtual function void display_brdg(string name);
  string msg;

  msg = $sformatf("\nThis is being displayed from %s\n", name);
  msg = {msg, $sformatf(
    "PADDR = 0x%08h PWRITE = %0d PENABLE = %0d PSEL = %0d\nPPROT = 0x%0h PSTRB = 0x%0h\nPWDATA = 0x%08h PRDATA = 0x%08h\nPREADY = %0d PSLVERR = %0d\n",
    PADDR, PWRITE, PENABLE, PSEL, PPROT, PSTRB, PWDATA, PRDATA, PREADY, PSLVERR
  )};

  `uvm_info(name, msg, UVM_MEDIUM)
endfunction // display_brdg


endclass // cuboid


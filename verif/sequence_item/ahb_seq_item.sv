////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_seq_item.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  sequence item for AHB Master
////////////////////////////////////////////////////////////////////////////////

class ahb_seq_item extends uvm_sequence_item;

  // constructor
function new(string name = "ahb_seq_item");
  super.new(name);
endfunction 
  // transaction fields
rand bit [31:0] HADDR;
rand bit        HWRITE;
rand bit [1:0]  HTRANS;
rand bit [2:0]  HSIZE;
rand bit [2:0]  HBURST;
rand bit [3:0]  HPROT;
rand bit [63:0] HWDATA;

bit [63:0] HRDATA;
bit        HREADY;
bit        HRESP;

// Automation Macro
`uvm_object_utils_begin(ahb_seq_item)

  `uvm_field_int(HADDR,  UVM_ALL_ON + UVM_DEC)
  `uvm_field_int(HWRITE, UVM_ALL_ON + UVM_DEC)
  `uvm_field_int(HTRANS, UVM_ALL_ON + UVM_DEC)
  `uvm_field_int(HSIZE,  UVM_ALL_ON + UVM_DEC)
  `uvm_field_int(HBURST, UVM_ALL_ON + UVM_DEC)
  `uvm_field_int(HPROT,  UVM_ALL_ON + UVM_DEC)
  `uvm_field_int(HWDATA, UVM_ALL_ON + UVM_DEC)

  `uvm_field_int(HRDATA, UVM_ALL_ON + UVM_DEC)
  `uvm_field_int(HREADY, UVM_ALL_ON + UVM_DEC)
  `uvm_field_int(HRESP,  UVM_ALL_ON + UVM_DEC)

`uvm_object_utils_end

 /*constraint haddr_range_c {
    HADDR inside {[32'h1000 : 32'h1FFF]}; // 4096 to 8191
  }

constraint haddr_alignment_c {
    (HADDR & ((1 << HSIZE) - 1)) == 0;
  }*/
// ==============================================================================================
// Custom display function
// ==============================================================================================
  virtual function void display_brdg(string name);
  string msg;

  msg = $sformatf("\nThis is being displayed from %s\n", name);
  msg = {msg, $sformatf(
    "HADDR = 0x%08h HWRITE = %0d HTRANS = 0x%0h\nHSIZE = 0x%0h HBURST = 0x%0h HPROT = 0x%0h\nHWDATA = 0x%016h HRDATA = 0x%016h\nHREADY = %0d HRESP = %0d\n",
    HADDR, HWRITE, HTRANS, HSIZE, HBURST, HPROT, HWDATA, HRDATA, HREADY, HRESP
  )};

  `uvm_info(name, msg, UVM_MEDIUM)
endfunction // display_brdg


endclass // cuboid


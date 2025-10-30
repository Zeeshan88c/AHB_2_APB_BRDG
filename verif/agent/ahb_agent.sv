////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_agent.sv
//  Author        : Zeeshan Malik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  Master agent AHB 
////////////////////////////////////////////////////////////////////////////////

class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)
  
  // =============================
  // Constructor
  // =============================
  function new(string name = "ahb_agent", uvm_component parent = null);
    super.new(name , parent);
  endfunction
  
  ahb_driver drv;
  ahb_monitor mon;
  uvm_sequencer #(ahb_seq_item) sequencer;
  
  // =============================
  // Build phase
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    drv = ahb_driver::type_id::create("drv", this);
    mon = ahb_monitor::type_id::create("mon", this);
    sequencer = uvm_sequencer#(ahb_seq_item)::type_id::create("sequencer",this);
    
  endfunction: build_phase
  
  // =============================
  // Connect phase
  // =============================
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    drv.seq_item_port.connect(sequencer.seq_item_export);
    
  endfunction: connect_phase
  
endclass
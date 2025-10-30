////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : apb_agent.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  Slave agent for APB
////////////////////////////////////////////////////////////////////////////////

class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  // ============================
  // Constructor
  // ============================
  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  apb_driver drv;
  apb_monitor mon;
  uvm_sequencer #(apb_seq_item) sequencer;
  
  // ============================
  // Build phase
  // ============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    drv = apb_driver::type_id::create("drv",this);
    mon = apb_monitor::type_id::create("mon",this);
    sequencer = uvm_sequencer #(apb_seq_item)::type_id::create("sequencer",this);
    
  endfunction: build_phase
  
  // ============================
  // Connect phase
  // ============================
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    drv.seq_item_port.connect(sequencer.seq_item_export);
    
  endfunction: connect_phase
  
endclass
  
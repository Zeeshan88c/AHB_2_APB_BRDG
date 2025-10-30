////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : common_config.sv
//  Author        : Zeeshan Malik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  Common Configuration Class
////////////////////////////////////////////////////////////////////////////////

class common_config extends uvm_component;
  
  ahb_2_apb_config A2B_cfg;
  
  // ========================
  // Constructor
  // ========================
  function new(string name = "common_config", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  `uvm_component_utils(common_config);
  
  function void post_randomize();
    A2B_cfg = ahb_2_apb_config::type_id::create("A2B_cfg", this);
    A2B_cfg.randomize();
  endfunction: post_randomize
  
endclass
  

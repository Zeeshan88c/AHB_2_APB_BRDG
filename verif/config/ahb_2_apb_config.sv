////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_2_apb_config.sv
//  Author        : Zeeshan Malik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  Common Configuration Class
////////////////////////////////////////////////////////////////////////////////

class ahb_2_apb_config extends uvm_component;

  string ahb_size_arg;
  string num_tsnx_arg;
  string ahb_ADDR_arg;
  string incr_4_arg;
  string hwrite_arg;
  int ahb_size_val;
  int num_tsnx_val;
  int ahb_ADDR;
  int incr_val;
  int hwrite_val;
   
  // ===============================
  // Constructor
  // ===============================
  function new(string name = "ahb_2_apb_config", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  `uvm_component_utils(ahb_2_apb_config)
  
  function void post_randomize();
    
    uvm_cmdline_processor clp;
    clp = uvm_cmdline_processor::get_inst();
    
    if(clp.get_arg_value("+AHB_SIZE=",ahb_size_arg))begin
      ahb_size_val = ahb_size_arg.atoi();
    end

    if(clp.get_arg_value("+num_tsnx=",num_tsnx_arg))begin
      num_tsnx_val = num_tsnx_arg.atoi();
    end

    if(clp.get_arg_value("+HADDR=",ahb_ADDR_arg))begin
      ahb_ADDR = ahb_ADDR_arg.atoi();
    end

    if(clp.get_arg_value("+incr=",incr_4_arg))begin
      incr_val = incr_4_arg.atoi();
    end

    if(clp.get_arg_value("+hwrite=",hwrite_arg))begin
      hwrite_val = hwrite_arg.atoi();
    end
    
  endfunction: post_randomize
  
endclass
    
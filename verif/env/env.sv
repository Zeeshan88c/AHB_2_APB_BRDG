////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_2_apb_brdg_env.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  UVM environment class for AHB_2_APB_Bridge.
////////////////////////////////////////////////////////////////////////////////

class ahb_2_apb_brdg_env extends uvm_env;
  `uvm_component_utils(ahb_2_apb_brdg_env)
  
  ahb_agent in_agnt_1;
  apb_agent in_agnt_2;
  scoreboard scb;
  
  uvm_event in_scb_evnt;
  
  int WATCH_DOG;
  
  // ================================
  // Constructor
  // ================================
  function new(string name = "ahb_2_apb_brdg_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  // ================================
  // Build phase
  // ================================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_agnt_1 = ahb_agent::type_id::create("in_agnt_1",this);
    in_agnt_2 = apb_agent::type_id::create("in_agnt_2" ,this);
    scb = scoreboard::type_id::create("scb" ,this);
    
    in_scb_evnt = uvm_event_pool::get_global("ingr_scb_evnt");

    //uvm_config_wrapper::set(this,"in_agnt_1.sequencer.main_phase" , "default_sequence" , inp_sequence::type_id::get());
    //uvm_config_wrapper::set(this,"in_agnt_2.sequencer.main_phase" , "default_sequence" , in_sequence::type_id::get());
    
  endfunction: build_phase
  
  // ================================
  // Connect phase
  // ================================
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    in_agnt_1.mon.out_port_a.connect(scb.expected);
    in_agnt_2.mon.out_port_b.connect(scb.received);
    
  endfunction: connect_phase
  
  // ================================
  // Main phase
  // ================================
  virtual task main_phase(uvm_phase phase);
    phase.raise_objection(this);    
    `uvm_info(get_type_name(), "Main phase starting ...", UVM_MEDIUM);
    super.main_phase(phase);
 
    WATCH_DOG = 1ms;
    
    fork 
      begin
        `uvm_info(get_type_name(), "Starting WATCH DOG started", UVM_MEDIUM);
        
        #WATCH_DOG
        `uvm_info(get_type_name(), "WATCH DOG Expired", UVM_MEDIUM);
          `uvm_fatal(get_type_name(), "Error event didn't triggered");
      end
      
      begin
        `uvm_info(get_type_name(), "wait for uvm_event ", UVM_MEDIUM);
        in_scb_evnt.wait_trigger();
        `uvm_info(get_type_name(), "Scoreboard event triggered successfully",UVM_MEDIUM);
      end
    join_any
    
    phase.drop_objection(this);
    
  endtask
  
endclass
                   
    
    

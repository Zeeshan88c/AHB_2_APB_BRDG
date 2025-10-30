////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : apb_base_seq.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  apb_base_seq for AHB
////////////////////////////////////////////////////////////////////////////////

class apb_base_seq extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_base_seq)
  
  common_config cmn_cfg;
  rand logic [3:0] cntr;
  
  // =========================
  // Constructor
  // =========================
  function new(string name = "apb_base_seq");
    super.new(name);
    set_response_queue_depth(128);
  endfunction 
  
  // =========================
  // Task body
  // =========================
  virtual task body();
    
    `uvm_info(get_type_name(), "Starting APB Sequence", UVM_NONE);
    
    if(!(uvm_config_db #(common_config)::get(null, "", "cmn_cfg", cmn_cfg)))begin
      `uvm_fatal(get_type_name(), " Failed to get config");
    end
    
    req = apb_seq_item::type_id::create("req");
    rsp = apb_seq_item::type_id::create("rsp");
    
    forever begin
      
      start_item(req);
      get_response(rsp);
     
      fork
        // thread for Setup
        begin
          if(rsp.PSEL)begin
            if(rsp.PWRITE)begin
              req.PREADY = 1;
              req.PSLVERR = 0;
            end else begin
              req.PREADY = 1;
              req.PSLVERR = 0;
              req.PRDATA = '0;
            end
          end
        end
        // thread for Access
        begin
          if(rsp.PSEL && rsp.PENABLE)begin
            req.PREADY = '0;
            req.PSLVERR = '0;
            req.PRDATA = $random();
          end
        end
      join
      finish_item(req);
    end
  endtask
  
endclass
    
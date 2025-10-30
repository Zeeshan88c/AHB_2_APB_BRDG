////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : apb_wait_states.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  apb_wait_states for AHB
////////////////////////////////////////////////////////////////////////////////

class apb_wait_states extends uvm_sequence #(apb_seq_item);
  `uvm_object_utils(apb_wait_states)

  common_config cmn_cfg    ;
  logic [3:0]   wait_states;

  // =========================
  // Constructor
  // =========================
  function new(string name = "apb_wait_states");
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
      finish_item(req);
      get_response(rsp);

      wait_states = 4;

      if(rsp.PSEL)begin

        repeat(wait_states)begin
          req.PREADY = 0;
          req.PSLVERR = 0;
          req.PRDATA = 0;
          #4;
        end

        if(rsp.PWRITE)begin
          req.PREADY = 1;
          req.PSLVERR = 0;
        end else begin
          req.PREADY = 1;
          req.PSLVERR = 0;
          req.PRDATA = $random;
        end
      end 

      if(rsp.PENABLE)begin
        req.PREADY = 0;
        req.PSLVERR = 0;
        req.PRDATA = 0;
      end

    end
  endtask

endclass

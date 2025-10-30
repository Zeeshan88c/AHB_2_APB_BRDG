////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_rnd_rd_wr.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  ahb_single_write for AHB
////////////////////////////////////////////////////////////////////////////////

class ahb_rnd_rd_wr extends uvm_sequence #(ahb_seq_item);
  `uvm_object_utils(ahb_rnd_rd_wr)
  
  common_config cmn_cfg;

  int ok;
  
  // =================================
  // Constructor
  // =================================
  function new(string name = "ahb_rnd_rd_wr");
    super.new(name);
  endfunction
  
  // =================================
  // Task body
  // =================================
  virtual task body();
  
    `uvm_info(get_type_name(), "Starting the AHB Sequence", UVM_NONE);
    
    if(!(uvm_config_db #(common_config)::get(null, "","cmn_cfg", cmn_cfg)))begin
      `uvm_fatal(get_type_name(), "Failed to get common config");
    end
    
    req = ahb_seq_item::type_id::create("req");
    
    repeat(cmn_cfg.A2B_cfg.num_tsnx_val)begin
      
      start_item(req);

      assert(req.randomize() with {
        HADDR  inside {[32'h1000 : 32'h1FFF]};              // Apply range
        (HADDR & ((1 << HSIZE) - 1)) == 0;
        HPROT  == 4'b0011;
        HSIZE  == cmn_cfg.A2B_cfg.ahb_size_val;
        HBURST == 3'b000;
        HTRANS == 2'b10;
        HWRITE inside {0,1};
      }) else begin
        `uvm_error("RAND", "Randomization failed for ahb_seq_item with specific values.")
      end  

      finish_item(req);
      
    end
    
    `uvm_info(get_type_name(), "Ending the AHB Sequence", UVM_NONE);
    
  endtask
  
endclass
      
    
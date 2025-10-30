////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_wrap_8_rnd_rd_wr.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  ahb_wrap_8_rnd_rd_wr for AHB
////////////////////////////////////////////////////////////////////////////////

class ahb_wrap_8_rnd_rd_wr extends uvm_sequence #(ahb_seq_item);
  `uvm_object_utils(ahb_wrap_8_rnd_rd_wr)
  
  common_config cmn_cfg;

  int ok;

  logic [31:0]wrap_address;
  logic [31:0]wrap_boundary;
  int wrap_size;
  
  // =================================
  // Constructor
  // =================================
  function new(string name = "ahb_wrap_8_rnd_rd_wr");
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

    wrap_address = cmn_cfg.A2B_cfg.ahb_ADDR;
    wrap_size = cmn_cfg.A2B_cfg.incr_val * (1 << cmn_cfg.A2B_cfg.ahb_size_val );
    wrap_boundary = (cmn_cfg.A2B_cfg.ahb_ADDR / wrap_size) * wrap_size;

    repeat(cmn_cfg.A2B_cfg.num_tsnx_val)begin

      for(int i = 0; i < cmn_cfg.A2B_cfg.incr_val; i++)begin

        start_item(req);

        if(i == 0) begin
          assert(req.randomize() with {
              HADDR  == wrap_address;
              HPROT  == 4'b0011;
              HSIZE  == cmn_cfg.A2B_cfg.ahb_size_val;
              HBURST == 3'b100;
              HTRANS == 2'b10;
              HWRITE == cmn_cfg.A2B_cfg.hwrite_val;
            });
        end else begin
          assert(req.randomize() with {
              HADDR  == wrap_address;
              HPROT  == 4'b0011;
              HSIZE  == cmn_cfg.A2B_cfg.ahb_size_val;
              HBURST == 3'b100;
              HTRANS == 2'b11;
              HWRITE == cmn_cfg.A2B_cfg.hwrite_val;
            });
        end

        finish_item(req);

        // ========================
        // Wrap Address
        // ========================
        if(wrap_address >= 4096 && wrap_address < 8192)begin
          wrap_address = wrap_boundary + (((wrap_address - wrap_boundary) + (1 << cmn_cfg.A2B_cfg.ahb_size_val )) % wrap_size);
        end else begin
          wrap_address = cmn_cfg.A2B_cfg.ahb_ADDR;
        end
        
      end
   
    end
    
    `uvm_info(get_type_name(), "Ending the AHB Sequence", UVM_NONE);

  endtask
  
endclass
      
    
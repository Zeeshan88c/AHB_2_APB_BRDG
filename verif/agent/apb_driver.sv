////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : apb_driver.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  Driver Class for APB
////////////////////////////////////////////////////////////////////////////////

class apb_driver extends uvm_driver #(apb_seq_item);
  `uvm_component_utils(apb_driver)
  
  // =============================
  // Constructor
  // =============================
  function new(string name = "apb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual ahb_2_apb_intf vif;
  
  // =============================
  // Build phase
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    req = apb_seq_item::type_id::create("req");
    rsp = apb_seq_item::type_id::create("rsp");
    
    if(!(uvm_config_db #(virtual ahb_2_apb_intf)::get(this, "", "vif", vif)))begin
      `uvm_fatal(get_type_name(), "Can't get interface");
    end
    
  endfunction: build_phase
  
  // =============================
  // Main phase
  // =============================
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    
    `uvm_info(get_type_name(), "Main phase starting ... ", UVM_NONE);
    
    forever begin
      
      seq_item_port.get_next_item(req);
      
      drive_item(req);

      seq_item_port.item_done();

      rsp.set_id_info(req);  

      seq_item_port.put_response(rsp);
      
    end
    
    `uvm_info(get_type_name(), "Main phase ending ... ", UVM_NONE);
    
  endtask
  
  // =============================
  // Driver item
  // =============================
  virtual task drive_item(apb_seq_item req);

    vif.PREADY  <= req.PREADY;
    vif.PSLVERR <= req.PSLVERR;
    vif.PRDATA  <= req.PRDATA;

    @(posedge vif.PCLK)begin
    rsp.PADDR = vif.PADDR;
    rsp.PRDATA = vif.PRDATA;
    rsp.PPROT = vif.PPROT;
    rsp.PSEL = vif.PSEL;
    rsp.PWDATA = vif.PWDATA;
    rsp.PWRITE = vif.PWRITE;
    rsp.PENABLE = vif.PENABLE;
    end

    `uvm_info(get_type_name(), "Main SIgnals are drived to DUT", UVM_NONE);

   endtask : drive_item

 endclass
    
    
    
    
    
    
    

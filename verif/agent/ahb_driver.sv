////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_driver.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  Driver Class for AHB
////////////////////////////////////////////////////////////////////////////////

class ahb_driver extends uvm_driver #(ahb_seq_item);
  `uvm_component_utils(ahb_driver)
  
  // =============================
  // Constructor
  // =============================
  function new(string name = "ahb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual ahb_2_apb_intf vif;
  semaphore lock = new(1);
  
  // =============================
  // Build phase
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    req = ahb_seq_item::type_id::create("req");
    
    if(!(uvm_config_db #(virtual ahb_2_apb_intf)::get(this,"", "vif", vif)))begin
      `uvm_fatal(get_type_name(), "Can't get interface");
    end
    
  endfunction:build_phase
  
  // =============================
  // Main phase
  // =============================
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    `uvm_info(get_type_name(), "Main phase starting .. ", UVM_NONE);

    forever begin
      fork       
        drive_item(req);
        drive_item(req);
      join
    end
    
    `uvm_info(get_type_name(), "Main phase ending ..", UVM_NONE);
    
  endtask
  
  // ============================
  // Drive_item
  // ============================
  virtual task drive_item(ahb_seq_item req);

    lock.get();

    seq_item_port.get(req);

    // ========================== //
    //       Address phase        //
    // ========================== //
    
    @(posedge vif.HCLK iff (vif.HREADY));
    vif.HADDR <= req.HADDR;
    vif.HSIZE <= req.HSIZE;
    vif.HTRANS <= req.HTRANS;
    vif.HPROT <= req.HPROT;
    vif.HBURST <= req.HBURST;
    vif.HWRITE <= req.HWRITE; 

    while(vif.HREADY != 1)begin
      @(posedge vif.HCLK);
    end
    
    lock.put();

    // ========================== //
    //         Data phase         //
    // ========================== //

    if(vif.HWRITE)begin
      vif.HWDATA <= req.HWDATA;
      while(vif.HREADY != 1)begin
        @(posedge vif.HCLK);
      end
    end else begin
      //@(posedge vif.HCLK);
      while(vif.HREADY != 1)begin
        @(posedge vif.HCLK);
      end
      req.HRDATA <= vif.HRDATA;
    end

    req.HRESP <= vif.HRESP;

    `uvm_info(get_type_name(),"Driving Input Signals to DUT",UVM_MEDIUM);
    
  endtask
  
endclass
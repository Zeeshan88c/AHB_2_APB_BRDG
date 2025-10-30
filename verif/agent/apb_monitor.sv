////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : apb_monitor.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  This is the Monitor for APB
////////////////////////////////////////////////////////////////////////////////

class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor);
  
  // ==============================
  // Constructor
  // ==============================
  function new(string name = "apb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual ahb_2_apb_intf vif;
  
  uvm_analysis_port#(apb_seq_item) out_port_b;
  
  apb_seq_item send_packet;
  
  // ==============================
  // Build phase
  // ==============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    send_packet = apb_seq_item::type_id::create("send_packet");
    out_port_b = new("out_port_b", this);
    
    if(!(uvm_config_db #(virtual ahb_2_apb_intf)::get(this, "", "vif", vif)))begin
      `uvm_fatal(get_type_name(), "Can't get the interface");
    end
    
  endfunction
  
  // ==============================
  // Main phase
  // ==============================
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    
    `uvm_info(get_type_name(), "Main phase starting ..", UVM_MEDIUM);
    collect_data();
    `uvm_info(get_type_name(), "Main phase ending ..", UVM_MEDIUM);
    
  endtask
  
  // ==============================
  // Collect data
  // ==============================
 task collect_data();
  forever begin
    @(posedge vif.PCLK iff (vif.PENABLE && vif.PREADY));

    send_packet.PWRITE  = vif.PWRITE;
    send_packet.PWDATA  = vif.PWDATA;
    send_packet.PENABLE = vif.PENABLE;
    send_packet.PADDR   = vif.PADDR;
    send_packet.PRDATA  = vif.PRDATA;
    send_packet.PSTRB   = vif.PSTRB;
    send_packet.PSEL    = vif.PSEL;
    send_packet.PPROT   = vif.PPROT;
    send_packet.PSLVERR = vif.PSLVERR;
    send_packet.PREADY  = vif.PREADY;

    send_packet.display_brdg("Apb_monitor");

    `uvm_info(get_type_name(), $sformatf(
      "APB Monitor: PADDR=%0h, PWDATA=%0h, PWRITE=%0b, PREADY=%0b, PENABLE=%0b, PSEL=%0b",
      send_packet.PADDR, send_packet.PWDATA, send_packet.PWRITE,
      send_packet.PREADY, send_packet.PENABLE, send_packet.PSEL
    ), UVM_LOW)

    out_port_b.write(send_packet); 
  end
endtask
endclass

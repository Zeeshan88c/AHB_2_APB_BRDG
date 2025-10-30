////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_monitor.sv
//  Author        : Zeeshan MAlik
//  Creation Date : 23/07/2025
//
//  Description
//  ===========
//  Monitor Class for AHB
////////////////////////////////////////////////////////////////////////////////

class ahb_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_monitor)
  
  // =============================
  // Constructor
  // =============================
  function new(string name = "ahb_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  virtual ahb_2_apb_intf vif;
  
  uvm_analysis_port#(ahb_seq_item) out_port_a;
  
  ahb_seq_item send_packet;

  //temporary register
  bit [31:0] temp_hADDR;
  bit        temp_hWRITE;
  bit [1:0]  temp_hTRANS;
  bit [2:0]  temp_hSIZE;
  bit [2:0]  temp_hBURST;
  bit [3:0]  temp_hPROT;

  semaphore lock = new(1);
  
  // =============================
  // Build phase
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    out_port_a = new("out_port_a", this);
    send_packet = ahb_seq_item::type_id::create("send_packet");
    
    if(!(uvm_config_db #(virtual ahb_2_apb_intf)::get(this, "", "vif", vif)))begin
      `uvm_fatal(get_type_name(), "Can't get interface");
    end
    
  endfunction
  
  // =============================
  // Main phase
  // =============================
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    
    `uvm_info(get_type_name(), "Main phase starting ..",UVM_MEDIUM);
  
    fork
      collect_data();
      collect_data();
    join

    `uvm_info(get_type_name(), "Main phase ending ..", UVM_MEDIUM);
    
  endtask
  
  // ============================
  // Collect data
  // ============================
  task collect_data;

    forever begin
          
      lock.get();
      
      // ====================== //
      //      Address phase     //
      // ====================== //
      @(posedge vif.HCLK iff (vif.HREADY && vif.HRESET))
      temp_hADDR  = vif.HADDR;
      temp_hWRITE = vif.HWRITE;
      temp_hTRANS = vif.HTRANS;
      temp_hSIZE  = vif.HSIZE;
      temp_hBURST = vif.HBURST;
      temp_hPROT  = vif.HPROT;
      
      lock.put();

      // ====================== //
      //       Data phase       //
      // ====================== //

      @(posedge vif.HCLK iff (vif.HREADY))
      send_packet.HWDATA = vif.HWDATA;
      send_packet.HRDATA = vif.HRDATA;
      send_packet.HREADY = vif.HREADY;
      send_packet.HRESP  = vif.HRESP;
      send_packet.HADDR  = temp_hADDR; 
      send_packet.HWRITE = temp_hWRITE;
      send_packet.HTRANS = temp_hTRANS;
      send_packet.HSIZE  = temp_hSIZE;
      send_packet.HBURST = temp_hBURST;
      send_packet.HPROT  = temp_hPROT;
    
      send_packet.display_brdg("Ahb_monitor");

      `uvm_info(get_type_name(), $sformatf(
        "AHB Monitor: HADDR=%0h HWDATA=%0h HRDATA=%0h HWRITE=%0b HTRANS=%0b HSIZE=%0b HBURST=%0b HPROT=%0b HRESP=%0b HREADY=%0b",
        send_packet.HADDR, send_packet.HWDATA, send_packet.HRDATA,
        send_packet.HWRITE, send_packet.HTRANS, send_packet.HSIZE,
        send_packet.HBURST, send_packet.HPROT, send_packet.HRESP, send_packet.HREADY
      ), UVM_LOW)
    
      out_port_a.write(send_packet);

    end
    
  endtask
  
endclass
    
////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : ahb_2_apb_base_test.sv
//  Author        : MR Zeeshan
//  Creation Date : 01/14/2020
//
//  Description
//  ===========
//  This is ahb_2_apb_base_test 
////////////////////////////////////////////////////////////////////////////////

class ahb_2_apb_base_test extends uvm_test;
  `uvm_component_utils(ahb_2_apb_base_test)

  // =============================
  // Constructor Method
  // =============================
  function new(string name = "ahb_2_apb_base_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // =============================
  // component handles
  // =============================
      //env handle
     ahb_2_apb_brdg_env my_env;
     common_config cmn_cfg;
  // =============================
  // Virtual Interfaces
  // =============================
    virtual ahb_2_apb_intf vif_in;


  // =============================
  // Build Phase Method
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // creating environment
    my_env = ahb_2_apb_brdg_env::type_id::create("my_env",this);
    // Creating the environment 
    cmn_cfg = common_config::type_id::create("cmn_cfg",this);
    cmn_cfg.randomize();
    //setting the common config in config_db
    uvm_config_db #(common_config) ::set(null,"*","cmn_cfg",cmn_cfg);
    // getting virtual interfaces for vif_init_zero tasks
   if(!uvm_config_db#(virtual ahb_2_apb_intf)::get(this,"","vif", vif_in))
    `uvm_fatal("inp_interface","Interface not accessed in cuboid_base_test")
   
  endfunction


  // =============================
  // Reset Phase Method
  // =============================
   virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    super.reset_phase(phase);

    `uvm_info(get_type_name(), $sformatf("Staring reset_phase.."), UVM_MEDIUM)

    vif_init_zero(); 
    //idle cycles
    //repeat(100)
    //@(posedge vif_in.clk);
    

    `uvm_info(get_type_name(), $sformatf("reset_phase done.."), UVM_MEDIUM)
    phase.drop_objection(this);
  endtask // reset_phase

  // ==============================================
  // all interfaces needs to intialize with zeros
  // ==============================================
  task vif_init_zero();
    if(!vif_in.HRESET)begin
      vif_in.HADDR=0;
      vif_in.HWRITE = 0;
      vif_in.HWDATA=0;
      vif_in.HPROT=0;
      vif_in.HSIZE=0;
      vif_in.HTRANS=0;
      vif_in.HBURST=0;
    end
    if(!vif_in.PRESETn)begin
      vif_in.PRDATA=0;
      vif_in.PSLVERR=0;
      vif_in.PREADY=0;
    end
  endtask
endclass


////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : incr_8_test.sv
//  Author        : Zeeshan Malik
//  Creation Date : 
//
//
//  Description
//  ===========
//  Test for incr 8
////////////////////////////////////////////////////////////////////////////////
class incr_8_test extends ahb_2_apb_base_test;
  `uvm_component_utils(incr_8_test)
  
  // =============================
  // Costructor Method
  // =============================
  function new(string name = "incr_8_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  ahb_incr_8_rnd_rd_wr seq1;
  apb_base_seq seq2;

  // =============================
  // Build Phase Method
  // ============================= 
  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
    `uvm_info("incr_8_test", "Starting incr_8_test.... ", UVM_MEDIUM)
    seq1 = ahb_incr_8_rnd_rd_wr::type_id::create("seq1");
    seq2 = apb_base_seq::type_id::create("seq2");
  endfunction

  // =============================
  // Run phase
  // =============================
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
       fork 
         seq1.start(my_env.in_agnt_1.sequencer);
         seq2.start(my_env.in_agnt_2.sequencer);;
       join
  endtask

endclass 


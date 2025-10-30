
package ahb_2_apb_pkg;                       // package declaration
  
  import uvm_pkg::*; 
  `include "uvm_macros.svh"                  // import UVM package

  //common config 
  `include "ahb_2_apb_config.sv"
  `include "common_config.sv"
  // Sequence Item
  `include "ahb_seq_item.sv"
  `include "apb_seq_item.sv"
  // Drivers
  `include "ahb_driver.sv"
  `include "apb_driver.sv"
  // Monitor
  `include "ahb_monitor.sv"
  `include "apb_monitor.sv"
  // Agents
  `include "ahb_agent.sv" 
  `include "apb_agent.sv"
  // Scoreboard
  `include "scoreboard.sv"
  // Sequences
  `include "ahb_single_read.sv"
  `include "ahb_single_write.sv"
  `include "ahb_rnd_rd_wr.sv"
  `include "ahb_incr_4_rnd_rd_wr.sv"
  `include "ahb_incr_8_rnd_rd_wr.sv"
  `include "ahb_incr_16_rnd_rd_wr.sv"
  `include "ahb_incr_undefined_rnd_rd_wr.sv"
  `include "apb_base_seq.sv"
  `include "apb_wait_states.sv"
  `include "apb_slv_error_seq.sv"
  `include "ahb_wrap_4_rnd_rd_wr.sv"
  `include "ahb_wrap_8_rnd_rd_wr.sv"
  `include "ahb_wrap_16_rnd_rd_wr.sv"
  // Enironment 
  `include "env.sv"
  // Tests
 
  `include "ahb_2_apb_base_test.sv"
  `include "single_write_test.sv"
  `include "single_read_test.sv"
  `include "single_rnd_rd_wr_test.sv"
  `include "incr_4_test.sv"
  `include "incr_8_test.sv"
  `include "incr_16_test.sv"
  `include "incr_undefined_test.sv"
  `include "slave_error_test.sv"
  `include "wrap_4_test.sv"
  `include "wrap_8_test.sv"
  `include "wrap_16_test.sv"

endpackage 


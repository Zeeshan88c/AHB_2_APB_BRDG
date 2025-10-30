`timescale 1ns/1ns
module tb_ahb2apb;

import uvm_pkg::*;
  `include "uvm_macros.svh"
  import ahb_2_apb_pkg::*;

  bit HCLK, HRESETn, PCLK, PRESETn, PCLKen;

  ahb_2_apb_intf ahb_vif(HCLK,HRESETn,PCLK, PCLKen, PRESETn); //handle instandiation for interface 

  nic400_ahb2apb DUT(
                      // Instance: u_cd_hclk, Port: ahb_slave
                      .HADDR_ahb_slave(ahb_vif.HADDR),
                      .HBURST_ahb_slave(ahb_vif.HBURST),
                      .HPROT_ahb_slave(ahb_vif.HPROT),
                      .HSIZE_ahb_slave(ahb_vif.HSIZE),
                      .HTRANS_ahb_slave(ahb_vif.HTRANS),
                      .HWDATA_ahb_slave(ahb_vif.HWDATA),
                      .HWRITE_ahb_slave(ahb_vif.HWRITE),
                      .HRDATA_ahb_slave(ahb_vif.HRDATA),
                      .HRESP_ahb_slave(ahb_vif.HRESP),
                      .HREADY_ahb_slave(ahb_vif.HREADY),  
                      // Instance: u_cd_pclk, Port: apb_master
                      .PADDR_apb_master(ahb_vif.PADDR),
                      .PSELx_apb_master(ahb_vif.PSEL),
                      .PENABLE_apb_master(ahb_vif.PENABLE),
                      .PWRITE_apb_master(ahb_vif.PWRITE),
                      .PRDATA_apb_master(ahb_vif.PRDATA),
                      .PWDATA_apb_master(ahb_vif.PWDATA),
                      .PPROT_apb_master(ahb_vif.PPROT),
                      .PSTRB_apb_master(ahb_vif.PSTRB),
                      .PREADY_apb_master(ahb_vif.PREADY),
                      .PSLVERR_apb_master(ahb_vif.PSLVERR),
                      // Non-bus signals
                      .hclkclk(HCLK),
                      .hclkresetn(HRESETn),
                      .pclkclk(PCLK),
                      .pclkclken(PCLKen),
                      .pclkresetn(PRESETn)
                    );
  // reset setting
  initial
  begin
    HRESETn=0;
    PRESETn=0;
    PCLKen=1;
    #30; 
    HRESETn=1;
    PRESETn=1;
  end
  // clocks for ahb and apb interfaces
  initial 
  begin 
    HCLK=0;
    PCLK=0;
    forever begin #10 HCLK=~HCLK; 
      PCLK=~PCLK;
    end
  end
  // setting interfaces in config DB to access in other components
  initial
  begin
    uvm_config_db#(virtual ahb_2_apb_intf)::set(null , "*", "vif", tb_ahb2apb.ahb_vif);
    uvm_config_int::set(null, "*","recording_detail",1);
    // run test specidied in command line
    run_test();
  end 

endmodule : tb_ahb2apb

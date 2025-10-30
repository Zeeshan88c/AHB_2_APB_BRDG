/////////////////////////////////////////////////////////////////////////////////
//
//  Filename      : scoreboard.sv
//  Author        : MR Zeeshan 
//  Creation Date : 12/01/2021
//
//  Description
//  ===========
//  Cuboid Scoreboard
////////////////////////////////////////////////////////////////////////////////

// Implementation ports macros
`uvm_analysis_imp_decl(_spkt)
`uvm_analysis_imp_decl(_rpkt)


class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  // Constructor Fucntion
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  // Implementation ports hanld
  uvm_analysis_imp_rpkt#(apb_seq_item,scoreboard) received;
  uvm_analysis_imp_spkt#(ahb_seq_item,scoreboard) expected;


  // Queue of seq item
  ahb_seq_item ahb_que[$];
  apb_seq_item apb_que[$];

  // seq item handles for epected and actual item
  ahb_seq_item actual,pkt;
  apb_seq_item actual_1, pkt_1;

  // uvm event
  uvm_event in_scb_evnt;

  // match, mismatch count variables
  int match = 0, mismatch = 0, mismatch_addr = 0, match_addr = 0;

  //coomon configuration
  common_config cmn_cfg;

  bit [31:0] temp_reg  ;
  bit [31:0] temp_reg_1;

  // ============================================
  // Create implementation ports in build phase
  // ============================================

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // instance if imp port
    received = new("received",this);
    expected = new("expected",this);

    actual = new("actual");
    actual_1 = new("actual_1");

    // uvm event instance
    in_scb_evnt = uvm_event_pool::get_global("ingr_scb_evnt");

  endfunction // build_phase

  // ===========================================
  // write function to push expecter data in que
  // ===========================================

  virtual function void write_spkt(ahb_seq_item sent);

    // Calculate expected Output that should be compared
    $cast(pkt,sent.clone());
    `uvm_info(get_type_name(),"Sent Packet Accessed",UVM_NONE)

    pkt.print();
    // Pushing the expected data in queue
    `uvm_info(get_type_name(),"Packet Pushed in Que",UVM_NONE)

    ahb_que.push_back(pkt);

  endfunction

  // =========================================
  // Popping data from que and then
  // Compare the data with Actual cuboid
  // =========================================
  virtual function void write_rpkt(apb_seq_item item);
    `uvm_info(get_type_name(), "DUT packet Accessed", UVM_MEDIUM);

    $cast(pkt_1, item.clone());
    `uvm_info(get_type_name(),"Sent Packet Accessed",UVM_NONE)

    item.print();
    // Pushing the expected data in queue
    `uvm_info(get_type_name(),"Packet Pushed in Que",UVM_NONE)

    apb_que.push_back(pkt_1);

  endfunction : write_rpkt

  // =========================================
  // Compare
  // =========================================
  virtual task compare_item_32(ahb_seq_item actual,apb_seq_item actual_1);

    //Compare of 8 bit or 1 byte
    if(actual.HSIZE == 0)begin
      if(actual.HWRITE)begin
        if(actual_1.PADDR != actual.HADDR) begin
          `uvm_error(get_type_name(), $sformatf("Address Mismatch: HADDR = %0h, PADDR = %0h", actual.HADDR, actual_1.PADDR))
          mismatch_addr++;
        end else begin
          `uvm_info(get_type_name(), $sformatf("Address Match: HADDR = %0h, PADDR = %0h",actual.HADDR, actual_1.PADDR ), UVM_LOW)
          match_addr++;
          // Compare extracted data
          if(actual_1.PREADY)begin
            if(actual_1.PSLVERR)begin
              `uvm_error(get_type_name(),"TRansaction failed as Response is error")
            end else begin
              if(actual.HADDR[2:0] == 3'b000)begin
                if (actual_1.PWDATA[7:0] == actual.HWDATA[7:0]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[7:0], actual.HWDATA[7:0]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[7:0], actual.HWDATA[7:0]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b001)begin
                if (actual_1.PWDATA[15:8] == actual.HWDATA[15:8]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[15:8], actual.HWDATA[15:8]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[15:8], actual.HWDATA[15:8]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b010)begin
                if (actual_1.PWDATA[23:16] == actual.HWDATA[23:16]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[23:16], actual.HWDATA[23:16]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[23:16], actual.HWDATA[23:16]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b011)begin
                if (actual_1.PWDATA[31:24] == actual.HWDATA[31:24]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h",actual_1.PWDATA[31:24], actual.HWDATA[31:24]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:24], actual.HWDATA[31:24]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b100)begin
                if (actual_1.PWDATA[7:0] == actual.HWDATA[39:32]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[7:0], actual.HWDATA[39:32]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h",  actual_1.PWDATA[7:0], actual.HWDATA[39:32]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b101)begin
                if (actual_1.PWDATA[15:8] == actual.HWDATA[47:40]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[15:8], actual.HWDATA[47:40]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h",  actual_1.PWDATA[15:8], actual.HWDATA[47:40]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b110)begin
                if (actual_1.PWDATA[23:16] == actual.HWDATA[55:48]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[23:16], actual.HWDATA[55:48]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[23:16], actual.HWDATA[55:48]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b111)begin
                if (actual_1.PWDATA[31:24] == actual.HWDATA[63:56]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h",actual_1.PWDATA[23:16], actual.HWDATA[63:56]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h",actual_1.PWDATA[31:24], actual.HWDATA[63:56]))
                  mismatch++;
                end
              end
            end
          end
        end
      end else begin
        if(actual_1.PADDR != actual.HADDR) begin
          `uvm_error(get_type_name(), $sformatf("Address Mismatch: HADDR = %0h, PADDR = %0h", actual.HADDR, actual_1.PADDR))
          mismatch_addr++;
        end else begin
          `uvm_info(get_type_name(), $sformatf("Address Match: HADDR = %0h, PADDR = %0h",actual.HADDR, actual_1.PADDR ), UVM_LOW)
          match_addr++;
          // Compare extracted data
          if(actual.HREADY)begin
            if(actual.HRESP)begin
              `uvm_error(get_type_name(),"TRansaction failed as Response is error")
            end else begin
              if(actual.HADDR[2:0] == 3'b000)begin
                if (actual_1.PRDATA[7:0] == actual.HRDATA[7:0]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[7:0], actual.HRDATA[7:0]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[7:0], actual.HRDATA[7:0]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b001)begin
                if (actual_1.PRDATA[15:8] == actual.HRDATA[15:8]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[15:8], actual.HRDATA[15:8]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[15:8], actual.HRDATA[15:8]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b010)begin
                if (actual_1.PRDATA[23:16] == actual.HRDATA[23:16]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[23:16], actual.HRDATA[23:16]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[23:16], actual.HRDATA[23:16]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b011)begin
                if (actual_1.PRDATA[31:24] == actual.HRDATA[31:24]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h",actual_1.PRDATA[31:24], actual.HRDATA[31:24]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:24], actual.HRDATA[31:24]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b100)begin
                if (actual_1.PRDATA[7:0] == actual.HRDATA[39:32]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[7:0], actual.HRDATA[39:32]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h",  actual_1.PRDATA[7:0], actual.HRDATA[39:32]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b101)begin
                if (actual_1.PRDATA[15:8] == actual.HRDATA[47:40]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[15:8], actual.HRDATA[47:40]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h",  actual_1.PRDATA[15:8], actual.HRDATA[47:40]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b110)begin
                if (actual_1.PRDATA[23:16] == actual.HRDATA[55:48]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[23:16], actual.HRDATA[55:48]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[23:16], actual.HRDATA[55:48]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b111)begin
                if (actual_1.PRDATA[31:24] == actual.HRDATA[63:56]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h",actual_1.PRDATA[23:16], actual.HRDATA[63:56]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h",actual_1.PRDATA[31:24], actual.HRDATA[63:56]))
                  mismatch++;
                end
              end
            end
          end
        end
      end
    end

    //Compare of 16 bit or 2 bytes
    if(actual.HSIZE == 1)begin
      if(actual.HWRITE)begin
        if(actual_1.PADDR != actual.HADDR) begin
          `uvm_error(get_type_name(), $sformatf("Address Mismatch: HADDR = %0h, PADDR = %0h", actual.HADDR, actual_1.PADDR))
          mismatch_addr++;
        end else begin
          `uvm_info(get_type_name(), $sformatf("Address Match: HADDR = %0h, PADDR = %0h",actual.HADDR, actual_1.PADDR ), UVM_LOW)
          match_addr++;
          // Compare extracted data
          if(actual_1.PREADY)begin
            if(actual_1.PSLVERR)begin
              `uvm_error(get_type_name(),"TRansaction failed as Response is error")
            end else begin
              if(actual.HADDR[2:0] == 3'b000)begin
                if (actual_1.PWDATA[15:0] == actual.HWDATA[15:0]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[15:0], actual.HWDATA[15:0]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[15:0], actual.HWDATA[15:0]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b010)begin
                if (actual_1.PWDATA[31:16] == actual.HWDATA[31:16]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:16], actual.HWDATA[31:16]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:16], actual.HWDATA[31:16]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b100)begin
                if (actual_1.PWDATA[15:0] == actual.HWDATA[47:32]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[15:0], actual.HWDATA[47:32]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[15:0], actual.HWDATA[47:32]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b110)begin
                if (actual_1.PWDATA[31:16] == actual.HWDATA[63:48]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:16], actual.HWDATA[63:48]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:16], actual.HWDATA[63:48]))
                  mismatch++;
                end
              end
            end
          end
        end
      end else begin
        if(actual_1.PADDR != actual.HADDR) begin
          `uvm_error(get_type_name(), $sformatf("Address Mismatch: HADDR = %0h, PADDR = %0h", actual.HADDR, actual_1.PADDR))
          mismatch_addr++;
        end else begin
          `uvm_info(get_type_name(), $sformatf("Address Match: HADDR = %0h, PADDR = %0h",actual.HADDR, actual_1.PADDR ), UVM_LOW)
          match_addr++;
          // Compare extracted data
          if(actual.HREADY)begin
            if(actual.HRESP)begin
              `uvm_error(get_type_name(),"TRansaction failed as Response is error")
            end else begin
              if(actual.HADDR[2:0] == 3'b000)begin
                if (actual_1.PRDATA[15:0] == actual.HRDATA[15:0]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[15:0], actual.HRDATA[15:0]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[15:0], actual.HRDATA[15:0]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b010)begin
                if (actual_1.PRDATA[31:16] == actual.HRDATA[31:16]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:16], actual.HRDATA[31:16]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:16], actual.HRDATA[31:16]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b100)begin
                if (actual_1.PRDATA[15:0] == actual.HRDATA[47:32]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[15:0], actual.HRDATA[47:32]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[15:0], actual.HRDATA[47:32]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b110)begin
                if (actual_1.PRDATA[31:16] == actual.HRDATA[63:48]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:16], actual.HRDATA[63:48]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:16], actual.HRDATA[63:48]))
                  mismatch++;
                end
              end
            end
          end
        end
      end
    end
    //Compare of 32 bit or 4 bytes
    if(actual.HSIZE == 2)begin
      if(actual.HWRITE)begin
        if(actual_1.PADDR != actual.HADDR) begin
          `uvm_error(get_type_name(), $sformatf("Address Mismatch: HADDR = %0h, PADDR = %0h", actual.HADDR, actual_1.PADDR))
          mismatch_addr++;
        end else begin
          `uvm_info(get_type_name(), $sformatf("Address Match: HADDR = %0h, PADDR = %0h",actual.HADDR, actual_1.PADDR ), UVM_LOW)
          match_addr++;
          // Compare extracted data
          if(actual_1.PREADY)begin
            if(actual_1.PSLVERR)begin
              `uvm_error(get_type_name(),"TRansaction failed as Response is error")
            end else begin
              if(actual.HADDR[2:0] == 3'b000)begin
                if (actual_1.PWDATA[31:0] == actual.HWDATA[31:0]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:0], actual.HWDATA[31:0]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:0], actual.HWDATA[31:0]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b100)begin
                if (actual_1.PWDATA[31:0] == actual.HWDATA[63:32]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:0], actual.HWDATA[63:32]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", actual_1.PWDATA[31:0], actual.HWDATA[63:32]))
                  mismatch++;
                end
              end
            end
          end
        end
      end else begin
        if(actual_1.PADDR != actual.HADDR) begin
          `uvm_error(get_type_name(), $sformatf("Address Mismatch: HADDR = %0h, PADDR = %0h", actual.HADDR, actual_1.PADDR))
          mismatch_addr++;
        end else begin
          `uvm_info(get_type_name(), $sformatf("Address Match: HADDR = %0h, PADDR = %0h",actual.HADDR, actual_1.PADDR ), UVM_LOW)
          match_addr++;
          // Compare extracted data
          if(actual.HREADY)begin
            if(actual.HRESP)begin
              `uvm_error(get_type_name(),"TRansaction failed as Response is error")
            end else begin
              if(actual.HADDR[2:0] == 3'b000)begin
                if (actual_1.PRDATA[31:0] == actual.HRDATA[31:0]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:0], actual.HRDATA[31:0]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:0], actual.HRDATA[31:0]))
                  mismatch++;
                end
              end else if(actual.HADDR[2:0] == 3'b100)begin
                if (actual_1.PRDATA[31:0] == actual.HRDATA[63:32]) begin
                  `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:0], actual.HRDATA[63:32]), UVM_LOW)
                  match++;
                end else begin
                  `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", actual_1.PRDATA[31:0], actual.HRDATA[63:32]))
                  mismatch++;
                end
              end
            end
          end
        end
      end
    end
  endtask : compare_item_32

  // ========================================
  // Compare 64 bit or 8 bytes
  // ========================================
  virtual task compare_item_64(ahb_seq_item actual, apb_seq_item actual_1, bit [31:0] temp_reg, bit [31:0] temp_reg_1);

    bit [63:0] pwdata;
    bit [63:0] prdata;

    if (actual_1.PADDR != actual.HADDR) begin
      `uvm_error(get_type_name(), $sformatf("Address Mismatch: HADDR = %0h, PADDR = %0h", actual.HADDR, actual_1.PADDR))
      mismatch_addr++;
    end else begin
      `uvm_info(get_type_name(), $sformatf("Address Match: HADDR = %0h, PADDR = %0h", actual.HADDR, actual_1.PADDR), UVM_LOW)
      match_addr++;

      if (actual_1.PREADY) begin
        if (actual_1.PSLVERR) begin
          `uvm_error(get_type_name(), "Transaction failed as APB response is error")
        end else begin
          if (actual.HWRITE) begin
            actual_1 = apb_que.pop_front();
            pwdata = {actual_1.PWDATA, temp_reg};
            if (pwdata == actual.HWDATA) begin
              `uvm_info(get_type_name(), $sformatf("Comparison Successful: PWDATA = %0h, Expected = %0h", pwdata, actual.HWDATA), UVM_LOW)
              match++;
            end else begin
              `uvm_error(get_type_name(), $sformatf("Mismatch: PWDATA = %0h, Expected = %0h", pwdata, actual.HWDATA))
              mismatch++;
            end
          end else begin  // Read case
            if (actual.HRESP) begin
              `uvm_error(get_type_name(), "Transaction failed as AHB response is error")
            end else begin
              actual_1 = apb_que.pop_front();
              prdata = {actual_1.PRDATA, temp_reg_1};
              if (prdata == actual.HRDATA) begin
                `uvm_info(get_type_name(), $sformatf("Comparison Successful: PRDATA = %0h, Expected = %0h", prdata, actual.HRDATA), UVM_LOW)
                match++;
              end else begin
                `uvm_error(get_type_name(), $sformatf("Mismatch: PRDATA = %0h, Expected = %0h", prdata, actual.HRDATA))
                mismatch++;
              end
            end
          end
        end
      end
    end

  endtask

  // ========================================
  // Run phase
  // ========================================
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(),"Run Phase Started",UVM_MEDIUM)

    forever begin
      wait(ahb_que.size() > 0 && apb_que.size() > 0);

      actual = ahb_que[0];
      actual_1 = apb_que[0];

      if (actual.HTRANS == 2'b10 || actual.HTRANS == 2'b11) begin  // NONSEQ or SEQ

        if (actual.HSIZE == 3) begin // 64-bit transfer (2 APB accesses)
          if (apb_que.size() >= 2) begin
            actual = ahb_que.pop_front();
            actual_1 = apb_que.pop_front();

            temp_reg   = actual_1.PWDATA;
            temp_reg_1 = actual_1.PRDATA;

            compare_item_64(actual, actual_1, temp_reg, temp_reg_1);
          end else begin
            #1ns;
          end
        end else begin // 32-bit transfer
          actual = ahb_que.pop_front();
          actual_1 = apb_que.pop_front();
          compare_item_32(actual, actual_1);
        end

      end else begin
        `uvm_warning(get_type_name(), $sformatf("Unexpected HTRANS = %b", actual.HTRANS))
        ahb_que.pop_front();
      end
    end
  endtask

  // ========================================
  // Main Phase Task
  // ========================================
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    // wait till match, mismatch count equals the no of packets sent
    `uvm_info(get_type_name(),"Main Phase Started",UVM_MEDIUM)

    if(!(uvm_config_db#(common_config)::get(null, "*", "cmn_cfg",cmn_cfg )))begin
      `uvm_fatal("Sequence", "Failed to get config")
    end

    //transx = cmn_cfg.A2B_cfg.int_trans;
    //no. of packets sent is equal to transx)

    wait(((match+mismatch)==cmn_cfg.A2B_cfg.num_tsnx_val));
    // trigger uvm event
    in_scb_evnt.trigger();
    `uvm_info(get_type_name(),"Main Phase Ended ...",UVM_MEDIUM)
  endtask // main_phase


  virtual function void report_phase (uvm_phase phase);
    //display no of matches and mismatches
    `uvm_info(get_type_name(), $sformatf("No. of matches : %0d \t No.of Mismatches : %0d",match,mismatch), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("No. of matches address : %0d \t No.of Mismatches address : %0d",match_addr,mismatch_addr), UVM_NONE)
  endfunction // report_phase

endclass// scoreboard

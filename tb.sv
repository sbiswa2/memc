/*-----------------------------------------------------------------------------
* AUthor: Sujoy Biswas
* Date: 28/05/2018
* ---------------------------------------------------------------------------*/

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "tb_macros.svh"
`include "dut_pkg.sv"
`include "dut_ifc_t.sv"

import dut_pkg::*;

/*-----------------------------------------------------------------------------
-----------------------------------------------------------------------------*/
class seq_item extends uvm_sequence_item;
  rand addr_t addr;
  rand data_t data;
  rand cmd_t  cmd;
  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_enum(cmd_t, cmd, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name="seq_item", uvm_component parent=null);
  endfunction

  constraint c_addr{
    addr < 25000;
  }

  constraint c_data{
    data < 1000;
    data > 0;
  }
endclass

/*-----------------------------------------------------------------------------
-----------------------------------------------------------------------------*/
class base_seq extends uvm_sequence#(seq_item);
  `REGISTER_OBJECT(base_seq)
  `CONSTRUCT_OBJECT("base_seq")
  seq_item item;

  virtual task body();
    `CREATE_OBJECT(seq_item, item)
    `uvm_do(item)
    item.print();
  endtask
endclass

/*-----------------------------------------------------------------------------
-----------------------------------------------------------------------------*/
class sequencer extends uvm_sequencer;
  `uvm_sequencer_utils(sequencer)
  `CONSTRUCT_COMPONENT("sequencer", null)
endclass

class test_0 extends uvm_test;
  `REGISTER_COMPONENT(test_0)
  `CONSTRUCT_COMPONENT("test_0",null)
  base_seq  seq;
  sequencer seqr;
  seq_item  item;
  virtual dut_ifc_t vif;

  function void build_phase(uvm_phase phase);
  	super.build_phase(phase);
    `CREATE_OBJECT(base_seq, seq)
    `CREATE_COMPONENT(sequencer, seqr)
    uvm_config_db#(virtual dut_ifc_t)::get(this,"","vif",vif);
    item = new();
  endfunction

  virtual task drive_vif(seq_item item);
    vif.req  = 1'b1;
    vif.data = item.data;
    vif.addr = item.addr;
  endtask 

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info(get_type_name(),"Hello World",UVM_NONE)
    repeat(100) begin
      @(posedge vif.clk);
      item.randomize();
      item.print();
      seq.start(seqr);
    end
    phase.drop_objection(this);
  endtask
endclass

/*-----------------------------------------------------------------------------
-----------------------------------------------------------------------------*/
module clk_rst_gen(
  output logic clk,
  output logic rst_n
  );

  initial begin: clk_generator
  	clk = 1'b0;
  	forever begin
  	  #5 clk = ~clk;
  	end
  end

  initial begin: reset_generator
  	rst_n = 1'b0;
  	#10  rst_n = 1'b1;
  	#100 rst_n = 1'b0;
  end // initial
endmodule

/*-----------------------------------------------------------------------------
-----------------------------------------------------------------------------*/
module tb();
  logic clk;
  logic rst_n;

  dut_ifc_t dut_ifc(clk, rst_n);
  clk_rst_gen ccr(clk, rst_n);

  initial begin
    run_test("test_0");
  end

  initial begin
    uvm_config_db#(virtual dut_ifc_t)::set(uvm_root::get(),"*","vif",dut_ifc);
  end
endmodule

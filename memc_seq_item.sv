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
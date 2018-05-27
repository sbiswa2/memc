`define CONSTRUCT_COMPONENT(name_str, parent_comp) \
  function new(string name = name_str, uvm_component parent=parent_comp); \
	  super.new(name, parent); \
  endfunction 
`define CONSTRUCT_OBJECT(name_str) \
  function new(string name = name_str); \
	  super.new(name); \
  endfunction 
`define REGISTER_COMPONENT(component) \
  `uvm_component_utils(component)
`define REGISTER_OBJECT(object) \
  `uvm_object_utils(object)
`define CREATE_OBJECT(o_type, o_name) \
  o_name = o_type::type_id::create("o_name");
`define CREATE_COMPONENT(o_type, o_name) \
  o_name = o_type::type_id::create("o_name", this);

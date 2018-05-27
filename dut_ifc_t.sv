interface dut_ifc_t(input logic clk, input logic rst_n);
	addr_t addr;
    data_t data;
	cmd_t  cmd;
	logic  req;
	logic  hold;
	logic  valid;
endinterface
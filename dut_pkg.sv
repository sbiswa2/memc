package dut_pkg;
  parameter ADDR_WIDTH = 32;
  parameter DATA_WIDTH = 256;
  typedef logic [ADDR_WIDTH-1:0]addr_t;
  typedef logic [DATA_WIDTH-1:0]data_t;
  typedef enum  {READ=0, WRITE=1} cmd_t;
endpackage

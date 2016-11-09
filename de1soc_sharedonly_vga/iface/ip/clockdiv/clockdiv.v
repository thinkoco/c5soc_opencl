module clockdiv
#( parameter DIV=2 )
(
   input clk,
   output div_clk
);

localparam LOG2DIV = $clog2(DIV);

reg [ LOG2DIV - 1 : 0 ] count;
initial
  count = 0;
always @(posedge clk)
  count <= count + 'b01;

assign div_clk = count[LOG2DIV-1];

endmodule

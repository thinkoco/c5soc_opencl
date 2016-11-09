module global_routing
(
   input s,
   output g
);

GLOBAL cal_clk_gbuf (.in(s), .out(g));

endmodule

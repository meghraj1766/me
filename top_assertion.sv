`ifndef ASSERTION_SV
`define ASSERTION_SV

`define deglitcher_asrt(__ID,__DEGL_NAME,__CLK,__RST,__DIN,__DOUT,__NMIN,__NMAX) \
logic __s__``__DIN;\
always@(posedge __DIN or negedge __DIN or posedge __CLK ) \
if (__DIN===1'b0) \
__s__``__DIN<=1'b0;\
else if (__DIN===1'b1) \
__s__``__DIN<=1'b1; \
else __s__``__DIN<=__DIN;\
asrt_``__ID``_``__DEGL_NAME``_nmin:assert property(prop_deglitch_dout_nmin(__CLK,__RST,__s__``__DIN,__DOUT,__NMIN));\
asrt_``__ID``_``__DEGL_NAME``_nmax:assert property(prop_deglitch_dout_nmax(__CLK,__RST,__s__``__DIN,__DOUT,__NMAX));\


`endif

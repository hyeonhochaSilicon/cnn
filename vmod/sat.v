module sat
(
 input      signed [18:0] i_bit19,
 output reg signed [15:0] o_bit16
);

always @(*)
begin
  if(i_bit19 >= 32767)
	o_bit16 = 32767;
  else if(i_bit19 <= -32768)
	o_bit16 = -32768;
  else
    o_bit16 = i_bit19;
end

endmodule

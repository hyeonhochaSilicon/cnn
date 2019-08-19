module delay27
#(parameter N = 16, D = 27)
(
 input                 iCLK,
 input                 iRSTn,
 input  signed [N-1:0] iData,
 output signed [N-1:0] oData
);

wire [N-1:0] data_arr [0:D];

assign data_arr[0] = iData;
genvar i;
generate for(i=0; i<D; i=i+1) begin:gen_dff
dff #(N) u_dff
(
 .iCLK  (iCLK),
 .iRSTn (iRSTn),
 .iD    (data_arr[i]),
 .oQ    (data_arr[i+1])
);
end
endgenerate

assign oData = data_arr[D];

endmodule

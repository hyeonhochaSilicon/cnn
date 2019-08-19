module pe
#(parameter                  BW1=16, BW2=16)
(
 input                       iCLK,
 input                       iRSTn,
 input      signed [7:0]     iX,
 input      signed [7:0]     iW,
 input      signed [BW1-1:0] iPsume,
 output reg signed [BW2-1:0] oPsume
);

 wire signed [15:0] sum;
 
 assign sum = (iX * iW) + iPsume;

 always @(posedge iCLK, negedge iRSTn) 
 begin
   if(!iRSTn)
     oPsume <= 0;
   else
     oPsume <= sum;
 end
endmodule
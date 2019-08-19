module weightR
(
 input                    iCLK,
 input                    iRSTn,
 input                    iWren,
 input             [4:0]  iADDR,
 input             [31:0] iWeight,
 output reg signed [31:0] w1,  w2,  w3,  w4,  w5,  w6,  w7,  w8,  w9,  w10,
                          w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, 
                          w21, w22, w23, w24, w25
);

//1
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w1 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd0)
    w1 <= iWeight;
end

//2
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w2 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd1)
    w2 <= iWeight;
end

//3
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w3 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd2)
    w3 <= iWeight;
end

//4
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w4 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd3)
    w4 <= iWeight;
end

//5
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w5 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd4)
    w5 <= iWeight;
end

//6
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w6 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd5)
    w6 <= iWeight;
end

//7
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w7 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd6)
    w7 <= iWeight;
end

//8
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w8 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd7)
    w8 <= iWeight;
end

//9
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w9 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd8)
    w9 <= iWeight;
end

//10
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w10 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd9)
    w10 <= iWeight;
end

//11
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w11 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd10)
    w11 <= iWeight;
end

//12
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w12 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd11)
    w12 <= iWeight;
end

//13
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w13 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd12)
    w13 <= iWeight;
end


//14
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w14 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd13)
    w14 <= iWeight;
end

//15
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w15 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd14)
    w15 <= iWeight;
end

//16
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w16 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd15)
    w16 <= iWeight;
end

//17
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w17 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd16)
    w17 <= iWeight;
end

//18
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w18 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd17)
    w18 <= iWeight;
end

//19
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w19 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd18)
    w19 <= iWeight;
end

//20
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w20 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd19)
    w20 <= iWeight;
end

//21
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w21 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd20)
    w21 <= iWeight;
end

//22
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w22 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd21)
    w22 <= iWeight;
end

//23
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w23 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd22)
    w23 <= iWeight;
end

//24
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w24 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd23)
    w24 <= iWeight;
end

//25
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w25 <= 8'd0;
  else if(iWren == 1'b1 && iADDR == 5'd24)
    w25 <= iWeight;
end

endmodule

module control
#(parameter XS = 32, WS = 5, STRIDE = 1)
(
 input          iCLK,
 input          iRSTn,
 input          iValid,
 output     reg oValid
);

localparam   col_end = 31;
reg          w_iValid;
reg [4:0]    i, j;
reg [4:0]    col_next;
reg [4:0]    row_next;

//delay iValid 1clock
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	w_iValid <= 1'b0;
  else
    w_iValid <= iValid;
end

//column index
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	j <= 0;
  else if(j == XS-1)
	j <= 0;
  else if(w_iValid == 1'b1)
	j <= j + 1;
end

//row index
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	i <= 0;
  else if(j == XS-1 && i == XS-1)
    i <= 0;
  else if(j == 5'd31)
    i <= i + 1;
end

//column
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
    col_next <= WS-1;
  else if(i == row_next && j == col_next)
    if(j == XS-1)
	  col_next <= WS-1;
	else
	  col_next <= col_next + STRIDE;
end

//row_next
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	row_next <= WS-1;
  else if ( (i == row_next) && (j == col_next) && (j == 31) )
    if(i == XS-1)
	  row_next <= WS-1;
	else
	  row_next <= row_next + STRIDE;
end

//oValid
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
	oValid <= 1'b0;
  else if(i==row_next && j==col_next && w_iValid)
    oValid <= 1'b1;
  else
    oValid <= 1'b0;
end


endmodule

module tb_conv5x5HW #(parameter BW1=16, BW2=19);

reg                   iCLK,iRSTn,iWren,iValid;
reg         [4:0]     iADDR;
reg signed  [7:0]     iX,iW;
wire                  oValid;
wire signed [BW1-1:0] oY;

convolution #(BW1,BW2) conv5x5_0(
		.iCLK(iCLK),
		.iRSTn(iRSTn),
		.iWren(iWren),
		.iValid(iValid),
		.iADDR(iADDR),
		.iX(iX),
		.iW(iW),
		.oValid(oValid),
		.oY(oY));

always #5 iCLK=~iCLK;

integer fidxIn,fidwIn,fidOut,fidCmp;
integer rdxIn,rdwIn,rdOut,refOut;
integer index_w,index_x,index;
integer cycle,count;
reg signed [7:0] w[0:5*5*6-1];
reg signed [7:0] x[0:32*32-1];

initial
begin
 iCLK=0;
 iRSTn=0;
 iWren=0;
 iValid=0;
 iADDR=0;
 iX=0;
 iW=0;
 fidxIn=0;
 fidwIn=0;
 fidOut=0;
 fidCmp=0;
 rdxIn=0;
 rdwIn=0;
 rdOut=0;
 refOut=0;
 index=0;
 index_x=0;
 index_w=0;
 cycle=0;
 count=0;
 for(count=0;count<1024;count=count+1) begin
  x[count]=0;
 end
 for(count=0;count<150;count=count+1) begin
  w[count]=0;
 end
/*
 fidxIn=$fopen("../testvector/x_in_1s.dat","r");
 fidwIn=$fopen("../testvector/w_in_1s.dat","r");
 fidOut=$fopen("../testvector/y_ref_1s.dat","r");
 fidCmp=$fopen("../testvector/y_out_cmp_1s.dat","w");
*/
 
 fidxIn=$fopen("x_in_1s.dat","r");
 fidwIn=$fopen("w_in_1s.dat","r");
 fidOut=$fopen("y_ref_1s.dat","r");
 fidCmp=$fopen("y_out_cmp_1s.dat","w");

 @(posedge iCLK);
 #1 iRSTn=1;

 @(posedge iCLK);
 while(!$feof(fidxIn))	begin
		#1	rdxIn=$fscanf(fidxIn,"%d\n",x[index_x]);
			index_x=index_x+1;		
 end
 while(!$feof(fidwIn))	begin
	#1	rdwIn=$fscanf(fidwIn,"%d\n",w[index_w]);
		index_w=index_w+1;
 end

 @(posedge iCLK);
 #1 iValid=1;
 for(cycle=0;cycle<6;cycle=cycle+1)begin
	for(count=0;count<1024;count=count+1)begin
		#1 iX=x[count];
	    if(count<25) begin
		   iWren=1;
		   iADDR=count;
		   iW=w[(cycle*25)+count];
		end
		else begin
		   iWren=0;
		   iADDR=0;
		   iW=0;
	    end
		@(posedge iCLK);
	end
 end
 #1 iValid=0;

 repeat (100) @(posedge iCLK);
 $fclose(fidxIn);
 $fclose(fidwIn);
 $fclose(fidOut);
 $fclose(fidCmp);
 $stop;
end

always @ (posedge iCLK) begin
	if(oValid) begin
		rdOut=$fscanf(fidOut,"%d\n",refOut);
		if(oY==refOut)
			$fwrite(fidCmp,"%0d(ns):SmpNum=%2d,OK:RTL=%d, REF=%d\n",$time,index,oY,refOut);
		else
			$fwrite(fidCmp,"%0d(ns):SmpNum=%2d,Error:RTL=%d, REF=%d\n",$time,index,oY,refOut);
		index = index+1;
	end
end
endmodule

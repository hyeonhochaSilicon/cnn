module convolution
#(parameter BW1 = 16, 
            BW2 = 19,
            ADDR_WIDTH = 12,
            DATA_WIDTH = 32,
            WEA_WIDTH = 4,
            WEIGHT_READ_BASEADDR = 0x43c02FFC
)
(
 input                        iCLK,                          //connect master clock
 input                        iRSTn,                         //connect master reset
 input       signed [7:0]     iX,                            //connect blk_mem - input_data  <- state machine 1
 input       signed [31:0]    iW,                            //connect blk_mem - kernel_data <- state machine 2
 input                        iWren,                         //connect enable                <- state machine 3
 input              [4:0]     iADDR,                         //connect blk_mem               <- state machine 4
 input                        iValid,
 output      signed [15:0]    oY,
 output                       oValid,

 //connect AXI
 input CONV_START,

 //connect BLOCK MEMORY
 output wire [ADDR_WIDTH-1:2] conv_to_blk_addr,
 output wire [DATA_WIDTH-1:0] conv_to_blk_wdata,
 input  wire [DATA_WIDTH-1:0] blk_to_conv_rdata,
 output reg                   conv_to_blk_enable,
 output wire [WEA_WIDTH-1:0]  conv_to_blk_wenable
 
)
/*******************************************LOAD DATA(BLK_MEMORY to CONV)*******************************************************/

//CONV_START_DELAY
reg CONV_START_DELAY;
always
begin
  if(!iRSTn)
    CONV_START_DELAY <= 1'b0;
  else
    CONV_START_DELAY <= CONV_START;
end

//LOAD_START, CONV_START == 1 and CONV_START_DELAY == 0
reg LOAD_START;
always (*)
begin
  if(CONV_START == 1'b1 && CONV_START_DELAY == 1'b0)
    LOAD_START = 1'b1;
  else
    LOAD_START = 1'b0;
end

//DATA_LOAD_ENABLE, HIGH = LOAD_START, -> LOW = weight_load_counter(23)
//                                     -> LOW = input_load_counter()
//acvitve: conv_to_blk_enable and weight_load_counter simultaneously
reg DATA_LOAD_ENABLE;
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
    DATA_LOAD_ENABLE = 1'b0;
  else if(LOAD_START == 1'b1;
    DATA_LOAD_ENABLE = 1'b1;
  else if(weight_load_counter == 5'h23)
    DATA_LOAD_ENABLE = 1'b0;
  else if(input_load_counter = )
    DATA_LOAD_ENABLE = 1'b0;
end

//conv_to_blk_enable
//DATA_LOAD_ENABLE -> dff -> conv_to_blk_enable
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
    conv_to_blk_enable <= 1'b0;
  else
    conv_to_blk_enable <= DATA_LOAD_ENABLE;
end

//weight_read_counter, START: DATA_LOAD_ENABLE, END: 1~25
reg [4:0] weight_load_counter;
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
    weight_read_counter <= 5'h0;
  else if(DATA_LOAD_ENABLE == 1'b1)
    weight_read_counter <= weight_read_counter + 5'h1;
end

//weight_read_addr, ACTIVE: 1 <= weight_read_counter <= 25
wire [ADDR_WIDTH-1:0] weight_load_addr;
always (*)
  weight_read_addr = WEIGHT_READ_BASEADDR;  //0x43c02FFC
begin
  if( (weight_read_counter >= 5'h1) && (weight_read_counter <= 5'h25) )
    weight_read_addr = (WEIGHT_READ_BASEADDR + (weight_load_counter << 2));
end

//port: conv_to_blk_addr[11:2] <- (1 <= weight_read_counter <= 25), weight_read_counter[11:0]
//                             <- (1 <= input_read_counter <= 25),  input_read_counter[11:0]
assign conv_to_blk_addr[11:2] = ((weight_read_counter >= 5'h1) && (weight_read_counter <= 5'h25)) ? weight_read_addr :
                                ((input_read_counter >= 5'h1)  && (input_read_counter <= 5'h25))  ? input_read_addr : 0;
/**************************************************************************************************/
reg signed [7:0] oX;
always @(posedge iCLK, negedge iRSTn)
begin
  if(!iRSTn)
    oX <= 8'd0;
  else
    oX <= iX;
end
/**************************************************************************************************/
wire signed [7:0] w1,  w2,  w3,  w4,  w5,  w6,  w7,  w8,  w9,  w10,
                  w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, 
                  w21, w22, w23, w24, w25;
weightR wei(
            .iCLK(iCLK), .iRSTn(iRSTn), .iWren(iWren), .iADDR(counter), .iWeight(iW), 
            .w1(w1),   .w2(w2),   .w3(w3),   .w4(w4),   .w5(w5),   .w6(w6),   .w7(w7),   .w8(w8),   .w9(w9),   .w10(w10), 
            .w11(w11), .w12(w12), .w13(w13), .w14(w14), .w15(w15), .w16(w16), .w17(w17), .w18(w18), .w19(w19), .w20(w20), 
            .w21(w21), .w22(w22), .w23(w23), .w24(w24), .w25(w25) 
           );

/**************************************************************************************************/
wire signed [16:0] pgrep1; 
wire signed [16:0] pgrep2; 
wire signed [17:0] pgrep3; 
wire signed [17:0] pgrep4;
wire signed [18:0] pgrep5;

pe #(16,17) m0(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w1), .iPsume(16'd0),  .oPsume(pgrep1));
pe #(17,17) m1(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w2), .iPsume(pgrep1), .oPsume(pgrep2));
pe #(17,18) m2(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w3), .iPsume(pgrep2), .oPsume(pgrep3));
pe #(18,18) m3(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w4), .iPsume(pgrep3), .oPsume(pgrep4));
pe #(18,19) m4(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w5), .iPsume(pgrep4), .oPsume(pgrep5));

wire signed [15:0] sat_out0;
sat sm0(.i_bit19(pgrep5), .o_bit16(sat_out0));

wire signed [15:0] o_stage0;
delay27 stage0(.iCLK(iCLK), .iRSTn(iRSTn), .iData(sat_out0), .oData(o_stage0));
/**************************************************************************************************/
wire signed [16:0] pgrep6;
wire signed [16:0] pgrep7;
wire signed [17:0] pgrep8;
wire signed [17:0] pgrep9;
wire signed [18:0] pgrep10;

pe #(16,17) m5(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w6), .iPsume(o_stage0), .oPsume(pgrep6));
pe #(17,17) m6(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w7), .iPsume(pgrep6),   .oPsume(pgrep7));
pe #(17,18) m7(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w8), .iPsume(pgrep7),   .oPsume(pgrep8));
pe #(18,18) m8(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w9), .iPsume(pgrep8),   .oPsume(pgrep9));
pe #(18,19) m9(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w10), .iPsume(pgrep9),   .oPsume(pgrep10));

wire signed [15:0] sat_out1;
sat sm1(.i_bit19(pgrep10), .o_bit16(sat_out1));

wire signed [15:0] o_stage1;
delay27 stage1(.iCLK(iCLK), .iRSTn(iRSTn), .iData(sat_out1), .oData(o_stage1));
/**************************************************************************************************/
wire signed [16:0] pgrep11;
wire signed [16:0] pgrep12;
wire signed [17:0] pgrep13;
wire signed [17:0] pgrep14;
wire signed [18:0] pgrep15;

pe #(16,17) m10(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w11), .iPsume(o_stage1), .oPsume(pgrep11));
pe #(17,17) m11(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w12), .iPsume(pgrep11),  .oPsume(pgrep12));
pe #(17,18) m12(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w13), .iPsume(pgrep12),  .oPsume(pgrep13));
pe #(18,18) m13(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w14), .iPsume(pgrep13),  .oPsume(pgrep14));
pe #(18,19) m14(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w15), .iPsume(pgrep14),  .oPsume(pgrep15));

wire signed [15:0] sat_out2;
sat sm2(.i_bit19(pgrep15), .o_bit16(sat_out2));

wire signed [15:0] o_stage2;
delay27 stage2(.iCLK(iCLK), .iRSTn(iRSTn), .iData(sat_out2), .oData(o_stage2));
/**************************************************************************************************/
wire signed [16:0] pgrep16;
wire signed [16:0] pgrep17;
wire signed [17:0] pgrep18;
wire signed [17:0] pgrep19;
wire signed [18:0] pgrep20;

pe #(16,17) m15(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w16), .iPsume(o_stage2), .oPsume(pgrep16));
pe #(17,17) m16(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w17), .iPsume(pgrep16),  .oPsume(pgrep17));
pe #(17,18) m17(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w18), .iPsume(pgrep17),  .oPsume(pgrep18));
pe #(18,18) m18(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w19), .iPsume(pgrep18),  .oPsume(pgrep19));
pe #(18,19) m19(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w20), .iPsume(pgrep19),  .oPsume(pgrep20));

wire signed [15:0] sat_out3;
sat sm3(.i_bit19(pgrep20), .o_bit16(sat_out3));

wire signed [15:0] o_stage3;
delay27 stage3(.iCLK(iCLK), .iRSTn(iRSTn), .iData(sat_out3), .oData(o_stage3));
/**************************************************************************************************/
wire signed [16:0] pgrep21;
wire signed [16:0] pgrep22;
wire signed [17:0] pgrep23;
wire signed [17:0] pgrep24;
wire signed [18:0] pgrep25;

pe #(16,17) m21(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w21), .iPsume(o_stage3), .oPsume(pgrep21));
pe #(17,17) m22(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w22), .iPsume(pgrep21),  .oPsume(pgrep22));
pe #(17,18) m23(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w23), .iPsume(pgrep22),  .oPsume(pgrep23));
pe #(18,18) m24(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w24), .iPsume(pgrep23),  .oPsume(pgrep24));
pe #(18,19) m25(.iCLK(iCLK), .iRSTn(iRSTn), .iX(oX), .iW(w25), .iPsume(pgrep24),  .oPsume(pgrep25));

wire signed [15:0] sat_out4;
sat sm4(.i_bit19(pgrep25), .o_bit16(sat_out4));

assign oY = sat_out4;
/**************************************************************************************************/
control m(.iCLK(iCLK), .iRSTn(iRSTn), .iValid(iValid), .oValid(oValid));
/**************************************************************************************************/
endmodule

module alsu_SVA (
    input  clk,
    input logic signed [2:0] A, B,
    input logic cin, serial_in, red_op_A, red_op_B,
    input [2:0] opcode,
    input logic bypass_A, bypass_B, rst, direction,
    input logic signed [15:0] leds,
    input logic signed [5:0] out
);

	parameter INPUT_PRIORITY = "A";
	parameter FULL_ADDER = "ON";

	wire invalid_red_op, invalid_opcode, invalid;

	assign invalid_red_op = (red_op_A | red_op_B) & (opcode[1] | opcode[2]);
	assign invalid_opcode = opcode[1] & opcode[2];
	assign invalid = invalid_red_op | invalid_opcode;

	property p_1;
    	@(posedge clk) disable iff (rst) invalid |-> ##2 (leds == (~$past(leds)));
	endproperty

	property p_2;
   		@(posedge clk) disable iff (rst) invalid |-> ##2 (out == 6'b0);
	endproperty

	property p_3;
   		@(posedge clk) disable iff (rst)
        	(bypass_A && bypass_B && !invalid) |-> ##2(out == ((INPUT_PRIORITY == "A") ? $past(A,2) : $past(B,2)));
	endproperty

	property p_4;
   		@(posedge clk) disable iff (rst)
        	(bypass_A && !bypass_B && !invalid) |-> ##2 (out == $past(A,2));
	endproperty

	property p_5;
   		@(posedge clk) disable iff (rst)
        	(bypass_B && !bypass_A && !invalid) |-> ##2 (out == $past(B,2));
	endproperty

	property p_6;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h0 && !invalid && !bypass_A && !bypass_B && red_op_A && red_op_B) |-> ##2 (out == ((INPUT_PRIORITY == "A") ? |$past(A,2) : |$past(B,2)));
	endproperty

	property p_7;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h0 && !invalid && !bypass_A && !bypass_B && red_op_A && !red_op_B) |-> ##2 (out == |$past(A,2));
	endproperty

	property p_8;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h0 && !invalid && !bypass_A && !bypass_B && !red_op_A && red_op_B) |-> ##2 (out == |$past(B,2));
	endproperty

	property p_9;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h0 && !invalid && !bypass_A && !bypass_B && !red_op_A && !red_op_B) |-> ##2 (out == ($past(B,2) | $past(A,2)));
	endproperty

	property p_A;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h1 && !invalid && !bypass_A && !bypass_B && red_op_A && red_op_B) |-> ##2 (out == ((INPUT_PRIORITY == "A") ? ^$past(A,2) : ^$past(B,2)));
	endproperty

	property p_B;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h1 && !invalid && !bypass_A && !bypass_B && red_op_A && !red_op_B) |-> ##2 (out == ^$past(A,2));
	endproperty

	property p_C;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h1 && !invalid && !bypass_A && !bypass_B && !red_op_A && red_op_B) |-> ##2 (out == ^$past(B,2));
	endproperty

	property p_D;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h1 && !invalid && !bypass_A && !bypass_B && !red_op_A && !red_op_B) |-> ##2 (out == ($past(B,2) ^ $past(A,2)));
	endproperty


	property p_E;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h2 && !invalid && !bypass_A && !bypass_B) |-> ##2 (out == ((FULL_ADDER == "ON") ? ($past(A,2) + $past(B,2) + $past(cin,2)) : ($past(A,2) + $past(B,2))));
	endproperty

	property p_F;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h3 && !invalid && !bypass_A && !bypass_B) |-> ##2 (out == $past(A,2) * $past(B,2));
	endproperty

	property p_G;
    	@(posedge clk) disable iff (rst)
    		(opcode == 3'h4 && !invalid && !bypass_A && !bypass_B && direction) |-> ##2 (out == ({$past(out[4:0]), $past(serial_in,2)}));


        	//(opcode == 3'h4 && !invalid && !bypass_A && !bypass_B) |-> ##2 (out == ((direction) ? ({$past(out[4:0],1), $past(serial_in,1)}) :
        	//																					  ({$past(serial_in,1), $past(out[5:1],1)}))); 
	endproperty

	property p_H;
    	@(posedge clk) disable iff (rst)
    		(opcode == 3'h4 && !invalid && !bypass_A && !bypass_B && !direction) |-> ##2 (out == ({$past(serial_in,2), $past(out[5:1])}));
	endproperty

	property p_I;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h5 && !invalid && !bypass_A && !bypass_B && direction) |-> ##2 (out == ({$past(out[4:0]), $past(out[5])}));     																						
	endproperty

	property p_J;
    	@(posedge clk) disable iff (rst)
        	(opcode == 3'h5 && !invalid && !bypass_A && !bypass_B && !direction) |-> ##2 (out == ({$past(out[0]), $past(out[5:1])}));
	endproperty




		AP: assert property (p_1) else $display("p_1 failed");
		BP: assert property (p_2) else $display("p_2 failed");
		CP: assert property (p_3) else $display("p_3 failed");
		DP: assert property (p_4) else $display("p_4 failed");
		EP: assert property (p_5) else $display("p_5 failed");
		FP: assert property (p_6) else $display("p_6 failed");
		GP: assert property (p_7) else $display("p_7 failed");
		HP: assert property (p_8) else $display("p_8 failed");
		IP: assert property (p_9) else $display("p_9 failed");
		JP: assert property (p_A) else $display("p_A failed");
		KP: assert property (p_B) else $display("p_B failed");
		LP: assert property (p_C) else $display("p_C failed");
		MP: assert property (p_D) else $display("p_D failed");
		NP: assert property (p_E) else $display("p_E failed");
		OP: assert property (p_F) else $display("p_F failed");
		PP: assert property (p_G) else $display("p_G failed");
		QP: assert property (p_H) else $display("p_H failed");
		RP: assert property (p_I) else $display("p_I failed");
		SP: assert property (p_J) else $display("p_J failed");


		Ac: cover property (p_1)  $display("p_1 pass");
		Bc: cover property (p_2)  $display("p_2 pass");
		Cc: cover property (p_3)  $display("p_3 pass");
		Dc: cover property (p_4)  $display("p_4 pass");
		Ec: cover property (p_5)  $display("p_5 pass");
		Fc: cover property (p_6)  $display("p_6 pass");
		Gc: cover property (p_7)  $display("p_7 pass");
		Hc: cover property (p_8)  $display("p_8 pass");
		Ic: cover property (p_9)  $display("p_9 pass");
		Jc: cover property (p_A)  $display("p_A pass");
		Kc: cover property (p_B)  $display("p_B pass");
		Lc: cover property (p_C)  $display("p_C pass");
		Mc: cover property (p_D)  $display("p_D pass");
		Nc: cover property (p_E)  $display("p_E pass");
		Oc: cover property (p_F)  $display("p_F pass");
		Pc: cover property (p_G)  $display("p_G pass");
		Qc: cover property (p_H)  $display("p_H pass");
		Rc: cover property (p_I)  $display("p_I pass");
		Sc: cover property (p_J)  $display("p_J pass");


endmodule 
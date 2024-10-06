import alsu_test_pkg::*;
import alsu_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module top();
	bit clk;
	initial begin
		clk=1;
		forever 
			#1 clk=~clk;
	end

	alsu_if alsu_Vif (clk);
	ALSU #(.INPUT_PRIORITY(alsu_Vif.INPUT_PRIORITY), .FULL_ADDER(alsu_Vif.FULL_ADDER)) DUT (
		clk,
		alsu_Vif.A,
		alsu_Vif.B,
		alsu_Vif.cin,
		alsu_Vif.serial_in,
		alsu_Vif.red_op_A,
		alsu_Vif.red_op_B,
		alsu_Vif.opcode,
		alsu_Vif.bypass_A,
		alsu_Vif.bypass_B,
		alsu_Vif.rst,
		alsu_Vif.direction,
		alsu_Vif.leds,
		alsu_Vif.out);

	bind  ALSU alsu_SVA #(.INPUT_PRIORITY(alsu_Vif.INPUT_PRIORITY),.FULL_ADDER(alsu_Vif.FULL_ADDER)) m1 (
		clk,
		alsu_Vif.A,
		alsu_Vif.B,
		alsu_Vif.cin,
		alsu_Vif.serial_in,
		alsu_Vif.red_op_A,
		alsu_Vif.red_op_B,
		alsu_Vif.opcode,
		alsu_Vif.bypass_A,
		alsu_Vif.bypass_B,
		alsu_Vif.rst,
		alsu_Vif.direction,
		alsu_Vif.leds,
		alsu_Vif.out);

	initial begin
		uvm_config_db #(virtual alsu_if)::set(null, "uvm_test_top", "alsu_Vif", alsu_Vif);
		run_test("alsu_test");
	end

endmodule	
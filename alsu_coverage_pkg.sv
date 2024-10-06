package alsu_coverage_pkg;
	import uvm_pkg::*;
	import alsu_shared_pkg::*;
	import alsu_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class alsu_coverage extends uvm_component;
		`uvm_component_utils(alsu_coverage)
		uvm_analysis_export #(alsu_sequence_item) cov_export;
		uvm_tlm_analysis_fifo #(alsu_sequence_item) cov_fifo;
		alsu_sequence_item seq_item_cov;
	
		// Covergroups
		covergroup cvr_gp();

			A_cp: coverpoint seq_item_cov.A 
			{
				bins A_data_0 = {0};
				bins A_data_max = {MAXPOS};
				bins A_data_min = {MAXNEG};
				bins A_data_default = default;	
			}
			A_Walking: coverpoint seq_item_cov.A iff(seq_item_cov.red_op_A)
			{
				bins A_data_ones[] = {1,2,-4};
			}

			B_cp: coverpoint seq_item_cov.B 
			{
				bins B_data_0 = {0};
				bins B_data_max = {MAXPOS};
				bins B_data_min = {MAXNEG};
				bins B_data_default = default;	
			}
			B_Walking: coverpoint seq_item_cov.B iff(seq_item_cov.red_op_B & !seq_item_cov.red_op_A)
			{
				bins B_data_ones[] = {1,2,-4}; 
			}

			ALU_cvp: coverpoint seq_item_cov.opcode 
			{
				bins Bins_shift [] = {[SHIFT:ROTATE]};
				bins Bins_arith [] = {[ADD:MULT]};
				illegal_bins Bins_invalid [] = {[INVALID_6:INVALID_7]};
				bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
			}

			opcode_bitwise_cp: coverpoint seq_item_cov.opcode{
				bins bins_bitwise[] = {OR, XOR};
			}

			cross_ARITH_PERM: cross A_cp, B_cp, ALU_cvp{
				ignore_bins ig_bins_shift = binsof(ALU_cvp.Bins_shift);
				ignore_bins ig_bins_trans = binsof(ALU_cvp.Bins_trans);
			}


			cross_SHIFT_opcode: cross seq_item_cov.direction, ALU_cvp{
				ignore_bins ig_bins_all = !binsof(ALU_cvp.Bins_shift);		
			}

			cross_ARITH_CIN: cross seq_item_cov.cin, ALU_cvp{
				ignore_bins ig_bins_shift = binsof(ALU_cvp.Bins_shift);
				ignore_bins ig_bins_trans = binsof(ALU_cvp.Bins_trans);
			}
		
		endgroup 

		function new(string name = "alsu_coverage", uvm_component parent = null);
			super.new(name,parent);
			cvr_gp=new();
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export =new("cov_export",this);
			cov_fifo =new("cov_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item_cov);
				cvr_gp.sample();
			end
		endtask : run_phase


	endclass
endpackage
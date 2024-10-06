package alsu_main_sequence_pkg;
	import uvm_pkg::*;
	import alsu_sequence_item_pkg::*;
	`include "uvm_macros.svh"
	class alsu_main_sequence extends uvm_sequence #(alsu_sequence_item) ;
		`uvm_object_utils(alsu_main_sequence)

		alsu_sequence_item seq_item;

		function new(string name = "alsu_main_sequence");
			super.new(name);
		endfunction

		task body;
			repeat(10_000) begin
				seq_item=alsu_sequence_item::type_id::create("seq_item");
				start_item(seq_item);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body
	endclass	
endpackage
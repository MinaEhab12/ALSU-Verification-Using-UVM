package alsu_test_pkg;
	import alsu_env_pkg::*;
	import alsu_driver_pkg::*;
	import alsu_config_pkg::*;
	import alsu_main_sequence_pkg::*;
	import alsu_reset_sequence_pkg::*;
	import alsu_agent_pkg::*;
	
	import MySequencer_pkg::*;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	class alsu_test extends uvm_test ;
		`uvm_component_utils(alsu_test)

		alsu_env env;
		alsu_config alsu_cfg;
		virtual alsu_if alsu_Vif;
		alsu_reset_sequence reset_seq;
		alsu_main_sequence main_seq;

		function new(string name = "alsu_test", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env = alsu_env::type_id::create("env",this); 
			alsu_cfg = alsu_config::type_id::create("alsu_cfg"); 
			reset_seq = alsu_reset_sequence::type_id::create("reset_seq");
			main_seq = alsu_main_sequence::type_id::create("main_seq");

			if (!uvm_config_db #(virtual alsu_if)::get(this,"","alsu_Vif",alsu_cfg.alsu_Vif)) begin
			 			`uvm_fatal("build_phase","Test - unable to get the virtual interface");
			 end

			uvm_config_db #(alsu_config)::set(this,"*","CFG",alsu_cfg); 		
		endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);

			reset_seq.start(env.agt.sqr);
			`uvm_info("run_phase","Reset asserted", UVM_LOW)
			
			main_seq.start(env.agt.sqr);
			`uvm_info("run_phase","Stimulus generation started", UVM_LOW)

			phase.drop_objection(this);
		endtask 
	endclass 
endpackage

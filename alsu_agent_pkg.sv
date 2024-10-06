package alsu_agent_pkg;
	import alsu_driver_pkg::*;
	import MySequencer_pkg::*;
	import alsu_config_pkg::*;
	import alsu_monitor_pkg::*;
	import alsu_sequence_item_pkg::*;
	
	import uvm_pkg::*;	
	`include "uvm_macros.svh"
	class alsu_agent extends uvm_agent ;
		`uvm_component_utils(alsu_agent)
		MySequencer sqr;
		alsu_driver drv;
		alsu_monitor mon;
		alsu_config alsu_cfg;
		uvm_analysis_port #(alsu_sequence_item) agt_ap; 

		function new(string name = "alsu_agent", uvm_component parent = null);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			drv = alsu_driver::type_id::create("drv",this);
			sqr = MySequencer::type_id::create("sqr",this);
			mon = alsu_monitor::type_id::create("mon",this);
			agt_ap =new("agt_ap",this);
			if (!uvm_config_db #(alsu_config)::get(this,"","CFG",alsu_cfg)) begin
			 	`uvm_fatal("build_phase","Driver - unable to get configuration object");
			 end 	
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			drv.seq_item_port.connect(sqr.seq_item_export);
			drv.alsu_Vif=alsu_cfg.alsu_Vif;
			mon.alsu_Vif=alsu_cfg.alsu_Vif;
			mon.mon_ap.connect(agt_ap);
		endfunction : connect_phase
	endclass
endpackage
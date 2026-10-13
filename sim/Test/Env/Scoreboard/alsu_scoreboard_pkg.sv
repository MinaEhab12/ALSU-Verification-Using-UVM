package alsu_scoreboard_pkg;
    import uvm_pkg::*;
    import alsu_shared_pkg::*;
    import alsu_sequence_item_pkg::*;
    `include "uvm_macros.svh"

    class alsu_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(alsu_scoreboard)
        uvm_analysis_export #(alsu_sequence_item) sb_export;
        uvm_tlm_analysis_fifo #(alsu_sequence_item) sb_fifo;
        alsu_sequence_item seq_item_sb;
        logic signed [5:0] dataout_ref;

        integer correct_counter = 0;
        integer error_counter = 0;

        function new(string name = "alsu_scoreboard", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export", this);
            sb_fifo = new("sb_fifo", this);
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);
        endfunction : connect_phase

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item_sb);
                ref_model(seq_item_sb);
                if (seq_item_sb.out != dataout_ref) begin
                    `uvm_error("run_phase", $sformatf("There is an error!!, Transaction received by the DUT is: %s while the reference output is: 0b%0b",
                        seq_item_sb.convert2string(), dataout_ref));
                    error_counter++;
                end
                else begin
                    `uvm_info("run_phase", $sformatf("Correct Transaction received, Output is: %s",
                        seq_item_sb.convert2string()), UVM_HIGH)
                    correct_counter++;
                end
            end
        endtask : run_phase

        task ref_model(alsu_sequence_item seq_item_chk);
            if (seq_item_chk.rst) begin
                dataout_ref = 0;
            end
            else begin
                case (seq_item_chk.opcode)
                    OR:    dataout_ref = seq_item_chk.A | seq_item_chk.B;
                    XOR:   dataout_ref = seq_item_chk.A ^ seq_item_chk.B;
                    ADD:   dataout_ref = seq_item_chk.A + seq_item_chk.B + seq_item_chk.cin;
                    MULT:  dataout_ref = seq_item_chk.A * seq_item_chk.B;
                    SHIFT: begin
                        if (seq_item_chk.direction)
                            dataout_ref = {seq_item_chk.serial_in, seq_item_chk.A[2:0]};
                        else
                            dataout_ref = {seq_item_chk.A[1:0], seq_item_chk.serial_in};
                    end
                    ROTATE: begin
                        if (seq_item_chk.direction)
                            dataout_ref = {seq_item_chk.A[1:0], seq_item_chk.A[2]};
                        else
                            dataout_ref = {seq_item_chk.A[0], seq_item_chk.A[2:1]};
                    end
                    default: dataout_ref = 0;
                endcase
            end
        endtask : ref_model

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase", $sformatf("Total correct counts is: 0d%0d", correct_counter), UVM_LOW)
            `uvm_info("report_phase", $sformatf("Total error counts is: 0d%0d", error_counter), UVM_LOW)
        endfunction : report_phase
    endclass
endpackage

package alsu_sequence_item_pkg;

	import alsu_shared_pkg::*;	
	import uvm_pkg::*;

	`include "uvm_macros.svh"
	class alsu_sequence_item extends uvm_sequence_item ;
		`uvm_object_utils(alsu_sequence_item)

		rand reg_e A_constrained,B_constrained;
		rand bit cin;
		rand bit serial_in;
		rand bit direction;
		rand bit signed [2:0] A, B;
		rand bit red_op_A;
		rand bit red_op_B;
		rand opcode_e opcode;
		rand bit rst;
		rand bit bypass_A, bypass_B;
		rand bit signed [2:0] A_rem_rand, B_rem_rand;
		bit [2:0] ones [] ='{3'b001, 3'b010, 3'b100};
		rand bit [2:0] only_ones, no_only_ones;
	    logic signed [15:0] leds;
		logic signed [5:0] out;

		function new(string name = "alsu_sequence_item");
			super.new(name);
		endfunction

  		constraint reset {
			rst dist {0:/98, 1:/2}; 
		} 

		constraint A_and_B {
    		A_rem_rand != MAXPOS || 0 || MAXNEG;
    		B_rem_rand != MAXPOS || 0 || MAXNEG;
    		only_ones inside {ones};
    		!(no_only_ones inside {ones});

    		if (opcode inside {OR,XOR}){
    			if(red_op_A){
    				B==0;
    				A dist {only_ones:/90, no_only_ones:/10};

    			}
    			else if (red_op_B) {
    				A==0;
    				B dist {only_ones:/90, no_only_ones:/10};
    				}
    		}
    		else {
    			red_op_A dist {1:/20, 0:/80};
    			red_op_B dist {1:/20, 0:/80};
    			if(opcode inside {ADD, MULT}){
    				A dist {A_constrained:/80, A_rem_rand:/20};
    				B dist {B_constrained:/80, B_rem_rand:/20};
    				}
	
    			}
			}

		constraint opcode_values 
		{
			opcode dist {[OR:ROTATE]:/80, [INVALID_6:INVALID_7]:/20};
		}


		constraint Bypass_values
		{
			bypass_A dist {0:/95, 1:/5};
			bypass_B dist {0:/95, 1:/5};
		}

		constraint cin_values {cin dist {1:/50,0:/50};}

		constraint serial_in_values {serial_in dist {1:/50,0:/50};}

		constraint direction_values {direction dist {1:/50,0:/50};}


  		function string convert2string();
  			return $sformatf("%s rst_rand = 0b%0b,  cin_rand = 0b%0b, red_op_A_rand = 0b%0b, red_op_B_rand = 0b%0b, bypass_A_rand = 0b%0b, bypass_B_rand =0b%0b
  								, direction_rand =0b%0b, serial_in_rand =0b%0b, opcode_rand =%s, A_rand =0b%0b, B_rand =0b%0b, leds =0b%0b, out =0b%0b",
  			 super.convert2string(), rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in
  			 , opcode, A, B, leds, out);
  		endfunction : convert2string

  		function string convert2string_stimulus();
  			return $sformatf("%s rst_rand = 0b%0b,  cin_rand = 0b%0b, red_op_A_rand = 0b%0b, red_op_B_rand =0b%0b, bypass_A_rand = 0b%0b, bypass_B_rand =0b%0b
  								, direction_rand =0b%0b, serial_in_rand =0b%0b, opcode_rand =%s, A_rand =0b%0b, B_rand =0b%0b",
  			 super.convert2string(), rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in
  			 , opcode, A, B);
  		endfunction : convert2string_stimulus
	endclass
	
	
endpackage
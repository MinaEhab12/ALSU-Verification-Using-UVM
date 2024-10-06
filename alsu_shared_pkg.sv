package alsu_shared_pkg;
	
	typedef enum logic [2:0] {OR = 3'b000,XOR = 3'b001,ADD = 3'b010,MULT = 3'b011,SHIFT = 3'b100,
								ROTATE = 3'b101,INVALID_6 = 3'b110,INVALID_7 = 3'b111} opcode_e;

	typedef enum {MAXPOS = 3, ZERO = 0, MAXNEG = -4} reg_e;
	
endpackage : alsu_shared_pkg


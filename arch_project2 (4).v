//Amany Hmidan	1200255
//Leena Affouri 1200335
//Mariam Hamad  1200837


reg [31:0]IR;
reg [31:0] data_word;   // To hold a 32-bit data word 
reg [31:0] buffer_stage0_stage1; // Buffer between Stage 1 and Stage 2
reg [31:0] buffer_stage1_stage2; 


reg [31:0] buffer_stage2_stage3; 
reg [31:0] buffer_stage3_stage4;

reg [2:0] stage;
reg [2:0]next_state;
reg [31:0] PC; // Program Counter




module All_Sys(	 
	
	input clk,
	input reset,
	//Control Siganls
	output reg PCSrc1, 
	output reg PCSrc0,	 
	output reg Reg_Src2,
	output reg push,
	output reg pop,
	output reg Reg_Write,
	output reg Reg_Write2,
	output reg Ext_Op,
	output reg Alu_Src2,
	output reg [0:1] Alu_Op,
	output reg Mem_R,
	output reg Mem_W,
	output reg WB_Data,
	output reg [0:1] mode,
	
	///Instruction Decode Part 
	output reg [31:0] Rs1, // (Bus A )Output data from register 1
	output reg [31:0] Rs2, // (Bus B) Output data from register 2
	output reg [31:0] Rd, // (Bus W) Output data from register 3
	
	///ALU Part
	output reg [31:0] Out_Alu, 
	
	output reg [15:0] immediate16,
	
	//output reg [1:0] Type // 00 for R-type, 01 for I-type, 10 for J-type, 11 for S-type
	
	
	
	);	   
	
	/// Instruction Fetch
	
	reg [31:0] Instruction_Mem[31:0]; // Define a memory block for code/instructions
	
	
	
	initial begin
			  
			
			//ADD inst: R[3] = R[2] + R[0]	 aluOut = 8
			Instruction_Mem[0] = 32'b 000001_0011_0000_0010_00000000000000;
			
			//ANDI inst:  R[4] = R[1] & 15	 aluOut = 4
			Instruction_Mem[1] = 32'b 000011_0100_0001_0000000000001111_00;
			
			//Load inst:  R[7] = Mem(R[1] + 2)	aluOut = 6  Rd = 7
			Instruction_Mem[2] = 32'b 000101_0111_0001_0000000000000010_00;
			
			//BEQ inst: Beq R8,R9 if equal go to inst 7 
			Instruction_Mem[3] = 32'b 001010_1000_1001_0000000000000011_00;
			
			//Sub inst: R[2] = R[5] - R[6]
			Instruction_Mem[4] = 32'b 000010_0010_0101_0110_00000000000000;
			
			//AND inst: R[3] = R[1] & R[2]
			Instruction_Mem[5] = 32'b 000000_0011_0001_0010_00000000000000;
			
			//Store inst:   Mem(R[8] + 2) = R[5] , data_memory[10] = 7
			Instruction_Mem[6] = 32'b 000111_0101_1000_0000000000000010_00;
			
			//ADDI inst:  R[4] = R[1] + 14 , alu_out = 12 hexa
			Instruction_Mem[7] = 32'b 000100_0100_0001_0000000000001110_00;
			
			//BGT inst: Bgt R10,R11 if TRUE go to inst 11 
			Instruction_Mem[8] = 32'b 001000_1010_1011_0000000000000010_00;
			
			//ADD inst: R[3] = R[1] + R[2]   aluOut = 9
			Instruction_Mem[9] = 32'b 000001_0011_0001_0010_00000000000000;
			
			
			
			//Sub inst: R[2] = R[5] - R[6]	 aluOUT = 5
			//Instruction_Mem[11] = 32'b 000010_0010_0101_0110_00000000000000;
			
			//ADD inst: R[15] = R[0] + R[1]	 aluOUT = 7
			Instruction_Mem[11] = 32'b 000001_1111_0000_0001_00000000000000;
			
			//BLT inst: Blt R10,R11 if TRUE go to inst 16 
			Instruction_Mem[12] = 32'b 001001_1010_1011_0000000000000011_00;
			
			//Load.PIO inst:  R[7] = Mem(5) = 6, R0 =3+1 =4
			Instruction_Mem[13] = 32'b 000101_0111_0000_0000000000000010_01;
			
			//try push and pop
			
			//AND inst: R[3] = R[1] & R[2]	 aluOut = 4  R3=4
			Instruction_Mem[14] = 32'b 000000_0011_0001_0010_00000000000000;
			
			//PUSH inst, push value of R3 on stack
			Instruction_Mem[15] = 32'b 001111_0011_0000000000000000000000;
			
			// next inst will change value of R3
			
			//ADD inst: R[3] = R[1] + R[2]	 aluOut = 9
			Instruction_Mem[16] = 32'b 000001_0011_0001_0010_00000000000000;
			
			// pop the value of R3 to see how the previos value was preserved 
			//  PoP inst, pop value of R3 from stack
			Instruction_Mem[17] = 32'b 010000_0011_0000000000000000000000; 
			
			//call instruction 22
			Instruction_Mem[18] = 32'b 001101_00000000000000000000010110;
			
		
			//AND inst: R[3] = R[1] & R[2]	 aluOut = 4  R3=4
			Instruction_Mem[19] = 32'b 000000_0011_0001_0010_00000000000000; 
			
			//Jump inst: it will jump to Instruction_Mem[4]	and preform Sub inst
			Instruction_Mem[20] = 32'b 001100_0000000000000000010110;
			
			//ADDI inst:  R[4] = R[1] + 14 , alu_out = 12 hexa
			Instruction_Mem[21] = 32'b 000100_0100_0001_0000000000001110_00;
			
			//Sub inst: R[2] = R[5] - R[6]	 aluOUT = 5
			Instruction_Mem[22] = 32'b 000010_0010_0101_0110_00000000000000;
			
			//return
			
			Instruction_Mem[23] = 32'b 001110_00000000000000000000010110;
			
			
			
			
		end
	
	initial begin
			GPR[0] = 32'h00000003;
			GPR[1] = 32'h00000004;
			GPR[2] = 32'h00000005;
			GPR[3] = 32'h00000006;
			GPR[4] = 32'h00000007;
			GPR[5] = 32'h00000007;
			GPR[6] = 32'h00000002;
			GPR[7] = 32'h00000009; 
			GPR[8] = 32'h00000008; 
			GPR[9] = 32'h00000008;
			GPR[10] = 32'h0000000C;
			GPR[11] = 32'h0000000A;
			GPR[12] = 32'h0000000A;
			GPR[13] = 32'h0000000A;
			GPR[14] = 32'h0000000B;
			GPR[15] = 32'h0000000A;
		end
	
	
	
	//reg [31:0] PC; // Program Counter
	
	
	
	//Instruction Decode
	reg [31:0] GPR[15:0]; // General-Purpose Registers array, R0 to R15
	reg [3:0] Address_Of_Rd;	 // Address for Rd
	reg [3:0] Address_Of_Rs1;  // Address for RS1
	reg [3:0] Address_Of_Rs2;  // Address for RS2	
	reg [3:0] Registers[0:15];
	reg [5:0] Opcode;  
	reg [1:0] Mode; 
	reg [25:0]Jump_Offset;
	
	//ALU Part
	reg [31:0] First_Input;    
	reg [31:0] Seconed_Input;         
	reg Zero_Flag;  
	reg Negative_Flag; 	   
	
	
	//Data Memory 
	reg [31:0] Address,Data_in;
	reg [31:0] Data_out;
	reg [31:0] Data_memory [31:0];	
	//Stack 
	reg [31:0] SP;	
	reg Full, Empty;
	reg [31:0] Out_Stack;
	parameter STACK_DEPTH = 8; 
	reg [31:0] stack [STACK_DEPTH-1:0];
	
	reg [31:0] data_memory[0:30];
	//let locations 0-15 for data and locations 16-30 for stack
	initial	begin
			SP = 32'h0000001E; //AT 30
		end	
	
	initial begin
			data_memory[0] = 32'h00000001;
			data_memory[1] = 32'h00000002;
			data_memory[2] = 32'h00000003;
			data_memory[3] = 32'h00000004;
			data_memory[4] = 32'h00000005;
			data_memory[5] = 32'h00000006;
			data_memory[6] = 32'h00000007;
			data_memory[7] = 32'h00000008;
			data_memory[8] = 32'h00000009;
			data_memory[9] = 32'h0000000A;
			data_memory[10] = 32'h0000000B;
			data_memory[11] = 32'h0000000C;
			data_memory[12] = 32'h0000000D;
			data_memory[13] = 32'h0000000E;
			data_memory[14] = 32'h0000000F;
			data_memory[15] = 32'h00000001;
			
		end
	
	
	
	//Write back stage
	reg [31:0]Out_Mux_WB;	  
	
	//Extenders 16
	//reg [15:0] immediate16;  
	
	//The output of the adder
	reg [31:0] Adder_Output; 
	
	//Branch Target Address
	reg [31:0] Branch_Target_Add;  
	
	//Out Mux Before Pc
	reg [31:0]Output_Mux_Bef_Pc; 	
	
	
	reg [1:0] Type; // 00 for R-type, 01 for I-type, 10 for J-type, 11 for S-type
	
	reg [1:0] S_Value;					  
	
	
	//---------------------------------------------------------	
	
	integer i;
	always @(posedge clk)  begin 
			//#20ns
			#10ns
			if(stage == 0) begin
					next_state = 1;
					
				end	
			
			
			if(stage != 0 ) begin 
					
					if(Type == 	 2'b00 || S_Value == 2'b00) begin	 // R type	 & I type  --> ADDI & ANDI
							case (stage) 	
								0: 		 //fetch
									next_state = 1;
								1: 
									next_state = 2;
								2: 
									next_state = 4;
								4: 
									next_state = 0;
							endcase
						end
					
					if(S_Value == 2'b01) begin	 //   I type LW
							case (stage) 	
								0: 
									next_state = 1;
								1: 
									next_state = 2;
								2: 
									next_state = 3;
								3: 
									next_state = 4;	 
								4: 
									next_state = 0;
							endcase
						end
					
					
					if(S_Value == 2'b10) begin	 //   I type SW
							case (stage) 	
								0: 
									next_state = 1;
								1: 
									next_state = 2;
								2: 
									next_state = 3;
								3: 
									next_state = 0;	 
								
							endcase
						end
					
					if(S_Value == 2'b11) begin	 //   I type Branches
							case (stage) 	
								0: 
									next_state = 1;
								1: 
									next_state = 2;
								2: 
									next_state = 0;
								
								
							endcase	
						end
					
					if(Type == 2'b10) begin	 //   J type 
							if(Opcode == 6'b001100) begin  //JUMP
									case (stage) 	
										0: begin 
												#6ns
												next_state = 1;
											end
										1: begin
												
												next_state = 0;
											end
										
									endcase
								end
							
							if(Opcode == 6'b001101 || Opcode == 6'b001110 ) begin	//CALL & RETURN
									case (stage) 	
										0: begin
												#6ns
												next_state = 1;
											end
										1: 
											next_state = 3;
										3: begin
											
											next_state = 0;
											end
										
									endcase
								end
							
							
						end
					
					if (Type == 2'b11) begin // S type
							case (stage)
								0:
									next_state = 1;
								1:
									next_state = 3;
								3:
									begin
										if (Opcode == 6'b001111) // push
											next_state = 0;
										else if (Opcode == 6'b010000)begin // pop
												next_state = 4;
												$display("time= %0t,pop has finished",$time);
											end
									end
								4:
									next_state = 0;
							endcase
						end
					
					
					
				end	
			
			stage = next_state;
			
			
		end	
	
	
	
	
	
	always @(posedge clk, posedge reset) begin
			if (reset) begin
					PC = 32'h00000000;
					Rs1 = 32'd0;
					Rs2 = 32'd0;
					Rd = 32'd0;
					
				end	
			// IF
			else if (stage == 0) begin
					IR = Instruction_Mem[PC];
					
					PC = PC +1;
					
					$display("Time= %0t,in stage: %0d, PC = %0d", $time, stage,PC);
					
					
					
					//stage =1;  
					buffer_stage0_stage1 = IR;
					
					
					
				end	 
			//**************************************************************
			// ID
			else if (stage == 1) begin	
					Opcode = buffer_stage0_stage1[31:26];
					
					
					$display("Time= %0t,in stage: %0d, opcode = %0h", $time, stage,Opcode);
					
					// ********** R TYPE  *****************
					if((Opcode == 6'b000000) || (Opcode == 6'b000001) || (Opcode == 6'b000010)) begin //ADD || AND || SUB
							
							Type = 2'b00;
							PCSrc1 = 1'b0;
							PCSrc0 = 1'b0;
							Reg_Src2 = 1'b0;
							Reg_Write = 1'b1;
							Reg_Write2= 1'b0;
							Alu_Src2 = 1'b0;
							Mem_R= 	1'b0;
							Mem_W=	1'b0;
							WB_Data= 1'b0;
							
							
							if (Opcode == 6'b000000)begin  // AND
									Alu_Op = 2'b01;
								end
							else if (Opcode == 6'b000001)begin  // ADD
									Alu_Op = 2'b10;
								end
							else begin
									Alu_Op = 2'b11;		 // SUB
								end
							
						end	 
					
					
					// ********** I TYPE  *****************		
					else if (Opcode == 6'b000011)begin	  //ANDI	
							
							Type = 2'b01;
							S_Value= 2'b00;
							PCSrc1=	1'b0;
							PCSrc0= 1'b0;
							Reg_Write= 1'b1;
							Reg_Write2= 1'b0;
							Alu_Src2= 1'b1;
							Mem_R= 	1'b0;
							Mem_W=	1'b0;
							WB_Data= 1'b0;
							Ext_Op=	1'b0; 
							Alu_Op = 2'b01;	  
							
						end	  
					
					
					else if (Opcode == 6'b000100)begin      //ADDI  
							
							Type = 2'b01;
							S_Value= 2'b00;
							PCSrc1=	1'b0;
							PCSrc0= 1'b0;
							Reg_Write= 1'b1;
							Reg_Write2= 1'b0;
							Alu_Src2= 1'b1;
							Mem_R= 	1'b0;
							Mem_W=	1'b0;
							WB_Data= 1'b0;
							Ext_Op= 1'b1;	 
							Alu_Op= 2'b10; 
							
							
						end
					
					else if (Opcode == 6'b000101 )begin      //LW or LW with post increment  
							
							Type = 2'b01; 
							S_Value= 2'b01;
							PCSrc1=	1'b0;
							PCSrc0= 1'b0;
							Reg_Write= 1'b1;
							Reg_Write2= 1'b0;
							Alu_Src2= 1'b1;
							Mem_R= 	1'b1;
							Mem_W=	1'b0;
							WB_Data= 1'b1;
							Ext_Op=	1'b1; 
							Alu_Op= 2'b10;
							
							
						end
					
					else if (Opcode == 6'b000111)begin   //SW 	  
							
							Type = 2'b01;
							S_Value= 2'b10;
							PCSrc1=	1'b0;
							PCSrc0= 1'b0;
							Reg_Src2 = 1'b1;
							Reg_Write= 1'b0;
							Reg_Write2= 1'b0;
							Alu_Src2= 1'b1;
							Mem_R= 	1'b0;
							Mem_W=	1'b1;
							Ext_Op=	  1'b1;
							Alu_Op= 2'b10; 
							
							
						end
					
					else if (Opcode == 6'b001000)begin   //BGT
							
							Type = 2'b01;
							S_Value= 2'b11;
							Reg_Src2= 1'b1;
							Reg_Write= 1'b0;
							Reg_Write2= 1'b0;
							Alu_Src2= 1'b0;
							Mem_R= 	1'b0;
							Mem_W=	1'b0;
							WB_Data= 1'b0;
							Ext_Op=	1'b1;
							Alu_Op= 2'b11;
							
							
							
						end	 
					
					else if (Opcode == 6'b001001)begin   //BLT
							S_Value= 2'b11;
							Type = 2'b01;		
							PCSrc1=	1'b0;
							PCSrc0= 1'b0;
							Reg_Src2= 1'b1;
							Reg_Write= 1'b0;
							Reg_Write2= 1'b0;
							Alu_Src2= 1'b0;
							Mem_R= 	1'b0;
							Mem_W=	1'b0;
							WB_Data= 1'b0;
							Ext_Op=	1'b1;
							Alu_Op= 2'b11;
							
							
						end	 
					
					
					
					else if (Opcode == 6'b001010)begin   //BEQ
							S_Value= 2'b11;
							Type = 2'b01;
							Reg_Src2= 1'b1;
							Reg_Write= 1'b0; 
							Reg_Write2= 1'b0;
							Alu_Src2= 1'b0;
							Mem_R= 	1'b0;
							Mem_W=	1'b0;
							WB_Data= 1'b0;
							Ext_Op=	1'b1;
							Alu_Op= 2'b11;
							
							
						end
					
					
					
					else if (Opcode == 6'b001011)begin   //BNE
							S_Value= 2'b11;
							Type = 2'b01;		
							PCSrc1=	1'b0;
							PCSrc0= 1'b0;
							Reg_Src2= 1'b1;
							Reg_Write= 1'b0;
							Reg_Write2= 1'b0;
							Alu_Src2= 1'b0;
							Mem_R= 	1'b0;
							Mem_W=	1'b0;
							WB_Data= 1'b0;
							Ext_Op=	1'b1;
							Alu_Op= 2'b11;
							
							
							
						end	  		
					
					
					//********************** J TYPE ****************
					
					if (Opcode == 6'b001100)begin   //JMP 	
							$display("jump decode");
							Type = 2'b10;
							PCSrc1=	1'b0;
							PCSrc0= 1'b1;
							Reg_Write= 1'b0;
							Reg_Write2= 1'b0;
							Mem_R= 	1'b0;
							Mem_W=	1'b0;
							
							Jump_Offset = IR[25:0] ;
							PC = {PC[31:26], Jump_Offset };
							
							
							$display("jump decode");
							
						end
					
					if (Opcode == 6'b001101)begin   //CALL 
							$display("Call inst reached");
							Type = 2'b10;
							PCSrc1=	1'b0;
							PCSrc0= 1'b1;
							Reg_Write= 1'b0;
							Reg_Write2= 1'b0;
							Mem_R= 	1'b0;
							Mem_W=	1'b1; //PUSH
							
							Jump_Offset = IR[25:0] ;
							
							PC = {PC[31:26], Jump_Offset };	
							$display("after J-type, PC= %0d" , PC);
							
							
						end
					
					else if (Opcode == 6'b001110)begin   //RET  
							Type = 2'b10;
							Mem_R= 	1'b1; //pop
							Mem_W=	1'b0;
							
							Reg_Write= 1'b0;
							Reg_Write2= 1'b0;
							
						end							   
					
					
					
					//********************** S TYPE **************** 
					
					
					else if (Opcode == 6'b001111)begin   //PUSH 
							
							Type = 2'b11;
							PCSrc1=	1'b0;
							PCSrc0= 1'b0;
							Reg_Src2= 1'b1;
							Reg_Write= 1'b0; 
							Reg_Write2= 1'b0;
							
							Mem_R= 	1'b0;
							Mem_W=	1'b1;
							
							
						end
					
					else if (Opcode == 6'b010000)begin   //POP 
							Type = 2'b11;
							PCSrc1=	1'b0;
							PCSrc0= 1'b0;
							
							Reg_Src2= 1'b1;
							Reg_Write= 1'b1; // becuase it stores top stack element in Rd
							Reg_Write2= 1'b0;
							
							Mem_R= 	1'b1;
							Mem_W=	1'b0;
							WB_Data= 1'b1;  // because it has access on data memory(stack)
							
						end
					
					//////////////////////////////////////
					
					/*if (PCSrc1 == 0 & PCSrc0 == 0)begin	//not branch or not jump
					PC = PC +1;
					end*/	
					
					case(Type) 
						
						
						//R-type
						00:begin
								
								
								Address_Of_Rd = IR[25:22];
								Address_Of_Rs1 = IR[21:18];
								Address_Of_Rs2 = IR[17:14];
								
							end
						
						//I-type
						01: begin
								
								Address_Of_Rd = IR[25:22];
								Address_Of_Rs1 = IR[21:18];
								immediate16 = IR[17:2];
								mode = IR[1:0];
								
								if(mode == 2'b00)
									Reg_Write2= 1'b0;
								else if ( mode == 2'b01 )
									Reg_Write2= 1'b1;	
								
								
								
							end
						
						//J-type
						10: begin
								
								$display("jump inst is reached"); 
								if(Opcode == 6'b001100 || Opcode == 6'b001101) begin 
										
										Jump_Offset = IR[25:0] ;
									end	 
								
								
								if (PCSrc1 == 0 & PCSrc0 == 1)begin		   //jump
										PC = {PC[31:26], Jump_Offset };
									end
								
								
							end	
						
						//S-type
						11: begin
								
								Address_Of_Rd = IR[25:22]; 
							end	  
						
						
						
					endcase
					
					Rs1 = GPR[Address_Of_Rs1];
					Rd =  GPR[Address_Of_Rd];
					Rs2 = (Reg_Src2 == 0) ? GPR[Address_Of_Rs2] :  GPR[Address_Of_Rd];
					Data_in = Rs2;
					
				end
			
			
			
			
			//Execution in ALU	
			else if (stage == 2) begin
					$display("Time= %0t,in stage: %0d, opcode = %0h", $time, stage,Opcode);
					
					First_Input = Rs1;    
					Seconed_Input =(Alu_Src2)? imm_extend(immediate16, Ext_Op) : Rs2 ;
					
					
					case(Alu_Op)
						
						2'b10: Out_Alu = First_Input + Seconed_Input;
						2'b11: Out_Alu = First_Input - Seconed_Input;	
						2'b01: Out_Alu = First_Input & Seconed_Input;
						default: Out_Alu = 32'b0;
					endcase
					$display("first input = %0d, second input = %0d",First_Input,Seconed_Input);
					$display("opcode = %0b, aluOut = %0d",Opcode,Out_Alu); 
					
					// set zero flag for BEQ, BNE
					Zero_Flag = (Out_Alu == 32'b0) ? 1 : 0; 
					// set negative flag for BGT, BLT
					Negative_Flag = (Out_Alu[31] == 1) ? 1 : 0;
					
					if(Opcode == 6'b001010) begin //BEQ
							if (Zero_Flag == 1 ) begin
									PCSrc1=	1'b1;	
									PCSrc0= 1'b0;
								end
							else begin
									PCSrc1=	1'b0;
									PCSrc0= 1'b0;
								end
						end
					
					else if(Opcode == 6'b001011) begin //BNE
							
							if(Zero_Flag == 0 )begin
									PCSrc1=	1'b1;	 
									PCSrc0= 1'b0; 
								end
							else begin
									PCSrc1=	1'b0;
									PCSrc0= 1'b0;  
								end
						end	
					
					else if (Opcode == 6'b001000)begin			     //BGT
							if (Negative_Flag == 1 )begin
									PCSrc1=	1'b1;	 // 10 pc
									PCSrc0= 1'b0;
								end
							else begin
									PCSrc1=	1'b0;
									PCSrc0= 1'b0;  
								end
						end	 	
					
					
					else if (Opcode == 6'b001001)begin   //BLT
							if(Negative_Flag == 0 )begin
									PCSrc1=	1'b1;	 // 10 pc
									PCSrc0= 1'b0; 
								end
							else begin
									PCSrc1=	1'b0;
									PCSrc0= 1'b0;
								end
						end
					
					if(PCSrc1 ==	1'b1 & PCSrc0 == 1'b0) begin  // if branch is taken , PC= branch target address	
							$display("branch1: PC= %0d",PC);
							$display("immediate16:%0d",immediate16);	
							PC= PC + imm_extend(immediate16, Ext_Op) ;
							
							$display("branch2: PC= %0d",PC);
						end 
					
					
					
					
				end	//end stage
			// Memory access stage
			else if(stage == 3) begin
					$display("Time= %0t,in stage: %0d, opcode = %0h", $time, stage,Opcode);
					
					if(Opcode == 6'b001101 || Opcode == 6'b001110) begin // FOR CALL OR RET
							if(Mem_R == 1'b1) begin 			// POP for return address (inst is RET)
								PC = data_memory[SP+1];
								$display("POP:OPcode= %0b, SP= %0d, Rd = %0d,",Opcode,SP,data_memory[SP+1]);
									if(SP < 32'h0x1E)
										SP = SP + 1;
								end
							else if(Mem_W == 1'b1) begin			 // Push for return address (inst is call)
								data_memory[SP] = PC;
								$display("PUSH:OPcode= %0b, SP= %0d,data_memory[%0d] = %0d",Opcode,SP,SP,data_memory[SP]);
									if(SP > 32'hF)
										SP = SP - 1;
								end
						end
					
					else if(Opcode == 6'b001111 || Opcode == 6'b010000) begin // for push or pop
							if(Mem_R == 1'b1) begin 			// POP
									Rd = data_memory[SP+1];
									$display("POP:OPcode= %0b, SP= %0d, Rd = %0d,",Opcode,SP,data_memory[SP+1]);
									if(SP < 32'h0x1E)
										SP = SP + 1;
								end
							else if(Mem_W == 1'b1) begin // Push
									data_memory[SP] = Rd;
									$display("PUSH:OPcode= %0b, SP= %0d,data_memory[%0d] = %0d",Opcode,SP,SP,data_memory[SP]);
									if(SP > 32'hF)
										SP = SP - 1;
								end
						end
					
					else if(Mem_R == 1'b1) begin // LOAD
							Data_out = data_memory[Out_Alu];
							$display("dataOut = %0d", Data_out);
						end
					
					else if(Mem_W == 1'b1) begin // STORE
							data_memory[Out_Alu] = Data_in;
							$display("STORE inst: data_memory[%0d] = %0d",Out_Alu,Data_in );
						end
					
				end
			
			// write back
			else if(stage == 4 ) begin 
					$display("Time= %0t,in stage: %0d, opcode = %0h", $time, stage,Opcode);
					if (Reg_Write) begin //LW and LW.POI
							if(WB_Data) begin
									GPR[Address_Of_Rd] = Data_out;
									Rd = Data_out;
							end else begin
									GPR[Address_Of_Rd] = Out_Alu;
									Rd = Out_Alu;
								end 
						end
					
					if(Reg_Write2)begin // ONLY FOR LW.POI
							$display("welcome");
							GPR[Address_Of_Rs1] = GPR[Address_Of_Rs1] +1 ; 
							Rs1 = Rs1 +1;
						end
					
				end
			
			
			
		end	// end always
	
	
	
	// Function to extend a 16-bit immediate to 32 bits
	function [31:0] imm_extend;
		input [15:0] imm;
		input extop;
		
		if (extop == 1) begin
				// Sign extension (extend with sign bit)
				imm_extend = { {16{imm[15]}}, imm };
		end else begin
				// Zero extension (extend with zeros)
				imm_extend = { 16'b0, imm };
			end
	endfunction
	
	
	
	
	
endmodule

//------------------------------------------------------------------------------------------

module All_Sys_TestBench;
	
	
	reg clk;
	reg reset;
	//Control Siganls
	wire PCSrc1;
	wire PCSrc0;	 
	wire Reg_Src2;
	wire push;
	wire pop;
	wire Reg_Write;
	wire Reg_Write2;
	wire Ext_Op;
	wire Alu_Src2;
	wire [0:1] Alu_Op;
	wire Mem_R;
	wire Mem_W;
	wire WB_Data;
	wire [0:1] mode;
	
	///Instruction Decode Part 
	wire [31:0] Rs1; // (Bus A )Output data from register 1
	wire [31:0] Rs2;// (Bus B) Output data from register 2
	wire [31:0] Rd; // (Bus W) Output data from register 3
	
	///ALU Part
	wire [31:0] Out_Alu; 
	
	wire [15:0] immediate16; 
	
	
	All_Sys M (clk, reset, PCSrc1,PCSrc0,Reg_Src2,push,pop, Reg_Write,Reg_Write2, Ext_Op,Alu_Src2,Alu_Op,Mem_R, Mem_W, WB_Data,mode, Rs1,Rs2,Rd,Out_Alu, immediate16);
	
	initial begin
			clk = 0;
			reset = 0;
			stage = 0;
			PC = 0;
		end	
	
	//clock generation
	always #20ns clk = ~clk;
	
	//always #40ns  reset = ~reset;
	
	//initial #200ns $finish;
	
endmodule



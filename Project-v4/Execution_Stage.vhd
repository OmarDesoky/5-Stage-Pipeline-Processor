LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_STD.ALL;
ENTITY Execution_Stage IS  
PORT (
    	wb_in:									in std_logic_vector(4 downto 0); -- input from ID/EX Buffer
    	mem_in:									in std_logic_vector(6 downto 0); -- input from ID/EX Buffer
    	alu_op:									in std_logic_vector(3 downto 0); -- input from ID/EX Buffer
-- will use bit 0 as (ALU Source) && bit 1 as I/O Enable
		ex_in:									in std_logic_vector(1 downto 0); -- input from ID/EX Buffer
    	reg1_data, reg2_data, alu_out2_MEM_WB, alu_out_MEM_WB, alu_out_EX_MEM, alu_out2_EX_MEM, mem_out_MEM_WB:in std_logic_vector(31 downto 0);
-- src2 will be used when we put the forwarding unit soon
		src1, src2, dst :						in std_logic_vector (2 downto 0);
    	ea_imm_in, pc_in:         				in std_logic_vector(31 downto 0);
  		enb_1st_mux, enb_2nd_mux:				in std_logic_vector(2 downto 0);
		pc_incremented_in: 						in std_logic_vector(31 downto 0);
		last_taken_in : 						in std_logic;
		prediction_result_in : 					in std_logic;
		zero_flag_in,if_jz_in :					in std_logic;
		
		Mem_out :           					out std_logic_vector(6 downto 0);
    	wb_out:             					out std_logic_vector(4 downto 0);
		alu_out1, alu_out2, EA_IMM_out, pc_out:	out std_logic_vector(31 downto 0);
		src1_out, DST_out:						out std_logic_vector (2 downto 0);
		IO_out,forwarded_jmp_addr : 			out std_logic_vector(31 downto 0); --edited 20/5/2020
		zero_flag, carry_flag, neg_flag:		out std_logic;
		take_jump_Correct : out std_logic);
END Execution_Stage;

ARCHITECTURE flow OF Execution_Stage IS
signal first_operand_for_ALU:		std_logic_vector(31 downto 0);
signal second_operand_for_ALU:		std_logic_vector(31 downto 0);
signal mux_choice:					std_logic_vector(31 downto 0);
signal zero_sig : std_logic;
BEGIN   
take_jump_Correct<= if_jz_in and (prediction_result_in);
Mem_out <= mem_in;
wb_out <= wb_in;
EA_IMM_out <=ea_imm_in;
pc_out <= pc_in;
DST_out <= dst;
src1_out <= src1;

choose_1st_operand :  entity work.mux_6to1 generic map(32)
    port map(a=>reg1_data, b=>alu_out_EX_MEM, c=>alu_out2_EX_MEM,d=>alu_out2_MEM_WB, e=>mem_out_MEM_WB, f=>alu_out_MEM_WB, sel=>enb_1st_mux, y=>first_operand_for_ALU);

choose_2nd_operand :  entity work.mux_6to1 generic map(32)
    port map(a=>mux_choice, b=>alu_out_EX_MEM, c=>alu_out2_EX_MEM,d=>alu_out2_MEM_WB, e=>mem_out_MEM_WB, f=>alu_out_MEM_WB, sel=>enb_2nd_mux, y=>second_operand_for_ALU);

-- will select on (ALU Source = ex_in(0) #bit 0) i have note on the control unit 
-- 	if (ALU Source  = '0')
--		will select => REG_DATA2
--	else
--		will select => EA/IMM
select_REGData2_or_EA_IMM:  entity work.mux_2to_1 generic map(32)
    port map(a=> reg2_data, b=>ea_imm_in, sel=>ex_in(1), y=>mux_choice);


--forwarded_jmp_addr<=first_operand_for_ALU; --edited 20/5/2020
forwarded_jmp_addr <= pc_incremented_in when (last_taken_in and prediction_result_in) = '1' else first_operand_for_ALU;


zero_flag <= '0' when (zero_flag_in and if_jz_in) = '1' else zero_sig;
	
execution_unit:  entity work.alu
    port map(a=> first_operand_for_ALU, b=>second_operand_for_ALU, z1=>alu_out1, z2=>alu_out2, zero=>zero_sig, carry=>carry_flag, neg=>neg_flag, sel=>alu_op);

	process(first_operand_for_ALU)
begin
	if (ex_in(0) = '1') then
		IO_out <= first_operand_for_ALU;
	else
		IO_out <= "00000000000000000000000000000000";
	end if;
end process;
END flow;
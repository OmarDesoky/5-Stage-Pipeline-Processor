LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_STD.ALL;
ENTITY Fetch_Stage IS  
PORT (
	rst_async_test, int_test, pc_wb, take_jmp_addr_test, IN_MIDDLE_OF_IMM, IF_ANY_JUMP, CLK, flip_next_cycle_INT_test, PC_ENB_DATAHAZARD, Flush: in std_logic;
	pc_frm_wb_test, calc_jmp_addr_test: in std_logic_vector(31 downto 0);
	instruction :out std_logic_vector(15 downto 0);
	PC_Saved :out std_logic_vector(31 downto 0);
	INT_First_Cycle: out std_logic);
END Fetch_Stage;

ARCHITECTURE flow OF Fetch_Stage IS
signal mem_loc_2_3_test: std_logic_vector(31 downto 0);
signal pc_updated_test :std_logic_vector(31 downto 0);
signal pc_selected :std_logic_vector(31 downto 0);
signal pc_out_memory_in :std_logic_vector(31 downto 0);
signal write_enb_from_INT: std_logic;
signal write_enb_test: std_logic;

--signal INT_1st_cycle_test:std_logic;
signal INT_2nd_cycle_test:std_logic;
signal INT_raised_before_test:std_logic; 

signal dataout_Memory :std_logic_vector(15 DOWNTO 0);

--signal PC_OUT_SAVE_Determine :std_logic_vector(31 DOWNTO 0);
signal PC_WB2:std_logic;
BEGIN   

 process(pc_out_memory_in, CLK) 
 begin 
 pc_updated_test <= pc_out_memory_in +1;
 end process;
 
 PC_WB2 <= pc_wb and (not(INT_raised_before_test));
 pc_Select : entity work.pc_selector
    port map(rst_async=>rst_async_test, int=>INT_2nd_cycle_test, pc_wb=>PC_WB2, take_jmp_addr=> take_jmp_addr_test, mem_loc_2_3=>mem_loc_2_3_test
, pc_frm_wb=>pc_frm_wb_test ,calc_jmp_addr=>calc_jmp_addr_test, pc_updated=>pc_updated_test, pc_out=>pc_selected);

 write_enb_test <= (write_enb_from_INT and PC_ENB_DATAHAZARD and (not int_test));

 pc_REG : entity work.n_bit_register
    port map(CLK, rst_async=>rst_async_test, write_enb=>write_enb_test, d=>pc_selected, q=>pc_out_memory_in);

 INT_Handel : entity work.handler
    port map(CLK, rst_async=>rst_async_test, flip_next_cycle_INT=>flip_next_cycle_INT_test, INT_sig=>int_test
, INT_1st_cycle=>INT_First_Cycle,INT_2nd_cycle=>INT_2nd_cycle_test, INT_raised_before=>INT_raised_before_test, PC_enb_from_INT=>write_enb_from_INT );

 INS_Memory : entity work.inst_ram
    port map(CLK, '0', '1', pc_out_memory_in, "0000000000000000",dataout_Memory, mem_loc_2_3_test);

 PC_SAVE_DET : entity work.PC_Save_Determine
    port map(pc_out_memory_in, pc_updated_test, IN_MIDDLE_OF_IMM, IF_ANY_JUMP,PC_Saved);

 Flush_Decision : entity work.mux_2to_1 generic map(16)
    port map(a=>dataout_Memory, b=>X"0000", sel=>Flush, y=>instruction);

END flow; 
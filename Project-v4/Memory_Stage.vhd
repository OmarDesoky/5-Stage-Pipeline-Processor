LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_STD.ALL;
ENTITY Memory_Stage IS  
PORT (
    clk:                in std_logic;
    rst_async_test:     in std_logic;
    wb_in:              in std_logic_vector(4 downto 0); 
    mem_in:            in std_logic_vector(6 downto 0);
    alu_out_1_in:      in std_logic_vector(31 downto 0);
    ea_imm_in:         in std_logic_vector(31 downto 0);
    pc_in:             in std_logic_vector(31 downto 0); 
    
    Mem_out :           out std_logic_vector(31 downto 0);
    wb_out:             out std_logic_vector(4 downto 0));
END Memory_Stage;

ARCHITECTURE flow OF Memory_Stage IS
signal INT_Controller_Address_out:      std_logic_vector(31 downto 0);
signal INT_Controller_Data_out:         std_logic_vector(31 downto 0);
signal SP_chosen:                       std_logic_vector(31 downto 0);
signal EA_IMM_OR_SP:                    std_logic_vector(31 downto 0);
signal ADDER_out:                       std_logic_vector(31 downto 0);
signal SP_current:                      std_logic_vector(31 downto 0);

-- MEM signals
signal MEM_read,MEM_write:              std_logic;
signal INT_RTI_call_RET_Dontuse_sig:    std_logic_vector(2 downto 0);
signal SP_enb:                          std_logic_vector(1 downto 0);
signal sp_reg_enable:                   std_logic;

BEGIN    
 MEM_write                      <= mem_in(0);
 MEM_read                       <= mem_in(1);
 INT_RTI_call_RET_Dontuse_sig   <= mem_in(4 downto 2);
 SP_enb                         <= mem_in(6 downto 5);
 sp_reg_enable<= SP_enb(1);

 DATA_Memory :      entity work.data_ram
    port map(clk, wr=>MEM_write, rd=>MEM_read, address=>INT_Controller_Address_out
     ,datain=>INT_Controller_Data_out, dataout=>Mem_out);
-- modified by waleed in 21/5 SP_enb(1) => SP_enb(0) 10 11
 takeSP_Decision1 :  entity work.mux_2to_1 generic map(32)
    port map(a=>ea_imm_in, b=>SP_chosen, sel=>SP_enb(1), y=>EA_IMM_OR_SP);

 INT_Controller :   entity work.controller
    port map(clk,rst_async=>rst_async_test,ALU_out=>alu_out_1_in,EA_IMM_SP=>EA_IMM_OR_SP,PC=>pc_in,
    INT_RTI_call_RET_Dontuse=>INT_RTI_call_RET_Dontuse_sig,ADDRESS_IN=>INT_Controller_Address_out
    ,DATA_IN=>INT_Controller_Data_out);

 SP_REG :           entity work.sp_n_bit_register
    port map(clk, rst_async=>rst_async_test, write_enb=>(sp_reg_enable), d=>ADDER_out, q=>SP_current);

 takeSP_Decision2 :  entity work.mux_2to_1 generic map(32)
    port map(a=>ADDER_out, b=>SP_current, sel=>SP_enb(0), y=>SP_chosen);

 ADD_SUB :          entity work.add_sub generic map(32)
    port map(a=>SP_current, sel=>SP_enb, y=>ADDER_out);

 Buff_Holder2 :     entity work.buffer_holder2
    port map(clk, rst_async=>rst_async_test,INT_RTI_call_RET_Dontuse=>INT_RTI_call_RET_Dontuse_sig
    ,WB_signals_in=>wb_in,WB_signals_out=>wb_out);
END flow; 
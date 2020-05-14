LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_STD.ALL;

entity processor is
  port (
    CLK,RST,INT:    in std_logic;
    DATA_fromIO :   in std_logic_vector(31 downto 0);

    DATA_toIO :     out std_logic_vector(31 downto 0);
    IO_enb :        out std_logic
  ) ;
end processor;

architecture Arch of processor is

    --to decode
    signal last_taken_TO_decode,next_stall_TO_decode,int_TO_decode:std_logic;
    signal instruction_TO_decode :std_logic_vector(15 downto 0);
    signal pc_TO_decode :std_logic_vector(31 downto 0);

    --from decode
    signal IF_ANY_JUMP_FROM_decode,Flush_FROM_decode,IN_MIDDLE_OF_IMM_FROM_decode :std_logic;
    signal ifJZ_FROM_decode,zero_flag_FROM_decode,last_taken_FROM_decode :std_logic;

    --to execute
    signal wb_out_TO_execute:     std_logic_vector(4 downto 0); 
    signal mem_out_TO_execute:    std_logic_vector(6 downto 0); 
    signal alu_op_out_TO_execute: std_logic_vector(3 downto 0);
    signal ex_out_TO_execute:     std_logic_vector(1 downto 0);
    signal data_1_out_TO_execute:  std_logic_vector(31 downto 0);
    signal data_2_out_TO_execute:  std_logic_vector(31 downto 0);
    signal src_1_out_TO_execute:    std_logic_vector(2 downto 0);
    signal src_2_out_TO_execute:    std_logic_vector(2 downto 0);
    signal ea_imm_out_TO_execute:  std_logic_vector(31 downto 0);
    signal pc_out_TO_execute:       std_logic_vector(31 downto 0);
    signal dst_out_TO_execute:       std_logic_vector(2 downto 0);

    --from prediction
    signal take_jmp_addr_FROM_prediction,last_taken_FROM_prediction,next_stall_FROM_prediction :std_logic;
    signal PC_FROM_prediction :std_logic_vector(31 downto 0);

    
    --from WB
    signal pc_wb_FROM_WB,swap_wb_FROM_WB,reg_wb_FROM_WB,flag_wb_FROM_WB :std_logic;
    signal DATA_FROM_WB,ALUout2_FROM_WB :std_logic_vector(31 downto 0);
    signal dst_FROM_WB,SRC1_FROM_WB : std_logic_vector(2 downto 0);

    --from fetch
    signal instruction_fetched :std_logic_vector(15 downto 0);
    signal PC_FROM_fetch :std_logic_vector(31 downto 0);
    signal INT_FROM_fetch :std_logic;

    -- from alu
    signal zero_FROM_ALU,neg_FROM_ALU,carry_FROM_ALU :std_logic;

    -- from data hazard "to be used later"
    signal PC_ENB_FROM_DATAHAZARD                     : std_logic := '1' ;
    signal insert_bubble_FROM_DATAHAZARD              : std_logic := '0' ;
    signal stall_for_INT_FROM_DATAHAZARD              : std_logic        ;
    signal stall_for_jump_prediction_FROM_DATAHAZARD  : std_logic        ;
    signal IF_ID_ENB                                  : std_logic := '1' ;

  


begin
    fetch : entity work.Fetch_Stage
        port map(rst_async_test=>RST,int_test=>INT, pc_wb =>pc_wb_FROM_WB
        ,take_jmp_addr_test=>take_jmp_addr_FROM_prediction
        ,IN_MIDDLE_OF_IMM=>IN_MIDDLE_OF_IMM_FROM_decode,IF_ANY_JUMP=>IF_ANY_JUMP_FROM_decode
        ,CLK,flip_next_cycle_INT_test=>IF_ID_ENB
        ,PC_ENB_DATAHAZARD=>PC_ENB_FROM_DATAHAZARD,Flush=>Flush_FROM_decode
        ,pc_frm_wb_test=>DATA_FROM_WB,calc_jmp_addr_test=>PC_FROM_prediction
        --outputs
        ,instruction=>instruction_fetched,PC_Saved=>PC_FROM_fetch
        ,INT_First_Cycle=>INT_FROM_fetch);

    IF_ID : entity work.if_id
        port map(CLK,RST,enable=>IF_ID_ENB,last_taken_in=>last_taken_FROM_prediction
        ,next_stall_in=>next_stall_FROM_prediction
        ,int_in=>INT_FROM_fetch,instruction_in=>instruction_fetched
        ,pc_in=>PC_FROM_fetch
        --outputs
        ,last_taken_out=>last_taken_TO_decode
        ,next_stall_out=>next_stall_TO_decode,int_out=>int_TO_decode
        ,instruction_out=>instruction_TO_decode,pc_out=>pc_TO_decode);

    decode : entity work.decode_stage
        port map(CLK,RST,swap_wb=>swap_wb_FROM_WB,write_enb_wb=>reg_wb_FROM_WB,flag_enb_wb=>flag_wb_FROM_WB
        ,int=>int_TO_decode,stall_next=>next_stall_TO_decode,last_taken=>last_taken_TO_decode
        ,instruction=>instruction_TO_decode,dest_mem_wb=>dst_FROM_WB,data_out_wb=>DATA_FROM_WB
        ,data_swp_wb=>ALUout2_FROM_WB,reg_swap_mem_wb=>SRC1_FROM_WB,pc_in=>pc_TO_decode
        ,zero_flg=>zero_FROM_ALU,carry_flg=>carry_FROM_ALU,neg_flg=>neg_FROM_ALU
        ,insert_bubble=>insert_bubble_FROM_DATAHAZARD,io_data=>DATA_fromIO
        --outputs
        ,wb_outt=>wb_out_TO_execute,mem_outt=>mem_out_TO_execute,alu_op_outt=>alu_op_out_TO_execute
        ,ex_outt=>ex_out_TO_execute,data_1_out_TO_execute,data_2_out_TO_execute
        src_1_out_TO_execute,src_2_out_TO_execute, ea_imm_out_TO_execute, pc_out_TO_execute,dst_out_TO_execute
        ,stall_for_int=>stall_for_INT_FROM_DATAHAZARD,stall_for_jmp_pred=>stall_for_jump_prediction_FROM_DATAHAZARD
        ,ifjmp_upd_fsm=>ifJZ_FROM_decode,zero_flag_compare=>zero_flag_FROM_decode
        ,last_taken_compara=>last_taken_FROM_decode,inmiddleofimm=>IN_MIDDLE_OF_IMM_FROM_decode
        ,ifanyjmp=>IF_ANY_JUMP_FROM_decode);


end Arch ; -- Arch